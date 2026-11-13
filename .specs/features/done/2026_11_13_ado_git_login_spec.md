# Azure DevOps Git Login Spec

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
- **S4 — No new setting:** organisation and project still come from the `origin` remote.

### Open questions

_None open._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | Git login in `ado.ps1` / `ado.sh`; docs | ✅ Done | [→ Step 1](#step-1--git-login-in-adops1--adosh-docs) |

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

## Definition of Done

- [x] Requirements · Part 1 agreed
- [x] Plan · Part 2 written
- [x] Implementation · every Step's tasks checked
- [x] Spec closed · in `.specs/features/done/`
- [x] Pull request · ~~not needed — committed on `main` (D2)~~
