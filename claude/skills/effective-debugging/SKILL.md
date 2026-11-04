---
name: effective-debugging
description: Use when anything fails or surprises you and the cause is not yet known — a reported bug, a failing or flaky test, a regression, a production incident, a slow or hanging process, a red CI job, a misbehaving tool or setup step, a probe's odd number — especially in code you did not write or no longer understand, and before reading code or guessing at a cause. Also use when a fix did not hold, when deciding whether to trust a repro, or when checking someone's root-cause claim.
---

# Effective Debugging

Code says what *can* happen; evidence says what *did*. Treat debugging as constraint satisfaction: gather facts, find what a control lacks, and keep only the hypothesis every fact allows.

This guards against how agents fail: a convincing story from thin evidence, a rare edge case taken for the bug, and a best finding walked past later. A wrong story can sound plausible even to the person who read every line, so human pushback can't be the safeguard.

It holds for everything that fails: the app, a test, the harness, a CI step, a tool, your own probe.

Scale it to the bug. When an error already pins the line, that is a strong signal: check it against the other facts and fix it, with the matrix in your head. Use the whole loop once the first obvious answer is wrong or the cause isn't obvious.

| Term | Meaning |
|---|---|
| Variable | the case where the bug shows |
| Control | the case you compare it with, ideally differing in one thing |
| Fact | what was observed by a tool or a person, not inferred. Hypotheses and repros are not facts |
| High-fidelity signal | a fact in the variable but not the control |
| Noise | a fact in both. It can eliminate a hypothesis but never says where to look |
| Strong signal | a high-fidelity signal that very few hypotheses fit |

Keep a running list of facts and the matrix in your notes, and reread them before each conclusion.

## 1. Gather facts before reading code

Read code only to explain a fact you hold, or to find where evidence lives, and read the version that actually ran. Hypotheses formed from code first are the commonest route to a wrong answer, because the state space is huge and you choose which snapshot to read.

- **Start from the report, word for word.** Each detail is a constraint: the version it began in, the last good one, the config, the frame in a profile. If it has repro steps or artefacts, use them before anything else.
- **Cheapest first:** what came with the report, then logs, telemetry, config, flags, dependency versions, deploy and commit history.
- **Want many facts:** different sources, and the same data from several instances of the bug. A pattern across instances that the control lacks is unlikely to be coincidence.
- **Prefer raw data to aggregates, and count things.** 5 addresses against 400 is arithmetic, not interpretation. A P99 or an SLO is a symptom that almost any hypothesis can explain.
- **Go where the bug happened.** A local rebuild can't reproduce production's facts, so read them from production where you have access: read-only and scoped. Captures and dumps can hold secrets: keep them out of the repo and delete them after.
- **Get it yourself.** Ask a person only for what you can't reach, never for what a log or the repo holds. Before chasing a finding seen on one OS or version, check that it's one the reporter runs.
- **Facts don't move.** Note each one's source, host, time and version. If one looks wrong, re-gather it or ask who gathered it; don't argue it away.
- **Your own probes are facts you gathered.** Check the path, the clock and the instrument before reading the number: a probe of the wrong folder reads as a finding.
- **Keep each measurement where it can be read back,** and iterate where a cycle is short: one question per run, its control alongside.

## 2. Find the high-fidelity signals with a control

Without a control, you can't tell which of many facts matter. Pick it first:

- **Happy path:** the same thing with the suspect removed: flag off, the last good version, a passing run, another host.
- **Sad path:** a case that also fails, for a different, well-understood and louder reason. Use it when the happy path differs in too many ways or is costly to set up. It often already sits in your data.

Then diff the two, broadly. Look at what you have no theory about, not only what your hypothesis predicts: a latency regression's cause came from asking "what else differs?", in DNS answers nobody suspected. Write throwaway scripts to do the diffing.

Check the control isn't broken the same way, since that turns every real signal into noise.

## 3. Write the hypotheses-by-fact matrix

One row per hypothesis, one column per fact. ✓ means the hypothesis explains or allows the fact, ✗ that it contradicts or leaves it unexplained.

| | P99 up | handshake same | cert loaded once | DNS 5 vs 400 |
|---|---|---|---|---|
| cert reloaded per call | ✓ | ✓ | ✗ | ✗ |
| server capacity | ✓ | ✓ | ✓ | ✗ |
| client routing broke | ✓ | ✓ | ✓ | ✓ |

- **Read the columns to steer.** A fact that few rows fit is a strong signal; one that all rows fit is weak. Follow the row the strongest signal points to, rather than testing every hypothesis.
- **Read the rows to check.** A row of all ✓ is the candidate. It may be one cause or a combination; in a combination, each cause must be needed for some fact.
- **Before a costly search,** such as a bisect or a long rerun, apply the constraints you already hold.
- **Run anything long in the background,** with one command that ends when the work does, such as `gh run watch --exit-status`, through `run_in_background`. Don't block on it or poll it. `Monitor` stops after 30 minutes at most, so re-arm it for longer CI. Meanwhile work on what doesn't depend on the result, and read the result as soon as it ends.

If no row is all ✓, work through these, cheapest first, rebuilding the matrix after each:

1. **Re-verify how each fact was gathered:** host, time window, build, tool.
2. **Split** a hypothesis that bundles two ideas. A fact may kill only one of them.
3. **Merge** fine-grained ones, each explaining one symptom, into what they share.
4. **Combine** complementary ones that each explain what the other can't.
5. **Only then form a new hypothesis,** from the facts you hold.

If every signal is weak, or the five find nothing, **gather from one layer down and return to step 1** with its control. More hypotheses won't help: many surviving ones mean too few constraints or weak ones. See `references/layers.md`. You can read a kernel IPC table or a packet capture as readily as a log, so don't stop where a person would. Stop at the first strong signal: you want the strongest, not the deepest.

## 4. Treat a repro as a hypothesis

A repro proves *a* bug exists, not that it's *this* bug, and a synthetic harness can produce the same symptom from a different cause. Take the strongest signal from the reported case and check the repro produces it too. If it doesn't, it's noise here, however alike the symptoms look. If a fake misled you, correct it and compare its output with the real thing's.

## 5. Validate against every fact, and review to eliminate

Call it a candidate until it survives this. Check it against every fact, noise included:

- **A fact contradicts it:** discard it and steer to the next. If none is left, return to the five tactics.
- **Several survive:** gather more facts.
- **Exactly one survives:** that's the cause, as far as the facts go.

Every claim cites a fact. Drop the ones that can't.

Ask for review at each step: a fresh subagent if you have one, or these questions yourself if not. Give the reviewer the facts and the matrix, not your conclusion, and ask for a contradiction. Agreement proves little: a reviewer can't see a fact nobody gathered, and one sharing your context and model is one opinion counted twice. A wrong theory can pass independent review, then fall to the next fact gathered.

| Step | Ask |
|---|---|
| Signals | Is it also in the control? Is the control broken the same way? Was each fact gathered from the right host, window and tool? |
| Hypothesis | How many hypotheses fit this signal? Was this layer exhausted before descending? |
| No row fits | Was the fact gathered wrongly? Does a contradicted hypothesis bundle a part that survives? Was a new hypothesis formed before tactics 1 to 4? |
| Validation | Which one fact does it fail? Which claim has no citation? Remove each cause in turn: is a fact left unexplained? |

## 6. Leave people the decisions, and make them policy

Diagnosis shouldn't need a person. Acting on it may: rolling back, escalating to another team, dropping a feature, or choosing between fixes with different trade-offs. Present those as options, each with its trade-off and your reasoning. Record the answer where agents will read it next time.

## 7. Close the loop

- **Test** at the lowest level that shows the reported signal, and assert that signal rather than only the outcome.
- **Count the interventions.** Each message a person sent after the report supplied a control, a constraint or a check. Name what would have gathered it without them.
- **Record the signal by default** if it wasn't, at the shallowest layer, so the next agent needn't descend. Do it if it's in scope, otherwise propose it.
- **Consider a gate** on the signal: a check comparing it with the last good run catches the regression before its symptom does.
- **Log it** wherever the project logs escaped bugs.

## Report

State the cause, whether it is confirmed or still a candidate, and the fix or the options. Then show:

- the control used, and what only the variable had;
- the matrix, or for a small bug the facts that pin it, each with its source;
- what eliminated the runners-up;
- whether a repro produced the reported signal;
- what remains unverified.

Method from Cindy Sridharan, [How to effectively debug when you no longer understand the code](https://copyconstruct.medium.com/how-to-effectively-debug-when-you-no-longer-understand-the-code-bd3dcb2c5f7b).

For worked examples, or when revising this skill, read the full article and its diagrams in `references/source/`. They are not in git, so they exist only on the machine that saved them.
