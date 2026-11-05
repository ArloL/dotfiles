#!/usr/bin/env python3
"""Mechanics of the pre-run hook, with no model. Run: python3 -I hooks/test_pre_run.py"""
import json, os, subprocess, unittest

HOOK = os.path.join(os.path.dirname(os.path.abspath(__file__)), "pre_run.py")


def call(command=None, tool="Bash", event="PreToolUse", **extra):
    inp = {"command": command, **extra} if command is not None else extra
    p = {"hook_event_name": event, "tool_name": tool, "tool_input": inp}
    r = subprocess.run(["python3", "-I", HOOK], input=json.dumps(p), capture_output=True, text=True)
    assert r.returncode == 0, r.stderr
    return json.loads(r.stdout) if r.stdout else None


def fired(out):
    return bool(out) and "additionalContext" in out["hookSpecificOutput"] and "permissionDecision" not in out["hookSpecificOutput"]


class Fires(unittest.TestCase):
    def test_watch(self):
        for c in ["gh run watch 123 --exit-status", "gh pr checks 612 --watch --interval 30 2>&1 | tail -15",
                  "tail -f build/log.txt", "watch -n 5 gh run list"]:
            self.assertTrue(fired(call(c)), c)

    def test_poll_loop_with_sleep(self):
        c = "end=$(( $(date +%s) + 2100 )); while [ $(date +%s) -lt $end ]; do sleep 45; s=$(gh run view 1 --json status --jq .status); [ \"$s\" = completed ] && break; done"
        self.assertTrue(fired(call(c)))
        self.assertTrue(fired(call("until grep -q '^exit' out.txt 2>/dev/null; do sleep 20; done; cat out.txt")))

    def test_poll_loop_without_sleep(self):
        # 59da1470 slept with perl to get past the sleep block; 52 and 87 minutes
        c = "end=$(( SECONDS + 5400 )); while [ $SECONDS -lt $end ]; do a=$(gh run view 41611055379 --json status --jq .status); if [ \"$a\" = completed ]; then exit 0; fi; perl -e 'select(undef,undef,undef,60)'; done"
        self.assertTrue(fired(call(c)))

    def test_long_sleep(self):
        self.assertTrue(fired(call("sleep 120; gh run view 1")))
        self.assertTrue(fired(call("sleep 5m")))

    def test_ci_start(self):
        self.assertTrue(fired(call("git commit -m 'x'; git push --set-upstream origin b 2>&1 | head -3; gh pr create --title t --body b")))
        self.assertTrue(fired(call("gh workflow run probe-session.yaml --ref main")))
        self.assertTrue(fired(call("gh run rerun 37402964455 && sleep 5")))

    def test_background_and_monitor(self):
        self.assertTrue(fired(call("npm test 2>&1 | tail -3", run_in_background=True)))
        self.assertTrue(fired(call(tool="Monitor", command="gh run view 1 --json status")))
        self.assertTrue(fired(call(tool="Monitor", description="watch for the ad read")))


class Silent(unittest.TestCase):
    def test_short_commands(self):
        for c in ["ls -la", "grep -rn foo src | head", "git status --short", "npm test 2>&1 | tail -3",
                  "pkill -x idb_companion; sleep 1; pgrep idb", "sleep 30 && echo done",
                  "for f in a b c; do cat $f; done", "git push --dry-run", "sed -n 1,40p README.md"]:
            self.assertIsNone(call(c), c)

    def test_heredoc_contents_ignored(self):
        c = "cat > notes.md <<'EOF'\nwhile [ 1 ]; do gh run view 1; sleep 60; done\ngit push\nEOF\necho written"
        self.assertIsNone(call(c))

    def test_other_tools_and_events(self):
        self.assertIsNone(call(tool="Read", file_path="/x"))
        self.assertIsNone(call("gh run watch 1", event="PostToolUse"))
        self.assertIsNone(call("gh run watch 1", event="PreToolUse", tool="Edit"))

    def test_bad_input(self):
        r = subprocess.run(["python3", "-I", HOOK], input="not json", capture_output=True, text=True)
        self.assertEqual(r.returncode, 0); self.assertEqual(r.stdout, "")


if __name__ == "__main__":
    unittest.main()
