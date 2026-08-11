---
name: documenting-the-non-obvious
description: Use when writing or rewriting prose that sits beside code — deployment and ops docs, READMEs, architecture notes, and the comment blocks in source and config files — especially when a draft reads as thorough but restates what the reader could look up, when reviewing comments someone else wrote, or when asked to make docs shorter or more focused.
---

# Documenting the Non-Obvious

## Overview

A prose doc competes with the sources it describes and loses: the code, the
other repo and the config files are more accurate and never go stale. The doc
earns its length only where it says something none of those can.

Write for someone competent who will read those sources anyway.

## The Test for Every Sentence

**Where else could the reader get this?**

- The code, the neighbouring repo, or one run of the thing → cut it.
- Nowhere, because it spans several sources → keep it. That is the doc.

Facts that pass are usually composites — several things, in different files,
that together mean something no single file says:

```markdown
The app exposes no health endpoint, the deploy waits only for the container to
be running, the probe is a TCP connect with no alert rules behind it, and a
container that dies on startup is restarted forever. A deploy that reports
green can be a restart loop.
```

Four files across two repos, one conclusion. Nobody assembles that by accident.

Passing this test is necessary and not sufficient. A fact can be composite,
non-obvious and verified, and still be worth nothing — apply the second gate
below before writing it down.

## Constraints, Not Their Absence

**Second gate: what does the reader do differently knowing this?**

A constraint changes behaviour — do not reorder these, this must stay set, that
role holds no `CREATE`. The *absence* of a constraint changes nothing. The
reader who was not going to reorder is unaffected, and the reader who does needs
no permission from a comment.

So never document that something is free, safe, harmless, optional, arbitrary,
"fine either way", or changes "nothing else". If the payload of the sentence is
a negation, there is no sentence. Delete it rather than rephrase it.

The absence of a coupling is also the one claim that rots while its subject sits
still: a later change creates the coupling, and nothing points back at the
comment that promised there wasn't one.

**When a comment states a constraint that turns out not to exist, delete it. Do
not invert it.** The inverted version documents your investigation, not the
system — that you were briefly misled is not a fact about the code. Same for any
comment that opens by refuting a misreading ("despite reading like it is not",
"you might think X, but"): you are answering a question only you asked, in front
of readers who never asked it.

## Name the Reader, Then Cut

A fact is not worth keeping on its own; it is worth keeping *here*. Before you
keep a sentence, say who is standing in this file and why they opened it.

- A repo-wide instruction file (`CLAUDE.md`, `AGENTS.md`) is read by everyone
  before every task. A fact that matters only to whoever edits one particular
  line does not belong there. It belongs beside that line.
- A config line is read by the person about to change it.
- A test is read by the person it just failed on.

**One fact, one home.** When the same fact appears in two files, keep the copy
where the reader who acts on it is standing and delete the other outright. Never
leave a shortened restatement behind: two copies drift, and whoever finds one
has no idea the other exists. A one-sentence pointer is allowed; a summary is
not.

## What a Guard Enforces Needs No Prose

If a test fails, the build breaks or the schema rejects it when the rule is
broken, the rule is already documented — by the failure. Delete the sentence.
Keep only what the failure cannot say: what to do about it, or that no guard
exists at all.

## The Deletion Pass

Draft, then go clause by clause and say what breaks if the clause is gone. Name
the concrete edit each one blocks — "stops someone inlining the DDL", "stops
someone computing the version", "stops someone deleting a changeset that looks
dead". A clause with no such edit behind it is you thinking on paper.

Two shapes that never survive the pass:

- A comment restating the identifier it sits on. The method name already said
  it.
- A comment defending a choice nobody questioned — usually a limit of the draft
  you just fixed. Fix the claim and delete the note about it.

Expect one to three sentences per block, and expect to delete more than you
rewrite.

## The Shape

Pick the paragraph ceiling before drafting and treat it as spec.

**One claim per paragraph, then at most one consequence.** If a claim needs four
supporting facts before the reader will believe it, you are arguing rather than
documenting — state the claim and let them verify it.

Order: where decisions are made → what the code demands of whoever operates it
→ what fails without saying so.

Plain declaratives. No bold lead-ins, no asides, no flourishes.

## Rules, Not Incidents

State the durable rule and how the reader checks whether it applies today.
Release-specific and dated facts age into trivia within a sprint.

```markdown
❌ The 07-31 and 08-04 changesets refuse to run while the outbox is non-empty.
✅ Before deploying, check whether the release adds anything under
   `db/changelog/changes/`.
```

## Describe, Don't Warn

Hazard framing ("this must be set before the deploy or the container dies")
turns a doc into a runbook. State how it is; a competent reader derives the
hazard.

The exception is the class above: a failure that leaves no trace where the
reader would look is exactly what only the doc can supply.

## Procedures Live With Their Scripts

Steps belong to the repo that owns the scripts they run. Point at it in one
sentence and stop. Duplicated procedure is the first thing to go out of date,
and the reader who runs it is already in that repo.

## Common Mistakes

| Symptom | Fix |
|---------|-----|
| Listing the parts of a system the reader can see | Name only the parts a change here can break |
| "This is free / harmless / doesn't matter / changes nothing else" | Nothing follows from it — delete the sentence |
| The same fact in two files | Keep the copy where the reader acts; delete the other |
| A rule a test or the compiler already enforces | The failure is the documentation |
| Javadoc restating the method name | Delete; the signature said it |
| Written without deciding who opens this file | Name the reader first — placement decides inclusion |
| Correcting a comment that claimed a constraint you disproved | Delete the comment; the correction is not a replacement |
| "Despite how it reads…", "you might think…" | You are answering your own question — cut |
| "I verified this, so it belongs" | Verification buys accuracy, not inclusion — apply both tests anyway |
| Four facts propping up one uncontested claim | Keep the claim, drop the evidence |
| A paragraph organised around a release or a date | Rewrite as the rule plus the check |
| Steps copied from another repo | One-sentence pointer |
| Every paragraph a warning | Describe; keep only the silent failures |
