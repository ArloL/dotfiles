# Replay eval

Replays real CI failures from Breezy's history. `../evals/<case>/` holds each prompt, expected outcome and graders; `cases.json` holds the same plus the failing commit and runs. Evidence is not stored here: it is `gh run download` plus each run's job logs, and GitHub keeps those artifacts for 90 days from each run, so the oldest cases expire in late January 2027.

`driver.py` builds a blinded checkout per run, with history only up to the failing commit, and runs `claude --print` with `--setting-sources project`, so a run sees only the skill under test. Its sandbox denies network, GitHub and every other run. `score.py` joins blind grades to setups.

To rerun, in a scratch folder: put `driver.py` and `score.py` in `replay/`, `cases.json` in `replay/truth/`, the runs in `history/runs/<id>/` with job logs in `job-logs/`, and the old and slim `debugging-breezy` as `replay/old-debugging-breezy.md` and `replay/slim-debugging-breezy.md`. Then `driver.py setup <cases> <setups> <n>` and `driver.py run <ids> <concurrency>`. Grade with a fresh agent per case, given only the reports under their opaque ids. A run takes about 2 % of a 5-hour window on Opus.

`results-2026-11-03.md` has the first results, including why this set cannot show a gain over no skill.
