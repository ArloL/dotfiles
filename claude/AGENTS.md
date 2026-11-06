* be concise
* ruthlessly cut comments and explanations to the bare essentials
* Prefer CLI long options (--silent) over short options (-s) when they are also macOS compatible. For example `mkdir -p` and `rm -f` must be short.
* Instead of load-bearing, use required, crucial or essential
* Split commands I'm meant to paste across short lines ending in `\`: copying from the terminal view keeps its hard wraps, which breaks long lines
* After creating a GitHub repo, subscribe to it: `gh api --method PUT repos/OWNER/REPO/subscription --field subscribed=true --field ignored=false` — GitHub dropped auto-watch on 2025-05-18, so new repos are otherwise silently unwatched
* A tool I name in passing ("xz or something") is an example, not a choice: measure the candidates, pick the best, say why in a line
* Anything left running in the background (a dispatched CI run, a detached process) gets a watcher in the same message: it watches the thing itself, not a proxy for it, and wakes you on the first failed or cancelled job, on the end, past its expected time, and when its own polls keep failing; report what it finds at once. A watcher with only a deadline is blind: a CI job that never got a runner and a session killed by one rejected push both went unseen until I said so
