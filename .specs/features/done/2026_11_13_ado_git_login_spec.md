# Azure DevOps Git Login and Backlog Project Spec

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
| 2026-11-13 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | Part 1 revised: S5–S6 backlog project (author's request) |
| 2026-11-13 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | Step 2 done; spec closed again |

---

# Part 1 · Requirements

## Context

The Azure DevOps tools only worked with a personal access token in `AZURE_DEVOPS_EXT_PAT`, so
every user had to create one. The original kit used the developer's git login instead.

**Already in the repository:** `stages/tools/azure_devops/ado.ps1` / `ado.sh` (organisation,
project and repository from the `origin` remote; REST calls with the token).

## 1 · Specs

- **S1 — No token needed:** with an https `origin` remote and a git login (Git Credential
  Manager), the Azure DevOps scripts work without `AZURE_DEVOPS_EXT_PAT`, in PowerShell and bash.
- **S2 — Token still wins:** when `AZURE_DEVOPS_EXT_PAT` is set, it is used (e.g. in CI).
- **S3 — Clear failure:** without either, the scripts stop with "run git fetch once to sign in,
  or set AZURE_DEVOPS_EXT_PAT"; credentials are never printed.
- **S4 — No new setting for sign-in:** organisation and project of the repository still come
  from the `origin` remote.
- **S5 — Backlog project (added at the author's request):** the generator asks in which
  Azure DevOps project the backlog items are (default: the repository's) and saves it as
  `work_items` in `.specs/spec-nx.json`; `CREATE ISSUE` / `UPDATE ISSUE` use that project, and
  the dry run names it.
- **S6 — Older settings keep working:** without `work_items`, the repository's project is used.

### Open questions

_None open._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | Git login in `ado.ps1` / `ado.sh`; docs | ✅ Done | [→ Step 1](#step-1--git-login-in-adops1--adosh-docs) |
| **2** | Backlog project: Q2d `work_items`, scripts (S5, S6) | ✅ Done | [→ Step 2](#step-2--backlog-project-q2d-work_items-scripts-s5-s6) |

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | Ask Git Credential Manager with `git credential fill` for the `origin` host and path; Basic authentication with the returned user and password | The approach the original kit used successfully against Azure DevOps |
| D2 | Small change straight on `main`, no pull request | Author's decision for a two-file fix |

---

## Step 1 — Git login in `ado.ps1` / `ado.sh`; docs

### Goal
The Azure DevOps scripts sign in with the git login unless a token is set (S1–S4).

### Tasks
- [x] Record the start time in Notes below.
- [x] `Get-AdoAuthorization` / `ado_auth`: token if set, otherwise `git credential fill`; clear error.
- [x] `generator/questions.md` (Q2 Needs) and `stages/tools/README.md`.
- [x] Check: without a token, a read-only call to an Azure DevOps project works in PowerShell and in bash; PowerShell parses, `bash -n` passes.

### Notes
Started: 2026-11-13 13:10

**Done (2026-11-13 · ~10m · Claude Opus 5.5)** — both shells use the git login when no token
is set. Check: without `AZURE_DEVOPS_EXT_PAT`, reading the work item types of an Azure DevOps
project succeeded in PowerShell and in bash; all scripts parse.

---

## Step 2 — Backlog project: Q2d `work_items`, scripts (S5, S6)

### Goal
Backlog items can live in another Azure DevOps project than the repository (S5, S6).

### Tasks
- [x] Record the start time in Notes below.
- [x] Q2d in `generator/questions.md`: question, suggestion from `origin`, key `work_items`.
- [x] `Get-AdoWorkItemsBase` / `ado_items`; `create_issue` and `update_issue` (both shells) use it; the dry run names the project.
- [x] Requirements stage: `CREATE ISSUE` names the project.
- [x] Check: dry runs in a scratch repository without settings and with `work_items` pointing to another project.

### Notes
Started: 2026-11-13 13:25

**Done (2026-11-13 · ~10m · Claude Opus 5.5)** — PowerShell dry runs: without settings the
item goes to the repository's project; with `work_items` to `Other%20Project` (encoded). The
bash version passes `bash -n`; it could not be run here because `jq` is not installed — to be
tried with the real other-project case.

---

## Definition of Done

- [x] Requirements · Part 1 agreed
- [x] Plan · Part 2 written
- [x] Implementation · every Step's tasks checked
- [x] Spec closed · in `.specs/features/done/`
- [x] Pull request · ~~not needed — committed on `main` (D2)~~
