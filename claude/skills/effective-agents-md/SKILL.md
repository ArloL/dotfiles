---
name: effective-agents-md
description: Use when writing, reviewing or pruning AGENTS.md or CLAUDE.md entries — after code changes, refactors, renames or schema changes, when dead code remains, when naming is misleading, when a "do not" pattern needs establishing for future AI instances, when an entry might belong in a linked doc instead, or when a file has grown and someone wants it cut down.
---

# Effective AGENTS.md Entries

## Overview

A future AI instance will read AGENTS.md cold (CLAUDE.md in Claude Code — same file, different name), then look at the code. Write entries that surface what the code **misrepresents or hides** — everything else is noise that will rot.

The file loads into every session, so each entry is paid for on every task. Two questions decide it: **is this worth writing**, and **does it belong in the always-loaded file**.

Frame entries as what to do, not what to avoid — active framing is more memorable and harder to rationalise away. The exception is a prohibition that prevents damage: "never push to `main`", "never edit `generated/`". Those keep their "never", and they stay in the always-loaded file, because a rule that loads conditionally is missing from exactly the session that was about to break it.

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

## Reviewing a File Someone Wants Cut Down

Your judgement about what is surplus is already good, and a careful read will find the duplication and the dead weight without help. What follows is the short list of what that judgement reliably gets **wrong** under instruction to shorten — each one measured, not theorised (see Provenance). Nothing else here needs a rule.

**1. Do not widen a rule while rewriting it.** Compressing tempts you to state a rule more generally than the code supports — "every model call goes through `AiServices`" when that is how two of eight call sites work. The reader follows the general form and is wrong, with nothing to catch it. Before you rewrite a rule into a cleaner sentence, count the places it actually holds; if it is two, name the two.

**2. The command a session runs most stays in this file.** The README has it too — that is not a duplicate worth removing. Replacing `./mvnw clean verify` with "commands are in the README" costs every session an extra read to reach the first thing it needs.

**3. A one-line rule with no other home is the cheapest thing in the file.** "`warmUp()` runs before the first check", "`tmpSuffix` is required", "keep both catch arms". Beside a paragraph they read as trivia, they cost a line each, and nothing else in the repo records them. Cutting one to shorten a file is the worst trade on offer.

**4. Keep one clause of why.** A rule stripped to a bare imperative cannot be checked, so the next reviewer deletes it as arbitrary. The reason is usually shorter than the rule. "Don't lower the floor" is an assertion; "don't lower the floor — 140 is where `data_collection_permissions` landed" is checkable.

**5. Keep the symptom that makes a rule survive.** The bug it produced, the issue number, the one concrete case. These look like history and cutting them feels like exactly the right cut — but they are what stops the rule reading as arbitrary the next time someone decides it looks redundant.

## Rewrite, Don't Only Delete

A pass that only removes lines hands back the original in the original order, and the reader's problem — finding the rule that applies to the change in front of them — is untouched. Three moves do more than any amount of cutting:

- **Order by the question a session arrives with**, not by the order the file grew. Headings like "Where a change goes", "Adding a setting", "Releasing" beat "Notes", "Gotchas", "Misc".
- **Lead each entry with the rule**, then the reason. The story goes after the instruction, or not at all.
- **Put the build commands and a map of the docs at the top** — what each holds and when to read it. That is the first thing a cold session needs and it is usually buried.

## Where an Entry Goes

An entry can pass the test above and still belong elsewhere. Route by **how often a session needs it**:

| Content | Home |
|---|---|
| Constraints that apply to any change | AGENTS.md |
| Constraints for one module, package, or file type | A nested `AGENTS.md` in that directory — it loads only while the session is working under it. Claude Code also reads `.claude/rules/*.md`, which take a `paths:` frontmatter glob and load only when a matching file is in play. |
| A job most sessions aren't doing — releasing, regenerating metadata, downloading schemas, a migration | A doc or skill, linked |
| What the project does, its feature list, its API surface | README |
| Rules a linter or formatter already enforces — naming, indentation, line length, import order | Nowhere; the tool checks them every time, for free. A command that *fixes* a failing gate is not one of these — it is a build rule, and it stays. Read the config before you decide: a rule nobody wired into the tool is enforced by nothing. |

Keep the build gate, drop the style rule:

```markdown
✅ Run `./mvnw clean verify` before pushing, not `verify` — Error Prone only sees what javac recompiles.
❌ Use camelCase for variables and 2-space indentation.
```

**Moving something means writing it at the destination, in the same change.** A pointer to a file that does not exist is not a move — it is a deletion with a citation, and it costs the reader a wasted lookup plus a reason to distrust every other pointer in the file. If you cannot create the destination, leave the entry in place and record the proposed move separately.

## Linking Instead of Inlining

A bare path gets ignored. Say what the file holds **and when to read it** — the pointer has to earn the load.

```markdown
❌ See `docs/request-scheduling.md` for details.
✅ `docs/request-scheduling.md` — the concurrency semaphore, rate-limit retries, the conditional GET.
   Read before touching the client's transport.
```

## What Does Come Out

- **The same fact written twice** — inside the file, or already carried by a doc, a docstring, or the comment beside the code it constrains. Keep the copy a session will be standing in front of when it needs it.
- **Anything a session could rebuild in a few tool calls** — directory layouts (`ls`), the tech stack (the manifest), architecture tours, API signatures copied from source, the standard invocation of a standard tool. The codebase is the README.
- **Generic advice the model already follows** — "write clean code", "handle errors properly", "add tests".
- **Numbers that are status, not constraint** — coverage percentages, test counts, annotation counts. Stale next commit; run the tool.
- **Contradictions** — two entries that can't both be satisfied leave the model to pick one arbitrarily, so behaviour goes unstable rather than wrong. Re-read the neighbours whenever you add a rule.
- **Unreviewed `/init` output** — a generated first draft describes the repo as it was the day it was scanned. A draft to edit, not the configuration.

When a line is borderline, keep it: the author wrote it for a reason the code may not show you. Quote what you remove in the summary, so putting it back costs nothing.

## Size

**Length is not a finding.** Count constraints, not lines: six hundred lines of traps is six hundred lines that each earn their load. When a file feels long, the win is usually reordering and re-heading it, not emptying it. Anthropic's memory docs suggest under 200 lines; Claude Code's `/doctor` measures characters instead (~5% of the context window, floor ~40,000). Both are prompts to look, neither knows whether your lines are constraints.

## Provenance

The routing table and the linking rule come from dos Santos et al., *Configuration Smells in AGENTS.md Files* (arXiv:2606.15828): six smells across 100 popular repositories, led by Lint Leakage (62%), Context Bloat (42%) and Skill Leakage (35%). It measures **prevalence, not harm**, and its 200-line figure is quoted from Anthropic's docs, not derived. The derivable-content list and the character threshold come from Claude Code's `/doctor` prompt (v2.1.278, checks 2–4) — a product prompt, not evidence, but it is what the tool will propose cutting.

**"Reviewing a File Someone Wants Cut Down" is the load-bearing section and every item in it is measured.** Twenty-four blind pairwise comparisons across three real repositories, arms hidden and order randomised, judged against the repo. A capable model given no guidance at all won 15 of its 18 pairs — so this skill is deliberately a thin correction to good judgement, not a framework replacing it. Its five items are that baseline's recurring faults, ranked by how often the judges named them: widening a rule while rewriting it (11 pairs), pushing the most-used command out of the file (in all 3 of its defeats), dropping one-line rules with no other home (10 pairs), dropping the reason, and dropping the symptom. Three earlier versions of this skill, which instead supplied a full framework for what to keep and cut, each lost 1–5 against no skill; two of them told the reviewer to cut the reason and the symptom, which is why those two items are stated here as corrections.
