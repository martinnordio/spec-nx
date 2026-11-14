# Update Without Questions Spec

> **Author:** Martin Nordio
> **Status:** ✅ Complete — on `main` (small change, no pull request)
> **Created:** 2026-11-14
> **Last updated:** 2026-11-14
> **Branch:** `main`

## Stage log

| Date | Stage | Command | Model | Note |
|------|-------|---------|-------|------|
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | Part 1 written |
| 2026-11-14 | plan | `PLAN:` | Claude Opus 5.5 | Part 2 written |
| 2026-11-14 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | Step 1 done; spec closed |

---

# Part 1 · Requirements

## Context

`GENERATE KIT --update` should regenerate the kit from the saved settings without asking the
setup questions again; in practice the assistant asked them all again "to confirm". There was
also no way to ask on purpose, to change answers.

**Already in the repository:** `generator/prompt.md` (`GENERATE KIT --update` asks only
questions whose key is missing), `generator/questions.md`, `README.md`.

## 1 · Specs

- **S1 — No questions with saved answers:** with `.specs/spec-nx.json` present,
  `GENERATE KIT --update` asks no question whose key has a value — not even to confirm; the
  answers used are listed in the report.
- **S2 — Only what is new:** it still asks questions added to spec-nx since (missing keys), and
  the developer questions when `.specs/spec-nx.local.json` is missing.
- **S3 — Force:** `GENERATE KIT --update --force` asks every question again in order, with the
  saved answer as the suggestion (and the scan's suggestion when it differs); changed answers
  are saved and named in the report.
- **S4 — Safe with force:** `--force` never writes a second project setup spec, and a changed
  kit folder removes the old kit's files first.

### Open questions

_None open._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## Closing summary

**Built:** `--update` uses saved answers without asking; `--update --force` asks again with
them as suggestions; documented in the generator, the questions file and the README.
**Differs from the plan:** nothing.
**Files:** `generator/prompt.md`, `generator/questions.md`, `README.md`.

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | `--update` without questions; `--update --force` | ✅ Done | [→ Step 1](#step-1----update-without-questions---update---force) |

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | `--force` is a flag of `--update`, not a new command | The same regeneration; only the questions differ |
| D2 | Small change straight on `main`; tag `v0.3.3` moved to it | Author's decision: `v0.3.3` was not taken by any project yet |

---

## Step 1 — `--update` without questions; `--update --force`

### Goal
Updating uses the saved answers; forcing asks again (S1–S4).

### Tasks
- [x] Record the start time in Notes below.
- [x] `generator/prompt.md`: the command list; `--update` step 2 (no confirmation questions, new team member) and `--force`; the report lists the answers.
- [x] `generator/questions.md` and `README.md`: `--update --force`.
- [x] Check: the generator names one rule for asking per mode.

### Notes
Started: 2026-11-14

**Done (2026-11-14 · ~10m · Claude Opus 5.5)** — see the Closing summary. Check: read
`generator/prompt.md` Commands and `GENERATE KIT --update` step 2.

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..S4 testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [x] Implementation · every Step's tasks checked
- [x] Spec closed · moved to `.specs/features/done/`
