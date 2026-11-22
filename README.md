# spec-nx

**The speed of vibe coding, the discipline of software engineering — and you know what every
feature cost.**

spec-nx generates the spec kit your team uses to build software with AI: requirements checked
against your repository, a plan in small Steps, and a pull request that shows the code does
what was asked.

- **Specs in the repository, not lost in a chat.** Requirements and plan live next to the
  code; the issue, the spec and the pull request stay in sync.
- **The right model for each Step.** A strong model where it matters, a cheaper one for
  routine work — chosen by the plan, run as sub-agents.
- **Know what it cost.** Tokens, GitHub AI credits and your currency for every stage and Step,
  and a cost summary for every feature.
- **A kit made for your project, by your AI model.** Your languages, folders and conventions —
  and it gets better with every newer model.
- **Reviews that make sense.** A semantic diff: Before / After of the commands, APIs and
  screens that changed, linked to the requirements.
- **Fits the way you work.** VS Code Copilot or Claude Code; GitHub, Azure DevOps or no host;
  PowerShell or bash; one kit for the team or one per developer; your company's rules as a
  layer.

For anyone who builds software with AI: developers, students, scientists, and curious kids.

> **Make it yours.** Every setting can be changed for the team, for one project, or only for
> you — another parent feature, only the requirements stage, your Azure DevOps area and
> iteration, a log of your prompts, your currency. See
> **[Customizing spec-nx](docs/customize.md)**.

## ⭐ Key feature: the right model for each Step — and what it cost

**spec-nx chooses the AI model for every stage and Step, and records the tokens and the cost
of each one.** How tokens and cost are counted, the prices and their sources:
**[COSTS.md](stages/COSTS.md)**.

### The right model, automatically

- **Three tiers** — *reasoning*, *standard* and *light* (default: Claude Opus 5.5, Claude
  Sonnet 5.5, Claude Haiku 5.5). Requirements, plan, review and improvement run on
  *reasoning*; documentation and `CLOSE:` on *standard*; `PR:` on *light*
  ([stages/models.md](stages/models.md)).
- **The plan picks the model of each Step:** the cheapest tier that does it well, with the
  reason, in the spec's **Model (suggested)** column — *reasoning* for architecture, security,
  tricky logic or graphics-heavy work, *standard* for code that follows a clear plan, *light*
  for renames, copies and docs.
- **`IMPLEMENT:` asks once,** then runs each Step as a **sub-agent on its model** and commits
  it with its message. It stops at the first failing check or open question, and never pushes.
  In a tool without sub-agents it tells you which model to switch to for the next Step.
- **Every Step records the model it was meant for and the model that ran it,** so you can
  compare models on real work.
- **Your choice** (setup question Q7): a model per Step (default), **one fixed model** for
  everything, or **none** — always the model selected in your tool. Each developer can
  override it in `.specs/spec-nx.local.json`.

### What it cost

- **Every stage and Step** records its tokens and their cost in the spec's Stage log and Done
  lines: **measured** in Claude Code, **estimated** from the chat transcript in VS Code
  Copilot.
- **In the units you pay in:** tokens, GitHub AI credits (1 credit = $0.01), your currency
  (default CHF) and the share of your plan's monthly credits (default: Copilot Business, $19
  and 1,900 credits per seat).
- **`CLOSE:` adds a cost summary** to the spec — one table by stage, one for the
  implementation by Step — and `PR:` copies it into the issue and the pull request.
- **`.specs/costs.md`** keeps one row per spec, by stage, with the total of the project.
- **On in new kits** (the `cost` block in `.specs/spec-nx.json`); `GENERATE KIT --update` never
  adds it, and without it — or with `"enabled": false` — nothing is calculated.

For example, this feature itself — 24 requirements, 12 Steps — cost about 25.8 M tokens,
CHF 7.82, or 936 credits: half of one Business seat's monthly credits
([the spec](.specs/features/done/2026_11_14_model_per_step_spec.md)).

> **Costs are estimates and may be wrong** — see [COSTS.md](stages/COSTS.md). How to set up
> models and cost: [docs/configuration.md](docs/configuration.md).

---

## The idea

Vibe coding — describing what you want and letting an AI write the code — is fast. Without
some discipline it also loses things: nobody wrote down what was wanted, the AI rebuilds what
already exists, changes get too big to review, and later nobody knows why the code is the way
it is.

spec-nx keeps the speed and adds the engineering:

1. **Requirements first.** A short spec says *what* is wanted, as testable statements, checked
   against what is already in the repository.
2. **A plan in small steps.** Once the requirements are agreed, the work is cut into steps
   small enough to review.
3. **Evidence.** The issue, the spec and the pull request stay in sync, so anyone can see which
   requirements a change meets — and why.

The spec lives in the repository next to the code, so people and the AI work from the same
source.

There is no single right process: a product team, a data-science team and a student need
different things, and so do different roles in one team. So spec-nx does not hand everyone
the same kit — it **generates the kit you need**, adapted to your project by your own AI
model, and regenerates it as models improve.

## Why spec-nx

### Your kit improves with your AI model

spec-nx does not just copy files. Its prompts and scripts are **building blocks**: the
generator gives them to the AI model you use, which **adapts them to your project** — your
languages, folders, naming and conventions — while keeping the same commands and behaviour.

So `GENERATE KIT --update` gives you an up-to-date kit in two ways:

- **A newer spec-nx** brings better building blocks.
- **A newer AI model** writes better prompts and scripts from the same building blocks — even
  if spec-nx itself has not changed for a year.

The building blocks stay the reference: every generated kit keeps their commands
(`REQUIREMENTS:`, `PLAN:`, `PR:` …), file names and markers, and the generator checks the
generated scripts with a dry run before you use them.

### One tool, many projects and roles

- **Different projects:** a product team, a data-science team and a student project each get
  the kit that fits them, from the same spec-nx.
- **Different roles in one project:** someone who only writes requirements, a developer who
  goes all the way to the pull request, a reviewer — each can use the stages they need.
- **Shared or personal kit** (a setup question):
  - **Shared:** the team commits `.specs/kit/`; everyone uses the same kit.
  - **Personal:** `.specs/kit/` is ignored by git; each contributor generates their own kit,
    with their own stages and their own AI model. The specs in `.specs/features/` are shared
    either way.

## How it works

The generator is a prompt you run in the AI chat of your editor (a command-line tool will
follow).

1. **Add spec-nx** to your project:

   ```
   git submodule add https://github.com/martinnordio/spec-nx .spec-nx
   ```

2. **Generate your kit.** In the AI chat:

   ```
   Load .spec-nx/generator/prompt.md.

   GENERATE KIT
   ```

   The assistant first **scans your repository** (git host, languages, folders, existing
   specs) and **suggests an answer** for each setup question. You confirm or change each one.

3. **The answers are saved** in `.specs/spec-nx.json`, and **your kit is generated** into
   `.specs/kit/` — only the stages you chose, adapted to your project by your AI model:

   ```
   your-project/
     .spec-nx/            spec-nx itself (submodule)
     .specs/
       spec-nx.json       the team's answers and the spec-nx version used
       spec-nx.local.json your own answers (not committed)
       kit/               your generated kit: stage prompts, spec template, git-host tools
       guidelines/        your project's own coding rules (GUIDELINES:)
       features/          your specs, yyyy_mm_dd_<name>_spec.md
       features/done/     closed specs — the first one records the kit setup and its cost
   ```

4. **Use the kit**, stage by stage — for example:

   ```
   Load .specs/kit/requirements/prompt.md.
   REQUIREMENTS: login page — users sign in with email and password
   ```

   then `PLAN:` on the new spec, `IMPLEMENT:` for the Steps (with a model per Step it asks
   once and runs them all; otherwise once per Step), `CLOSE:` when they are done, and `PR:`.
   The kit's own `README.md` lists every command of your stages.

5. **Update the kit** when spec-nx improves, or when you use a newer AI model:

   ```
   git submodule update --remote .spec-nx
   ```

   ```
   Load .spec-nx/generator/prompt.md.

   GENERATE KIT --update
   ```

   Your saved answers are reused, so nothing is asked again (only questions that are new in
   spec-nx). `.specs/kit/` is regenerated; your specs in `.specs/features/` are never touched.
   To change answers (for example the stages or the git host), run
   `GENERATE KIT --update --force`: every question is asked again, with your saved answer as the
   suggestion.

### Project and developer settings

Some answers are about **the team**, some about **you**:

| | Project settings | Developer settings |
|---|---|---|
| File | `.specs/spec-nx.json` — committed, shared | `.specs/spec-nx.local.json` — not committed, one per developer |
| Examples | stages, git host, issues, models, cost | your shell: PowerShell (Windows PowerShell 5.1 or 7) or bash (macOS, Linux, Git Bash); any project setting you want different for you — another parent, fewer stages, your backlog area, the prompt log, models, cost |

A shared kit added as a submodule can bring its own settings too: the kit's, the project's and
your file are read in that order, each winning over the one before — see
[Customizing spec-nx](docs/customize.md).

The kit contains its scripts for every shell your team uses, so a Windows developer and a
macOS developer share the same kit. A new team member runs `GENERATE KIT` once: the project
answers are already there and the shell comes from the operating system, so nothing is asked
(with a personal kit: only the stages).

## Tutorial

Try spec-nx on a small, well-known app: **one full workflow** — requirements, plan,
implementation with a model per Step, close with the cost summary — on your own computer, with
no account needed.

| Tutorial | You build | You need |
|----------|-----------|----------|
| [Angular](docs/tutorials/angular.md) | From Angular's *Tour of Heroes*: a hero list and a detail view to edit a hero's name | Node.js, git, VS Code with GitHub Copilot (or Claude Code) |
| [Python](docs/tutorials/python.md) | From Flask's *Flaskr*: a list of blog posts and a form to write one, in SQLite | Python, uv, git, VS Code with GitHub Copilot (or Claude Code) |

Each tutorial gives you the exact `REQUIREMENTS:` text, so you start from the same feature.
To see what you get, read the specs of real runs:
[examples/tour-of-heroes](examples/tour-of-heroes/README.md) (Angular: 15 requirements, 4 Steps
on Sonnet and Haiku, ~CHF 2 including the kit setup) and
[examples/flaskr](examples/flaskr/README.md) (Python: 14 requirements, 3 Steps, ~CHF 1.90).
**Optional, afterwards:** [connect GitHub or Azure DevOps](docs/tutorials/git-host.md) and
build a second feature with an issue and a pull request — the repository has to exist on the
host first.

## Stages

A kit is made of **stages**. You choose which ones you use (setup question Q1):

| Stage | Commands | What it does | Output |
|-------|----------|--------------|--------|
| **requirements** | `REQUIREMENTS:`, `CREATE ISSUE:`, `UPDATE ISSUE:` | Writes the requirements of a feature (S1, S2, …) after checking what already exists in the repository; when they are finished, offers to create the issue / backlog item, optionally under a parent | Part 1 of the spec file |
| **plan** | `PLAN:` | Turns agreed requirements into Steps with goals and tasks | Part 2 of the same spec file |
| **implementation** | `IMPLEMENT:`, `CLOSE:` | Does the Steps one by one — each on its own model, as a sub-agent, when the plan sets one — ticking tasks and recording when each is done, with which model and at what cost; closes the spec with a cost summary | Code + updated spec |
| **documentation** | `DOCS:`, `ARCHITECTURE`, `ADR:` | Updates the documents the change affects; architecture and decision records | README, architecture, ADRs, … |
| **review** | `REVIEW:`, `CODE REVIEW:` | Builds a *semantic diff*: Before / After of the commands, APIs, outputs and screens that changed, linked to the requirements; a layered code review | HTML review page in `.specs/review/` (with an index) + pull-request text; findings in the spec |
| **pr** | `PR:` | Pushes the branch and opens or updates the pull request with a summary of the spec (and the semantic diff) | Pull request on GitHub or Azure DevOps |

Workflows:

- **Simple** (the default): requirements → plan → implementation → pr
- **Full:** requirements → plan → implementation → documentation → review → pr
- **Custom:** you answer yes / no for each stage.

**On demand** (question Q1b), used now and then rather than for every feature:

| Stage | Commands | What it does |
|-------|----------|--------------|
| **improvement** | `IMPROVE:` | A clean-up spec after some merges — never changes behaviour |
| **setup** | `SETUP TOOLING:`, `SETUP MACHINE` | Specs that bring the tooling, or a developer's computer, up to date |
| **ui** | `LOOK:`, `UI CATALOG` | Dark and light Looks from one style contract; a catalog of components and pages |

Every kit also gets **coding guidelines** for the project's languages (Python, TypeScript,
Svelte, PowerShell, bash) and the command `GUIDELINES:` that writes the project's own rules
into `.specs/guidelines/`.

### A new project

In an empty repository the generator asks for your languages and offers a **project setup
spec**: it asks the framework, package manager and test tools per language and writes a first
spec whose Steps build a skeleton that runs, is checked and has one passing test.

### Prompts and skills

Each stage has a **prompt**: the commands you type (`REQUIREMENTS:`, `PLAN:`, `PR:`) and the
rules the AI assistant follows to carry them out. The *way of thinking* behind a stage lives
in a separate **skill**: a role the assistant takes on.

| Skill | Thinks about | Used by |
|-------|--------------|---------|
| **Requirements engineer** | *What* is wanted: testable statements, what already exists, what is unclear | requirements, plan (to check Part 1) |
| **Architect** | *How* to build it: the smallest change, small Steps, explicit decisions, architecture, ADRs | plan, documentation |
| **Developer** | Doing one Step well, with the project's checks | implementation |
| **Reviewer** | Does the change do what the spec says, and is it sound? | review |
| **Refactorer** | Clean-up without behaviour change | improvement |
| **UI designer** | Consistent screens: Looks, conventions, catalog | ui |

Keeping them apart means one role can serve several stages, a role can be improved without
touching the commands, and the generator can adapt a role to your team (for example a
requirements engineer for data-science work) while the commands stay the same.

## Requirements first, then the plan

Each feature has **one spec file**, `yyyy_mm_dd_<name>_spec.md`, in two parts:

- **Part 1 · Requirements** — *what* is needed, as short, testable statements. Written first,
  and checked against the repository so that what already exists is reused, not rebuilt.
- **Part 2 · Plan** — *how*, in small Steps. Written only once the requirements are agreed and
  the details are known.

Keeping both parts in one file means the reason for every Step is right above it.

A short **Stage log** at the top of the spec records which stage wrote what, and with which AI
model (requirements, plan, each implemented Step, pull request), so you can later see — and
compare — what each model produced. With cost tracking on, it also records the tokens and the
cost of each row.

## Terms

spec-nx uses the usual names of your git host; it adds no new ones.

| Term | Meaning |
|------|---------|
| **feature** | A piece of work. Its branch is always `feature/<name>`. |
| **spec** | The file that describes one feature: `.specs/features/yyyy_mm_dd_<name>_spec.md`. |
| **issue / backlog item** | Where the feature is tracked: an *issue* on GitHub, a *backlog item* on Azure DevOps. Commits mention it (`#1` on GitHub, `AB#123` on Azure DevOps). |
| **pull request** | How the feature's branch is reviewed and merged. |
| **step** | One part of the plan; one commit on the feature branch. |
| **stage** | One part of the method (requirements, plan, implementation, documentation, review, pr); a kit contains the stages you choose. |

## Setup questions

The generator asks these questions in this order. For each one it **suggests** an answer —
from your repository, your computer or your AI tool — and you confirm or change it. Questions
that do not apply are skipped.

| # | Question | Default | Suggested from |
|---|----------|---------|----------------|
| Q0b | **Languages** — which programming languages? (several allowed) | from the scan | an existing project: a scan of the source and build files (`pyproject.toml` → python, `package.json` + `.ts` → typescript, `.svelte`, `*.ps1`, `*.sh` …), most used first; a new project: asked openly |
| Q0c | **Project setup spec** — write a first spec that sets up the project? (new projects only) | yes | — |
| Q1 | **Workflow** — which [stages](#stages) for every feature? **Simple:** requirements → plan → implementation → pr. **Full:** adds documentation and review (semantic diff) before the pr. **Custom:** yes / no per stage. | Simple | an existing `.specs/spec-nx.json`; Full if there is `.specs/architecture.md` or `.specs/decisions/` |
| Q1b | **On-demand stages** — extra commands used now and then: **improvement** (`IMPROVE:`, a clean-up spec), **setup** (`SETUP TOOLING:`, `SETUP MACHINE`), **ui** (`LOOK:`, `UI CATALOG`)? | none | ui for a UI framework (`.svelte`, `.tsx`, `.vue`, HTML templates); setup for a new project; improvement with the review stage |
| Q2 | **Git host** — GitHub, Azure DevOps or none? | from the remote | the `origin` remote (`github.com`, `dev.azure.com`, none) |
| Q2b | **Issues** — keep each spec in sync with an issue / backlog item? (with a git host) | yes | commit messages that mention issues (`#<n>`, `AB#<n>`) |
| Q4 | **Shared or personal kit** — one kit for the team, or one per contributor? | shared | `.specs/kit/` committed → shared; in `.gitignore` → personal |
| Q6 | **AI agent permissions** — for Claude Code, VS Code Copilot, both or none? | the agents found | existing agent settings (`.claude/`, `chat.` keys in `.vscode/settings.json`), otherwise the editor you run in |
| Q7 | **Model per Step** — a model per Step, one fixed model, or always your tool's model? | per Step: Claude Opus 5.5 / Sonnet 5.5 / Haiku 5.5 | your tool's model list (each default checked, the nearest enabled model offered); fixed: the model you run on |

Only for a company's shared rules or kit: the questions in
[Your company's rules](#your-companys-rules-a-layer).

Not asked, taken as defaults and changed by hand for special cases
([docs/configuration.md](docs/configuration.md)):

- **New or existing project** — from the files in the repository (only a README and licence
  → new). The generator says what it found; correct it with one word if it is wrong.
- **Your shell** — from the operating system: Windows → PowerShell, macOS / Linux → bash.
  For Git Bash on Windows, set `"shell": "bash"` in `.specs/spec-nx.local.json`.
- **Backlog item type** (Azure DevOps) — Product Backlog Item (Scrum). For another process,
  set `work_item_type` in `.specs/spec-nx.json` (User Story, Requirement or Issue).
- **Backlog project** (Azure DevOps) — the repository's project. For backlog items in another
  project, add `work_items` to `.specs/spec-nx.json`.
- **Cost tracking** (the `cost` block) — the first `GENERATE KIT` writes it, switched on, with
  Copilot Business ($19, 1,900 credits per month) and CHF at the ECB rate.
  `GENERATE KIT --update` never adds it.

All questions, options and the configuration files: [generator/questions.md](generator/questions.md);
how to configure models, cost and the rest: [docs/configuration.md](docs/configuration.md).

If you connect a git host, the kit includes scripts that keep the issue (GitHub) or backlog
item (Azure DevOps) and the pull request in sync with the spec: the requirements stage can
update the issue while you define it, and the pr stage always updates both. When the review
stage is part of your kit, the pull request also gets the semantic diff.

## Your company's rules: a layer

Only useful when many repositories should follow the same rules. A company or team can keep
its own defaults and rules — its stack for new projects, its coding rules, its brand Looks,
its agent permissions — in a private **layer**, without forking spec-nx. The project's own
rules still win.

- **Using a layer:** when the repository contains one (a folder with a `layer.json`, e.g. in
  a submodule), the generator first asks whether to use it; its defaults become the
  suggestions of the other questions.
- **One kit for all projects:** the company's private repository can hold the generated kit
  itself, and projects only add it as a submodule. Generating it there asks two more
  questions: the kit folder (instead of `.specs/kit/`, e.g. the repository root) and the
  submodule folder the projects use (e.g. `.my-kit`), so the paths in the kit's prompts work
  in those projects.

The format and an example: [generator/layer.md](generator/layer.md).

## Repository layout

```
spec-nx/
  README.md          this file
  docs/              how to configure spec-nx (configuration.md) and the tutorials (tutorials/)
  generator/         setup questions, the generator prompt, the company-layer format
  stages/            the building blocks: one folder per stage (prompt, templates, rules)
    spec_template.md the spec file template, shared by all stages
    models.md        which model runs each stage and Step, shared by all stages
    COSTS.md         how tokens and cost are counted (the kit's COSTS.md)
    kit_readme.md    the README of a generated kit
    skills/          roles the assistant takes on, shared by the stages
    guidelines/      coding-rule baselines per language and GUIDELINES:
    agent/           how the AI agent's permissions are written
    tools/           git-host scripts (GitHub, Azure DevOps) and the token / cost scripts
  examples/          real results: the specs of the tutorials (tour-of-heroes/, flaskr/)
  testing/           local trial runs (not pushed; see testing/README.md)
  .specs/            spec-nx's own specs — spec-nx is built with itself
```

## License

[MIT](LICENSE). Specs, kits and other files you create with spec-nx, including copies of its
templates, are yours; no attribution needed.
