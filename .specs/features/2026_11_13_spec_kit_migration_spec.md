# Spec-Kit Migration Spec

> **Author:** Martin Nordio
> **Status:** 🔄 In progress
> **Created:** 2026-11-13
> **Last updated:** 2026-11-13
> **Branch:** `feature/spec-kit-migration` (all Steps; one pull request at the end)
> **Issue:** _created with the pull request_

## Stage log

| Date | Stage | Command | Model | Note |
|------|-------|---------|-------|------|
| 2026-11-13 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | Part 1 written from the migration plan (M1–M12) |
| 2026-11-13 | plan | `PLAN:` | Claude Opus 5.5 | Part 2 written: one Step per M item |

---

# Part 1 · Requirements

## Context

The [migration plan](../migrations/2026_11_11_spec_kit_migration.md) lists what of the original
spec-kit moves into spec-nx and cuts it into items M1–M12 (M8 dropped). This spec builds all of
them, so a project can generate a complete kit — from an empty repository to a reviewed pull
request — and company content stays in a private layer outside spec-nx.

**Already in the repository:**
- Stages `requirements`, `plan`, `pr` ([stages/](../../stages/)); skills `requirements_engineer`,
  `architect`; the spec template with the Stage log; git-host tools for GitHub and Azure DevOps.
- Generator with Q1–Q4 ([generator/questions.md](../../generator/questions.md),
  [generator/prompt.md](../../generator/prompt.md)).
- The first feature, [requirements → plan → pr](done/2026_11_09_spec_plan_pr_spec.md).

**New:** stages `implementation`, `documentation`, `review`, and on demand `improvement`,
`setup`, `ui`; guideline baselines; the new-project spec; the company layer; agent permissions;
questions Q0, Q0b, Q0c, Q1b, Q5, Q6.

## 1 · Specs

- **S1 — Questions start with the project (M10):** the generator asks first whether the project
  is new (suggested from a scan: nothing but README, LICENSE, git files, `.specs/` and
  submodules → new), then its languages (suggested from the scan for an existing project). Q1
  offers **Simple** (`requirements, plan, implementation, pr`, the default), **Full** (all six
  stages) and **Custom** (one yes / no per stage from `plan` on, `requirements` always yes, a
  stage not asked when its prerequisite is no). Q1b offers the on-demand stages.
- **S2 — Implement a Step (M1):** `IMPLEMENT: <spec> [Step n]` does one Step of a planned spec:
  start time, tasks ticked, overview row ✅ Done, a Done line with duration and model, a Stage
  log row, and a suggested commit message; it follows the guidelines of the languages it
  touches and never commits.
- **S3 — Close a spec (M1):** `CLOSE: <spec>` checks every Step is done, writes what was built
  compared with the plan, ticks the Definition of Done, sets the status and moves the spec to
  `.specs/features/done/`.
- **S4 — Kit README (M1):** every generated kit has `.specs/kit/README.md` with the workflow and
  the commands of the chosen stages, in order.
- **S5 — Guidelines (M2):** spec-nx has short baselines (≤ ~100 lines) for Python, TypeScript,
  Svelte, PowerShell and bash, each naming the linter configuration it defers to; the kit gets
  the baselines of the project's languages; `GUIDELINES: <lang>` writes
  `.specs/guidelines/<lang>.md` from a scan of the project, or proposes a diff if it exists;
  project rules win over the layer, the layer over the baseline. No long reference copies.
- **S6 — New project spec (M6):** for a new project, the generator offers a project setup spec;
  it asks the framework, package manager and test runner per language and writes a spec
  (Part 1 and Part 2) whose first Step builds a skeleton that runs and has one passing test —
  for any language.
- **S7 — Company layer (M11):** a project can point to a layer folder (marker `layer.json`);
  its `defaults.json` pre-fills the suggestions; its guidelines, setup stacks, looks, agent
  permissions and stage notes are adapted into the kit; the report names what came from it.
  spec-nx itself holds no company content.
- **S8 — Documentation (M3):** `DOCS: <spec>` updates the documents a change affects;
  `ARCHITECTURE` creates or refreshes `.specs/architecture.md`; `ADR: <title>` (also from a
  plan decision) writes `.specs/decisions/NNNN-<slug>.md`; data model, API contracts, glossary
  and runbooks are created only when the project needs them; existing project documents get a
  proposed diff, never a silent overwrite.
- **S9 — Review (M4):** `REVIEW: <spec>` writes a change record (objects Before | After, each
  linked to `S<n>`), a review page and a semantic-diff text; the pull-request scripts publish
  that text in its own `semantic-diff` marker block on both hosts and in both shells, with a
  dry run. `CODE REVIEW: <spec>` runs a layered review, logs findings in the Review Log with the
  model, and sends out-of-scope findings to an improvement spec instead of fixing them.
- **S10 — Improvement (M5):** `IMPROVE: <scope>` writes a normal spec whose tasks change
  structure, consistency or docs only, never behaviour; `--dry-run` only lists the findings.
- **S11 — UI (M7):** `LOOK: <app>` writes a spec for the app's look against the Looks contract;
  `UI CATALOG` creates or refreshes the UI catalog; brand values come from the layer or the
  project.
- **S12 — Agent permissions (M9):** a question picks the AI agent (Claude Code, VS Code
  Copilot, none); the generator writes its permissions as a project file: run tests, linters
  and read-only commands; ask before deleting or moving files; never commit, push or merge.
- **S13 — Setup tooling (M12):** `SETUP TOOLING: <scope>` and `SETUP MACHINE` write normal
  specs; the machine spec installs only what is missing.
- **S14 — The contract only grows:** existing commands, markers, settings keys and script
  parameters keep their meaning; new script parameters are optional; an existing
  `.specs/spec-nx.json` keeps working and `--update` asks only the new questions.
- **S15 — Clean content:** nothing in the repository names a company, customer, internal
  system, internal URL, local path or credential, and no person except the author.
- **S16 — Used on itself:** this spec is implemented with the implementation stage's protocol,
  reviewed with `REVIEW:` (semantic diff) and published with the pr stage, which also creates
  and updates its issue.

### Open questions

_None open._ The plan's open questions were answered on 2026-11-13 (see the migration plan).

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **0** | Branch, migration plan, this spec | ✅ Done | [→ Step 0](#step-0--branch-migration-plan-this-spec) |
| **1** | Generator questions (M10) | ✅ Done | [→ Step 1](#step-1--generator-questions-m10) |
| **2** | Implementation stage, developer skill, kit README (M1) | ⬜ Not started | [→ Step 2](#step-2--implementation-stage-m1) |
| **3** | Guidelines (M2) | ⬜ Not started | [→ Step 3](#step-3--guidelines-m2) |
| **4** | New project spec (M6) | ⬜ Not started | [→ Step 4](#step-4--new-project-spec-m6) |
| **5** | Company layer (M11) | ⬜ Not started | [→ Step 5](#step-5--company-layer-m11) |
| **6** | Documentation stage (M3) | ⬜ Not started | [→ Step 6](#step-6--documentation-stage-m3) |
| **7** | Review stage and semantic-diff block (M4) | ⬜ Not started | [→ Step 7](#step-7--review-stage-m4) |
| **8** | Improvement stage (M5) | ⬜ Not started | [→ Step 8](#step-8--improvement-stage-m5) |
| **9** | UI stage (M7) | ⬜ Not started | [→ Step 9](#step-9--ui-stage-m7) |
| **10** | Agent permissions (M9) | ⬜ Not started | [→ Step 10](#step-10--agent-permissions-m9) |
| **11** | Setup tooling (M12) | ⬜ Not started | [→ Step 11](#step-11--setup-tooling-m12) |
| **12** | README, checks, semantic diff, close | ⬜ Not started | [→ Step 12](#step-12--readme-checks-semantic-diff-close) |

> **Step completion protocol (required):** every time a Step is finished, in the same edit:
> 1. Tick its tasks `[x]` **and** set its row in this table to ✅ Done.
> 2. Append a **`**Done (YYYY-MM-DD · ~<duration> · <model>)**`** line to that Step's
>    **Notes**: date, time it took, the AI model that did the work, a one-line summary and
>    the verifying test/command result.
>
> The table and the Step sections must **always agree**.

> **Time tracking (required for every Step):** each Step's **first task** is
> `Record the start time in Notes`; the Done line records the finish and the duration.

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | One spec for all M items, **one Step per M item, one commit per Step**; nothing pushed until the author approves; one pull request at the end | The author wants one review; each Step stays visible in the history |
| D2 | On-demand stages get their own key `on_demand` (Q1b); `stages` keeps its six values | P3: an existing key never changes meaning |
| D3 | Guidelines are a building block `stages/guidelines/` (prompt + baselines), copied to `.specs/kit/guidelines/` when `languages` is set — not a Q1 stage | Every stage that writes code needs them; they are not a step of the method |
| D4 | New questions: Q0 `project`, Q0b `languages`, Q0c `project_spec`, Q1b `on_demand`, Q5 `layer`, Q6 `agent`. They are **asked** in the order of the question table; Q5 comes first because the layer's defaults feed every suggestion | Numbers stay stable (P3); the order is what the user sees |
| D5 | The review stage writes `.specs/changes/<name>/` (`change_record.yaml`, `review.md`, `semantic_diff.md`); `update_pr.*` gets an optional `-SemanticDiffFile` / `--semantic-diff` that replaces the `semantic-diff` block. HTML page and card images are deferred | Markdown works on both hosts without attachments; optional parameter keeps old calls working (S14) |
| D6 | Agent permissions: Claude Code → `.claude/settings.json` (`permissions` allow / ask / deny); VS Code Copilot → `.vscode/settings.json` (`chat.tools.terminal.autoApprove`). Both are project files: created if missing, otherwise a proposed diff | The two agents the author uses; project files survive `--update` (P2) |
| D7 | Prompts cannot be unit-tested; each Step is checked by: every `../` path in the prompts exists, PowerShell files parse and are ASCII, bash files pass `bash -n`, and a read-through against the statements | The checks the generator itself runs (generator step 6) |

---

## Step 0 — Branch, migration plan, this spec

### Goal
Start the feature branch with the migration plan, the Stage log work and this spec (S15, S16).

### Tasks
- [x] Record the start time in Notes below.
- [x] Create `feature/spec-kit-migration` from `main`.
- [x] Remove company names and local paths from the migration plan; answer its open questions.
- [x] Write this spec (Part 1 and Part 2).
- [x] Check: search for company names and local paths finds nothing; commit.

### Notes
Started: 2026-11-13 09:40

**Done (2026-11-13 · ~20m · Claude Opus 5.5)** — branch created; migration plan made generic
(no company names or local paths) and its open questions answered; this spec written. Search
for company names and local paths: no match.

---

## Step 1 — Generator questions (M10)

### Goal
The generator asks Q0, Q0b, Q1 (Simple / Full / Custom) and Q1b (S1, S14).

### Tasks
- [x] Record the start time in Notes below.
- [x] `generator/questions.md`: Q0 `project`, Q0b `languages`, Q1 options and Custom rules, Q1b `on_demand`; question table with the asking order; settings example and key table.
- [x] `generator/prompt.md`: scan for an empty repository and languages; ask in the new order; `--update` asks only missing keys.
- [x] Check: every key in the example JSON is in the key table and has a question.

### Notes
Started: 2026-11-13 10:00

**Done (2026-11-13 · ~15m · Claude Opus 5.5)** — Q0, Q0b, Q1 (Simple / Full / Custom), Q1b
written; question table shows the asking order; generator scans for an empty repository.
Check: the 12 keys of the example JSON are all in the key table.
---

## Step 2 — Implementation stage (M1)

### Goal
`IMPLEMENT:` and `CLOSE:`, the developer skill, the skill shape and the kit README (S2, S3, S4).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `stages/implementation/prompt.md` with `IMPLEMENT:` and `CLOSE:`.
- [ ] `stages/skills/developer.md`; `stages/skills/README.md` (skill shape, handoffs); the original's quality checks in `requirements_engineer.md`.
- [ ] `stages/kit_readme.md` (building block of `.specs/kit/README.md`); generator writes it.
- [ ] Check: paths in the new prompt exist; the generator contract lists the new commands.

### Notes

---

## Step 3 — Guidelines (M2)

### Goal
Baselines per language and `GUIDELINES:` (S5).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `stages/guidelines/prompt.md` (`GUIDELINES: <lang>`), baselines `python.md`, `typescript.md`, `svelte.md`, `powershell.md`, `bash.md`.
- [ ] Generator copies the baselines of `languages`; implementation stage loads them.
- [ ] Check: each baseline ≤ ~100 lines and names its linter configuration.

### Notes

---

## Step 4 — New project spec (M6)

### Goal
Q0c and the project setup spec for any language (S6).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `stages/setup/project_spec.md` (questions per language, Part 1 + Part 2 shape, Step 0 skeleton).
- [ ] Q0c `project_spec` in the questions; generator writes the spec after the kit, never over an existing file.
- [ ] Check: a read-through for Python only, TypeScript only and Python + Svelte gives a sensible spec.

### Notes

---

## Step 5 — Company layer (M11)

### Goal
Q5 `layer`, the layer format and how the generator uses it (S7).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] Q5 in the questions; layer format (`layer.json`, `defaults.json`, `guidelines/`, `setup/`, `looks/`, `agent/`, `notes/`) documented in `generator/layer.md` with a tiny generic example.
- [ ] Generator: find the layer, pre-fill suggestions, adapt its blocks, name them in the report; `--update` re-reads it.
- [ ] Check: no company content in the example.

### Notes

---

## Step 6 — Documentation stage (M3)

### Goal
`DOCS:`, `ARCHITECTURE`, `ADR:` and the document templates (S8).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `stages/documentation/prompt.md`; templates `architecture.md`, `adr.md`, `data_model.md`, `api_contracts.md`, `glossary.md`, `runbook.md`.
- [ ] Architect skill: owns architecture and ADRs.
- [ ] Check: paths exist; project files are never overwritten.

### Notes

---

## Step 7 — Review stage (M4)

### Goal
`REVIEW:` with the semantic diff, `CODE REVIEW:`, and the `semantic-diff` block in the pull-request scripts (S9, S14).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `stages/review/prompt.md`, `semantic_diff.md` (rules), `code_review.md` (checklist), `change_record.yaml`, `change_record.schema.json`; `stages/skills/reviewer.md`.
- [ ] `update_pr.ps1` / `.sh` for GitHub and Azure DevOps: optional semantic-diff file; tools README; pr stage passes it when the kit has review.
- [ ] Check: PowerShell parse + ASCII, `bash -n`; dry run of the block replacement on a sample description.

### Notes

---

## Step 8 — Improvement stage (M5)

### Goal
`IMPROVE:` writes a behaviour-preserving spec (S10).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `stages/improvement/prompt.md`; `stages/skills/refactorer.md`.
- [ ] Check: paths exist; the prompt forbids behaviour changes.

### Notes

---

## Step 9 — UI stage (M7)

### Goal
`LOOK:`, `UI CATALOG` and the Looks contract (S11).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `stages/ui/prompt.md`, `looks.md` (contract), templates `ui_conventions.md`, `ui_catalog.md`; `stages/skills/ui_designer.md`.
- [ ] Check: no brand values in spec-nx.

### Notes

---

## Step 10 — Agent permissions (M9)

### Goal
Q6 and the permissions file for the chosen agent (S12).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] Q6 `agent`; `stages/agent/permissions.md` (allow / ask / deny lists per tool kind, file formats per agent); generator writes or proposes the file.
- [ ] Check: the example files are valid JSON.

### Notes

---

## Step 11 — Setup tooling (M12)

### Goal
`SETUP TOOLING:` and `SETUP MACHINE` (S13).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `stages/setup/prompt.md` with both commands, writing normal specs.
- [ ] Check: paths exist.

### Notes

---

## Step 12 — README, checks, semantic diff, close

### Goal
The README tells the new story, everything passes the checks, this spec is reviewed with its own review stage and closed (S14, S15, S16).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] README: stages, questions, layout, company layer, status.
- [ ] Checks of D7 on the whole repository; search for company names and local paths.
- [ ] `REVIEW:` this spec → `.specs/changes/spec-kit-migration/`.
- [ ] Close the spec; migration plan statuses; dry run of the pull request and the issue.

### Notes

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|-------------|
| HTML review page and card images (`render_cards`) | Markdown first (D5) | a later review spec |
| Command-line generator | Out of scope of the migration | later |
| Example kits in `examples/` | After the stages settle | later |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..S16 testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [ ] Implementation · every Step's tasks checked
- [ ] Documentation · README and generator docs updated
- [ ] Review · semantic diff written for this spec
- [ ] Spec closed · moved to `.specs/features/done/`
- [ ] Pull request · opened with the spec summary; reviewed; merged; branch deleted
