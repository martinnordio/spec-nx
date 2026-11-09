# spec-nx

**Spec-nx: a generator for spec kits — specify, plan and build step by step, and show your
code is right.**

For anyone who builds software: developers, students, scientists, and curious kids.

> 🚧 **Work in progress.** spec-nx is built in the open, one spec at a time, using itself.
> See [Status](#status) for what works today.

---

## The idea

Every team works a little differently. A product team may go all the way from requirements to
a reviewed pull request; a data-science team may only need requirements, a plan and a pull
request; someone else may only write requirements.

**spec-nx does not give everybody the same kit. It generates the kit you need.**

1. Add spec-nx to your project (as a git submodule, or copy it in as a component).
2. Answer a few **setup questions** — or let spec-nx read the answers from your repository
   (languages, folders, git host, existing specs).
3. An AI assistant (Copilot or Claude in your editor, or a command-line LLM) generates **your
   spec kit**: the prompts, templates and scripts for exactly the stages you chose.
4. Use the kit: write a spec, plan it, build it, open the pull request.

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
       features/          your specs, yyyy_mm_dd_<name>_spec.md
       features/done/     closed specs
   ```

4. **Use the kit**, stage by stage — for example:

   ```
   Load .specs/kit/requirements/prompt.md.
   REQUIREMENTS: login page — users sign in with email and password
   ```

   then `PLAN:` on the new spec, and `PR:` when the work is done.

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

| Stage | What it does | Output |
|-------|--------------|--------|
| **requirements** | Writes the requirements of a feature (S1, S2, …) after checking what already exists in the repository | Part 1 of the spec file |
| **plan** | Turns agreed requirements into Steps with goals and tasks | Part 2 of the same spec file |
| **implementation** | Does the Steps one by one, ticking tasks and recording when each is done | Code + updated spec |
| **documentation** | Updates the documents the change affects | README, architecture, … |
| **review** | Builds a *semantic diff*: Before/After of APIs, outputs and screens, linked to the requirements | Review page + images |
| **pr** | Pushes the branch and opens or updates the pull request with a summary of the spec | Pull request on GitHub or Azure DevOps |

Examples:

- **Full:** requirements → plan → implementation → documentation → review → pr
- **Data science:** requirements → plan → pr
- **Requirements only:** requirements

## Requirements first, then the plan

Each feature has **one spec file**, `yyyy_mm_dd_<name>_spec.md`, in two parts:

- **Part 1 · Requirements** — *what* is needed, as short, testable statements. Written first,
  and checked against the repository so that what already exists is reused, not rebuilt.
- **Part 2 · Plan** — *how*, in small Steps. Written only once the requirements are agreed and
  the details are known.

Keeping both parts in one file means the reason for every Step is right above it.

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

The generator starts with a short list of questions (more will be added):

| # | Question | Can be read from the repository? |
|---|----------|----------------------------------|
| Q1 | **Development method** — which stages do you use? | Partly (existing specs, pull-request history) |
| Q2 | **Git host** — none, GitHub or Azure DevOps? | Yes (the `origin` remote) |
| Q3 | **Your shell** — PowerShell 7 or bash? (per developer) | Yes (the operating system) |
| Q4 | **Shared or personal kit** — one kit for the team, or one per contributor? | Partly (is `.specs/kit/` committed or ignored?) |

All questions, options and the configuration files: [generator/questions.md](generator/questions.md).

If you connect a git host, the kit includes scripts that keep the issue (GitHub) or backlog
item (Azure DevOps) and the pull request in sync with the spec: the requirements stage can
update the issue while you define it, and the pr stage always updates both. When the review
stage is part of your kit, updating the review also updates the pull request.

## Repository layout

```
spec-nx/
  README.md          this file
  generator/         setup questions and the generator prompt
  stages/            the building blocks: one folder per stage (prompt, scripts)
    spec_template.md the spec file template, shared by the requirements and plan stages
    tools/           git-host scripts (GitHub, Azure DevOps), shared by the stages
  examples/          generated kits, e.g. a "requirements → plan → pr" kit
  testing/           local trial runs (not pushed; see testing/README.md)
  .specs/            spec-nx's own specs — spec-nx is built with itself
```

## Status

The first feature, [requirements → plan → pr](.specs/features/2026_11_09_spec_plan_pr_spec.md),
is in progress:

- [x] This README and the repository layout
- [x] The spec template in two parts
- [x] Setup questions Q1 and Q2 ([generator/questions.md](generator/questions.md))
- [ ] Git-host tools: keep the issue / backlog item and the pull request in sync with the spec
- [ ] Requirements stage (can update the issue on request)
- [ ] Plan stage
- [ ] Pull-request stage (always updates the pull request and the issue)
- [ ] Generator: `GENERATE KIT` and `GENERATE KIT --update`

Later: a command-line tool, the implementation, documentation and review stages, and a first
example kit.

## License

[MIT](LICENSE). Specs, kits and other files you create with spec-nx, including copies of its
templates, are yours; no attribution needed.
