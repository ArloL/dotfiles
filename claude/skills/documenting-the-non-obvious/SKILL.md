---
name: documenting-the-non-obvious
description: Use when writing or rewriting prose that sits beside code — deployment and ops docs, READMEs, architecture notes, and the comment blocks in source and config files — especially when a draft reads as thorough but restates what the reader could look up, when reviewing comments someone else wrote, when asked to make docs shorter or more focused, or when a draft is accurate but hard to skim: paragraphs opening on a pronoun or a backward reference, sentences carrying three or four facts each, comparative figures buried in prose that want to be a table, or headings outnumbering the ideas.
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

**The criterion is whether it blocks a concrete edit, not whether it is phrased
as a negation.** Run the deletion pass on it: name the edit the sentence stops.

- "The staging deploy has no rollback step" stops someone assuming the
  production runbook applies here. Keep it.
- "No index on this column would help; the planner already rejects it" stops
  someone adding one. Keep it, though it is literally the absence of an
  improvement.
- "This setting is safe to change" stops nothing. Delete it.

This is what governs when this rule meets "or that no guard exists at all"
below. Neither clause wins on wording; the blocked edit decides.

**A sentence that is wrong is not the same as one that is unnecessary.** Cut the
false clause and keep the instruction it was attached to — "run the normalizer
so it strips the counters" becomes "run the normalizer" when the script does no
such thing. Deleting the whole sentence throws away the part that was right.

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

When the other copy lives somewhere this task may not touch, name the file that
holds it and which of the two should go. Leaving both without saying so is how
they drift.

This is about the same fact serving the same purpose twice. Two passages that
reach different conclusions from one underlying fact are not duplicates — an
example demonstrating that free text misses contract type, and a measurement of
what the contract-type filter fails to remove, are separate claims that happen
to share a term. Before deleting as a duplicate, state both conclusions. If they
differ, keep both.

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

Everything above decides what survives. This decides whether anyone can read
what survived. A doc can pass both gates on every sentence and still be
unreadable, which is the more common failure once the deletion pass is working.

**One claim per paragraph, then at most one consequence.** If a claim needs four
supporting facts before the reader will believe it, you are arguing rather than
documenting — state the claim and let them verify it.

The exception is a claim the reader can act against but cannot check: a setting
they could revert with no failing test to stop them. There the evidence is the
constraint, and it stays.

Order: where decisions are made → what the code demands of whoever operates it
→ what fails without saying so.

Plain declaratives in the doc itself. No bold lead-ins, no asides, no flourishes.

Edit density tracks defect density. A paragraph that already reads well is
finished, even when its neighbours are being rewritten. When two rules below
collide, cohesion wins: a passage that reads as one connected argument beats a
set of individually cleaner sentences.

### Name the subject in the opening words

A reader skims by reading the start of each paragraph and moving on. An opener
that points backwards is unreadable to them, because its referent sits in a
paragraph they skipped:

```markdown
❌ That is why the retry budget matters.
❌ Taken together, those two settings halve the queue depth.
✅ The retry budget matters because the upstream returns 502 mid-rollout.
```

A claim that merely arrives late is the same defect without a pronoun, and it is
easier to miss because nothing about the sentence looks broken:

```markdown
❌ The scheduler polls every 30 seconds and writes each row to the outbox.
   Polling is what bounds the delivery delay.
✅ Polling bounds the delivery delay. The scheduler polls every 30 seconds and
   writes each row to the outbox.
```

Old information still belongs first. The defect is not the backward link — it is
that a bare pronoun, a demonstrative, or a scene-setting first sentence gives
the skimmer nothing to carry away.

Apply this to the document's own first paragraph before anything else. It is the
one most often left exactly as drafted.

**The test:** read only the first sentence of each paragraph, in order. If that
sequence does not carry the argument, the openers are wrong.

This is the highest-yield edit available on a dense doc, and the one most
reliably skipped.

### Check subject-verb adjacency before length

Anything of length between a subject and its verb reads as an interruption. That
is usually the real defect in a sentence that merely feels long, and it survives
being shortened.

**A sentence is too long when it has more things worth emphasising than it has
places to put them.** Readers emphasise whatever arrives at a syntactic closure
— a full stop, and more weakly a colon or semicolon. Four emphasis-worthy facts
against one full stop means three of them land nowhere.

The repair is another closure, not amputation: split it, or earn a stress
position with a colon, or restate the noun and continue.

Do not adopt a word cap. Every published cap is asserted, none is measured, and
a cap is trivially satisfied by chopping prose into something choppier and no
clearer. Long sentences are hard to write, not inherently hard to read.

### Repeated structure becomes a table

Two things want a table: figures only meaningful against each other, and items
that repeat the same attributes. Both force the reader to rebuild a grid in
their head from prose. This is the one formatting choice with a real effect size
behind it — same figures, table versus prose, 79.6 % against 69.7 %
comprehension.

Convert when an item carries three or more attributes, when the content is
if-then conditions, or when it is a before-and-after. One column means it wanted
to be a list. A cell needing more than two sentences means the table is the
wrong format.

Keep a sentence above it stating what follows, so the point stays readable as a
claim. Never invent a figure to fill a cell. Name the gap for what it actually
is: `not applicable` when the cell cannot have a value, `not measured` when you
know it was never established, and `not stated` when you only know the source is
silent. Silence is the common case, so `not stated` is the honest default.

A single number, or one that nothing is weighed against, stays in prose.

If half the cells would be gap labels, the table is not carrying its weight —
leave it as prose.

### A heading is earned by a second topic

Headings are how a skimmer navigates and the first thing they look for. Two
failures, in opposite directions, and both tests have to pass:

- **Too few.** Someone after one fact should not have to read past two unrelated
  topics to reach it. A long run with no landmark cannot be re-found tomorrow.
- **Too many.** If you cannot name a second distinct topic for a level to
  separate, the level is not earned. Two headings with no text between them
  means the organisation is wrong, not that the doc needs filler.

A heading that ends up over a single paragraph means the split went one too far.
Fold it back into its neighbour.

Noun phrases, front-loaded on the distinguishing word. Not sentences, not
questions.

Two levels below the title — `##` and `###` — is enough. Needing `####` means
the document wants splitting. The title does not count as a level.

### Conditions before instructions

Put the circumstance first, so a reader whose situation does not match can stop
at the first clause.

```markdown
❌ Use `-Bau*` if you want to exclude the construction terms.
✅ To exclude the construction terms, use `-Bau*`.
```

## Before Handing It Back

Four checks, every time, on the draft you are about to return. Each one failed
in testing when it was left implicit.

1. **The first paragraph.** Read its first sentence alone. If it sets a scene
   rather than making the claim, rewrite it. This is the single most commonly
   skipped edit in the document, because nothing about the paragraph looks
   broken.
2. **The skim test.** First sentence of every paragraph, in order, including the
   first. Does that sequence carry the argument?
3. **Headings, both directions.** Compare the count against what you started
   with: a drop needs justifying, and any heading left sitting over a single
   paragraph has gone one too far.
4. **Your own insertions.** Read only what you added, against everything above.

## Rules, Not Incidents

State the durable rule and how the reader checks whether it applies today.
Release-specific facts age into trivia within a sprint.

**A measurement is not an incident.** Keep its date: it tells the reader how
stale the number is and what to re-run. Stripping the date makes the figure
unfalsifiable rather than durable. This rule targets facts that expire, not
facts that were true when measured.

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
| Four facts propping up one uncontested claim | Keep the claim, drop the evidence — unless reverting it breaks nothing loudly |
| Deleting an absence that a sibling path makes the reader assume away | Adjacency is the test; write that one |
| Stripping the date off a measurement | Dates on measurements say how stale; keep them |
| A doc handed back with fewer headings than it started with | Check the too-few direction too |
| A paragraph organised around a release or a date | Rewrite as the rule plus the check |
| Steps copied from another repo | One-sentence pointer |
| Every paragraph a warning | Describe; keep only the silent failures |
| Paragraph opens "That is…", "Their…", "Taken together…" | Name the subject in the opening words |
| Skimming the first sentences conveys nothing | The openers are the defect, not the length |
| The first paragraph left as drafted | Check it explicitly; it is the one most often missed |
| Deleting a passage as duplicate without stating both conclusions | Different conclusions from one fact are not duplicates |
| An absence deleted for being phrased as a negation | Name the edit it blocks; that decides, not the wording |
| A sentence that feels long | Check subject-verb distance before shortening anything |
| Splitting a sentence to hit a word count | No cap; add a stress position instead |
| Rates or before/after figures compared inside a sentence | Rows and columns; keep the claim above it |
| A blank cell filled with a plausible number | Write `not measured` |
| A heading over every paragraph | A heading needs a second topic to separate |
| Every paragraph rewritten to match its neighbours | Edit density tracks defect density; leave good prose alone |
| Uniformly short sentences | Four in a row is a wall too |
