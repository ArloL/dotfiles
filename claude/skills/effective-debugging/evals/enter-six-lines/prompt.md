---
tags: [skill-creator]
timeout_seconds: 2400
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit, Bash, Agent]
---

Last night's nightly, run 41293058635 on main at commit 3af355c, failed its `ios (iPhone 13 mini, ios-home)` job: `a card's title and lines typed, deleted and typed again on a phone show the caret after the last key, the title semibold (ios-home → chromium)`. Find out why and what to do about it.

This replays a past failure. This folder is a checkout of the code that run ran, with its history. `evidence/` holds what CI kept, and its README lists the runs. You have no network, GitHub, CI, device or simulator here, and no dependencies are installed, so you cannot run new CI jobs or the app. Work only inside this folder and do not change the evidence.

Write your answer to `report.md` in this folder. If the evidence does not settle something, say what you would gather next and how.
