#!/usr/bin/env python3
"""Mechanics of the waits hook, with no model."""
import json, os, subprocess, unittest

HOOK = os.path.join(os.path.dirname(os.path.abspath(__file__)), "waits.py")


def call(event, command, **extra):
    p = {"hook_event_name": event, "tool_name": "Bash", "tool_input": {"command": command, **extra}}
    r = subprocess.run(["python3", "-I", HOOK], input=json.dumps(p), capture_output=True, text=True)
    assert r.returncode == 0, r.stderr
    return json.loads(r.stdout) if r.stdout else None


def denied(out):
    return bool(out) and out["hookSpecificOutput"]["permissionDecision"] == "deny"


class Pre(unittest.TestCase):
    def test_watch_in_foreground_denied(self):
        for c in ["gh run watch 123 --exit-status", "gh pr checks 612 --watch --interval 30 2>&1 | tail -15",
                  "tail -f build/log.txt", "watch -n 5 gh run list"]:
            self.assertTrue(denied(call("PreToolUse", c)), c)

    def test_watch_in_background_allowed(self):
        self.assertIsNone(call("PreToolUse", "gh run watch 123 --exit-status", run_in_background=True))

    def test_poll_loop_denied(self):
        c = "end=$(( $(date +%s) + 2100 )); while [ $(date +%s) -lt $end ]; do sleep 45; s=$(gh run view 1 --json status --jq .status); [ \"$s\" = completed ] && break; done"
        self.assertTrue(denied(call("PreToolUse", c)))
        c2 = "until grep -q '^exit' out.txt 2>/dev/null; do sleep 20; done; cat out.txt"
        self.assertTrue(denied(call("PreToolUse", c2)))
        c3 = "for i in $(seq 1 12); do c=$(gh run view 1 --json conclusion --jq .conclusion); [ -n \"$c\" ] && break; sleep 30; done"
        self.assertTrue(denied(call("PreToolUse", c3)))

    def test_long_sleep_denied_short_allowed(self):
        self.assertTrue(denied(call("PreToolUse", "sleep 120; gh run view 1")))
        self.assertTrue(denied(call("PreToolUse", "sleep 5m")))
        self.assertIsNone(call("PreToolUse", "pkill -x idb_companion; sleep 1; pgrep idb"))
        self.assertIsNone(call("PreToolUse", "sleep 30 && echo done"))

    def test_watch_false_and_readiness_loops_allowed(self):
        self.assertIsNone(call("PreToolUse", "npx ng test --include x.spec.ts --watch=false 2>&1 | tail -30"))
        self.assertIsNone(call("PreToolUse", "git push --quiet && gh pr checks 70 --watch=false | head -3"))
        self.assertIsNone(call("PreToolUse", "for i in $(seq 1 60); do curl --silent --fail http://localhost:65111 && break; sleep 2; done"))
        self.assertIsNone(call("PreToolUse", "while pgrep -x Breezy >/dev/null; do sleep 1; done"))
        self.assertIsNone(call("PreToolUse", "sed -i '' 's/for _ in 0..<40 { steps.append {} }/x/' Bench.swift && xcodebuild test; pgrep -f done; sleep 10"))

    def test_loop_without_a_poll_allowed(self):
        self.assertIsNone(call("PreToolUse", "for f in *.md; do wc -l $f; done"))
        self.assertIsNone(call("PreToolUse", "for i in 1 2 3; do npm test; done"))

    def test_sleep_inside_heredoc_ignored(self):
        c = "python3 - <<'EOF'\nimport time\nwhile True:\n    time.sleep(60)\n    print('sleep 120')\nEOF\n"
        self.assertIsNone(call("PreToolUse", c))

    def test_other_tools_and_bad_input_ignored(self):
        p = {"hook_event_name": "PreToolUse", "tool_name": "Read", "tool_input": {"file_path": "x"}}
        r = subprocess.run(["python3", "-I", HOOK], input=json.dumps(p), capture_output=True, text=True)
        self.assertEqual((r.returncode, r.stdout), (0, ""))
        r = subprocess.run(["python3", "-I", HOOK], input="not json", capture_output=True, text=True)
        self.assertEqual((r.returncode, r.stdout), (0, ""))


class Post(unittest.TestCase):
    def test_push_adds_context(self):
        out = call("PostToolUse", "git add -A && git commit --quiet --message x && git push --quiet")
        self.assertIn("background watch", out["hookSpecificOutput"]["additionalContext"])
        for c in ["gh workflow run nightly.yaml", "gh run rerun 123 --failed"]:
            self.assertIsNotNone(call("PostToolUse", c), c)

    def test_no_push_no_context(self):
        for c in ["git push --dry-run", "git status && git log --oneline -3", "gh run view 1"]:
            self.assertIsNone(call("PostToolUse", c), c)


if __name__ == "__main__":
    unittest.main()
