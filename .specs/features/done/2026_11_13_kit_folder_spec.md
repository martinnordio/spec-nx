# Kit Folder Spec

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

The generator always writes the kit to `.specs/kit/`. A company that keeps one shared kit for
all its projects (a private repository with spec-nx as a submodule and a company layer) wants
the kit generated once, into the root of that repository, so projects add it as a submodule and
load `.<kit>/<stage>/prompt.md` without generating anything themselves.

**Already in the repository:** `generator/prompt.md`, `generator/questions.md` (Q4 shared or
personal kit), `generator/layer.md`, `stages/kit_readme.md`.

## 1 · Specs

- **S1 — Kit folder question:** a new question **Q4b** `kit_dir` asks where the kit goes;
  default `.specs/kit`, which keeps today's behaviour. A layer's `defaults.json` can suggest it.
- **S2 — Kit used from other repositories:** only when `kit_dir` is not the default, **Q4c**
  `kit_ref` asks under which folder other repositories add this kit as a submodule (default:
  `kit_dir`, i.e. not used elsewhere). Every path the kit shows to its users starts with
  `kit_ref`.
- **S3 — Safe regeneration:** outside `.specs/kit/` the generator deletes only the files and
  folders of its previous generation (`kit_files` in `.specs/spec-nx.json`) and never
  overwrites another file without asking; `.specs/`, `.spec-nx/` and the layer are never
  touched.
- **S4 — Quick start:** with a `kit_ref`, the kit's README starts with how to add the kit to a
  project and the first command (at most ten lines).
- **S5 — No settings in using projects:** with a `kit_ref`, the prompts carry this
  repository's answers (`git_host`, `link_issues`, `work_item_type`, `stages`, `languages`) as
  defaults; a using project's own `.specs/spec-nx.json` still wins.

### Open questions

_None open._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | Q4b / Q4c, generator, kit README, layer | ✅ Done | [→ Step 1](#step-1--q4b--q4c-generator-kit-readme-layer) |

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | A question, not a hidden setting | The author's choice; it is visible in `GENERATE KIT` and a layer can preset it |
| D2 | `kit_files` lists only top-level entries | Enough to delete the previous kit at the root; short settings file |
| D3 | Small change straight on `main`, no pull request; new tag `v0.3.0` | Author's decision |

---

## Step 1 — Q4b / Q4c, generator, kit README, layer

### Goal
A kit can be generated into any folder and used from other repositories (S1–S5).

### Tasks
- [x] Record the start time in Notes below.
- [x] `generator/questions.md`: Q4b, Q4c; `kit_dir`, `kit_ref`, `kit_files` in the settings.
- [x] `generator/prompt.md`: write to `kit_dir`; delete by `kit_files`; paths with `kit_ref`; defaults in the prompts; report.
- [x] `stages/kit_readme.md`: quick start and settings for a kit used from other repositories.
- [x] `generator/layer.md`: `kit_dir` / `kit_ref` in `defaults.json`; the shared company kit.
- [x] Check: every `.specs/kit` in `generator/` is the default or says it stands for `kit_dir`.

### Notes
Started: 2026-11-13 13:22

**Done (2026-11-13 · ~5m · Claude Opus 5.5)** — Q4b / Q4c added; generator, kit README, layer
and README updated. Check: every remaining `.specs/kit` in `generator/` and
`stages/kit_readme.md` is a default or under a note that it stands for `kit_dir`.

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..S5 testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [x] Implementation · every Step's tasks checked
- [x] Spec closed · moved to `.specs/features/done/`
