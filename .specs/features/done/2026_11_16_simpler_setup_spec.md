# Simpler Setup Spec

> **Author:** Martin Nordio
> **Status:** � In progress — Steps 1–6 done; Step 7 (tutorial) written, trial runs open
> **Created:** 2026-11-16
> **Last updated:** 2026-11-16
> **Branch:** `main` (release `v0.4.0`, no pull request)

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../../stages/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-16 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | ~2.25 M (12 k in · 2.23 M cached · 7 k out) | ~CHF 0.54 (65 credits) | Step 1 done |
| 2026-11-16 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | ~449 k (2 k in · 445 k cached · 2 k out) | ~CHF 0.11 (14 credits) | Company layer: what it is, why, options (S6) |
| 2026-11-16 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | ~759 k (3 k in · 754 k cached · 2 k out) | ~CHF 0.17 (20 credits) | Step 2 done |
| 2026-11-16 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | ~772 k (2 k in · 768 k cached · 2 k out) | ~CHF 0.17 (20 credits) | Step 3 done |
| 2026-11-16 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | ~1.44 M (9 k in · 1.43 M cached · 5 k out) | ~CHF 0.36 (43 credits) | Step 4 done |
| 2026-11-16 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | ~833 k (5 k in · 826 k cached · 3 k out) | ~CHF 0.20 (24 credits) | Step 5 done; impact of S11 analysed |
| 2026-11-16 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | ~2.08 M (13 k in · 2.06 M cached · 7 k out) | ~CHF 0.52 (62 credits) | Step 6 done; this spec written and closed (until 12:42 UTC) |
| 2026-11-16 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | ~751 k (6 k in · 743 k cached · 3 k out) | ~CHF 0.20 (23 credits) | Tutorial drafted (S14–S21), open questions; Step 7 added; spec reopened (from 12:49 UTC) |
| 2026-11-16 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | ~1.36 M (52 k in · 1.29 M cached · 12 k out) | ~CHF 0.64 (76 credits) | Step 7: open questions answered; tutorials and README section written; trial step 1 checked; commit `760260b` (12:51–13:10 UTC) |
| 2026-11-16 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | ~344 k (6 k in · 334 k cached · 4 k out) | ~CHF 0.15 (17 credits) | Step 8 done (from 13:10 UTC) |

> The work was done in one chat on `main`, turn by turn, before this spec was written: the
> Stage log and the Steps record those turns after the fact. Every row was computed with
> `stages/tools/usage.ps1` (method D11 of the model-per-step spec, [COSTS.md](../../../stages/COSTS.md))
> on the VS Code transcript of this chat; the time range of each row runs from its user
> message to the next one (UTC 11:56:43, 12:04:36, 12:12:59, 12:20:23, 12:24:59, 12:37:36,
> 12:39:47, end of this spec). No plan stage ran (the Steps followed the requests one by one);
> no review and no pull request: the author reviews and commits on `main`.

---

## Cost summary

This feature used ~11.03 M tokens, ~CHF 3.07 — estimate, see [COSTS.md](../../../stages/COSTS.md).

| Stage | Tokens | Cost (CHF) | Share of Copilot Business |
|-------|--------|------------|---------------------------|
| requirements | ~1.20 M | ~CHF 0.31 (37 credits) | 1.9 % |
| implementation | ~9.83 M | ~CHF 2.76 (327 credits) | 17.2 % |
| **Total** | **~11.03 M** | **~CHF 3.07 (364 credits)** | **19.2 %** |

**Implementation by Step**

| Step | Tokens | Cost (CHF) | Share of Copilot Business |
|------|--------|------------|---------------------------|
| Step 1 | ~2.25 M | ~CHF 0.54 (65 credits) | 3.4 % |
| Step 2 | ~759 k | ~CHF 0.17 (20 credits) | 1.0 % |
| Step 3 | ~772 k | ~CHF 0.17 (20 credits) | 1.1 % |
| Step 4 | ~1.44 M | ~CHF 0.36 (43 credits) | 2.3 % |
| Step 5 | ~833 k | ~CHF 0.20 (24 credits) | 1.3 % |
| Step 6 + CLOSE | ~2.08 M | ~CHF 0.52 (62 credits) | 3.3 % |
| Step 7 (so far) | ~1.36 M | ~CHF 0.64 (76 credits) | 4.0 % |
| Step 8 | ~344 k | ~CHF 0.15 (17 credits) | 0.9 % |
| **Total implementation** | **~9.83 M** | **~CHF 2.76 (327 credits)** | **17.2 %** |

---

# Part 1 · Requirements

## Context

Before tagging `v0.4.0`, the README must describe spec-nx as it is now, with the new key
feature — the right model for each Step and what it cost — up front. Reading it showed that
the setup asks more than it needs to: several answers can be taken from the repository or the
computer, and only special cases need to change them. Fewer questions make the first
`GENERATE KIT` faster, while every setting stays changeable by hand.

**Already in the repository:**
- `README.md`, `docs/configuration.md`, `stages/kit_readme.md`.
- `generator/questions.md` (questions, suggestions, settings keys) and `generator/prompt.md`
  (how `GENERATE KIT` asks and saves).
- `stages/requirements/prompt.md` (`CREATE ISSUE:` and the Azure DevOps item type).
- The Azure DevOps scripts already fall back to the repository's project without `work_items`
  and to `Product Backlog Item` without `--type`.

**New:**
- The README's selling points, the key-feature section and a correct setup-questions table.
- Four answers that are no longer asked: project start, shell, backlog item type, backlog
  project.

## 1 · Specs

**README**

- **S1 — Selling points:** the README opens with a tagline and a short list of what spec-nx
  gives: specs in the repository, the right model per Step, the cost of every feature, a kit
  made by your AI model, semantic-diff reviews, and the tools it fits.
- **S2 — Key feature:** the section on the model per Step and its cost matches the current
  stages, settings and scripts, links to `stages/COSTS.md`, and shows this repository's own
  cost of the model-per-step feature as an example.
- **S3 — Released, not in progress:** the "Work in progress" banner and the `## Status`
  section are removed.
- **S4 — Setup questions:** the README lists the questions in the order the generator asks
  them, each with its default and where the suggestion comes from.
- **S5 — Correct throughout:** How it works, the settings table, the stages table and the
  repository layout match the current behaviour (one confirmation for all Steps with per-Step
  models; `CLOSE:`; Windows PowerShell 5.1 or 7; example kits still planned).
- **S6 — Company layer apart:** the company-layer question and the two shared-kit questions
  (kit folder, kit used from other repositories) are not in the README's main table; the
  section on the company's rules explains, without question numbers, when they apply and what
  they do.
- **S7 — Workflows explained:** the README says which stages Simple, Full and Custom contain,
  and what each on-demand stage (improvement, setup, ui) is for.

**Fewer questions** — each answer below is taken by the generator without asking, and the
documentation says how to change it for special cases.

- **S8 — Shell:** from the operating system (Windows → PowerShell, macOS / Linux → bash),
  saved in `.specs/spec-nx.local.json`; a saved shell is kept. Another shell (e.g. Git Bash on
  Windows): set `shell` by hand and run `GENERATE KIT --update`.
- **S9 — Backlog project (Azure DevOps):** the repository's project; nothing is saved. Items
  in another project: add `work_items` by hand.
- **S10 — Backlog item type (Azure DevOps):** `Product Backlog Item`; nothing is saved.
  Another process: set `work_item_type` by hand. If Azure DevOps rejects the type,
  `CREATE ISSUE:` asks for the right one and offers to save it.
- **S11 — Project start:** new or existing is decided from the scan and stated in the scan
  summary, not asked; the user can correct it with one word. It is still saved as `project`
  and still drives the project setup spec and the language question.
- **S12 — Settings keep working:** no key changes meaning; existing settings files with
  `shell`, `work_items`, `work_item_type` or `project` work as before.

**This spec**

- **S13 — Cost logged:** this spec records the tokens and cost of the work, at least per stage.

**Tutorial**

- **S14 — A tutorial in the README:** a short `## Tutorial` section after *How it works*
  names the tutorials, what you build and what you need, and links to one page per tutorial
  in `docs/tutorials/`.
- **S15 — Two tutorials, two projects:** one in TypeScript with **Angular** and one in
  **Python**, each a separate new repository, each building a small app known from that
  framework's own official tutorial — only the idea of the app is reused; no text or code is
  copied from it.
- **S16 — One full workflow:** each tutorial goes once, step by step, through the default
  Simple workflow on one feature: create the project with the framework's own command,
  `GENERATE KIT`, `REQUIREMENTS:`, `PLAN:`, `IMPLEMENT:`, `CLOSE:`. Each step shows what to
  type and what you should see.
- **S17 — Requirements already suggested:** each tutorial gives the exact `REQUIREMENTS:` text
  to paste, so every reader starts from the same feature.
- **S18 — Local first, git host optional:** the main path needs no account: git host "none",
  no issue, no pull request; the work ends merged on the local branch. An optional part at
  the end adds a git host:
  - **GitHub:** create an empty repository first, `gh auth login`; then `CREATE ISSUE:` and
    `PR:`.
  - **Azure DevOps:** an organisation and a project with a repository must exist first, and a
    git login; then `CREATE ISSUE:` (a backlog item) and `PR:`.
- **S19 — Prerequisites listed:** git, VS Code with GitHub Copilot in agent mode (Claude Code
  noted as an alternative), and per tutorial the runtime (Node.js LTS and the Angular CLI;
  Python and `uv` or `pip`).
- **S20 — Models and cost shown:** the tutorial points out the model of each stage and Step,
  and ends with the spec's cost summary and what the reader's run cost.
- **S21 — Tried before published:** each tutorial is run end to end in a scratch repository
  in `testing/`; its real Stage log and cost are the example numbers in the tutorial.

**Kit spec**

- **S22 — The setup is a spec:** `GENERATE KIT` (and `--update`) ends by writing a closed spec
  in `.specs/features/done/` dated today: the settings it decided as statements, one Step
  "Generate the kit" with the files written and the checks, and — with cost tracking — the
  tokens and cost of the run in the Stage log and a cost summary; `.specs/costs.md` is
  rebuilt. The generator's report ends by pointing to that spec.

### Open questions

None. The tutorial questions were answered on 2026-11-16 with the suggestions: Tour of Heroes
(hero list and detail); Flaskr (list and create posts, no login); a short README section with
the tutorials in `docs/tutorials/`; GitHub and Azure DevOps in the optional part (a second
feature, `docs/tutorials/git-host.md`); the reader creates the skeleton with the framework's
command.

<details>
<summary>The questions as asked</summary>

1. **Angular app:** *Tour of Heroes* (the classic, best known; list, detail, edit a hero) or
   the current angular.dev first app *Homes* (list of houses, details, a form)? Suggestion:
   Tour of Heroes, one feature — "a list of heroes and a detail view where the name can be
   edited".
2. **Python app:** the official Flask tutorial *Flaskr* (a small blog), Django's *Polls*, or a
   small data tool for data scientists (no web framework)? Suggestion: Flaskr, one feature —
   "list posts and create a post, stored in SQLite" — without login, to stay one workflow.
3. **Where the text lives:** a short README section and the full tutorials in
   `docs/tutorials/angular.md` and `docs/tutorials/python.md` (suggested), or everything in
   the README?
4. **Git host part:** both GitHub and Azure DevOps in the optional part (suggested), or only
   GitHub first?
5. **Starting point:** the reader creates the skeleton with the framework's command
   (`ng new`, a minimal Flask app) before `GENERATE KIT` (suggested: one workflow only), or
   lets the generator's project setup spec build it (a second workflow)?

</details>

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | README rewrite (S1–S5) | ✅ Done | [→ Step 1](#step-1--readme-rewrite-s1s5) |
| **2** | Company layer apart (S6) | ✅ Done | [→ Step 2](#step-2--company-layer-apart-s6) |
| **3** | Workflows explained (S7) | ✅ Done | [→ Step 3](#step-3--workflows-explained-s7) |
| **4** | Shell and backlog project not asked (S8, S9, S12) | ✅ Done | [→ Step 4](#step-4--shell-and-backlog-project-not-asked-s8-s9-s12) |
| **5** | Backlog item type not asked (S10) | ✅ Done | [→ Step 5](#step-5--backlog-item-type-not-asked-s10) |
| **6** | Project start not asked, this spec (S11, S13) | ✅ Done | [→ Step 6](#step-6--project-start-not-asked-this-spec-s11-s13) |
| **7** | Tutorial (S14–S21) | 🔄 In progress | [→ Step 7](#step-7--tutorial-s14s21) |
| **8** | Kit spec (S22) | ✅ Done | [→ Step 8](#step-8--kit-spec-s22) |

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | Work on `main`, no feature branch and no pull request | Last changes before tagging `v0.4.0`; the author reviews and commits |
| D2 | Question numbers stay (Q0, Q2c, Q2d, Q3 keep their headings in `questions.md`) | Renaming them all would touch every prompt; the README no longer shows the numbers of the special cases |
| D3 | Not-asked answers keep their keys | S12: older settings and the scripts stay compatible |
| D4 | Company layer kept, moved off the front page | Useful only for many repositories of one company; a full explanation stays in `generator/layer.md` |
| D5 | The tutorials' trial runs (S21) happen in a fresh chat, one per tutorial | The cost of a run is measured on its own chat transcript; in this chat it would mix with the spec-nx work |
| D6 | The optional git-host part builds a second feature, shared by both tutorials | The first run stays simple; the issue and the pull request come with a feature of their own |

---

## Step 1 — README rewrite (S1–S5)

### Goal
The README sells spec-nx, puts the key feature first and is correct.

### Tasks
- [x] Record the start time in Notes below.
- [x] Tagline and selling points (S1).
- [x] Key-feature section checked against `stages/models.md`, the implementation prompt,
      `generator/questions.md` and `stages/COSTS.md`; link to `COSTS.md`; own cost as example (S2).
- [x] Remove the banner and `## Status` (S3).
- [x] Setup-questions table in the generator's order, with Default and Suggested from (S4).
- [x] How it works, settings table, stages table, repository layout (S5).

### Notes
Started: 2026-11-16 12:56

**Done (2026-11-16 · ~8m · Claude Opus 5.5)** — README rewritten; `check_all.ps1`: 4 known
placeholders. · ~2.25 M · ~CHF 0.54

---

## Step 2 — Company layer apart (S6)

### Goal
Individual users are not confronted with the company layer; companies still find it.

### Tasks
- [x] Record the start time in Notes below.
- [x] Remove the layer row and the kit-folder / kit-used-from rows from the README table.
- [x] Rewrite "Your company's rules: a layer": when it is useful, using a layer, one kit for
      all projects with its two extra questions; link to `generator/layer.md`.

### Notes
Started: 2026-11-16 13:12

**Done (2026-11-16 · ~7m · Claude Opus 5.5)** — README only; `check_all.ps1`: 4 known
placeholders. · ~759 k · ~CHF 0.17

---

## Step 3 — Workflows explained (S7)

### Goal
The README says what Simple, Full and the on-demand stages contain.

### Tasks
- [x] Record the start time in Notes below.
- [x] Q1 and Q1b rows: the stages of each workflow; the commands of each on-demand stage.
- [x] Check that the on-demand stages are still in `stages/` and what of the old private kit
      was dropped (migration plan, `.specs/migrations/`).

### Notes
Started: 2026-11-16 13:20

**Done (2026-11-16 · ~5m · Claude Opus 5.5)** — improvement, setup and ui are all in
`stages/`; dropped from the old kit: `migrate_project`, `synthesize_project`, the PEP 8 copy;
`render_cards` later; company content belongs in the layer. · ~772 k · ~CHF 0.17

---

## Step 4 — Shell and backlog project not asked (S8, S9, S12)

### Goal
`GENERATE KIT` no longer asks for the shell or the Azure DevOps backlog project.

### Tasks
- [x] Record the start time in Notes below.
- [x] `generator/questions.md`: both rows out of the question table; sections "Your shell
      (developer, not asked)" and "Backlog project (Azure DevOps, not asked)" with the special
      cases; settings-key table.
- [x] `generator/prompt.md`: do not ask them; `shell` from the operating system unless saved.
- [x] README (Not asked list; a new team member is asked nothing), `docs/configuration.md`,
      `stages/kit_readme.md`.

### Notes
Started: 2026-11-16 13:25

**Done (2026-11-16 · ~13m · Claude Opus 5.5)** — scripts unchanged (they already default to
the repository's project); `check_all.ps1`: 4 known placeholders. · ~1.44 M · ~CHF 0.36

---

## Step 5 — Backlog item type not asked (S10)

### Goal
`GENERATE KIT` no longer asks for the Azure DevOps backlog item type.

### Tasks
- [x] Record the start time in Notes below.
- [x] `generator/questions.md`: section "Backlog item type (Azure DevOps, not asked)" with the
      type per process; settings-key table.
- [x] `generator/prompt.md`: not asked.
- [x] `stages/requirements/prompt.md`: default `Product Backlog Item`; when rejected, ask and
      offer to save `work_item_type`.
- [x] README and `docs/configuration.md`.

### Notes
Started: 2026-11-16 13:37

**Done (2026-11-16 · ~2m · Claude Opus 5.5)** — `create_issue` scripts unchanged (default
type already `Product Backlog Item`); `check_all.ps1`: 4 known placeholders. · ~833 k ·
~CHF 0.20 (includes the impact analysis of S11)

---

## Step 6 — Project start not asked, this spec (S11, S13)

### Goal
The generator states new / existing instead of asking; this spec records the work and its
cost.

### Tasks
- [x] Record the start time in Notes below.
- [x] `generator/questions.md`: Q0 out of the question table; section "Q0 · Project start (not
      asked)"; settings key `project`.
- [x] `generator/prompt.md`: state new / existing in the scan summary, do not ask.
- [x] README: Q0 row out, Not asked list.
- [x] This spec with the Stage log and the cost summary from `usage.ps1` (S13).

### Notes
Started: 2026-11-16 13:39

**Done (2026-11-16 · ~5m · Claude Opus 5.5)** — `check_all.ps1`: 4 known placeholders. ·
~2.08 M · ~CHF 0.52

---

## Step 7 — Tutorial (S14–S21)

### Goal
A newcomer goes once through the whole workflow on a known app, in Angular or in Python.

### Tasks
- [x] Record the start time in Notes below.
- [x] Answer the open questions; finish S14–S21.
- [x] Write `docs/tutorials/angular.md`, `docs/tutorials/python.md` and
      `docs/tutorials/git-host.md` (checked against the stage prompts: branch offer, the one
      confirmation of `IMPLEMENT:`, commit approval in VS Code and Claude Code, `PR:` without a
      git host).
- [x] README `## Tutorial` section after *How it works*; `docs/` in the repository layout.
- [ ] Run the Angular tutorial end to end in a fresh chat in `testing/` (local path, then the
      GitHub part) (D5).
- [ ] Run the Python tutorial end to end in a fresh chat in `testing/` (local path, then the
      Azure DevOps part) (D5).
- [ ] Fix the tutorials from those runs; add their real cost as the example (S20, S21).
- [ ] `check_all.ps1`.

### Notes
Started: 2026-11-16 13:52

Tutorials written; `check_all.ps1`: 4 known placeholders. Not yet tried end to end.

First trial (Angular, 2026-11-16): step 1 checked — Angular 22.2, Vitest, build and 2 tests
pass; the first commit is on `master`, so the merge command now names `master` or `main`.
The run was stopped at step 2: the submodule was added before the simpler questions were
pushed; it restarts from scratch on `760260b` or later.
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 8 — Kit spec (S22)

### Goal
The kit setup is recorded as the project's first spec, with its cost.

### Tasks
- [x] Record the start time in Notes below.
- [x] `generator/prompt.md`: note the start time (step 1); new step 9 *Kit spec* (file name,
      header, Stage log row with `usage`, cost summary, the settings as statements, one Step,
      `costs_ledger`); the report ends with the spec's path; `--update` writes a kit update
      spec; *Never* and the file table allow the kit spec.
- [x] Tutorials (step 2) and README (*How it works*) mention the kit spec.
- [x] `check_all.ps1`.

### Notes
Started: 2026-11-16 14:10

**Done (2026-11-16 · ~2m · Claude Opus 5.5)** — the stage `generator` goes to the
*Other* column of `.specs/costs.md`; `check_all.ps1`: 4 known placeholders. · ~344 k ·
~CHF 0.15

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Renumber the remaining questions (Q5, Q0b, Q0c, Q1 …) | D2: touches every prompt | later spec |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|
| 2026-11-16 | Martin Nordio | diff | pending | — |
