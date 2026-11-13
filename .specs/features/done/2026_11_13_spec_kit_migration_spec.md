# Spec-Kit Migration Spec

> **Author:** Martin Nordio
> **Status:** ✅ Complete — closed on `feature/spec-kit-migration`; pull request #4 in review
> **Created:** 2026-11-13
> **Last updated:** 2026-11-13
> **Branch:** `feature/spec-kit-migration` (all Steps; one pull request at the end)
> **Issue:** #3

## Stage log

| Date | Stage | Command | Model | Note |
|------|-------|---------|-------|------|
| 2026-11-13 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | Part 1 written from the migration plan (M1–M12) |
| 2026-11-13 | plan | `PLAN:` | Claude Opus 5.5 | Part 2 written: one Step per M item |
| 2026-11-13 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | Steps 0–12 done |
| 2026-11-13 | review | `REVIEW:` | Claude Opus 5.5 | semantic diff written |
| 2026-11-13 | review | `CODE REVIEW:` | Claude Opus 5.5 | Approve; 1 Should-fix, 3 Nits deferred |
| 2026-11-13 | implementation | `CLOSE:` | Claude Opus 5.5 | spec closed |
| 2026-11-13 | pr | `PR:` | Claude Opus 5.5 | pull request and issue prepared (dry run); waiting for the author's approval |
| 2026-11-13 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | Part 1 revised: S17 HTML review page (author's request) |
| 2026-11-13 | plan | `PLAN:` | Claude Opus 5.5 | re-planned: Steps 13–14 added |
| 2026-11-13 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | Steps 13–14 done |
| 2026-11-13 | review | `REVIEW:` | Claude Opus 5.5 | semantic diff updated: HTML report, review-page block |
| 2026-11-13 | implementation | `CLOSE:` | Claude Opus 5.5 | spec closed again |
| 2026-11-13 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | Part 1 revised: S18–S20 (author's request) |
| 2026-11-13 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | Step 15 done |
| 2026-11-13 | review | `REVIEW:` | Claude Opus 5.5 | semantic diff updated: create-issue, commit-message |
| 2026-11-13 | requirements | `CREATE ISSUE:` | Claude Opus 5.5 | issue #3 created (no parent) |
| 2026-11-13 | pr | `PR:` | person | pull request #4 opened (closes #3) |
| 2026-11-13 | review | `REVIEW:` | Claude Opus 5.5 | review page moved to `.specs/review/` as HTML with an index (Step 16) |

---

# Part 1 · Requirements

## Context

The migration plan (`.specs/migrations/2026_11_11_spec_kit_migration.md`, removed in Step 14 once
the migration was done; last version: `git show bbf7af7:.specs/migrations/2026_11_11_spec_kit_migration.md`) lists what of the original
spec-kit moves into spec-nx and cuts it into items M1–M12 (M8 dropped). This spec builds all of
them, so a project can generate a complete kit — from an empty repository to a reviewed pull
request — and company content stays in a private layer outside spec-nx.

**Already in the repository:**
- Stages `requirements`, `plan`, `pr` ([stages/](../../../stages/)); skills `requirements_engineer`,
  `architect`; the spec template with the Stage log; git-host tools for GitHub and Azure DevOps.
- Generator with Q1–Q4 ([generator/questions.md](../../../generator/questions.md),
  [generator/prompt.md](../../../generator/prompt.md)).
- The first feature, [requirements → plan → pr](2026_11_09_spec_plan_pr_spec.md).

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
- **S17 — HTML review page (M4, added at the author's request):** `REVIEW:` also writes a
  self-contained HTML report — no external files, readable without JavaScript, light and dark —
  with Before | After side by side and the changed lines shaded, the highlights as coloured
  diffs with concept tooltips, the findings, a reviewer checklist and machine-readable
  metadata; an index lists all review pages; the pull-request text links to the report.
- **S18 — Create the item when the requirements are finished (added at the author's
  request):** when a spec has no open questions left and no issue yet, the requirements stage
  asks whether to create the issue (GitHub) or backlog item (Azure DevOps), and `CREATE ISSUE:`
  creates it with the spec summary after a dry run, writing its number into the header.
- **S19 — Parent (added at the author's request):** the spec header can name a parent; the
  created Azure DevOps backlog item gets it as its Parent link, the GitHub issue becomes its
  sub-issue. The Azure DevOps work item type is a setting (Q2c).
- **S20 — Commit references (added at the author's request):** every suggested commit message
  carries the reference of the spec's item (`#<n>` / `AB#<id>`), following a commit guideline
  that also binds an AI agent allowed to commit; the pr stage lists commits without it.

### Open questions

_None open._ The plan's open questions were answered on 2026-11-13 in the migration plan
(see Context); the answers are decisions D1–D7 below.

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## Closing summary

**Built:** spec-nx now has every stage of the method — requirements, plan, implementation,
documentation, review, pr — and the on-demand stages improvement, setup and ui; coding
guideline baselines for five languages; a project setup spec for empty repositories; a
private company layer; and agent permissions. The generator asks Q5, Q0, Q0b, Q0c, Q1 (Simple /
Full / Custom), Q1b, Q2–Q4 and Q6, and writes a kit README. The pull-request scripts publish the
semantic diff in their own block.
**Differs from the plan:** a new change kind `command` was added to the semantic diff (the
objects of spec-nx are commands); `agent` became a list so a team can use both agents; the dark
neutral Look's `primary` was darkened to meet contrast; the HTML review page (S17) was added
after the first close, and the migration plan was removed once done (Steps 13–14).
**Files:** `generator/` (questions, prompt, `layer.md`); `stages/` (implementation,
documentation, review, improvement, setup, ui, guidelines, agent, `kit_readme.md`, four new
skills); `stages/tools/` (`spec_summary.*`, `update_pr.*`); `README.md`;
`.specs/changes/done/spec-kit-migration/`.

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **0** | Branch, migration plan, this spec | ✅ Done | [→ Step 0](#step-0--branch-migration-plan-this-spec) |
| **1** | Generator questions (M10) | ✅ Done | [→ Step 1](#step-1--generator-questions-m10) |
| **2** | Implementation stage, developer skill, kit README (M1) | ✅ Done | [→ Step 2](#step-2--implementation-stage-m1) |
| **3** | Guidelines (M2) | ✅ Done | [→ Step 3](#step-3--guidelines-m2) |
| **4** | New project spec (M6) | ✅ Done | [→ Step 4](#step-4--new-project-spec-m6) |
| **5** | Company layer (M11) | ✅ Done | [→ Step 5](#step-5--company-layer-m11) |
| **6** | Documentation stage (M3) | ✅ Done | [→ Step 6](#step-6--documentation-stage-m3) |
| **7** | Review stage and semantic-diff block (M4) | ✅ Done | [→ Step 7](#step-7--review-stage-m4) |
| **8** | Improvement stage (M5) | ✅ Done | [→ Step 8](#step-8--improvement-stage-m5) |
| **9** | UI stage (M7) | ✅ Done | [→ Step 9](#step-9--ui-stage-m7) |
| **10** | Agent permissions (M9) | ✅ Done | [→ Step 10](#step-10--agent-permissions-m9) |
| **11** | Setup tooling (M12) | ✅ Done | [→ Step 11](#step-11--setup-tooling-m12) |
| **12** | README, checks, semantic diff, close | ✅ Done | [→ Step 12](#step-12--readme-checks-semantic-diff-close) |
| **13** | HTML review page (S17) | ✅ Done | [→ Step 13](#step-13--html-review-page-s17) |
| **14** | Remove the migration plan and its template | ✅ Done | [→ Step 14](#step-14--remove-the-migration-plan-and-its-template) |
| **15** | Create the issue with a parent; commit references (S18–S20) | ✅ Done | [→ Step 15](#step-15--create-the-issue-with-a-parent-commit-references-s18s20) |
| **16** | Review pages as HTML in `.specs/review/` with an index (S17) | ✅ Done | [→ Step 16](#step-16--review-pages-as-html-in-specsreview-with-an-index-s17) |

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
| D5 | The review stage writes the **HTML review page** `.specs/review/<yyyy-mm-dd>_<branch-slug>.html` and the index `.specs/review/index.html` (no Markdown page), and keeps the record, Before / After and the pull-request text in `.specs/changes/<name>/`; `update_pr.*` gets an optional `-SemanticDiffFile` / `--semantic-diff` that replaces the `semantic-diff` block. Card images are deferred | The same place and form as the original kit's review pages, so reviewers find every page in one folder; the optional parameter keeps old calls working (S14) |
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
Started: 2026-11-13 09:25

**Done (2026-11-13 · ~13m · Claude Opus 5.5)** — branch created; migration plan made generic
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
Started: 2026-11-13 09:38

**Done (2026-11-13 · ~2m · Claude Opus 5.5)** — Q0, Q0b, Q1 (Simple / Full / Custom), Q1b
written; question table shows the asking order; generator scans for an empty repository.
Check: the 12 keys of the example JSON are all in the key table.
---

## Step 2 — Implementation stage (M1)

### Goal
`IMPLEMENT:` and `CLOSE:`, the developer skill, the skill shape and the kit README (S2, S3, S4).

### Tasks
- [x] Record the start time in Notes below.
- [x] `stages/implementation/prompt.md` with `IMPLEMENT:` and `CLOSE:`.
- [x] `stages/skills/developer.md`; `stages/skills/README.md` (skill shape, handoffs); the original's quality checks in `requirements_engineer.md`.
- [x] `stages/kit_readme.md` (building block of `.specs/kit/README.md`); generator writes it.
- [x] Check: paths in the new prompt exist; the generator contract lists the new commands.

### Notes
Started: 2026-11-13 09:39

**Done (2026-11-13 · ~3m · Claude Opus 5.5)** — implementation stage (`IMPLEMENT:`, `CLOSE:`),
developer skill, skill shape with quality checks and handoffs (also added to the requirements
engineer and architect), kit README building block written by the generator. Check: every
`../` path in `stages/` resolves (guidelines follow in Step 3); contract lists `IMPLEMENT:`,
`CLOSE:`.
---

## Step 3 — Guidelines (M2)

### Goal
Baselines per language and `GUIDELINES:` (S5).

### Tasks
- [x] Record the start time in Notes below.
- [x] `stages/guidelines/prompt.md` (`GUIDELINES: <lang>`), baselines `python.md`, `typescript.md`, `svelte.md`, `powershell.md`, `bash.md`.
- [x] Generator copies the baselines of `languages`; implementation stage loads them.
- [x] Check: each baseline ≤ ~100 lines and names its linter configuration.

### Notes
Started: 2026-11-13 09:41

**Done (2026-11-13 · ~2m · Claude Opus 5.5)** — `GUIDELINES:` (scan, project file only for
what is specific, diff when it exists) and five baselines; the generator copies the baselines
of `languages`. Check: 36–58 lines per baseline, each names its linter configuration and links
its reference instead of copying it.
---

## Step 4 — New project spec (M6)

### Goal
Q0c and the project setup spec for any language (S6).

### Tasks
- [x] Record the start time in Notes below.
- [x] `stages/setup/project_spec.md` (questions per language, Part 1 + Part 2 shape, Step 0 skeleton).
- [x] Q0c `project_spec` in the questions; generator writes the spec after the kit, never over an existing file.
- [x] Check: a read-through for Python only, TypeScript only and Python + Svelte gives a sensible spec.

### Notes
Started: 2026-11-13 09:43

**Done (2026-11-13 · ~3m · Claude Opus 5.5)** — building block for the project setup spec
(kind of project, framework, package manager, tests, linter per language; S1–S4 run / test /
check / install; one skeleton Step per part, then glue); Q0c and generator step 8. Read-through:
Python only → one skeleton Step + glue; TypeScript web app → SvelteKit / React suggestion;
Python + Svelte → server and UI Steps, then glue with a run script.
---

## Step 5 — Company layer (M11)

### Goal
Q5 `layer`, the layer format and how the generator uses it (S7).

### Tasks
- [x] Record the start time in Notes below.
- [x] Q5 in the questions; layer format (`layer.json`, `defaults.json`, `guidelines/`, `setup/`, `looks/`, `agent/`, `notes/`) documented in `generator/layer.md` with a tiny generic example.
- [x] Generator: find the layer, pre-fill suggestions, adapt its blocks, name them in the report; `--update` re-reads it.
- [x] Check: no company content in the example.

### Notes
Started: 2026-11-13 09:43

**Done (2026-11-13 · ~2m · Claude Opus 5.5)** — `generator/layer.md` (files, priority project >
layer > spec-nx, contract cannot be changed, example); Q5 `layer` asked first; generator finds
the layer, uses `defaults.json` as suggestions, adds its guidelines, notes, skills, looks and
setup, and reports them. Check: both JSON examples parse; the example names no company.
---

## Step 6 — Documentation stage (M3)

### Goal
`DOCS:`, `ARCHITECTURE`, `ADR:` and the document templates (S8).

### Tasks
- [x] Record the start time in Notes below.
- [x] `stages/documentation/prompt.md`; templates `architecture.md`, `adr.md`, `data_model.md`, `api_contracts.md`, `glossary.md`, `runbook.md`.
- [x] Architect skill: owns architecture and ADRs.
- [x] Check: paths exist; project files are never overwritten.

### Notes
Started: 2026-11-13 09:44

**Done (2026-11-13 · ~1m · Claude Opus 5.5)** — documentation stage (`DOCS:`, `ARCHITECTURE`,
`ADR:` also from a plan decision), six templates, architect owns the documents; generator
copies a stage's other files with its prompt. Check: the six `templates/` paths exist; every
command shows a diff for existing project documents.
---

## Step 7 — Review stage (M4)

### Goal
`REVIEW:` with the semantic diff, `CODE REVIEW:`, and the `semantic-diff` block in the pull-request scripts (S9, S14).

### Tasks
- [x] Record the start time in Notes below.
- [x] `stages/review/prompt.md`, `semantic_diff.md` (rules), `code_review.md` (checklist), `change_record.yaml`, `change_record.schema.json`; `stages/skills/reviewer.md`.
- [x] `update_pr.ps1` / `.sh` for GitHub and Azure DevOps: optional semantic-diff file; tools README; pr stage passes it when the kit has review.
- [x] Check: PowerShell parse + ASCII, `bash -n`; dry run of the block replacement on a sample description.

### Notes
Started: 2026-11-13 09:46

**Done (2026-11-13 · ~26m · Claude Opus 5.5)** — review stage (`REVIEW:` record → Before | After
→ checks C1–C9 → `review.md` → `semantic_diff.md`; `CODE REVIEW:` four layers, findings routed
to fix now / `IMPROVE:` / new spec / `ADR:`), new kind `command`, reviewer skill; marker helpers
generalised (`Set-MarkedBlock` / `set_marked_block`) and the four `update_pr` scripts take an
optional semantic-diff file. Checks: 6 PowerShell files parse and are ASCII, 6 bash files pass
`bash -n`; block test in both shells replaces both blocks once and keeps the hand-written text;
the example record validates against the schema.
---

## Step 8 — Improvement stage (M5)

### Goal
`IMPROVE:` writes a behaviour-preserving spec (S10).

### Tasks
- [x] Record the start time in Notes below.
- [x] `stages/improvement/prompt.md`; `stages/skills/refactorer.md`.
- [x] Check: paths exist; the prompt forbids behaviour changes.

### Notes
Started: 2026-11-13 10:10

**Done (2026-11-13 · ~2m · Claude Opus 5.5)** — `IMPROVE: <scope> [--dry-run]` writes a normal
spec (nine finding classes, ranked by impact ÷ cost, one Step per class, statement "Behaviour
unchanged"; behaviour changes deferred to a new spec); refactorer skill. Check: `../` paths
resolve; behaviour changes are excluded in step 3 and under Never.
---

## Step 9 — UI stage (M7)

### Goal
`LOOK:`, `UI CATALOG` and the Looks contract (S11).

### Tasks
- [x] Record the start time in Notes below.
- [x] `stages/ui/prompt.md`, `looks.md` (contract), templates `ui_conventions.md`, `ui_catalog.md`; `stages/skills/ui_designer.md`.
- [x] Check: no brand values in spec-nx.

### Notes
Started: 2026-11-13 10:11

**Done (2026-11-13 · ~2m · Claude Opus 5.5)** — ui stage (`LOOK:` writes a look spec: dark +
light switchable, roles only, theme-aware top navigation; `UI CATALOG`), Looks contract with
neutral dark / light Looks (company Looks come from the layer), two templates, UI designer
skill. Check: no brand names or brand colours; contrast of the neutral Looks measured — dark
`primary` darkened to `#2f6fe0` (4.7 : 1 with white), all text pairs ≥ 4.5 : 1.
---

## Step 10 — Agent permissions (M9)

### Goal
Q6 and the permissions file for the chosen agent (S12).

### Tasks
- [x] Record the start time in Notes below.
- [x] Q6 `agent`; `stages/agent/permissions.md` (allow / ask / deny lists per tool kind, file formats per agent); generator writes or proposes the file.
- [x] Check: the example files are valid JSON.

### Notes
Started: 2026-11-13 10:13

**Done (2026-11-13 · ~2m · Claude Opus 5.5)** — Q6 `agent` (a list: Claude Code, VS Code
Copilot, both, none); building block with allow / ask / deny lists from the project's tools and
the layer, the file and syntax per agent (checked against both agents' current documentation;
Copilot can only require approval, not block), never overwriting an existing file. Check: all
seven JSON examples in the permissions, questions and layer documents parse.
---

## Step 11 — Setup tooling (M12)

### Goal
`SETUP TOOLING:` and `SETUP MACHINE` (S13).

### Tasks
- [x] Record the start time in Notes below.
- [x] `stages/setup/prompt.md` with both commands, writing normal specs.
- [x] Check: paths exist.

### Notes
Started: 2026-11-13 10:14

**Done (2026-11-13 · ~1m · Claude Opus 5.5)** — setup stage: detect the stack first; `SETUP
TOOLING:` checks T1–T11 and writes a spec that keeps behaviour unchanged; `SETUP MACHINE`
compares needs with what the computer has and plans only the missing installs. Check: every
`../` path in `stages/` resolves.
---

## Step 12 — README, checks, semantic diff, close

### Goal
The README tells the new story, everything passes the checks, this spec is reviewed with its own review stage and closed (S14, S15, S16).

### Tasks
- [x] Record the start time in Notes below.
- [x] README: stages, questions, layout, company layer, status.
- [x] Checks of D7 on the whole repository; search for company names and local paths.
- [x] `REVIEW:` this spec → `.specs/changes/spec-kit-migration/`.
- [x] Close the spec; migration plan statuses; dry run of the pull request and the issue.

### Notes
Started: 2026-11-13 10:14

**Done (2026-11-13 · ~6m · Claude Opus 5.5)** — README rewritten for the new stages,
questions, layer and layout; checks: every `../` path in `stages/` resolves, 6 PowerShell files
parse and are ASCII, 6 bash files pass `bash -n`, no company names, internal hosts or local
paths; 4 template placeholder links fail the link check by design (finding 3). `REVIEW:` wrote
the record (14 blocks, schema-valid after one fix), 17 Before | After pairs produced from
`3cae701` and the head, the review page and the pull-request text; `CODE REVIEW:` approved
with 1 Should-fix and 3 Nits (deferred). Spec closed; pull request and issue prepared as a dry
run — nothing pushed.

---

## Step 13 — HTML review page (S17)

### Goal
The review stage writes the HTML report, and this branch has one (S17).

### Tasks
- [x] Record the start time in Notes below.
- [x] `stages/review/review_page.html`: template (styles, light / dark, sections, Before | After side by side, diff table, CSS tooltips, `review-meta`).
- [x] Review prompt: write `review.html` and `review.md`, tooltips, `.specs/changes/index.html`; the pull-request text links the HTML page; `semantic_diff.md` files list; generator contract; README.
- [x] Write `review.html` for this branch and the index; add the `review-page` block to the record.
- [x] Check: the page opens in a browser with no external requests and no horizontal overflow; tooltips show on hover; the record is valid.

### Notes
Started: 2026-11-13 11:29

**Done (2026-11-13 · ~5m · Claude Opus 5.5)** — HTML template and review-stage rules;
`review.html` (15 change cards, 18 Before | After pairs, 4 highlights from the real diff with 6
concept tooltips) and `.specs/changes/index.html` for this branch; the pull-request text links
the report. Checks in the browser: no external requests, no horizontal overflow at 733 and 1 400
px, tooltip shows on hover, code ligatures off; the record (15 blocks) passes the schema.

---

## Step 14 — Remove the migration plan and its template

### Goal
The migration is done, so its plan and the plan template leave the repository; nothing links to them.

### Tasks
- [x] Record the start time in Notes below.
- [x] Delete `.specs/migrations/` and `.specs/migration_template.md`; update `.specs/README.md`.
- [x] Replace links to the plan with a note (it stays in the git history); close the spec again.
- [x] Check: the link check finds only the known template placeholders.

### Notes
Started: 2026-11-13 11:34

**Done (2026-11-13 · ~1m · Claude Opus 5.5)** — plan and template removed; the spec and the
review page point to the last version in the git history; spec closed again. Link check: only
the 4 known template placeholders.

---

## Step 15 — Create the issue with a parent; commit references (S18–S20)

### Goal
The item is created from the spec when the requirements are finished, under a parent if given,
and every commit names it (S18, S19, S20).

### Tasks
- [x] Record the start time in Notes below.
- [x] `create_issue.ps1` / `.sh` for GitHub (sub-issue of a parent) and Azure DevOps (type, Parent link), with dry runs.
- [x] Requirements stage: `CREATE ISSUE:`, offered when Part 1 is finished; `Parent:` in the header; Q2c `work_item_type`.
- [x] `stages/guidelines/commits.md`; implementation and pr stages, kit README, tools README, generator.
- [x] Check: PowerShell parse + ASCII, `bash -n`; dry runs on GitHub in both shells; record valid; then create this spec's issue with the new script.

### Notes
Started: 2026-11-13 11:40

**Done (2026-11-13 · ~10m · Claude Opus 5.5)** — four `create_issue` scripts; `CREATE ISSUE:`
with parent (GitHub sub-issue via the sub-issues API, Azure DevOps `Hierarchy-Reverse` link);
Q2c; commit guideline used by implementation, pr and the kit README. Checks: 8 PowerShell
files parse and are ASCII, 8 bash files pass `bash -n`; GitHub dry runs in PowerShell (with a
parent) and bash; the Azure DevOps scripts are only syntax-checked (no Azure DevOps repository
here) — deferred to the trial run. This spec's issue #3 was created with the new GitHub
script.

---

## Step 16 — Review pages as HTML in `.specs/review/` with an index (S17)

### Goal
The review stage writes only HTML review pages, in one folder with an index, like the original
kit's review pages; spec-nx's own review follows it (S17, review of PR #4).

### Tasks
- [x] Record the start time in Notes below.
- [x] Template: table of contents per card and highlight, page header, recommendation, *Previously reviewed*, concepts glossary; `index_page.html`.
- [x] Review prompt, rules, `CLOSE`, generator contract, README: `.specs/review/<yyyy-mm-dd>_<branch-slug>.html` + `.specs/review/index.html`; no Markdown page.
- [x] This branch: page moved to `.specs/review/`, index built from the template, `review.md` and the old index removed, links fixed.
- [x] Check: the page opens with no external requests; links resolve; the record is valid.

### Notes
Started: 2026-11-13 12:05

**Done (2026-11-13 · ~15m · Claude Opus 5.5)** — the HTML page is the only review page; it
and the index live in `.specs/review/`; the record, Before / After and the pull-request text
stay in `.specs/changes/`. Checks: record valid (17 blocks); link check only the 4 known
template placeholders; page and index open in the browser with no external requests.

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|-------------|
| Card images of the semantic diff for the pull request (`render_cards`, needs Node + Playwright) | The HTML page and the Markdown table cover the review (D5) | a later review spec |
| Command-line generator | Out of scope of the migration | later |
| Example kits in `examples/` | After the stages settle | later |
| Try `GENERATE KIT` end to end in `testing/`: an empty repository (Q0c) and an existing one, with and without a layer | Code review finding 2; prompts cannot run in this repository | before the first project switches |
| Run the Azure DevOps `create_issue` scripts against a real project (type, parent) | Only syntax-checked here | the trial run, in an Azure DevOps project |
| Committed tests for the git-host scripts (block replacement, parameters) | Code review finding 1 (C7) | a later spec for script tests |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|
| 2026-11-13 | AI assistant (Claude Opus 5.5) | semantic diff | — | [review page](../../review/2026-11-13_feature-spec-kit-migration.html); checks 4 pass · 4 n/a · 1 fail (C7) |
| 2026-11-13 | AI assistant (Claude Opus 5.5) | diff | Approve | 0 Blocking · 1 Should-fix · 3 Nit (the same model wrote the code: a person should review too) |

### Code review 2026-11-13

| # | Finding | Layer | Class | Severity | Target |
|---|---------|-------|-------|----------|--------|
| 1 | C7: the changed scripts have no committed tests; the checks ran from the git-ignored `testing/` folder | scan | test | Nit | Deferred Items |
| 2 | `GENERATE KIT` with the new questions was not run end to end in a scratch project | spec | test | Should-fix | Deferred Items |
| 3 | Placeholder links in templates fail a link check by design | scan | docs | Nit | none |
| 4 | Spec summary + semantic diff may exceed Azure DevOps' 4 000 characters | code | docs | Nit | none — the script stops with a clear message |

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..S16 testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [x] Implementation · every Step's tasks checked
- [x] Documentation · README and generator docs updated
- [x] Review · semantic diff written for this spec
- [x] Spec closed · moved to `.specs/features/done/`
- [ ] Pull request · opened with the spec summary; reviewed; merged; branch deleted
