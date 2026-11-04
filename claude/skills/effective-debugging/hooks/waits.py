#!/usr/bin/env python3
"""Keep long waits out of the foreground. PreToolUse and PostToolUse on Bash, from the skill's frontmatter.

PreToolUse: deny a watch, a poll loop or a long sleep unless the call runs in the background.
PostToolUse: after a push or a workflow start, say to watch it in the background.
"""
import json, re, sys

HEREDOC = re.compile(r"<<-?\s*['\"]?(\w+)['\"]?.*?\n\1\b", re.S)
WATCH = re.compile(r"\bgh\s+run\s+watch\b|\bgh\s+pr\s+checks\b[^\n|;&]*--watch(?![= ]false)|\s--watch\b(?![= ]false)|\btail\s+-[a-zA-Z]*f\b|(^|[;&|(\s])watch\s+")
LOOP = re.compile(r"\b(?:while|until|for)\b[^\n]*?(?:;|\n|&&|\|\|)\s*do\b(.*?)\bdone\b", re.S)
POLL_SLEEP = 5  # a loop sleeping less than this is a readiness wait, not a poll
POLL = re.compile(r"\bgh\s+(?:run|pr|api)\b|\bcurl\b|\bpgrep\b|\bps\s|\bstat\s|\bgrep\s+-q|\[\s+-[fsed]\s|\btest\s+-[fsed]\s|\bcat\s|\bls\s|\bkubectl\b|\baz\s")
SLEEP = re.compile(r"\bsleep\s+(\d+(?:\.\d+)?)([mh]?)\b")
STARTS = re.compile(r"\bgit\s+push\b(?![^\n;&|]*--dry-run)|\bgh\s+workflow\s+run\b|\bgh\s+run\s+rerun\b")


def seconds(m):
    n = float(m.group(1)); u = m.group(2)
    return n * {"": 1, "m": 60, "h": 3600}[u]


def wait_reason(command):
    body = HEREDOC.sub(" ", command)
    if WATCH.search(body):
        return "a watch"
    for m in LOOP.finditer(body):
        sl = SLEEP.search(m.group(0))
        if sl and seconds(sl) >= POLL_SLEEP and POLL.search(m.group(0)):
            return "a poll loop"
    for m in SLEEP.finditer(body):
        if seconds(m) >= 60:
            return "a sleep of a minute or more"
    return None


def main():
    try:
        p = json.load(sys.stdin)
    except ValueError:
        return
    if p.get("tool_name") != "Bash":
        return
    inp = p.get("tool_input") or {}
    cmd = inp.get("command", "") or ""
    event = p.get("hook_event_name")
    if event == "PreToolUse":
        why = wait_reason(cmd)
        if why and not inp.get("run_in_background"):
            print(json.dumps({"hookSpecificOutput": {
                "hookEventName": "PreToolUse", "permissionDecision": "deny",
                "permissionDecisionReason": f"This is {why} in the foreground. Run it with run_in_background as one command that ends when the work does, such as `gh run watch --exit-status <id>`, then work on what doesn't depend on it and read the result when it arrives."}}))
    elif event == "PostToolUse" and STARTS.search(HEREDOC.sub(" ", cmd)):
        print(json.dumps({"hookSpecificOutput": {
            "hookEventName": "PostToolUse",
            "additionalContext": "That started CI. Start one background watch for it now, such as `gh run watch --exit-status <id>` with run_in_background, and read its result as soon as it ends. Don't poll it."}}))


if __name__ == "__main__":
    main()
