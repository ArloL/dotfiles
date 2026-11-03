import json,glob,os,math,subprocess
E=os.path.dirname(os.path.abspath(__file__)); m=json.load(open(f"{E}/truth/mapping.json"))
g={}
for f in glob.glob(f"{E}/grading/*.json"):
    for k,v in json.load(open(f)).items(): g[k]=v
def met(r):
    res=None; first_code=first_ev=None;n=0
    import re
    for l in open(f"{E}/runs/{r}.jsonl",errors="ignore"):
        try:d=json.loads(l)
        except: continue
        if d.get("type")=="result":res=d
    return res
cfgs=["none","old","general","pair"]; cases=sorted({v["case"] for v in m.values()})
print("case".ljust(22)+"".join(c.ljust(22) for c in cfgs))
for c in cases:
    row=c.ljust(22)
    for cf in cfgs:
        for r,v in m.items():
            if v["case"]==c and v["config"]==cf and r in g:
                s=g[r]; row+=f"c{s['cause']} s{s['signal']} t{s['trap']} f{s['fix']} h{s['honest']}".ljust(22)
    print(row)
def wilson(k,n,z=1.96):
    p=k/n; d=1+z*z/n; c=(p+z*z/(2*n))/d; h=z*math.sqrt(p*(1-p)/n+z*z/(4*n*n))/d; return round(c-h,2),round(c+h,2)
print()
for cf in cfgs:
    rs=[r for r,v in m.items() if v["config"]==cf and r in g]
    n=len(rs); full=sum(g[r]["cause"]==2 for r in rs); tot=sum(g[r]["cause"]+g[r]["signal"]+g[r]["trap"]+g[r]["fix"]+g[r]["honest"] for r in rs)
    res=[met(r) for r in rs]; cost=[x["total_cost_usd"] for x in res]; mins=[x["duration_ms"]/60000 for x in res]; turns=[x["num_turns"] for x in res]
    print(cf.ljust(8),f"n={n} cause=2: {full}/{n} CI95 {wilson(full,n)} points {tot}/{6*n} ({tot/(6*n):.2f}) CI95 {wilson(tot,6*n)} | mean ${sum(cost)/n:.2f} {sum(mins)/n:.1f} min {sum(turns)/n:.0f} turns")
print()
for c in cases:
    print("##",c)
    for r,v in m.items():
        if v["case"]==c and r in g: print(f"  {v['config']:8}",g[r]["why"][:260])
