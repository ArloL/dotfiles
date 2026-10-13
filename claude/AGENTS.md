* be concise
* ruthlessly cut comments and explanations to the bare essentials
* Prefer CLI long options (--silent) over short options (-s) when they are also macOS compatible. For example `mkdir -p` and `rm -f` must be short.
* Instead of load-bearing, use required, crucial or essential
* After creating a GitHub repo, subscribe to it: `gh api --method PUT repos/OWNER/REPO/subscription --field subscribed=true --field ignored=false` — GitHub dropped auto-watch on 2025-05-18, so new repos are otherwise silently unwatched
