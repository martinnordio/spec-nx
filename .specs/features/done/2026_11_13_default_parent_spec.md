# Default Parent Spec

> **Author:** Martin Nordio
> **Status:** ✅ Complete — on `main` (small change, no pull request)
> **Created:** 2026-11-13
> **Last updated:** 2026-11-13
> **Branch:** `main`

## Stage log

| Date | Stage | Command | Model | Note |
|------|-------|---------|-------|------|
| 2026-11-13 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | Part 1 written |
| 2026-11-13 | plan | `PLAN:` | Claude Opus 5.5 | Part 2 written |
| 2026-11-13 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | Step 1 done; spec closed |

---

# Part 1 · Requirements

## Context

A project usually files all its backlog items under the same Feature or Epic. `CREATE ISSUE`
asked for the parent every time unless the command or the spec header named it.

**Already in the repository:** `stages/requirements/prompt.md` (`CREATE ISSUE` step 2: parent
from the command, the header, or ask), `generator/questions.md` (settings keys).

## 1 · Specs

- **S1 — Default parent:** an optional `parent` in `.specs/spec-nx.json` is used by
  `CREATE ISSUE` when neither the command nor the spec header names one; the dry run shows it.
- **S2 — Explicit wins:** `parent <n>` in the command, or the header's `Parent:` line, still
  wins over the default.
- **S3 — Nothing else changes:** without the key, `CREATE ISSUE` asks as before; no new
  setup question.

### Open questions

_None open._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## Closing summary

**Built:** the optional `parent` setting, read by `CREATE ISSUE` step 2.
**Differs from the plan:** nothing.
**Files:** `stages/requirements/prompt.md`, `generator/questions.md`.

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | `parent` in the settings and in `CREATE ISSUE` | ✅ Done | [→ Step 1](#step-1--parent-in-the-settings-and-in-create-issue) |

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | A settings key set by hand, not a setup question | Optional; most projects do not need it |
| D2 | Small change straight on `main`; tag `v0.3.2` | Author's decision |

---

## Step 1 — `parent` in the settings and in `CREATE ISSUE`

### Goal
`CREATE ISSUE` uses a project's default parent (S1–S3).

### Tasks
- [x] Record the start time in Notes below.
- [x] `stages/requirements/prompt.md`: step 2 reads `parent`; the settings row names it.
- [x] `generator/questions.md`: `parent` in the settings table.
- [x] Check: the order command → header → default → ask is stated once.

### Notes
Started: 2026-11-13 15:30

**Done (2026-11-13 · ~5m · Claude Opus 5.5)** — see the Closing summary. Check: read in
`stages/requirements/prompt.md` step 2.

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..S3 testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [x] Implementation · every Step's tasks checked
- [x] Spec closed · moved to `.specs/features/done/`
