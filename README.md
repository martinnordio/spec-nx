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

If you connect a git host, the kit includes scripts that push the spec summary to the pull
request; when the review stage is part of your kit, updating the review also updates the pull
request.

## Repository layout

```
spec-nx/
  README.md          this file
  generator/         setup questions and the generator prompt
  stages/            the building blocks: one folder per stage (prompt, scripts)
    spec_template.md the spec file template, shared by the requirements and plan stages
  examples/          generated kits, e.g. a "requirements → plan → pr" kit
  testing/           local trial runs (not pushed; see testing/README.md)
  .specs/            spec-nx's own specs — spec-nx is built with itself
```

## Status

The first feature, [requirements → plan → pr](.specs/features/2026_11_09_spec_plan_pr_spec.md),
is in progress:

- [x] This README and the repository layout
- [x] The spec template in two parts
- [ ] Setup questions Q1 and Q2
- [ ] Requirements stage
- [ ] Plan stage
- [ ] Pull-request stage (GitHub and Azure DevOps)

Later: the generator prompt, the implementation, documentation and review stages, and a first
example kit.

## License

[MIT](LICENSE). Specs, kits and other files you create with spec-nx, including copies of its
templates, are yours; no attribution needed.
