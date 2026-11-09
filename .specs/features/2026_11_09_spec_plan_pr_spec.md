# Requirements → Plan → PR Spec

> **Author:** Martin Nordio
> **Status:** 🔄 In progress — Step 0 done
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
small team needs to start: **requirements → plan → pr**. The generator prompt itself, the
other stages and the first example kit come in later specs.

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
  Q1 (development method = which stages) and Q2 (git host: none, GitHub, Azure DevOps).
- **S4 — Requirements stage:** with one prompt, the assistant creates a new spec file with
  Part 1 filled, after reading the repository (README, existing specs, folder structure) and
  listing what already exists and what is new; it asks the author open questions instead of
  guessing, and does not write Part 2.
- **S5 — Plan stage:** with one prompt, the assistant fills Part 2 of an existing spec from
  its agreed Part 1 and the repository: Steps with goals and tasks, decisions, deferred items
  and the Definition of Done for the stages in use; it does not change Part 1 (it adds open
  questions instead).
- **S6 — Pull-request stage:** with one prompt (and a script per git host), the branch is
  pushed and a pull request is opened or updated on GitHub or Azure DevOps; only the
  `spec-summary` block of its description is replaced, with the spec title, the requirements
  (S1…Sn), the Steps with their status and a link to the spec; a dry run shows the result
  without changing anything.
- **S7 — Local testing:** `testing/` is ignored by git except its README, which explains how
  to try the stages on a throw-away project.
- **S8 — Clean content:** nothing in the repository names a company, customer, internal
  system, internal URL, local path or credential, and no person except the author; every
  commit is checked before it is pushed.
- **S9 — Used on itself:** this spec is written with the template, planned with the plan
  stage's rules, and its pull request is opened by its own pr stage.

### Open questions

- Q-A: Scripts for the pr stage in PowerShell 7 (Windows, macOS, Linux) or Python? —
  decided in Step 4.

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **0** | Bootstrap: layout, README, template, testing README, this spec | ✅ Done | [→ Step 0](#step-0--bootstrap) |
| **1** | Setup questions Q1, Q2 | ⬜ Not started | [→ Step 1](#step-1--setup-questions) |
| **2** | Requirements stage | ⬜ Not started | [→ Step 2](#step-2--requirements-stage) |
| **3** | Plan stage | ⬜ Not started | [→ Step 3](#step-3--plan-stage) |
| **4** | Pull-request stage (GitHub, Azure DevOps) | ⬜ Not started | [→ Step 4](#step-4--pull-request-stage) |
| **5** | Use it on this spec, close it, open the pull request | ⬜ Not started | [→ Step 5](#step-5--use-it-on-this-spec-and-close-it) |

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
| D5 | The generator prompt is **not** part of this spec; stages are used directly from `stages/` until it exists | Keeps the first feature small |

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
- [ ] Record the start time in Notes below.
- [ ] `generator/questions.md`: Q1 development method (stages, with the three example sets), Q2 git host; for each: options, default, how to read it from a repository, which stage folders and scripts it selects.
- [ ] Room for later questions (numbered, one table).
- [ ] Clean-content check (S8); commit "Step 1: setup questions"; push.

### Notes

---

## Step 2 — Requirements stage

### Goal
The assistant can write Part 1 of a new spec from a short request and the repository (S4).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `stages/requirements/prompt.md`: command `REQUIREMENTS: <name> — <request>`; reads the repository first; writes the file name with today's date; fills Part 1 only; lists "already in the repository" and "new"; asks open questions.
- [ ] Role text for the assistant (requirements engineer) inside the prompt or as `stages/requirements/role.md`.
- [ ] Try it in `testing/` on a throw-away project; note the result in this Step's Notes.
- [ ] Clean-content check (S8); commit "Step 2: requirements stage"; push.

### Notes

---

## Step 3 — Plan stage

### Goal
The assistant can fill Part 2 of a spec from its agreed Part 1 (S5).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `stages/plan/prompt.md`: command `PLAN: <spec file>`; refuses while Part 1 has unanswered open questions; writes Steps (each starting with the start-time task), decisions, deferred items and a Definition of Done for the stages in use; never edits Part 1.
- [ ] Try it in `testing/` on the spec from Step 2; note the result.
- [ ] Clean-content check (S8); commit "Step 3: plan stage"; push.

### Notes

---

## Step 4 — Pull-request stage

### Goal
The branch is pushed and the pull request shows the spec summary, on GitHub or Azure DevOps (S6).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] Decide Q-A (script language).
- [ ] `stages/pr/prompt.md`: command `PR: <spec file>` (and `--dry-run`); builds the summary from the spec; calls the script for the git host.
- [ ] `stages/pr/github` script using `gh`: find or create the pull request of the current branch (draft allowed); replace only the `spec-summary` block.
- [ ] `stages/pr/azure_devops` script using the REST API with a personal access token from the environment; same behaviour.
- [ ] Dry run on this spec: open this branch's pull request as a **draft** and fill its summary.
- [ ] Clean-content check (S8); commit "Step 4: pull-request stage"; push.

### Notes

---

## Step 5 — Use it on this spec and close it

### Goal
spec-nx's first feature is delivered with its own stages (S9).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] README Status updated.
- [ ] Close the spec: move it to `.specs/features/done/`; fix links; tick the Definition of Done.
- [ ] Clean-content check (S8); commit "Step 5: close the spec"; push.
- [ ] `PR:` on this spec (summary refreshed); mark the pull request ready; review; merge with a merge commit; delete the branch.

### Notes

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| 🔜 DEFERRED — Generator prompt: ask Q1/Q2 (or read them from the repository) and write the kit into the project | First the stages it assembles must exist (D5) | generator spec |
| 🔜 DEFERRED — First example kit `examples/requirements-plan-pr/` | Needs the generator | generator spec |
| 🔜 DEFERRED — Implementation, documentation and review (semantic diff) stages | Not needed for requirements → plan → pr | later specs |
| 🔜 DEFERRED — Prompt that closes a spec | Done by hand once here | later spec |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..S9 testable)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [ ] Implementation · every Step's tasks checked
- ~~Documentation · affected docs updated — N/A (the README is a task of Steps 0 and 5)~~
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
