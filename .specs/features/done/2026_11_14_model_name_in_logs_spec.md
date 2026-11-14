# Model Name in Logs Spec

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

The Stage log, the Done lines and the Review Log should show which AI model did each stage, so
models can be compared. In a project used with several models, every row said the model that
generated the kit: the stage prompts only asked for "the exact name of the AI model you are",
and the assistant copied the name from `.specs/spec-nx.json` (`model` = the model that generated
the kit), from the kit README or from earlier rows.

**Already in the repository:** the stage prompts (`requirements`, `plan`, `implementation`,
`documentation`, `review`, `pr`, `improvement`) and `setup/project_spec.md` write Stage log
rows, Done lines and Review Log rows; `spec_template.md` explains the Stage log;
`generator/questions.md` defines the `model` setting.

## 1 · Specs

- **S1 — The model of this run:** every Stage log row, Done line and Review Log row names the
  model that runs the command now, as the assistant's runtime reports it (for example
  "GPT-6 Luna" when `PLAN:` runs on it).
- **S2 — Never copied:** the name is never taken from `.specs/spec-nx.json`, the kit README,
  earlier rows or examples; a stage prompt says so where it asks for the name.
- **S3 — Unknown is said:** when the assistant cannot tell its model, it asks the user once and
  otherwise writes `unknown model` — never a guess.
- **S4 — The setting stays:** `model` in the settings keeps its meaning (the model that
  generated the kit) and its description says it is not the model of a stage run.

### Open questions

_None open._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## Closing summary

**Built:** a **Model name** rule in every stage prompt that logs a model, in the spec template
and in the contract of `generator/prompt.md`; the `model` setting is described as the kit's
generator only.
**Differs from the plan:** nothing.
**Files:** `stages/{requirements,plan,implementation,documentation,review,pr,improvement}/prompt.md`,
`stages/setup/project_spec.md`, `stages/spec_template.md`, `generator/prompt.md`,
`generator/questions.md`.

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | Model name rule in prompts, template, contract, settings | ✅ Done | [→ Step 1](#step-1--model-name-rule-in-prompts-template-contract-settings) |

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | The rule is written in each stage prompt, not only in the template | Stages load their own prompt; not all of them load the template |
| D2 | The settings key `model` keeps its name | Existing keys never change meaning; its description is made explicit instead |
| D3 | Small change straight on `main`; tag `v0.3.3` | Author's decision |

---

## Step 1 — Model name rule in prompts, template, contract, settings

### Goal
Every logged model is the model of that run (S1–S4).

### Tasks
- [x] Record the start time in Notes below.
- [x] A **Model name** section in the seven stage prompts; "the exact name of the AI model you are" → "your model".
- [x] `setup/project_spec.md`, `spec_template.md` (Stage log comment, Done line), `generator/prompt.md` (contract), `generator/questions.md` (`model` setting).
- [x] Check: every place that asks for a model name points to the rule; no example implies a fixed model.

### Notes
Started: 2026-11-14

**Done (2026-11-14 · ~15m · Claude Opus 5.5)** — see the Closing summary. Check: `git grep`
for "model you are", "your model" and "<model>" in `stages/` — every hit is covered by the
rule of its file.

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..S4 testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [x] Implementation · every Step's tasks checked
- [x] Spec closed · moved to `.specs/features/done/`
