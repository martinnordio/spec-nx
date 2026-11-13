# spec-nx

**Software engineering for vibe coding.**

spec-nx generates the spec kit your team needs to build software with AI the right way: clear
requirements, a plan in small steps, and a pull request that shows the code does what was
asked.

For anyone who builds software with AI: developers, students, scientists, and curious kids.

> 🚧 **Work in progress.** spec-nx is built in the open, one spec at a time, using itself.
> See [Status](#status) for what works today.

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
       features/done/     closed specs
   ```

4. **Use the kit**, stage by stage — for example:

   ```
   Load .specs/kit/requirements/prompt.md.
   REQUIREMENTS: login page — users sign in with email and password
   ```

   then `PLAN:` on the new spec, `IMPLEMENT:` once per Step, and `PR:` when the work is done.
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

### Project and developer settings

Some answers are about **the team**, some about **you**:

| | Project settings | Developer settings |
|---|---|---|
| File | `.specs/spec-nx.json` — committed, shared | `.specs/spec-nx.local.json` — not committed, one per developer |
| Examples | stages, git host, issues | your shell: PowerShell 7 (Windows) or bash (macOS, Linux) |

The kit contains its scripts for every shell your team uses, so a Windows developer and a
macOS developer share the same kit. A new team member runs `GENERATE KIT` once: the project
answers are already there, so only the developer questions are asked.

## Stages

A kit is made of **stages**. You choose which ones you use (setup question Q1):

| Stage | Commands | What it does | Output |
|-------|----------|--------------|--------|
| **requirements** | `REQUIREMENTS:`, `CREATE ISSUE:`, `UPDATE ISSUE:` | Writes the requirements of a feature (S1, S2, …) after checking what already exists in the repository; when they are finished, offers to create the issue / backlog item, optionally under a parent | Part 1 of the spec file |
| **plan** | `PLAN:` | Turns agreed requirements into Steps with goals and tasks | Part 2 of the same spec file |
| **implementation** | `IMPLEMENT:`, `CLOSE:` | Does the Steps one by one, ticking tasks and recording when each is done and with which model; closes the spec | Code + updated spec |
| **documentation** | `DOCS:`, `ARCHITECTURE`, `ADR:` | Updates the documents the change affects; architecture and decision records | README, architecture, ADRs, … |
| **review** | `REVIEW:`, `CODE REVIEW:` | Builds a *semantic diff*: Before / After of the commands, APIs, outputs and screens that changed, linked to the requirements; a layered code review | HTML review page in `.specs/review/` (with an index) + pull-request text; findings in the spec |
| **pr** | `PR:` | Pushes the branch and opens or updates the pull request with a summary of the spec (and the semantic diff) | Pull request on GitHub or Azure DevOps |

Workflows:

- **Simple** (the default, e.g. for data science): requirements → plan → implementation → pr
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
compare — what each model produced.

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

The generator starts with a short list of questions:

| # | Question | Can be read from the repository? |
|---|----------|----------------------------------|
| Q5 | **Company layer** — use your company's defaults and rules? (asked first, only if one is found) | Yes (a folder with `layer.json`) |
| Q0 | **Project start** — a new, empty project or an existing one? | Yes (what files exist) |
| Q0b | **Languages** — which programming languages? | Yes for an existing project |
| Q0c | **Project setup spec** — write a first spec that sets up the project? (new projects) | — |
| Q1 | **Workflow** — Simple, Full or Custom? | Partly (existing documents) |
| Q1b | **On-demand stages** — improvement, setup, ui? | Partly (a UI framework, a new project) |
| Q2 | **Git host** — none, GitHub or Azure DevOps? | Yes (the `origin` remote) |
| Q3 | **Your shell** — PowerShell or bash? (per developer) | Yes (the operating system) |
| Q4 | **Shared or personal kit** — one kit for the team, or one per contributor? | Partly (is `.specs/kit/` committed or ignored?) |
| Q6 | **AI agent permissions** — for Claude Code, VS Code Copilot, both or none? | Partly (existing agent settings) |

All questions, options and the configuration files: [generator/questions.md](generator/questions.md).

If you connect a git host, the kit includes scripts that keep the issue (GitHub) or backlog
item (Azure DevOps) and the pull request in sync with the spec: the requirements stage can
update the issue while you define it, and the pr stage always updates both. When the review
stage is part of your kit, the pull request also gets the semantic diff.

## Your company's rules: a layer

A company or team can keep its own defaults and rules — its stack for new projects, its
coding rules, its brand Looks, its agent permissions — in a private **layer** next to
spec-nx, without forking it. The generator reads the layer after spec-nx's building blocks;
the project's own rules still win. The format: [generator/layer.md](generator/layer.md).

## Repository layout

```
spec-nx/
  README.md          this file
  generator/         setup questions, the generator prompt, the company-layer format
  stages/            the building blocks: one folder per stage (prompt, templates, rules)
    spec_template.md the spec file template, shared by all stages
    kit_readme.md    the README of a generated kit
    skills/          roles the assistant takes on, shared by the stages
    guidelines/      coding-rule baselines per language and GUIDELINES:
    agent/           how the AI agent's permissions are written
    tools/           git-host scripts (GitHub, Azure DevOps), shared by the stages
  examples/          generated kits, e.g. a "requirements → plan → pr" kit
  testing/           local trial runs (not pushed; see testing/README.md)
  .specs/            spec-nx's own specs — spec-nx is built with itself
```

## Status

Done:

- [x] [requirements → plan → pr](.specs/features/done/2026_11_09_spec_plan_pr_spec.md): the
  first three stages, the git-host tools and the generator.
- [x] [Spec-kit migration](.specs/features/done/2026_11_13_spec_kit_migration_spec.md): the
  implementation, documentation and review stages; the on-demand stages improvement, setup
  and ui; guidelines; the new-project spec; the company layer; agent permissions; questions
  Q0, Q0b, Q0c, Q1b, Q5, Q6.

Later: a command-line tool, card images of the semantic diff for pull requests, and example
kits.

## License

[MIT](LICENSE). Specs, kits and other files you create with spec-nx, including copies of its
templates, are yours; no attribution needed.
