---
tags: [skill-creator]
timeout_seconds: 2400
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit, Bash, Agent]
---

The nightly dispatched on branch copy-paste-web, run 41037799231, failed its android job: two copy cases with WebKit acting, `a card in a lane copied and pasted shows right below it on the other device (webkit → android)` and `⌘C copies a card's front, leaves the clipboard as it was with a lane alone selected, and in the find field copies its text (webkit → android)`. Find out why and what to do about it.

This replays a past failure. This folder is a checkout of the code that run ran, with its history. `evidence/` holds what CI kept, and its README lists the runs. You have no network, GitHub, CI, device or simulator here, and no dependencies are installed, so you cannot run new CI jobs or the app. Work only inside this folder and do not change the evidence.

Write your answer to `report.md` in this folder. If the evidence does not settle something, say what you would gather next and how.
