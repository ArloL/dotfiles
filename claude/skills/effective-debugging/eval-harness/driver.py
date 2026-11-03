#!/usr/bin/env python3
# usage: driver.py setup CASE[,CASE] CONFIG[,CONFIG] N | run ID[,ID] CONCURRENCY
import json,os,sys,shutil,subprocess,secrets,re,time
from concurrent.futures import ThreadPoolExecutor
E=os.path.dirname(os.path.abspath(__file__)); SP=os.path.dirname(E); W=f"{SP}/history"; T=f"{E}/truth"; REPO="/Users/arlookeeffe/Developer/breezy"
SKILL=os.path.expanduser("~/.claude/skills/effective-debugging")
MAP=f"{T}/mapping.json"
FULL={"webkit-copy":"41037799231","page-not-answering":"41056326362"}
def sh(*a,**k): return subprocess.run(a,check=True,capture_output=True,text=True,**k).stdout
def head(c,cases):
    h=cases[c]["head"]
    if h.startswith("PLACEHOLDER"): h=sh("gh","run","view",FULL[c],"--json","headSha","--jq",".headSha",cwd=REPO).strip()
    return sh("git","rev-parse",h,cwd=REPO).strip()
def evidence(c,cases):
    d=f"{E}/evidence/{c}"
    if os.path.exists(d): return d
    os.makedirs(d)
    lines=["# Evidence","","What CI kept. Folder names are run ids.",""]
    for kind in ("failing","controls"):
        for r in cases[c][kind]:
            sub=f"{'failing' if kind=='failing' else 'other'}-run-{r}"
            sh("cp","-cR",f"{W}/runs/{r}",f"{d}/{sub}")
            lines.append(f"- `{sub}/`: {'the failing run' if kind=='failing' else 'an earlier run'}: artifacts, and `job-logs/`")
    open(f"{d}/README.md","w").write("\n".join(lines)+"\n")
    sh("chmod","-R","a-w",d)
    return d
def checkout(dest,h,cfg):
    os.makedirs(dest); sh("git","init","--quiet",cwd=dest); sh("git","fetch","--quiet",REPO,h,cwd=dest); sh("git","checkout","--quiet","FETCH_HEAD",cwd=dest)
    shutil.rmtree(f"{dest}/.claude/skills",ignore_errors=True); shutil.rmtree(f"{dest}/.claude/memory",ignore_errors=True)
    if os.path.exists(f"{dest}/.claude/settings.json"): os.remove(f"{dest}/.claude/settings.json")
    shutil.rmtree(f"{dest}/docs/superpowers",ignore_errors=True)
    cm=open(f"{dest}/CLAUDE.md").read().split("\n"); line=[l for l in cm if "debugging-breezy" in l]
    t=open(f"{dest}/TESTING.md").read().split("\n"); open(f"{dest}/TESTING.md","w").write("\n".join(l for l in t if "debugging-breezy" not in l))
    open(f"{dest}/CLAUDE.md","w").write("\n".join(l for l in cm if "debugging-breezy" not in l))
    sk=f"{dest}/.claude/skills"
    if cfg in("general","pair"):
        os.makedirs(sk,exist_ok=True); os.makedirs(f"{sk}/effective-debugging/references")
        shutil.copy(f"{SKILL}/SKILL.md",f"{sk}/effective-debugging/SKILL.md"); shutil.copy(f"{SKILL}/references/layers.md",f"{sk}/effective-debugging/references/layers.md")
    if cfg in("old","pair"):
        os.makedirs(f"{sk}/debugging-breezy",exist_ok=True)
        shutil.copy(f"{E}/{'old' if cfg=='old' else 'slim'}-debugging-breezy.md",f"{sk}/debugging-breezy/SKILL.md")
        generic="- A bug found by hand, or by a nightly run, is debugged through `.claude/skills/debugging-breezy`, from its recordings, before its code is read, and so is any failure of the harness, CI or a setup step."
        open(f"{dest}/CLAUDE.md","a").write(generic+"\n")
    sh("git","add","--all",cwd=dest); sh("git","-c","user.name=replay","-c","user.email=replay@localhost","commit","--quiet","--allow-empty","--message","Replay setup",cwd=dest)
NOTE="""

This replays a past failure. This folder is a checkout of the code that run ran, with its history. `evidence/` holds what CI kept, and its README lists the runs. You have no network, GitHub, CI, device or simulator here, and no dependencies are installed, so you cannot run new CI jobs or the app. Work only inside this folder and do not change the evidence.

Write your answer to `report.md` in this folder. If the evidence does not settle something, say what you would gather next and how."""
def setup(cs,cfgs,n):
    cases=json.load(open(f"{T}/cases.json")); m=json.load(open(MAP)) if os.path.exists(MAP) else {}
    made=[]
    for c in cs:
        ev=evidence(c,cases); h=head(c,cases)
        for cfg in cfgs:
            for i in range(n):
                rid="r"+secrets.token_hex(4); d=f"{E}/runs/{rid}"; checkout(d,h,cfg)
                os.symlink(ev,f"{d}/evidence")
                sh("sh","-c","printf 'evidence\\nreport.md\\n' >> .git/info/exclude",cwd=d)
                m[rid]={"case":c,"config":cfg,"rep":len([1 for v in m.values() if v["case"]==c and v["config"]==cfg])+1}; made.append(rid)
    json.dump(m,open(MAP,"w"),indent=1); print(",".join(made))
def settings(rid):
    m=json.load(open(MAP)); c=m[rid]["case"]; home=os.path.expanduser("~")
    deny=[f"{home}/Developer",f"{home}/.claude/projects",f"{home}/.dotfiles",f"{home}/Downloads",W,T,f"{SP}/article-images",f"{SP}/iso",f"{E}/driver.py"]
    deny+=[f"{E}/runs/{r}" for r in m if r!=rid]+[f"{E}/evidence/{x}" for x in os.listdir(f"{E}/evidence") if x!=c]
    s={"sandbox":{"enabled":True,"autoAllowBashIfSandboxed":True,"allowUnsandboxedCommands":False,"network":{"allowedDomains":[]},"filesystem":{"denyRead":deny}},
       "permissions":{"deny":[f"Read(/{p})" for p in deny]+[f"Grep(/{p})" for p in deny]+[f"Glob(/{p})" for p in deny]+["WebFetch","WebSearch"]}}
    p=f"{E}/runs/{rid}.settings.json"; json.dump(s,open(p,"w")); return p
def run(rid,deadline=2400):
    m=json.load(open(MAP)); cases=json.load(open(f"{T}/cases.json")); c=m[rid]["case"]; d=f"{E}/runs/{rid}"
    env=dict(os.environ,GH_TOKEN="blocked",GIT_CONFIG_GLOBAL="/dev/null"); t=time.time(); out=open(f"{E}/runs/{rid}.jsonl","w")
    cmd=["perl","-e",f"alarm {deadline}; exec @ARGV","claude","--print","--model","claude-opus-5-5","--setting-sources","project","--settings",settings(rid),"--strict-mcp-config","--no-session-persistence","--allowedTools","Read,Grep,Glob,Write,Edit,Skill,Bash,Agent","--verbose","--output-format","stream-json",cases[c]["prompt"]+NOTE]
    p=subprocess.run(cmd,cwd=d,env=env,stdin=subprocess.DEVNULL,stdout=out,stderr=subprocess.STDOUT)
    print(rid,"exit",p.returncode,round(time.time()-t),"s",flush=True)
if sys.argv[1]=="setup": setup(sys.argv[2].split(","),sys.argv[3].split(","),int(sys.argv[4]))
if sys.argv[1]=="run":
    with ThreadPoolExecutor(int(sys.argv[3])) as ex: list(ex.map(run,sys.argv[2].split(",")))
