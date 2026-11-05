#!/usr/bin/env python3
"""Before a long run, add one paragraph of context. PreToolUse on Bash and Monitor, from the skill's frontmatter.

Fires on: a watch, a polling loop however it sleeps, a sleep of a minute or more, a CI start (push, workflow
run, rerun), any Bash call declared run_in_background, and every Monitor call. It blocks nothing.

Why: in 26 real sessions, 43 runs were wasted, 18 of them long, because the deciding fact was already in
output the agent had fetched earlier in the same session. The skill's pre-run line is read at the start of a
session; this says the same thing at the moment it applies. skill-research: experiments/pre-run-trigger/.
"""
import json, re, sys

HEREDOC = re.compile(r"<<-?\s*['\"]?(\w+)['\"]?.*?\n\1\b", re.S)
WATCH = re.compile(r"\bgh\s+run\s+watch\b|\bgh\s+pr\s+checks\b[^\n|;&]*--watch(?![= ]false)|\s--watch\b(?![= ]false)|\btail\s+-[a-zA-Z]*f\b|(^|[;&|(\s])watch\s+")
LOOP = re.compile(r"\b(while|until)\b[^\n]*?(?:;|\n|&&|\|\|)\s*do\b(.*?)\bdone\b", re.S)
POLL = re.compile(r"\bgh\s+(?:run|pr|api)\b|\bcurl\b|\bpgrep\b|\bps\s|\bstat\s|\bgrep\s+-q|\[\s+-[fsed]\s|\btest\s+-[fsed]\s|\bcat\s|\bls\s|\bkubectl\b|\baz\s|\bdate\b|\bSECONDS\b")
SLEEP = re.compile(r"\bsleep\s+(\d+(?:\.\d+)?)([mh]?)\b")
STARTS = re.compile(r"\bgit\s+push\b(?![^\n;&|]*--dry-run)|\bgh\s+workflow\s+run\b|\bgh\s+run\s+rerun\b")

CONTEXT = (
    "effective-debugging, before a long run. In 26 past debugging sessions, 43 runs were wasted, 18 of them long, "
    "because the deciding fact was already in output the agent had fetched, read or printed earlier in the same "
    "session. A run earns its wait when it answers a named question that nothing in hand answers. What found those "
    "facts: the question this run answers, written down; the logs, artifacts, earlier run output and files already "
    "read, re-read for that answer; and, where a subagent is available, a fresh reader given those outputs and the "
    "question, asked whether the answer is already there. A second wait for the same kind of answer meant the "
    "question was wrong, not the run."
)


def seconds(m):
    return float(m.group(1)) * {"": 1, "m": 60, "h": 3600}[m.group(2)]


def reason(tool, inp):
    """Why this call counts as a long run, or None."""
    if tool == "Monitor":
        return "a monitor"
    if tool != "Bash":
        return None
    if inp.get("run_in_background"):
        return "a background run"
    body = HEREDOC.sub(" ", inp.get("command", "") or "")
    if WATCH.search(body):
        return "a watch"
    if any(POLL.search(m.group(0)) for m in LOOP.finditer(body)):
        return "a polling loop"
    if any(seconds(m) >= 60 for m in SLEEP.finditer(body)):
        return "a sleep of a minute or more"
    if STARTS.search(body):
        return "a CI start"
    return None


def main():
    try:
        p = json.load(sys.stdin)
    except ValueError:
        return
    if p.get("hook_event_name") != "PreToolUse":
        return
    if reason(p.get("tool_name"), p.get("tool_input") or {}):
        print(json.dumps({"hookSpecificOutput": {"hookEventName": "PreToolUse", "additionalContext": CONTEXT}}))


if __name__ == "__main__":
    main()
