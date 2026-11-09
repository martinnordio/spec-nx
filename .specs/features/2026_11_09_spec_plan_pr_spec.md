# Requirements → Plan → PR Spec

> **Author:** Martin Nordio
> **Status:** 🔄 In progress — Steps 0–1 done
> **Created:** 2026-11-09
> **Last updated:** 2026-11-09
> **Branch:** `feature/spec-plan-pr` (all Steps; one pull request at the end)
> **Issue:** #1

---

# Part 1 · Requirements

## Context

spec-nx is a generator: users add it to their project, answer a few setup questions (or let
spec-nx read them from the repository), and an AI assistant generates the spec kit they need —
only the stages they use. This first feature defines the idea and builds the three stages a
small team needs to start: **requirements → plan → pr**, plus a minimum generator that
writes the kit into a project and can update it later. A command-line tool, the other stages
and the first example kit come in later specs.

**Already in the repository:** `LICENSE` (MIT).

**New:** everything else — README, layout, spec template, setup questions, three stages.

| Document | Purpose |
|----------|---------|
| [README.md](../../README.md) | The idea, stages, setup questions, layout, status |
| [stages/spec_template.md](../../stages/spec_template.md) | The spec file template (Part 1 · Requirements, Part 2 · Plan) |
| [.specs/README.md](../README.md) | Where spec-nx's own specs live and how they are named |

## 1 · Specs

- **S1 — The idea is written down:** the README explains the generator, the stages, the
  setup questions, "requirements first, then the plan", the git-host connection, how to add
  spec-nx to a project and what works today.
- **S2 — One spec file, two parts:** the spec template has Part 1 · Requirements and
  Part 2 · Plan, separated by a marker line, so one file grows from requirements to plan.
  Spec files are named `yyyy_mm_dd_<name>_spec.md` and keep their name when closed.
- **S3 — Setup questions:** `generator/questions.md` lists the setup questions with their
  options and how each can be read from an existing repository; it contains at least
  Q1 (development method = which stages) and Q2 (git host: none, GitHub, Azure DevOps, and
  whether specs are linked to an issue / backlog item).
- **S4 — Requirements stage:** with one prompt, the assistant creates a new spec file with
  Part 1 filled, after reading the repository (README, existing specs, folder structure) and
  listing what already exists and what is new; it asks the author open questions instead of
  guessing, and does not write Part 2. On request, it updates the linked issue / backlog item
  with the current requirements (S10).
- **S5 — Plan stage:** with one prompt, the assistant fills Part 2 of an existing spec from
  its agreed Part 1 and the repository: Steps with goals and tasks, decisions, deferred items
  and the Definition of Done for the stages in use; it does not change Part 1 (it adds open
  questions instead).
- **S6 — Pull-request stage:** with one prompt, the branch is pushed and a pull request is
  opened or updated on GitHub or Azure DevOps; only the `spec-summary` block of its
  description is replaced, with the spec title, the requirements (S1…Sn), the Steps with their
  status and a link to the spec. The stage **always** updates the linked issue / backlog item
  in the same way, so spec, issue and pull request say the same (S10). A dry run shows the
  result without changing anything.
- **S7 — Local testing:** `testing/` is ignored by git except its README, which explains how
  to try the stages on a throw-away project.
- **S8 — Clean content:** nothing in the repository names a company, customer, internal
  system, internal URL, local path or credential, and no person except the author; every
  commit is checked before it is pushed.
- **S9 — Used on itself:** this spec is written with the template, planned with the plan
  stage's rules, and its pull request is opened by its own pr stage, which also updates
  issue #1.
- **S10 — Issue sync:** the spec header names its issue (GitHub `#<n>`) or backlog item
  (Azure DevOps ID). A script per git host replaces only the `spec-summary` block of the
  issue / backlog item description with the spec summary; text written by hand outside the
  block is kept; a dry run shows the result first. The requirements stage uses it on request,
  the pr stage always.
- **S11 — Generate a kit:** in a project, one prompt command (`GENERATE KIT`) scans the
  repository, suggests an answer for each setup question, asks the user to confirm or change
  each one, saves the answers in `.specs/spec-nx.json`, and writes the kit for the chosen
  stages into `.specs/kit/` (stage prompts, spec template, git-host tools). It creates
  `.specs/` and `.specs/features/` if they do not exist and never touches existing specs.
- **S12 — Update a kit:** `GENERATE KIT --update` reads `.specs/spec-nx.json`, asks nothing
  (except questions added to spec-nx since the file was written), and regenerates
  `.specs/kit/` from the current spec-nx; the configuration records the spec-nx version it
  was generated with.

### Open questions

- Q-A: Git-host scripts in PowerShell 7 (Windows, macOS, Linux) or Python? — decided in
  Step 2.

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **0** | Bootstrap: layout, README, template, testing README, this spec | ✅ Done | [→ Step 0](#step-0--bootstrap) |
| **1** | Setup questions Q1, Q2 | ✅ Done | [→ Step 1](#step-1--setup-questions) |
| **2** | Git-host tools: update issue / backlog item and pull request (GitHub, Azure DevOps) | ⬜ Not started | [→ Step 2](#step-2--git-host-tools) |
| **3** | Requirements stage (+ optional issue update) | ⬜ Not started | [→ Step 3](#step-3--requirements-stage) |
| **4** | Plan stage | ⬜ Not started | [→ Step 4](#step-4--plan-stage) |
| **5** | Pull-request stage (pull request + issue, always) | ⬜ Not started | [→ Step 5](#step-5--pull-request-stage) |
| **6** | Generator: `GENERATE KIT` (scan, suggest, ask, configuration, kit) and `--update` | ⬜ Not started | [→ Step 6](#step-6--generator) |
| **7** | Use it on this spec, close it, update issue #1 and the pull request | ⬜ Not started | [→ Step 7](#step-7--use-it-on-this-spec-and-close-it) |

> **Step completion protocol (required):** every time a Step is finished, in the same edit:
> tick its tasks `[x]`, set its row above to ✅ Done, and append a
> **`**Done (YYYY-MM-DD · ~<duration>)**`** line to its Notes (summary + verifying result).

> **Time tracking (required for every Step):** each Step's first task is
> `Record the start time in Notes`; the Done line records the finish and the duration.

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | One branch and **one pull request per spec**; **one commit per Step**, pushed after each Step; merged with a **merge commit** | One review per feature; each Step stays visible in the history |
| D2 | The pr stage writes a **spec summary** only (title, S1…Sn, Steps with status, link); the semantic diff comes with the review stage later | Smallest useful pull request for teams without a review stage |
| D3 | Folder layout: `generator/` (questions, generator prompt) and `stages/<stage>/` (prompt, scripts); the spec template is shared at `stages/spec_template.md` | A kit is assembled by picking stage folders |
| D4 | Stage prompts are adapted from an earlier private kit and rewritten generically, never copied as is | S8 |
| D5 | The generator is a **prompt** run in the AI chat (`generator/prompt.md`); a command-line tool comes in a later feature and reads the same configuration | Nothing to install; the configuration format keeps the CLI easy to add |
| D6 | Git-host scripts live in `stages/tools/`, shared by the stages and selected by Q2 — not inside `stages/pr/` | A kit with only the requirements stage also needs the issue update |
| D7 | In a project, everything spec-nx writes lives in `.specs/`: `spec-nx.json` (answers + spec-nx version), `kit/` (generated, replaced on update), `features/` (the project's specs, never overwritten) | One folder to find, review and commit; updating the kit cannot touch specs |

---

## Step 0 — Bootstrap

### Goal
The repository has the layout, the README with the idea, the two-part spec template, the
testing README and this spec.

### Tasks
- [x] Record the start time in Notes below.
- [x] `README.md`: idea, stages, requirements first, setup questions, layout, status, license (S1).
- [x] `stages/spec_template.md`: Part 1 · Requirements, marker, Part 2 · Plan (S2).
- [x] `.gitignore` with `testing/*` except `testing/README.md`, and `*.local.md`; `testing/README.md` (S7).
- [x] `examples/README.md` (placeholder), `.specs/README.md`, `.github/pull_request_template.md` with the `spec-summary` block.
- [x] This spec, Part 1 and Part 2.
- [x] Clean-content check (S8).

### Notes
Started: 2026-11-09.

- Replaces an earlier, uncommitted plan (a kit with a semantic-diff loop) after the project
  was re-scoped as a generator and renamed spec-nx.
- Branch renamed from `spec/spec-plan-pr` to `feature/spec-plan-pr`: branches are always
  `feature/<name>`; "spec" is only the file (see README, Terms).

**Done (2026-11-09 · ~1h)** — layout, README, template, testing README and this spec; clean-content check clean.

---

## Step 1 — Setup questions

### Goal
The setup questions Q1 and Q2 are defined (S3).

### Tasks
- [x] Record the start time in Notes below.
- [x] `generator/questions.md`: Q1 development method (stages, with the three example sets), Q2 git host (none / GitHub / Azure DevOps; link specs to an issue / backlog item: yes / no); for each: options, default, how to read it from a repository, which stage folders and tools it selects.
- [x] Room for later questions (numbered, one table).
- [x] Clean-content check (S8); commit "Step 1: setup questions (#1)"; push.

### Notes
Started: 2026-11-09.

- Q2 is split into Q2 (git host) and Q2b (`link_issues`), asked only with a git host.
- The format of `.specs/spec-nx.json` is documented in `questions.md` (keys `version`,
  `spec_nx_version`, `generated`, `stages`, `git_host`, `link_issues`); Step 6 decides
  whether a JSON schema file is also needed.
- Stages not yet in spec-nx are not saved, so `--update` offers them once they exist.
- Also in this commit: spec updated for issue sync (S10), the generator (S11, S12, Step 6),
  shared git-host tools (D6) and the `.specs/` layout in projects (D7); README "How it works".

**Done (2026-11-09 · ~1h)** — `generator/questions.md` with Q1, Q2, Q2b and the configuration format; clean-content check clean.

---

## Step 2 — Git-host tools

### Goal
One script per git host updates the `spec-summary` block of an issue / backlog item and of a
pull request from a spec (S6, S10).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] Decide Q-A (script language).
- [ ] Summary builder: from a spec file, the block text (title, S1…Sn, Steps with status, link to the spec).
- [ ] `stages/tools/github`: using `gh` — update an issue's block; find or create the pull request of the current branch (draft allowed) and update its block; `--dry-run`.
- [ ] `stages/tools/azure_devops`: same, using the REST API with a personal access token from the environment.
- [ ] Dry run on this spec against issue #1 (nothing changed on GitHub).
- [ ] Clean-content check (S8); commit "Step 2: git-host tools (#1)"; push.

### Notes

---

## Step 3 — Requirements stage

### Goal
The assistant can write Part 1 of a new spec from a short request and the repository, and on
request update the linked issue / backlog item (S4, S10).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `stages/requirements/prompt.md`: command `REQUIREMENTS: <name> — <request>`; reads the repository first; writes the file name with today's date; fills Part 1 only; lists "already in the repository" and "new"; asks open questions.
- [ ] Command `UPDATE ISSUE: <spec file>` in the same prompt: calls the git-host tool for the issue / backlog item in the spec header (dry run first).
- [ ] Role text for the assistant (requirements engineer) inside the prompt or as `stages/requirements/role.md`.
- [ ] Try it in `testing/` on a throw-away project; note the result in this Step's Notes.
- [ ] Clean-content check (S8); commit "Step 3: requirements stage (#1)"; push.

### Notes

---

## Step 4 — Plan stage

### Goal
The assistant can fill Part 2 of a spec from its agreed Part 1 (S5).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `stages/plan/prompt.md`: command `PLAN: <spec file>`; refuses while Part 1 has unanswered open questions; writes Steps (each starting with the start-time task), decisions, deferred items and a Definition of Done for the stages in use; never edits Part 1.
- [ ] Try it in `testing/` on the spec from Step 3; note the result.
- [ ] Clean-content check (S8); commit "Step 4: plan stage (#1)"; push.

### Notes

---

## Step 5 — Pull-request stage

### Goal
The branch is pushed and the pull request and the issue / backlog item show the same spec
summary (S6, S10).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `stages/pr/prompt.md`: command `PR: <spec file>` (and `--dry-run`): push the branch; open or update the pull request; **always** update the linked issue / backlog item; both via the git-host tools.
- [ ] Open this branch's pull request as a **draft** with the stage (`Closes #1` in the description); check the dry run for issue #1.
- [ ] Clean-content check (S8); commit "Step 5: pull-request stage (#1)"; push.

### Notes

---

## Step 6 — Generator

### Goal
In a project, `GENERATE KIT` creates `.specs/spec-nx.json` and `.specs/kit/` from the answers,
and `GENERATE KIT --update` regenerates the kit without asking again (S11, S12).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `generator/prompt.md`: `GENERATE KIT` — scan the repository (git remote, languages, folders, existing `.specs/`), suggest answers to the questions of `generator/questions.md`, ask the user to confirm each, write `.specs/spec-nx.json`, write `.specs/kit/` (chosen stage prompts, spec template, git-host tools), create `.specs/features/` if missing.
- [ ] `GENERATE KIT --update`: read the configuration; ask only questions it does not contain; replace `.specs/kit/`; update the recorded spec-nx version; never touch `.specs/features/`.
- [ ] `generator/spec-nx.schema.json` (or a documented format in `questions.md`): `version`, `spec_nx_version`, `stages`, `git_host`, `link_issues`.
- [ ] Try both commands in `testing/` on a throw-away project (GitHub remote, no `.specs/`); note the result.
- [ ] Clean-content check (S8); commit "Step 6: generator (#1)"; push.

### Notes

---

## Step 7 — Use it on this spec and close it

### Goal
spec-nx's first feature is delivered with its own stages; issue #1 and the pull request match
the spec (S9, S10).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] README Status updated.
- [ ] Close the spec: move it to `.specs/features/done/`; fix links; tick the Definition of Done.
- [ ] Clean-content check (S8); commit "Step 7: close the spec (#1)"; push.
- [ ] `PR:` on this spec: pull request and issue #1 updated (the hand-written part of the issue is kept); mark the pull request ready; review; merge with a merge commit; delete the branch.

### Notes

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| 🔜 DEFERRED — Command-line tool (`spec-nx init` / `spec-nx update`) that calls an LLM and reads the same `.specs/spec-nx.json` | Prompt first (D5) | CLI spec |
| 🔜 DEFERRED — First example kit `examples/requirements-plan-pr/` | Done on another branch, with the generator from Step 6 | example spec |
| 🔜 DEFERRED — Implementation, documentation and review (semantic diff) stages | Not needed for requirements → plan → pr | later specs |
| 🔜 DEFERRED — Prompt that closes a spec | Done by hand once here | later spec |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..S12 testable)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [ ] Implementation · every Step's tasks checked
- ~~Documentation · affected docs updated — N/A (the README is a task of Steps 0 and 7)~~
- [ ] Spec closed · moved to `.specs/features/done/`
- [ ] Pull request · opened with the spec summary by the pr stage; reviewed; merged; branch deleted

### Run guide

All Steps on the branch `feature/spec-plan-pr`; one commit per Step, pushed as a backup:

```
Load .specs/features/2026_11_09_spec_plan_pr_spec.md
and stages/spec_template.md.

DO STEP <N> — <goal from the Overview>
```

```
git add -A
git commit -m "Step <N>: <goal>"
git push
```
