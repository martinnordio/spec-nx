# Description Markers Spec

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

Azure DevOps removes HTML comments from a work item's Markdown description. The
`<!-- spec-summary:start -->` / `<!-- spec-summary:end -->` markers were lost when a backlog
item was created, so `UPDATE ISSUE` could not find the summary and added a second one below
the old one. Found while closing the spec-kit integration (backlog item 150074).

**Already in the repository:** `stages/tools/spec_summary.ps1` / `.sh` (`Set-MarkedBlock` /
`set_marked_block`), used by every issue and pull-request script of both hosts.

## 1 · Specs

- **S1 — Markers that survive:** the scripts write the blocks between Markdown comment lines
  `[//]: # (<name>:start)` and `[//]: # (<name>:end)`, with an empty line on each side of the
  text so the markers are never shown. Checked on Azure DevOps: the lines are kept in a work
  item's Markdown description; HTML comments are not.
- **S2 — Old markers still found:** a description that still has
  `<!-- <name>:start -->` … `<!-- <name>:end -->` (GitHub issues, pull requests) gets its block
  replaced, in the new form.
- **S3 — Same in both shells:** PowerShell and bash give the same result.

### Open questions

_None open._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## Closing summary

**Built:** `Set-MarkedBlock` / `set_marked_block` write `[//]: # (…)` markers and still find
the old HTML ones; the contract and the tools README name both.
**Differs from the plan:** nothing.
**Files:** `stages/tools/spec_summary.ps1`, `stages/tools/spec_summary.sh`,
`stages/tools/README.md`, `generator/prompt.md`.

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | Markers in both helpers; contract and README | ✅ Done | [→ Step 1](#step-1--markers-in-both-helpers-contract-and-readme) |

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | Markdown comment lines `[//]: # (…)` for every host | One form everywhere; plain Markdown that renders as nothing on GitHub and Azure DevOps |
| D2 | Small change straight on `main`; tag `v0.3.1` | Author's decision |

---

## Step 1 — Markers in both helpers; contract and README

### Goal
Blocks survive Azure DevOps work items, and old blocks are still replaced (S1–S3).

### Tasks
- [x] Record the start time in Notes below.
- [x] `spec_summary.ps1` / `.sh`: write the new markers with empty lines; find new, then old markers.
- [x] `generator/prompt.md` (contract) and `stages/tools/README.md`.
- [x] Check: both helpers on four bodies (empty, new markers, old markers, no markers) give the same output; the new markers read back unchanged from Azure DevOps.

### Notes
Started: 2026-11-13 14:45

**Done (2026-11-13 · ~15m · Claude Opus 5.5)** — see the Closing summary. Check: Azure DevOps
item 150074 kept `[//]: # (spec-summary:start)` / `:end` and dropped an HTML comment; the
four cases gave identical output in PowerShell 5.1 and Git Bash.

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..S3 testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [x] Implementation · every Step's tasks checked
- [x] Spec closed · moved to `.specs/features/done/`
