---
name: effective-agents-md
description: Use when updating or writing AGENTS.md or CLAUDE.md entries after code changes, refactors, renames, or schema changes — especially when dead code remains, naming is misleading, a "do not" pattern needs to be established for future AI instances, the file has grown past a few hundred lines, or an entry might belong in a linked doc instead.
---

# Effective AGENTS.md Entries

## Overview

A future AI instance will read AGENTS.md cold (CLAUDE.md in Claude Code — same file, different name), then look at the code. Write entries that surface what the code **misrepresents or hides** — everything else is noise that will rot.

The file loads into every session, so each entry is paid for on every task — including the tasks it has nothing to do with. Two questions decide it: **is this worth writing**, and **does it belong in the always-loaded file**.

Frame entries as what to do, not what to avoid. Active framing is more memorable and less likely to be rationalised away under pressure.

## The Test for Every Entry

**Would a cold-start AI reach for the wrong thing without this?**
- Yes → write it
- No → the code already communicates it; skip it

## Three Things Worth Writing

### 1. Dead code that stays in the file

Label it explicitly with what's active and what's unused. Add a "do not use" directive.

```markdown
**Active**: kaikki.org JSONL at `dicts/kaikki.org-dictionary-Spanish.jsonl`. Parse with `load_kaikki()`.
**Unused**: `load_freedict()` still exists but `generate_cards` no longer calls it. Do not add FreeDict lookups.
```

### 2. Names that don't match their content

When a column, variable, or function name suggests something different from what it holds, name the mismatch.

```markdown
- **`en_gloss` vs `best_en`**: `en_gloss` is the short dictionary word (e.g. "weapon"). `best_en` is the full
  English corpus sentence with the matched word bolded. Never swap them.
```

### 3. Non-obvious constraints with reasons

When an approach that looks reasonable is actually wrong, state the constraint and why.

```markdown
- **Surface forms, not lemmas**: "hablo" and "hablas" are separate cards. Lemmatisation is only used
  as a bridge to look up the kaikki entry — the card always shows the surface form. Do not deduplicate
  by lemma; frequency is the whole point.
```

## Where an Entry Goes

An entry can pass the test above and still belong elsewhere. Route by **how often a session needs it**:

| Content | Home |
|---|---|
| Constraints that apply to any change | AGENTS.md |
| A job most sessions aren't doing — releasing, regenerating metadata, downloading schemas, a migration | A doc or skill, linked |
| What the project does, its feature list, its API surface | README |
| Rules a linter or formatter already enforces — naming, indentation, line length, import order | Nowhere; the tool checks them every time, for free. A command that *fixes* a failing gate is not one of these — it is a build rule, and it stays. |

The last row is the most common surplus. Keep the build gate, drop the style rule:

```markdown
✅ Run `./mvnw clean verify` before pushing, not `verify` — Error Prone only sees what javac recompiles.
❌ Use camelCase for variables and 2-space indentation.
```

## Linking Instead of Inlining

A bare path gets ignored. Say what the file holds **and when to read it** — the pointer has to earn the load.

```markdown
❌ See `docs/request-scheduling.md` for details.
✅ `docs/request-scheduling.md` — the concurrency semaphore, rate-limit retries, the conditional GET.
   Read before touching the client's transport.
```

## Size

Length is a symptom to investigate, not a target to hit. Anthropic's memory docs suggest under 200 lines. Past a few hundred, the cause is almost always a wrong-home entry from the table above, not a constraint that deserves cutting — so extract by job ("who would read this, and when?") rather than by trimming the reasons off the rules that stay.

## Pruning Existing Entries

When reviewing, cut anything that fails the test above:

- **Metrics** (test counts, file sizes, headword counts) — stale on the next commit; run the tool instead
- **Runtime behaviour** (input formats, error handling) — read the code; a docstring is the right home
- **Trivia that doesn't change any decision** — interesting details that have no actionable consequence
- **Duplicates** — one location, the most prominent one; delete the rest
- **Contradictions** — two entries that can't both be satisfied leave the model to pick one arbitrarily, so the behaviour goes unstable rather than wrong. Re-read the neighbours whenever you add a rule.
- **Unreviewed `/init` output** — a generated first draft describes the repo as it was on the day it was scanned. Treat it as a draft to edit, not as the configuration.

## Provenance

The routing table, the linking rule and the last two pruning bullets come from dos Santos et al., *Configuration Smells in AGENTS.md Files* (arXiv:2606.15828): six smells across 100 popular repositories, led by Lint Leakage (62% of files), Context Bloat (42%) and Skill Leakage (35%). It measures **prevalence, not harm** — nothing there shows an agent performing worse — and its 200-line figure is quoted from Anthropic's docs, not derived. The routing question is well-founded; the threshold is a prompt to look.
