---
name: effective-claude-md
description: Use when updating or writing CLAUDE.md entries after code changes, refactors, renames, or schema changes — especially when dead code remains, naming is misleading, or a "do not" pattern needs to be established for future AI instances.
---

# Effective CLAUDE.md Entries

## Overview

A future AI instance will read CLAUDE.md cold, then look at the code. Write entries that surface what the code **misrepresents or hides** — everything else is noise that will rot.

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

## Pruning Existing Entries

When reviewing, cut anything that fails the test above:

- **Metrics** (test counts, file sizes, headword counts) — stale on the next commit; run the tool instead
- **Runtime behaviour** (input formats, error handling) — read the code; a docstring is the right home
- **Trivia that doesn't change any decision** — interesting details that have no actionable consequence
- **Duplicates** — one location, the most prominent one; delete the rest
