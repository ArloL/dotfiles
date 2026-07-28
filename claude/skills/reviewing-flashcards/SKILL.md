---
name: reviewing-flashcards
description: Use when reviewing generated flashcards for bad sentence pairs to add to bad.json; after deck.py generates output, or when user reports a specific flashcard has a bad sentence.
---

# Reviewing Flashcards

## Overview

`bad.json` is the manual veto layer for the Spanish flashcard generator. The automatic filters (`single_match`, `is_clean`, `IDIOM_DENYLIST`) catch most bad picks, but some slip through. Human review catches the rest.

Each entry is `{word: [{es, en}, ...]}` — the Spanish and English sentences **unbolded**, matching `harvest.json`'s candidate format. `deck.py` matches on `es.strip()`.

## When to Review

- After initial deck generation — review the top-N cards for obvious bad picks
- When a word keeps getting bad picks across regeneration cycles
- When the user reports a specific card has a wrong match

## What to Look For

### Wrong English Bold

The bolded English token must semantically correspond to the Spanish target word. If the bold picks up an unrelated word, the card is bad.

| Problem | Example |
|---------|---------|
| Bolded word ≠ target | `por eso` → **am** (por eso = "that's why", not "am") |
| Bolded word from different part of sentence | `a la` → **manners** (a la ≠ manners) |
| Bolded word is wrong POS | `llegar` (verb) → **pass** (noun) — llegó ≠ "pass" |

### Broken / Non-Native English

If the English sentence has bad grammar, it shouldn't be used for a teaching card.

| Problem | Example |
|---------|---------|
| Subject-verb agreement | "He **go back** to her" (should be "goes back") |
| Wrong person/number | "We **has** to walk" (should be "have") |
| Mixed language | "You should let you **cogiesen**" — Spanish word in EN sentence |

### Misaligned Sentence Pairs

When the ES and EN sentences have different meanings, subjects, or polarity.

| Problem | Example |
|---------|---------|
| Opposite meaning | ES says "Usted dijo que **podía** pagar" (could), EN says "You **can't** pay" (opposite polarity) |
| Unrelated sentences | ES "Esta noche **hay** invitados" ≠ EN "I've got my best clothes on" |
| Surrounding context diverges, even if target maps | ES "Puede ser **muy** agradable" / EN "He's **very** nice" — `muy`↔`very` is fine, but "puede ser" (can be) has no English counterpart, so the rest of the sentence doesn't teach. |

The user reads sentences to map meaning while learning the target word — the surroundings should reinforce learning, not just the bolded token. If a learner can't piece together the non-target words from the parallel sentence, veto.

### Wrong Number / Gender

| Problem | Example |
|---------|---------|
| Singular ≠ plural | `estas` = "these" (feminine plural) but EN bolds "**this**" (singular) |
| Article mismatch | `es_display` shows "la agua" — should be "el agua" (code bug, not bad.json) |

### Non-Primary Sense

Even when the EN bold is a *valid* translation of the ES target, prefer cards that teach the **primary/canonical sense** of the word. Secondary or oblique senses make weak teaching cards because the learner is building first associations.

| Problem | Example |
|---------|---------|
| Object form of subject pronoun | `él` → **him** in "A él lo eché / I've thrown him out". Primary sense of `él` is subject "he"; prefer `Él es mi hermano / He is my brother`. |
| Idiom-for-idiom mapping | `así` → **way** in "Así se hace / Way to go". Neither side teaches `así` = "thus/like that". |
| Rare/figurative gloss when basic sense exists | A NOUN target glossed by a metaphorical EN equivalent when a literal one is available. |

If the dictionary has multiple senses, ask: *would a learner seeing this card for the first time infer the most common meaning?* If not, veto.

### Contraction Fragments

Contraction-fragment bolds (`I**'ve**`, `**has**n't`) are **acceptable** when the fragment semantically maps to the target. They're **bad** when the fragment belongs to an unrelated word.

| Verdict | Example |
|---------|---------|
| ✅ Acceptable | `tengo` → I**'ve**: "have" maps to "tener" |
| ❌ Bad | `hay` → I**'ve**: "'ve" belongs to "I have", not "hay" (there is) |

### Tense Mismatch (recurring pattern)

Past-tense Spanish verb targets (`podía`, `pudo`, `pude`, `dijo`, `decía`, `había`, `fuiste`, `hizo`, `cree` 3rd-pres vs "believed", `siente` vs "felt") routinely get glossed against present/wrong-tense English. `single_match` does not catch tense — only lemma identity — so these slip through constantly. When the bolded EN verb is the right meaning but the wrong tense, veto.

### Idiomatic Constructions Lose the Target's Meaning

When the ES target appears inside a fixed idiom and the EN translation maps the *idiom's* meaning to a different ES word, the card is bad even though the bold mechanically matches.

| Example | Issue |
|---------|-------|
| `acabo` → "**finished**" in "Acabo de terminar…" / "I just finished…" | `acabo de` = "I just"; "finished" maps to `terminar` |
| `hubo` → "**had**" in "Hubo que…" / "I had to…" | `hubo que` is impersonal "it was necessary to"; subject doesn't match |
| `por eso` → "'**re**" in "Por eso…" / "you're…" | `por eso` = "that's why"; `'re` belongs to "you" |

## Process

When this skill is invoked, review the **entire** CSV unless the user explicitly scopes it (e.g. "just the top 50", "just word X"). Don't ask which range — go through the whole file.

1. **Read the CSV** — `data/<corpus>.flashcards.csv`
2. **For each card**, check: does `en_answer`/EN bold make sense for `es_word`?
3. **If bad**, strip `**` bold markers from `best_es` and `best_en`
4. **Add to bad.json** via Python (not Edit) — see below

### Adding entries safely

`bad.json` may contain **duplicate top-level keys** from historical edits (`json.load` silently keeps only the last one). Always go through Python with an `object_pairs_hook` that merges. Editing the file by hand or with `Edit` risks (a) clobbering a sibling duplicate key and (b) typos in nested JSON.

Template:

```python
import json
from collections import OrderedDict

def merge_pairs(pairs):
    # Inner entries are {"es": str, "en": str} — leave them as plain dicts.
    if not all(isinstance(v, list) for _, v in pairs):
        return dict(pairs)
    merged = OrderedDict()
    for k, v in pairs:
        if k in merged:
            seen = {(e["es"], e["en"]) for e in merged[k]}
            for entry in v:
                if (entry["es"], entry["en"]) not in seen:
                    merged[k].append(entry)
        else:
            merged[k] = list(v)
    return merged

with open(path) as f:
    data = json.load(f, object_pairs_hook=merge_pairs)

new_entries = { "word": [{"es": "...", "en": "..."}], ... }
for k, entries in new_entries.items():
    data.setdefault(k, [])
    seen = {(e["es"], e["en"]) for e in data[k]}
    for entry in entries:
        if (entry["es"], entry["en"]) not in seen:
            data[k].append(entry)

with open(path, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")
```

Detect duplicate keys at any point with:
```bash
grep -n "^  \"" data/<corpus>.bad.json | awk -F'"' '{print $2}' | sort | uniq -d
```

### When to escalate to a code fix instead

`bad.json` is per-sentence. If the same word produces a new bad pick after every regeneration (e.g. `podía` → "can" on three different sentences), per-sentence vetoes are whack-a-mole. The real fix is in `flashcardlib.py`:

- **Tense leakage** (`podía`/`pudo`/`pude` all glossed "can") → `GLOSS_OVERRIDE` to `["could"]`, or `GLOSS_DENYLIST` removing "can"
- **Plural demonstratives** (`estas`/`estos`/`esos`/`esas` glossed "this"/"that") → `GLOSS_DENYLIST` removing singular forms
- **Idiom-only senses** → `GLOSS_OVERRIDE` to the literal sense only

Flag this to the user rather than stacking 5+ vetoes for the same word.
