# Configuration Smells in AGENTS.md Files: Common Mistakes in Configuring Coding Agents

Hélio Victor F. dos Santos, Vitor Costa, João Eduardo Montandon (Department of
Computer Science, Federal University of Minas Gerais, Belo Horizonte, Brazil) ·
Luciana Lourdes Silva (Department of Computing, Federal Institute of Minas
Gerais, Ouro Branco, Brazil) · Marco Tulio Valente (UFMG)

arXiv:2606.15828v5 [cs.SE], 30 Jul 2026 · <https://doi.org/10.48550/arXiv.2606.15828>

## Abstract

Coding agents are increasingly used to automate software engineering tasks. To
guide their behavior, these agents commonly rely on configuration files,
typically named `AGENTS.md` or `CLAUDE.md`, which provide instructions about
architecture, workflows, coding conventions, and testing practices. Despite
their growing importance, little is known about common problems affecting the
definition and maintenance of these files. In this paper, we present the first
catalog of smells for coding-agent configuration files. To identify such smells,
we first conducted a grey literature review and a repository mining analysis. As
a result, we identified six configuration smells and proposed automated
heuristics to detect them. To evaluate the prevalence of the proposed smells, we
analyzed 100 popular open-source repositories containing either an `AGENTS.md`
or a `CLAUDE.md` file. Our results show that configuration smells are
widespread. **Lint Leakage** was the most common smell, affecting 62% of the
files, followed by **Context Bloat** (42%) and **Skill Leakage** (35%). We
further show that several smells frequently co-occur, particularly *Context
Bloat*, *Skill Leakage*, and *Conflicting Instructions*.

## I. Introduction

Large Language Models (LLMs) are transforming the way software is developed by
automating a wide range of software engineering tasks. For example, LLMs can
assist developers with code generation [1, 2], bug fixing [3], test creation
[4, 5], code review [6], documentation writing [7, 8], software migration
[9, 10], and code smell detection [11]. Initially, these capabilities were
delivered through coding assistants that interactively support developers while
they write code. For example, this was the case with the first version of GitHub
Copilot, launched in 2021. More recently, however, automation has advanced with
the emergence of coding agents, such as [Claude
Code](https://claude.com/product/claude-code),
[Codex](https://openai.com/codex/), [Cursor Agent](https://cursor.com/agents),
and [Gemini CLI](https://ai.google.dev/gemini-api/docs), which can execute
complex tasks with limited intervention.

Coding agents are designed to operate autonomously. Given a high-level goal,
they can plan and execute multiple actions until the requested task is
completed. Architecturally, a coding agent can be viewed as a combination of a
language model and a harness. The language model provides reasoning and
inference capabilities, while the harness implements an agentic loop that
repeatedly interacts with the model, executes actions, and feeds the results
back to the model. During this loop, agents can invoke a variety of external
tools, including code search utilities, shell commands, test runners,
version-control systems, web search engines, and issue-tracking platforms.

To guide their behavior, coding agents commonly rely on project-specific
configuration files, typically named `AGENTS.md` or `CLAUDE.md`. These files
contain instructions that complement the agent's built-in capabilities, such as
coding conventions, architectural guidelines, testing requirements, project
workflows, and domain-specific knowledge. Their main purpose is to provide
persistent contextual information that helps agents behave consistently across
different tasks and sessions. In most agent harnesses, the configuration files
are loaded when a session starts, incorporated into the agent's prompt, and
maintained as part of the context available throughout the execution of the
agentic loop.

Given their importance for the performance of coding agents, **in this paper we
present a catalog of smells commonly found in agent configuration files**. To
identify these smells, we conducted a review of the grey literature, covering 14
recent articles on the topic. As a result, we identified six smells that may
occur in these files and, consequently, impair the overall performance of coding
agents. We then used a set of heuristics to detect these smells in a dataset of
100 popular open-source projects containing either an `AGENTS.md` or a
`CLAUDE.md` file. In total, we identified 207 instances of the proposed smells.
The most common smell was *Lint Leakage*, with 62 identified instances. This
smell refers to instructions in configuration files that essentially restate
rules already enforced by automated tools such as linters and formatters, thus
unnecessarily consuming context space and tokens. We also analyzed the
co-occurrence of smells in our dataset and discovered several strong
relationships. For example, two smells (*Skill Leakage* and *Conflicting
Instructions*) increase the likelihood of *Context Bloat* by 83%. These results
are important because they allow us to understand which smells can trigger the
appearance of others in configuration files.

The remainder of this paper is organized as follows. Section II provides
background on the role and importance of configuration files in agentic
development. Section III details our study design and methods, which included a
grey literature review, the creation of a dataset of real-world agent
configuration files, and a manual analysis of pull requests involving changes to
such files. Section IV describes the configuration smells that can occur in
agent configuration files, i.e., the proposed catalog. Next, Section V defines
the heuristics used to detect these smells, and Section VI reports their
occurrence in our dataset. Section VII then investigates co-occurrence
relationships among the identified smells. Finally, Section VIII discusses
threats to validity, Section IX reviews related work, and Section X concludes
the paper.

## II. Coding Agents Configuration Files

While the effectiveness of coding agents is heavily dependent on the capacity of
the underlying model, it is equally restricted by the harness used for task
execution. In this scenario, agent configuration files — such as `AGENTS.md` and
`CLAUDE.md` — emerge as a standard for context injection and for providing a
persistent memory for coding agents. According to Xi et al. [12], the
effectiveness of an agent lies not only in the power of the base model but in
the precision with which guidelines are defined, stored, and retrieved.

In essence, `AGENTS.md` is a markdown file with rules about the project. In this
file, one can add information regarding system architecture, tool documentation,
testing practices, and other constraints whose absence might lead to agent
errors. In a recent study, Santos et al. [13] indicate that the most common
sections in these files cover architecture, development rules, project
overviews, and testing workflows.

Upon starting a session, the agent detects the presence of `AGENTS.md` files in
the project directory and incorporates their content into the agent's prompt,
persisting this context throughout the entire agentic loop [14]. An example of a
configuration file can be seen in Figure 1 (extracted and adapted from
<https://agents.md>). This file includes a commands section for project setup,
project-specific code style rules, and workflow definitions for the model.

**Figure 1. Example of `AGENTS.md` file**

```markdown
# AGENTS.md

## Setup commands
- Install deps: `pnpm install`
- Start dev server: `pnpm dev`
- Run tests: `pnpm test`

## Code style
- TypeScript strict mode
- Use functional patterns where possible
- Use ES modules (import/export) syntax, not CommonJS (require)

## Workflow
- Be sure to typecheck when you're done making a series of code changes
- Prefer running single tests, and not the whole test suite, for performance
```

The first version of the `AGENTS.md` file can be created automatically by the
agent itself. In this case, a specific command — generally `/init` — relies on
an internal prompt instructing the agent to inspect the repository and leverage
an initial set of guidelines. For example, the prompt used by the OpenAI Codex —
which is [publicly
available](https://github.com/openai/codex/blob/main/codex-rs/tui/prompt_for_init_command.md)
— asks the agent to summarize the project structure and module organization,
build and testing commands, coding and naming conventions, testing guidelines,
and pull request requirements, while keeping the resulting document concise,
instructional, and tailored to the analyzed repository.

It is also possible to use both files in the same repository. In this case, one
file should simply point to the other one. For example, the `CLAUDE.md` file may
exist but contain only the following line: `read AGENTS.MD`.

> **Note:** Most agent-based systems use the name `AGENTS.md` for their
> configuration files. The notable exception is Claude Code, which uses the name
> `CLAUDE.md`. Therefore, in this paper, we analyze both `AGENTS.md` and
> `CLAUDE.md` files, since the only difference between them, in terms of purpose
> and role within an agent-based system, is their name.

## III. Methods

To research the smells that affect agent configuration files, we employed three
methods: a grey literature review (Section III-A), the creation of a dataset of
real-world agent configuration files (Section III-B), and an analysis of
discussions conducted in pull requests (Section III-C).

### A. Literature Review

Grey literature review is commonly used in software engineering research to
gather information for emerging topics, since it emphasizes the inclusion of
non-academic sources, such as blog posts, technical reports, and documentation
[15]. Our procedure is depicted in Figure 2 and consists of three main steps:
(a) Google search, (b) Document selection, and (c) Data extraction and
validation.

**Figure 2. Overview of the grey literature steps**

```
Google Search (May 2026)  →  Document Selection  →  Data Extraction and Validation
~532,000 documents           Google Top-30           6 agent smells
                             14 documents
```

**Document Search:** We started by performing a Google search to identify
documents that describe bad practices or smells in `AGENTS.md` files. Similar to
other grey literature reviews, we restricted our search to Google due to its
wide coverage and relevance for retrieving non-academic sources [16, 17].
Specifically, the search query, as presented in Figure 3, looked for documents
containing the terms *agents.md* or *claude.md* together with terms related to
*bad smells*, *anti-patterns*, and *best practices*.

**Figure 3. Search string used in the literature review**

```
("agents.md" OR "AGENTS.md" OR "claude.md" OR "CLAUDE.md")
AND
("bad smell" OR "bad smells" OR "anti-pattern" OR "anti-patterns" OR
 "antipattern" OR "antipatterns" OR "bad-practice" OR "bad-practices" OR
 "bad practice" OR "bad practices" OR "best-practices" OR "best practice" OR
 "best practices")
```

**Document Selection:** Our search returned 532,000 documents. From these
results, we manually analyzed the first 30 documents returned by the search;
i.e., the ones returned in the first three pages. The first author discarded 16
documents according to the following criteria: (a) five documents were
accessible only through subscription or paywall; (b) four documents were out of
scope, i.e., focused on specific tools or other topics; (c) three represented
discussion threads on forums; (d) three documents did not explain any bad smell
or best practice on `AGENTS.md` files, they only listed these issues pointing to
the official documentation of the tools; and (e) one document was written in a
non-English language. As a sanity check, the third author analyzed each
discarded document to confirm the reason for exclusion; no disagreements were
found in this process. The remaining 14 documents were selected for the next
step. We also assessed the quality and reputation of the authors of all selected
documents. Six documents were published by well-known companies, such as
Anthropic and GitHub. The remaining eight documents were written by authors with
relevant expertise in the field (seven authors have at least six years of
experience, and one author has two years). Furthermore, three of the articles
were extensively discussed on Hacker News (a well-known forum for technology and
startup discussions), receiving at least 140 upvotes each. Throughout this
paper, we refer to these documents using the identifier *D<sub>n</sub>*, where
*n* is a numeric identifier. The list of selected documents is available in our
replication package.

**Smells Extraction and Validation:** For each selected document, the first
author thoroughly read its content and marked any sentence that described
practice to avoid when creating `AGENTS.md` files. Following this initial
extraction, the second author reviewed the annotations as a sanity check to
confirm whether they actually describe a bad smell. This process revealed four
disagreements, which both authors discussed to reach a consensus. After this
annotation process, the first and last authors manually grouped sentences
describing similar smells and proposed a name and a short description for each
group. They also decided to discard one smell that is not specific to coding
agents: exposing secret keys in configuration files. At the end, **we obtained a
list of six smells**.

### B. Dataset of Agent Configuration Files

To investigate whether the smells actually occur in real projects, we created **a
dataset with 100 agent configuration files**, including 39 `AGENTS.md` and 61
`CLAUDE.md` files. We selected these files using the following steps. In January
2026, we used the GitHub Search API to find repositories containing either
`AGENTS.md` or `CLAUDE.md` in their root folder. Next, we manually removed from
this list repositories that are not applications, e.g., awesome lists and
tutorials. From the remaining ones, we selected the top-100 repositories with
the highest number of stars. For example, our dataset of selected GitHub
projects includes [`n8n-io/n8n`](https://github.com/n8n-io/n8n) (a workflow
automation platform),
[`langchain-ai/langchain`](https://github.com/langchain-ai/langchain) (an agent
engineering platform), and [`vercel/ai`](https://github.com/vercel/ai) (an AI
Toolkit for TypeScript).

### C. Pull Requests Analysis

After creating the dataset of files described in the previous section, we
decided to inspect the Pull Requests (PRs) of the corresponding projects to
determine whether they contained discussions about potential issues in agent
configuration files. Such issues could help expand the list of six smells
identified through our grey literature review. Next, we explain how the pull
requests were selected and analyzed.

**Pull Requests Selection:** We collected all commits associated with each of
the 100 configuration files in our dataset, including modifications, additions,
and deletions. This process yielded an initial dataset composed of 760 commits.
From this initial dataset, we selected only the ones linked to pull requests,
resulting in a total of 383 pull requests.

A manual inspection was then performed on the conversation history of each
filtered pull request to check whether the ongoing discussions about the target
files, `CLAUDE.md` and `AGENTS.md`, were in fact of substantive relevance. We
discarded all PRs that met any of the following exclusion criteria: (a)
conversations consisting entirely of bot-generated messages; (b) threads where
human participants interacted exclusively with bots; (c) discussions that failed
to actively engage with or reference the `AGENTS.md` or `CLAUDE.md` files; (d)
PRs containing only the initial opening description without any subsequent
discussion or peer review. The application of these sequential filters yielded a
**final corpus of 17 relevant pull requests**.

**Pull Requests Analysis:** After analyzing the 17 pull requests, we found
discussions about configuration-related problems in only two of them. These pull
requests were labeled *PR<sub>1</sub>* and *PR<sub>2</sub>* and are also included
in our replication package. However, the discussions concerned smells that had
already been identified in the grey literature review. Therefore, **our list
remained unchanged, containing six smells**. Although no new smells were
discovered, the analysis of PRs was still valuable because it provided concrete
examples of discussions about smells in agent configuration files, which we use
to illustrate the content of Section IV.

> As an additional note to this analysis, in six PRs, the goal was to
> consolidate agent-related documentation into a single file. For example, one
> PR was described as a pure rename of `CLAUDE.md` to `AGENTS.md`.

## IV. Configuration Smells

Table I presents a list of the smells identified in our study. The table also
shows the identifiers of the articles in which these smells were found. In the
remainder of this section, we provide a description of the smells listed in this
table.

**Table I. Configuration smells**

| Smell | Articles and PRs |
| --- | --- |
| Context Bloat | D1, D3, D4, D5, D6, D9, D11, D12, D13, D14, PR1 |
| Skill Leakage | D2, D3, D4, D5, D6, D11, D12, D13, PR2 |
| Lint Leakage | D1, D4, D5, D6, D9, D13 |
| Blind Reference | D6, D7 |
| Init Fossilization | D4, D6, D9, D10, D13 |
| Conflicting Instructions | D1, D3, D6 |

### A. Context Bloat

This was the most frequently cited smell in our documents, being mentioned in 10
out of the 14 reviewed articles and in one PR. It occurs when an `AGENTS.md`
file becomes excessively large and overloaded with rules, examples, or
low-priority details. Bloated configuration files increase token consumption,
raise costs, and reduce the visibility of important instructions. Therefore,
`AGENTS.md` files should remain concise and focused on essential project-specific
guidance. For example, [Anthropic's
documentation](https://code.claude.com/docs/en/memory) explicitly recommends the
following: *target under 200 lines per `CLAUDE.md` file. Longer files consume
more context and reduce adherence.*

To provide another example, in one of the pull requests we analyzed
(*PR<sub>1</sub>*), the authors proposed restructuring the `AGENTS.md` file to
reduce its size. The PR explicitly states that the project's configuration file
was reduced from 598 to 149 lines, because *modern LLMs tend to perform better
with configuration files containing approximately 150 to 200 lines*.

### B. Skill Leakage

This smell occurs when specific, rarely used, or highly context-dependent
instructions are placed in the `AGENTS.md` file instead of being specified in
dedicated skill files (e.g., `skills.md`) and loaded on demand. In practice,
this means that specialized knowledge "leaks" into every agent session, even
when it is not needed. As a result, the agent's context becomes larger, more
expensive, and harder to maintain. Furthermore, such rules may compete for
attention with the rules that are actually critical for the project. For
example, one of the articles explicitly recommends the following: *Instead of
including all your different instructions about building your project, running
tests, code conventions, or other important context in your CLAUDE.md file, we
recommend keeping task-specific instructions in separate markdown files with
self-descriptive names somewhere in your project.* (D13)

### C. Lint Leakage

This smell occurs when an `AGENTS.md` file includes rules that are already
checked by linters, formatters, or other static analysis tools. Typical examples
include naming conventions (such as camelCase or PascalCase), formatting rules,
import ordering, maximum line length, or generic style-guide recommendations.
Because these constraints are automatically checked by local tools, repeating
them in `AGENTS.md` adds limited value while unnecessarily increasing the
agent's context size [18]. Moreover, emphasizing such coding rules can divert
the model from focusing on more important project-specific concerns, such as
architectural constraints, domain rules, or safety policies. For example, one of
the articles explicitly recommends the following: *Code style enforcement is the
biggest trap. Formatting, indentation, import ordering: these are deterministic
problems with deterministic solutions. Linters and formatters like Biome,
ESLint, or Ruff handle them faster, cheaper, and with 100% consistency. Spending
instruction budget on style rules is dead weight: the same work a pre-commit
hook does for free.* (D6)

### D. Blind References

This smell occurs when an `AGENTS.md` file contains references to external
documents, files, or directories without explaining their purpose or scope. As a
consequence, the agent may unnecessarily load large documents into context,
ignore important references, or fail to prioritize the correct source of
information for a given task. Thus, a better practice is to complement
references with concise descriptions explaining the role of the document, the
type of information it contains, and the context in which it should be used. For
example, one document explicitly recommends the following: *If you just mention
the path [of an external document], Claude will often ignore it. You have to
pitch the agent on why and when to read the file.* (D7)

### E. Init Fossilization

This smell occurs when the configuration file is generated by an initialization
command such as `/init` but not reviewed or updated afterwards. Thus, the file
generated by the coding agent becomes the permanent configuration, often
carrying instructions that are not relevant anymore to the project. As a result,
the configuration tends to accumulate noise, increase context consumption, and
reduce the overall effectiveness of the agent over time. For example,
[Anthropic's documentation](https://code.claude.com/docs/en/memory) explicitly
recommends that the configuration file should be continuously updated, such as
when: *Claude makes the same mistake a second time; a code review reveals
something Claude should already have known about the codebase; you find yourself
typing the same correction or clarification in chat that you already provided in
a previous session; and a new team member would need the same context in order
to be productive.*

### F. Conflicting Instructions

This smell occurs when an `AGENTS.md` file contains instructions that contradict
each other, creating ambiguity about the expected behavior of the agent. Such
inconsistencies can confuse the model and lead to unstable results. For example,
small variations in the prompt can result in different agent behavior, because
they are enough to make the agent follow a different inference path than the one
followed previously. [Anthropic's
documentation](https://code.claude.com/docs/en/memory) explicitly recommends the
following: *if two rules contradict each other, Claude may pick one arbitrarily.
Review your CLAUDE.md files periodically to remove outdated or conflicting
instructions.*

## V. Detection Heuristics

We also propose a set of heuristics to detect the smells described in the
previous section.

### A. Heuristic based on Lines of Code

This heuristic is used exclusively to detect the *Context Bloat* smell.
Specifically, we decided to use a threshold of 200 lines of code to identify
this smell, as also suggested in the Anthropic document mentioned in Section
IV-A. In other words, `AGENTS.md` files with 200 or more lines of code are
classified as presenting the *Context Bloat* smell.

### B. Heuristic based on Language Models

To detect the *Skill Leakage*, *Lint Leakage*, *Blind References*, and
*Conflicting Instructions* smells, we decided to use a large language model. We
designed a dedicated prompt for each smell, thereby requesting a more specific
and objective task from the model. Figure 4 illustrates the baseline template of
these prompts.

In the case of *Blind References* and *Conflicting Instructions*, we also
enriched the basic prompt with examples of true/false positives. For example, in
Figure 5 we show the example (true positive) added to the prompt to detect
*Blind References*.

**Figure 4. Prompt to detect Skill Leakage, Lint Leakage, Blind References and
Conflicting Instructions**

```
# Context
You are a senior software engineer. I will provide an agent configuration file
(AGENTS.md). Your task is to detect whether the file contains the following
configuration smell.

# Smell: [name]
Description: [as in Section IV; essentially the first paragraph of the smell
description]

[Optional: Operational Guidelines / True & False Positives Examples]
- Examples and edge cases specific to the smell to minimize false positives.

# Output
- If detected: [Return exact lines / JSON object with contradiction context]
- If not detected, return only: NO SMELL

# Agents.md file
[file content]
```

**Figure 5. Example added to the prompt to detect Blind References**

```markdown
...
## Releases & Environment
For releases or environment issues, see
`web/book/src/project/contributing/development.md`.
```

### C. Heuristic based on Number of Commits

This heuristic is used exclusively to detect the *Init Fossilization* smell.
Conservatively, we consider that an `AGENTS.md` file with only a single commit
exhibits this smell; that is, the file has never been modified since its
creation.

## VI. Configuration Smells in the Wild

To detect the smells in our dataset of 100 agent configuration files, we applied
the heuristics proposed in Section V. For the heuristics based on LLMs, we used
gemini-3.1-flash-lite, with a temperature of 0. Additionally, each smell
instance identified by these heuristics was carefully reviewed by the first
author to verify whether it is a true occurrence of the smell. The results are
summarized in Table II and are discussed in the following subsections.

In Table II, we also show the number of false positives and the precision, for
the smells whose identification relies on LLM-based heuristics. In other words,
we did not compute precision for *Context Bloat* and *Init Fossilization*
because, in these cases, detection is based on pre-established thresholds.

**Table II. Smells detected in real projects** (FP: false positives; Prec.:
precision)

| Smell | Instances | FP | Prec. (%) |
| --- | ---: | ---: | ---: |
| Context Bloat | 42 | – | – |
| Skill Leakage | 35 | 6 | 82 |
| Lint Leakage | 62 | 4 | 93 |
| Blind Reference | 16 | 2 | 87 |
| Init Fossilization | 24 | – | – |
| Conflicting Instructions | 28 | 12 | 57 |

> **Summary:** We detected at least one smell in 91 agent configuration files.
> Thus, only nine files were found to be smell-free. These results suggest that
> developers could benefit from catalogs and tools designed to spot
> configuration issues in agent configuration files.

### A. Context Bloat

The proposed heuristic detected 42 cases of *Context Bloat*. The smallest file
contains 216 lines of code, whereas the largest file contains 1,477 lines of
code. Due to space constraints, we will not present a complete example of
*Context Bloat* here. However, just to provide a high-level illustration, the
`CLAUDE.md` file of the
[`javascript-obfuscator`](https://github.com/javascript-obfuscator/javascript-obfuscator)
project — a very popular and powerful obfuscator of JavaScript and Node.js
source code — has 1,477 lines. This file is organized into 27 sections,
including Project Overview, Architecture Overview, Core Workflow, CLI/API Usage,
etc. As a result, the file is very large for repeated context loading, which can
lead language models to discard important instructions. Much of these
instructions would be better maintained in separate documentation or loaded on
demand through skills.

When analyzing the file, we noticed, for example, that the second section is
called *Key Features*, and has 22 lines. This section describes the obfuscation
techniques used by the project, such as variable and function renaming, string
extraction and encryption, dead code injection, and control-flow flattening.
This information is mostly product documentation and provides limited value as
persistent context for agents. Therefore, it could be removed from the agent
configuration and described in the project's README, for example.

It is also important to note that *Context Bloat* is a more visible smell, which
makes it easier to detect. The root cause of this smell is the presence of other
smells in the configuration file, such as *Skill Leakage*, which we will discuss
next.

### B. Skill Leakage

The proposed heuristic detected 35 cases of *Skill Leakage*. After a manual
analysis conducted by the first author, 29 cases were confirmed (86%). An
example of *Skill Leakage* was found in the `AGENTS.md` file of
[`quickemu-project/quickemu`](https://github.com/quickemu-project/quickemu),
which is a tool to simplify the creation and execution of virtual machines. The
detected smell instance is shown in Figure 6. As we can see, the section *Adding
a new OS to quickget* contains instructions that are only useful for a small
subset of tasks. Since most interactions with the coding agent do not involve
adding new operating systems, these instructions unnecessarily increase the size
of the configuration file. Thus, they would be better placed in a dedicated
skill or documentation file.

**Figure 6. Example of Skill Leakage (quickemu-project/quickemu)**

```markdown
## Adding a new OS to quickget
Follow the [guide in the wiki](...). Each OS requires:
1. Entry in `os_info()` case statement
2. `releases_<os>()` function returning available versions
3. `editions_<os>()` function if multiple editions exist
4. `arch_<os>()` function if ARM64 is supported (defaults to amd64 only if omitted)
5. Download URL construction logic
```

**Most common leaked skills:** We also manually classified the skills
responsible for the identified *Skill Leakage* instances. The results of this
classification are presented in Table III. As can be seen, the most common skills
incorrectly defined in `AGENTS.md` files are related to testing concerns,
followed by workflow guidelines (e.g., procedures for code reviews, pull
requests, and issue management). Particularly, the *Skill Leakage* instance
presented in Figure 6 was classified as scaffolding, as it defines functions
that must be implemented to support a new operating system image within a
module.

**Table III. Most common leaked skills**

| Skill Type | Frequency |
| --- | ---: |
| Testing | 10 |
| Workflow | 8 |
| Scaffolding | 4 |
| Infrastructure | 4 |
| Architecture | 3 |

### C. Lint Leakage

The proposed heuristic detected 62 cases of *Lint Leakage*. After a manual
analysis conducted by the first author, 58 cases were confirmed (93%). An
interesting case of this smell was identified in the
[`google/adk-python`](https://github.com/google/adk-python) project, which is an
open-source SDK for building agent-based applications in Python. As shown in
Figure 7, the `AGENTS.md` file of this project includes a section called *Python
Style Guide* containing instructions for writing Python code, including
recommendations for indentation and line length, naming conventions, usage of
docstrings, etc. Normally, these recommendations are enforced by linters,
formatters, or widely adopted community conventions, making their inclusion in
the file unnecessary.

**Figure 7. Example of Lint Leakage (google/adk-python)**

```markdown
### Python Style Guide
* Indentation: 2 spaces.
* Line Length: Maximum 80 characters.
* Naming Conventions**:
  * `function_and_variable_names`: `snake_case`
  * `ClassNames`: `CamelCase`
  * `CONSTANTS`: `UPPERCASE_SNAKE_CASE`
* Docstrings: Required for all public modules, ...
* Imports: Organized and sorted.
* Error Handling: Specific exceptions should be ...
```

However, after creating our dataset (in January, 2026), we found that the
project maintainers performed a major refactoring of the `AGENTS.md` file.
Specifically, the *Python Style Guide* section, shown in Figure 7, was moved to
a separate skill file. Therefore, this extraction confirms the relevance of the
smell we initially detected in our dataset.

### D. Blind Reference

To help explain this smell, Figure 8 shows an example in which an external
reference is cited appropriately. Notice that the text references an external
dependency, includes a link to its GitHub repository, and provides a brief
explanation of its purpose (*cdp-use only provides shallow typed interfaces for
the websocket calls*). Consequently, the agent is able to understand the role of
the dependency without needing to load or inspect the external repository
directly.

**Figure 8. External reference described with context (browser-use/browser-use)**

```markdown
## CDP-Use
We use a thin wrapper around CDP called cdp-use:
https://github.com/browser-use/cdp-use. cdp-use only provides shallow typed
interfaces for the websocket calls, all CDP client and session management +
other CDP helpers still live in browser_use/browser/session.py.
```

However, after applying the proposed heuristic, we were able to detect 16
instances of *Blind Reference*, i.e., references cited in `AGENTS.md` files
without appropriate context. After a manual analysis, 14 cases were confirmed
(87%). An example is shown in Figure 9. As we can see, this configuration
references an external document (`docs/plugin-reorg.md`) to explain the planned
plugin system, but it does not provide any contextual information about the
document itself. Therefore, the agent would need to load and inspect the
referenced file to understand the architecture and goals of the plugin system.

**Figure 9. Blind Reference (SuperClaude-Org/SuperClaude_Framework)**

```markdown
### Plugin System (v5.0 - Not Yet Available)
The TypeScript plugin system (`.claude-plugin/`, marketplace) is planned for
v5.0. See `docs/plugin-reorg.md` for details.
...
```

### E. Init Fossilization

We detected 24 cases of *Init Fossilization*, that is, `AGENTS.md` files with a
single commit, as illustrated by the histogram in Figure 10. The histogram also
shows that configuration files are frequently updated in practice, thus
reinforcing our argument that the absence of changes in such files is indeed a
smell. For example, 14 of the analyzed files (14%) have between 11 and 15
commits, while 17 files (17%) have between 16 and 20 commits.

**Figure 10. Number of changes in `AGENTS.md` files** (*Init Fossilization*
corresponds to files with a single commit)

| Number of commits | Number of `AGENTS.md` files |
| --- | ---: |
| 1 | 24 |
| 2–5 | 27 |
| 6–10 | 18 |
| 11–15 | 14 |
| 16–20 | 17 |

However, it is possible that the 24 projects exhibiting *Init Fossilization* were
dormant projects, that is, projects with limited activity and few commits.
Therefore, the histogram in Figure 11 shows the total number of commits made to
these projects after the creation of their respective `AGENTS.md` files. As the
histogram indicates, the hypothesis that these projects were inactive was not
supported. In fact, we did not find a single project in such a situation, that
is, with zero commits after the creation of the `AGENTS.md` file. On the
contrary, we observed many projects with a substantial number of commits,
including two projects with more than 1,500 commits, for example.

**Figure 11. Number of commits in projects exhibiting *Init Fossilization***
(counting only commits made after the creation of `AGENTS.md`)

| Number of commits after `AGENTS.md` creation | Number of repositories |
| --- | ---: |
| 0 | 0 |
| 1–99 | 9 |
| 100–249 | 5 |
| 250–499 | 3 |
| 750–999 | 1 |
| 1000–1499 | 4 |
| 1500+ | 2 |

### F. Conflicting Instructions

The proposed heuristic detected 28 cases of *Conflicting Instructions*. However,
after a manual analysis conducted by the first author, only 16 cases were
confirmed (57%). This lower precision is, to some extent, understandable, since
identifying contradictory instructions is indeed a more complex task. Figure 12
shows an example of this smell. As can be observed, the configuration specifies
two directory paths for creating new components. An agent cannot satisfy the
requirement to place components in `packages/ui/components` while simultaneously
following the instruction to create them in `packages/components`.

**Figure 12. Example of Conflicting Instructions (inkline/inkline)**

```markdown
...
# Component Guidelines
- Components should be placed in the `packages/ui/components` directory
- ...

## How to create a new component
- Create a new folder in `packages/components` with the name of the component.
...
```

## VII. Co-occurrence Analysis

Besides analyzing smells individually, we also investigated which of them tend
to co-exist in the same `AGENTS.md` files. To discover such relationships, we
used Apriori to mine association rules between the smells detected in our
dataset [19]. This procedure is frequently used in software engineering research
to associate code smells [20–22], source code files [23], and bug types [24]. In
our case, we mapped each `AGENTS.md` as a transaction record, and the presence
of each smell in the file as an item. For instance, a given file *F<sub>1</sub>*
with *Context Bloat* (CB), *Skill Leakage* (SL), and *Lint Leakage* (LL) is
represented by the following transaction: *F<sub>1</sub>* = {CB, SL, LL}. For
the 91 `AGENTS.md` files — our transactions — we applied Apriori with a support
of 0.05.

Table IV presents the association rules. The support varies between 0.06 and
0.24, i.e., the associated smells co-exist between 6% and 24% of the files in
our dataset. The confidence levels measure the probability of the consequent
smell being present given the presence of the antecedent ones. As we can see,
the confidence levels are relatively high; for example, the presence of
*Conflicting Instructions* and *Skill Leakage* increases the likelihood of
*Context Bloat* to 83%. Similar confidence appears in other rules, such as the
one associating *Init Fossilization* and *Skill Leakage* with *Lint Leakage*
(83%), and *Conflicting Instructions* with *Context Bloat* (81%).

**Table IV. Co-existing smells detected by Apriori**

| Antecedent | Consequent | Support | Confidence | Lift |
| --- | --- | ---: | ---: | ---: |
| Conflicting Instructions, Skill Leakage | Context Bloat | 0.06 | 0.83 | 1.81 |
| Init Fossilization, Skill Leakage | Lint Leakage | 0.06 | 0.83 | 1.31 |
| Conflicting Instructions | Context Bloat | 0.14 | 0.81 | 1.76 |
| Skill Leakage | Lint Leakage | 0.24 | 0.76 | 1.19 |
| Context Bloat, Skill Leakage | Lint Leakage | 0.10 | 0.75 | 1.18 |
| Conflicting Instructions, Lint Leakage | Context Bloat | 0.07 | 0.67 | 1.44 |

Lift measures how much more likely items are to appear together than by chance.
A lift value greater than 1 indicates the smells appear in the same file more
often than randomly. We observe a strong association in two rules: *Conflicting
Instructions* and *Skill Leakage* with *Context Bloat* (1.81), and *Conflicting
Instructions* with *Context Bloat* (1.76). In other words, the probability of
*Conflicting Instructions*, *Skill Leakage*, and *Context Bloat* co-occurring in
the same file is 1.81 times higher than if they were independent; likewise,
*Conflicting Instructions* and *Context Bloat* are 1.76 times more likely to
co-occur than by chance.

Figure 13 depicts an Upset diagram showing the frequency of `AGENTS.md` files —
bar chart on top — for each unique smell combination — intersection matrix
below. In total, we detected 15 smell combinations with at least two
occurrences. *Context Bloat* and *Lint Leakage* stands out with 12 occurrences;
i.e., they appeared together in 12 configuration files. A second group of smells
shows up next: (a) *Skill Leakage* and *Lint Leakage* with seven occurrences;
(b) *Skill Leakage*, *Lint Leakage*, and *Context Bloat* in six files; and (c)
*Lint Leakage* and *Init Fossilization* in five files. The other 11 remaining
combinations were detected in three configuration files, at most. We observe
that configuration smells frequently overlap in `AGENTS.md` files, suggesting
that multiple issues can compromise the performance of coding agents.

**Figure 13. Smell accumulation in `AGENTS.md` files** — Upset diagram over the
six smells (Blind Reference, Conflicting Instructions, Context Bloat, Init
Fossilization, Lint Leakage, Skill Leakage). The 15 combination counts, in
descending order: 12, 7, 6, 5, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2. The named ones
are Context Bloat + Lint Leakage (12), Skill Leakage + Lint Leakage (7), Skill
Leakage + Lint Leakage + Context Bloat (6), and Lint Leakage + Init
Fossilization (5).

> **Summary:** We leveraged six rules with co-existing smells. *Context Bloat*
> is strongly associated with *Conflicting Instructions* and *Skill Leakage*,
> with lift values of 1.81 and 1.76, respectively. This suggests that long
> `AGENTS.md` files often contain inconsistent or overly specific instructions.

## VIII. Threats to Validity

Some steps of this work may be subject to threats to validity. In this section,
we highlight and discuss these threats.

**Bad Practices Annotations.** We manually annotated the sentences from the
selected documents, which can introduce some bias in the smells identified
further. To mitigate this issue, another author performed a sanity check and
reviewed all annotations from the selected documents to confirm whether the
content accurately represented a good or bad practice in writing configuration
files.

**Google Search Limitations.** In a grey literature review, relevant results
might be missed due to the specific combination of search terms. To mitigate
this threat, we used keywords to consider both bad and good practices to expand
search coverage. Furthermore, following the guidelines from other works [15,
16], we conducted preliminary search trials, adding and excluding keywords to
refine our search strings.

**Use of LLMs for Code Smell Detection.** In this work, we rely on LLMs to
evaluate each `AGENTS.md` file and identify the presence of a specific smell.
Large Language Models (LLMs) are highly dynamic and frequently updated by their
providers. Another key factor is the non-deterministic nature of LLMs, which
poses challenges for exact replication. Consequently, the performance and
results of code smell detection in configuration files may evolve over time. To
mitigate this issue, we set the model temperature to 0 and carefully analyzed
the responses to ensure the identification of true positive cases.

## IX. Related Work

We organize related work in three subsections: Context Engineering,
Configuration Files, and Configuration Smells.

### A. Context Engineering

The effectiveness of LLMs in software engineering depends on the context
provided to the model. Prior work has investigated how documentation, source
code, retrieved artifacts, and prompt engineering can improve model responses
[25, 26]. Other studies have examined how developers formulate prompts and how
prompting practices can be systematized for programming tasks [27, 28]. Recent
benchmarks have further highlighted the repository-level nature of realistic
software engineering tasks. Through SWE-bench, Jimenez et al. [29] show that
resolving real-world GitHub issues requires reasoning over repository context,
modifying multiple files, and validating changes through tests. Thus, this
observation motivates the study of project-level guidance for coding agents.

### B. Agent Configuration Files

Recent studies have started investigating configuration files for coding agents.
Chatlatanagulchai et al. [30] refer to such files as *Agentic Coding Manifests*
and show that `CLAUDE.md` files are predominantly action-oriented, commonly
including build and run commands, implementation guidance, testing instructions,
and architectural information. Santos et al. [13] also analyzes `CLAUDE.md`
files from public projects and identifies recurring sections such as
architecture, development guidelines, project overview, and testing. Together,
these studies show that configuration files are becoming key artifacts in
agentic software development. However, they focus on describing their structure
and content. In this paper, we complement this line of work by investigating
misconfiguration problems in `AGENTS.md` and `CLAUDE.md` files, including
excessive context, lint leakage, blind references, outdated files, and
conflicting instructions.

### C. Configuration Smells

Bad smells have long been studied as indicators of design, implementation, and
maintenance problems, including their introduction [31], developers' perceptions
[32], and manifestations across different artifacts and paradigms [33, 34]. More
recently, researchers have extended the smell concept to configuration and
infrastructure artifacts. Rosa et al. [35] investigate Dockerfile smells, i.e.,
violations of Dockerfile best practices that may affect reliability, security,
build time, image size, and reproducibility. Urdih et al. [36] study
cache-related smells in GitLab CI/CD pipelines, proposing a catalog of ten
smells and reporting that only 11% of 228 analyzed projects were smell-free. In
this paper, we also focused on domain-specific smells, but with a focus on
repository-level configuration files for coding agents. Unlike Dockerfile or
CI/CD cache smells, which affect build and delivery processes, smells in
`AGENTS.md` and `CLAUDE.md` may directly influence how coding agents interpret
project conventions, prioritize instructions, and perform development tasks.

## X. Conclusion

In this paper, we presented a catalog of smells that may affect configuration
files for coding agents, such as `AGENTS.md` and `CLAUDE.md`. Based on a grey
literature review of 14 documents, we identified six smells and proposed
heuristics to detect them in a dataset of 100 popular open-source repositories.
Our results show that these smells are widespread in practice, with 91
repositories exhibiting at least one smell. In particular, *Lint Leakage* was
the most common smell, and we also observed recurring co-occurrence patterns
involving *Context Bloat*, *Skill Leakage*, and *Conflicting Instructions*.
Since configuration files are key artifacts in agentic software development, our
findings suggest that their quality deserves effort and attention. We hope that
the proposed catalog will serve as a foundation for future tools and techniques
to detect and prevent configuration smells in coding-agent ecosystems.

## Replication Package

The data and results of this research are available at:
<https://doi.org/10.5281/zenodo.20600327>.

## Acknowledgments

This research was supported by FAPEMIG and CNPq.

## References

1. M. Chen, J. Tworek, H. Jun, Q. Yuan, H. P. D. O. Pinto, J. Kaplan, H. Edwards, Y. Burda, N. Joseph, G. Brockman et al., "Evaluating large language models trained on code," arXiv preprint arXiv:2107.03374, 2021.
2. J. Shin, C. Tang, T. Mohati, M. Nayebi, S. Wang, and H. Hemmati, "Prompt Engineering or Fine Tuning: An Empirical Assessment of Large Language Models in Automated Software Engineering Tasks," ArXiv, 2023.
3. A. Mastropaolo, N. Cooper, D. N. Palacio, S. Scalabrino, D. Poshyvanyk, R. Oliveto, and G. Bavota, "Using Transfer Learning for Code-Related Tasks," IEEE Transactions on Software Engineering, 2023.
4. M. L. Siddiq, J. C. S. Santos, R. H. Tanvir, N. Ulfat, F. A. Rifat, and V. C. Lopes, "Using Large Language Models to Generate JUnit Tests: An Empirical Study," in 28th International Conference on Evaluation and Assessment in Software Engineering (EASE), 2024.
5. N. Alshahwan, J. Chheda, A. Finegenova, B. Gokkaya, M. Harman, I. Harper, A. Marginean, S. Sengupta, and E. Wang, "Automated Unit Test Improvement Using Large Language Models at Meta," in 32nd ACM Symposium on the Foundations of Software Engineering (FSE), 2024.
6. J. Lu, L. Yu, X. Li, L. Yang, and C. Zuo, "LLaMA-Reviewer: Advancing Code Review Automation with Large Language Models through Parameter-Efficient Fine-Tuning," in IEEE 34th International Symposium on Software Reliability Engineering (ISSRE), 2023.
7. I. Guelman, A. G. Leal, L. Xavier, and M. T. Valente, "On the Quality of AI-Generated Source Code Comments: A Comprehensive Evaluation," in 1st International Workshop on AI for Software Quality Evaluation (AI-SQE), 2026.
8. X. Hou, Y. Zhao, Y. Liu, Z. Yang, K. Wang, L. Li, X. Luo, D. Lo, J. Grundy, and H. Wang, "Large Language Models for Software Engineering: A Systematic Literature Review," ACM Transactions on Software Engineering and Methodology, 2024.
9. A. Almeida, L. Xavier, and M. T. Valente, "Using Copilot Agent Mode to Automate Library Migration: A Quantitative Assessment," in 1st International Workshop on Agentic Engineering, 2026.
10. C. Ziftci, S. Nikolov, A. Sjövall, B. Kim, D. Codecasa, and M. Kim, "Migrating Code At Scale With LLMs At Google," in Proceedings of the 33rd ACM International Conference on the Foundations of Software Engineering, 2025.
11. L. L. Silva, J. R. d. Silva, J. E. Montandon, M. Andrade, and M. T. Valente, "Detecting Code Smells Using ChatGPT: Initial Insights," in 18th ACM/IEEE International Symposium on Empirical Software Engineering and Measurement (ESEM), 2024.
12. Z. Xi, W. Chen, X. Guo, W. He, Y. Ding, B. Hong, M. Zhang, J. Wang, S. Jin, E. Zhou, R. Zheng, X. Fan, X. Wang, L. Xiong, Y. Zhou, W. Wang, C. Jiang, Y. Zou, X. Liu, Z. Yin, S. Dou, R. Weng, W. Qin, Y. Zheng, X. Qiu, X. Huang, Q. Zhang, and T. Gui, "The rise and potential of large language model based agents: a survey," Science China Information Sciences, 2025.
13. H. V. F. Santos, V. Costa, J. E. Montandon, and M. T. Valente, "Decoding the Configuration of AI Coding Agents: Insights from Claude Code Projects," in 1st International Workshop on Agentic Engineering, 2026.
14. S. Mohsenimofidi, M. Galster, C. Treude, and S. Baltes, "Context engineering for ai agents in open-source software," arXiv preprint arXiv:2510.21413, 2025.
15. V. Garousi, M. Felderer, and M. V. Mäntylä, "Guidelines for including grey literature and conducting multivocal literature reviews in software engineering," Information and Software Technology, 2019.
16. L. Vegi and M. T. Valente, "Code Smells in Elixir: Early Results from a Grey Literature Review," in 30th International Conference on Program Comprehension (ICPC), 2022.
17. C. Sadowski, K. T. Stolee, and S. Elbaum, "How developers search for code: a case study," in Proceedings of the 2015 10th Joint Meeting on Foundations of Software Engineering, 2015.
18. C. Huyen, AI Engineering: Building Applications with Foundation Models. O'Reilly, 2025.
19. R. Agrawal, H. Mannila, R. Srikant, H. Toivonen, and A. I. Verkamo, "Fast discovery of association rules," Advances in Knowledge Discovery and Data Mining, 1996.
20. O. Hamdi, A. Ouni, E. A. AlOmar, and M. W. Mkaouer, "An Empirical Study on Code Smells Co-occurrences in Android Applications," in 36th IEEE/ACM International Conference on Automated Software Engineering Workshops (ASEW), 2021.
21. B. A. Muse, M. M. Rahman, C. Nagy, A. Cleve, F. Khomh, and G. Antoniol, "On the Prevalence, Impact, and Evolution of SQL Code Smells in Data-Intensive Systems," in 17th International Conference on Mining Software Repositories (MSR), 2020.
22. F. Palomba, R. Oliveto, and A. De Lucia, "Investigating Code Smell Co-Occurrences Using Association Rule Learning: A Replicated Study," in IEEE Workshop on Machine Learning Techniques for Software Quality Evaluation (MaLTeSQuE), 2017.
23. M. Soto and C. Le Goues, "Using a Probabilistic Model to Predict Bug Fixes," in IEEE 25th International Conference on Software Analysis, Evolution and Reengineering (SANER), 2018.
24. T. L. De Santana, P. A. D. M. S. Neto, E. S. De Almeida, and I. Ahmed, "Bug Analysis in Jupyter Notebook Projects: An Empirical Study," ACM Transactions on Software Engineering and Methodology (TOSEM), 2024.
25. D. Nam, A. Macvean, V. J. Hellendoorn, B. Vasilescu, and B. A. Myers, "Using an LLM to Help With Code Understanding," in 46th International Conference on Software Engineering (ICSE), 2024.
26. G. Pinto, C. R. B. de Souza, J. B. Cordeiro Neto, A. de Souza, T. Gotto, and E. Monteiro, "Lessons from Building CodeBuddy: A Contextualized AI Coding Assistant," in 46th International Conference on Software Engineering: Software Engineering in Practice (ICSE-SEIP), 2024.
27. K. Pister, D. J. Paul, P. Brophy, and I. Joshi, "PromptSet: A Programmer's Prompting Dataset," in Proceedings of the 1st ACM International Conference on AI-Powered Software (AIware), 2024.
28. Y. Sasaki, H. Washizaki, J. Li, N. Yoshioka, N. Ubayashi, and Y. Fukazawa, "Landscape and Taxonomy of Prompt Engineering Patterns in Software Engineering," IT Professional, 2025.
29. C. E. Jimenez, J. Yang, A. Wettig, S. Yao, K. Pei, O. Press, and K. R. Narasimhan, "SWE-bench: Can Language Models Resolve Real-World GitHub Issues?" in 12th International Conference on Learning Representations (ICLR), 2024.
30. W. Chatlatanagulchai, K. Thonglek, B. Reid, Y. Kashiwa, P. Leelaprute, A. Rungsawang, B. Manaskasemsak, and H. Iida, "On the use of agentic coding manifests: An empirical study of claude code," in International Conference on Product-Focused Software Process Improvement, 2025.
31. M. Tufano, F. Palomba, G. Bavota, R. Oliveto, M. Di Penta, A. De Lucia, and D. Poshyvanyk, "When and Why Your Code Starts to Smell Bad," in 37th IEEE/ACM International Conference on Software Engineering (ICSE), 2015.
32. F. Palomba, G. Bavota, M. Di Penta, R. Oliveto, and A. De Lucia, "Do They Really Smell Bad? A Study on Developers' Perception of Bad Code Smells," in International Conference on Software Maintenance and Evolution (ICSME), 2014.
33. E. V. de Paulo Sobrinho, A. De Lucia, and M. de Almeida Maia, "A Systematic Literature Review on Bad Smells–5 W's: Which, When, What, Who, Where," IEEE Transactions on Software Engineering, 2021.
34. D. Taibi and V. Lenarduzzi, "On the Definition of Microservice Bad Smells," IEEE Software, 2018.
35. G. Rosa, F. Zappone, S. Scalabrino, and R. Oliveto, "Fixing Dockerfile Smells: An Empirical Study," Empirical Software Engineering, 2024.
36. F. Urdih, T. Theodoropoulos, and U. Zdun, "Cache-Related Smells in GitLab CI/CD: Comprehensive Catalog, Automated Detection, and Empirical Evidence," arXiv preprint arXiv:2604.17890, 2026.
