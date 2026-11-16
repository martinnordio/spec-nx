# spec-nx Kit Spec

> **Author:** Martin Nordio
> **Status:** ✅ Complete
> **Created:** 2026-11-16
> **Last updated:** 2026-11-16
> **Branch:** `master`

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../stages/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-16 | generator | `GENERATE KIT` | Claude Opus 5.5 | ~1.43 M (80 k in · 1.33 M cached · 24 k out) | ~CHF 0.96 (114 credits) | kit generated |

## Cost summary

This feature used ~1.43 M tokens, ~CHF 0.96 — estimate, see [COSTS.md](../../stages/COSTS.md).

| Stage | Tokens | Cost (CHF) | Share of Copilot Business |
|-------|--------|------------|---------------------------|
| generator | ~1.43 M | ~0.96 | 6.0 % |
| **Total** | **~1.43 M** | **~0.96** | **6.0 %** |

---

# Part 1 · Requirements

## Context

Set up spec-nx (`d4aa796`) in this project. The scan found an existing Angular 22 app created
by the Angular CLI (TypeScript ~6.0, npm, Vitest + jsdom via `ng test`, Prettier), one
commit on `master`, no `origin` remote, no `.specs/` folder, no company layer, Windows.

## 1 · Specs

- **S1 — Project:** existing.
- **S2 — Company layer:** none.
- **S3 — Languages:** typescript.
- **S4 — Workflow:** Simple — requirements, plan, implementation, pr.
- **S5 — On-demand stages:** none.
- **S6 — Git host:** none; specs are not linked to issues (`link_issues` false).
- **S7 — Kit:** shared, in `.specs/kit`.
- **S8 — Shell:** powershell (`shells`: powershell).
- **S9 — Agent permissions:** VS Code Copilot.
- **S10 — Models:** per Step — reasoning Claude Opus 5.5, standard Claude Sonnet 5.5, light
  Claude Haiku 5.5.
- **S11 — Cost tracking:** on — Copilot Business, CHF at 0.8384 per USD (2026-11-13).

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | Generate the kit | ✅ Done | [→ Step 1](#step-1--generate-the-kit) |

---

## Step 1 — Generate the kit

### Tasks
- [x] Save the settings (`.specs/spec-nx.json`, `.specs/spec-nx.local.json`, `.gitignore`).
- [x] Write the kit in `.specs/kit/`.
- [x] Check the kit.
- [x] Write the agent permissions (`.vscode/settings.json`).

### Notes
**Done (2026-11-16 · Claude Opus 5.5)** — Written: `.specs/spec-nx.json`,
`.specs/spec-nx.local.json`, `.gitignore` (local settings ignored), `.vscode/settings.json`,
`.specs/features/done/.gitkeep`, and `.specs/kit/`: `README.md`, `spec_template.md`,
`models.md`, `COSTS.md`, `requirements/`, `plan/`, `implementation/`, `pr/`, `guidelines/`
(`prompt.md`, `commits.md`, `typescript.md`), `skills/` (`requirements_engineer.md`,
`architect.md`, `developer.md`), `tools/` (`README.md`, `usage.ps1`, `costs_ledger.ps1`,
`spec_summary.ps1`). Checks: every `../` path in the prompts exists; the three PowerShell
scripts parse with no errors and are ASCII only; the commands, spec markers and Stage log are
present. · ~1.43 M · ~CHF 0.96
