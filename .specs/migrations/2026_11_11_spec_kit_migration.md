# Spec-Kit Migration Plan

> **Author:** Martin Nordio
> **Status:** 📝 Decisions agreed — all M items are built in one spec:
> [2026_11_13_spec_kit_migration_spec.md](../features/2026_11_13_spec_kit_migration_spec.md)
> **Created:** 2026-11-11
> **Last updated:** 2026-11-13
> **Source:** the original spec-kit — an earlier private kit, used as the git submodule `.spec-kit/`

## Stage log

| Date | Stage | Command | Model | Note |
|------|-------|---------|-------|------|
| 2026-11-11 | migration plan | — | Claude Opus 5.5 | Plan written: inventory, decisions, specs M1–M9 |
| 2026-11-13 | migration plan | — | Claude Opus 5.5 | Revised: phases; Q0 project start, Q0b languages, Q0c project spec; Q1 Simple / Full / Custom; company content stays private in a company layer; no migration tool (M8 dropped); M10–M12 added |
| 2026-11-13 | migration plan | — | Claude Opus 5.5 | Open questions answered; one spec for all M items |

## Context

The original spec-kit is one fixed toolkit: 15 prompts, 6 skills, 12 guidelines, 11 templates
and 2 tools, loaded by hand (`Load … CREATE SPEC: …`). spec-nx today has three stages
(requirements → plan → pr), two skills, the spec template and the git-host tools, and generates
a kit adapted to each project. This plan decides what of the original moves into spec-nx as
**building blocks**, and cuts that work into specs, one per stage or feature.

**Where it ends:** spec-kit stops being a hand-written toolkit. It becomes a thin, private
**company layer** on top of spec-nx: spec-nx as a submodule plus a layer folder with what is
not open source (brand looks, the company's stack and guidelines, default answers, agent
permissions, private migration notes). Projects generate their kit from it with `GENERATE KIT`. Projects still on the
old spec-kit keep their pinned submodule commit; there is no migration tool (D11).

## Phases

| Phase | What | Specs | Done when |
|-------|------|-------|-----------|
| **1 · Minimum spec-nx** | What a project needs to start: the new questions, implementation, guidelines, the new-project spec, the company layer | M10, M1, M2, M6, M11 | A scratch project in `testing/` goes from `GENERATE KIT` (empty repo) to a merged pull request with the Simple workflow |
| **2 · Regenerate spec-kit** | spec-kit becomes spec-nx + company layer | In the private spec-kit repository | The first project has a generated kit and its first spec |
| **3 · First project** | Work on the first project with the generated kit | (in that repository) | — |
| **4 · Rest of spec-nx** | Documentation, review, improvement, ui, agent permissions, setup tooling; projects get them with `GENERATE KIT --update` | M3, M4, M5, M7, M9, M12 | — |

Until phase 2 is done, new projects may use the old spec-kit prompts at their pinned commit.

**2026-11-13:** phases 1 and 4 are built together in one spec,
[2026_11_13_spec_kit_migration_spec.md](../features/2026_11_13_spec_kit_migration_spec.md), one
Step per M item and one pull request.

## Principles

- **P1 — Building blocks, not copies:** what is migrated goes into `stages/` as a reference the
  generator adapts to each project; nothing project-specific (company stack, colours, paths,
  Azure DevOps URLs) goes into spec-nx.
- **P2 — Two kinds of files, so updates never lose work:**
  - **kit files** (`.specs/kit/…`) are owned by the generator and **replaced** on every
    `GENERATE KIT` / `--update`;
  - **project files** (`.specs/features/`, `.specs/guidelines/`, `.specs/architecture.md`, ADRs,
    …) are owned by the project: the generator or a stage **creates them once if missing**,
    never overwrites them, and on `--update` only **proposes** changes (a diff the user accepts).
- **P3 — The contract grows, it does not change:** new stages add commands and files; the
  existing commands, spec file, markers, script parameters and settings keys stay as they are.
- **P4 — Both hosts and both shells:** every new script exists for GitHub and Azure DevOps, in
  PowerShell and bash (the original `publish_pr.ps1` is Azure DevOps / PowerShell only).
- **P5 — Every stage logs its model:** each new stage adds a Stage log row to the spec, and
  each implemented Step records its model in its Done line (done in spec-nx on 2026-11-11).
- **P6 — Smaller than the original:** a stage prompt stays short and concrete; long reference
  texts (PEP 8, methodology) are linked or left to linters, not copied.
- **P7 — Open source stays generic, company content stays private:** spec-nx gets only
  generic building blocks and a generic way to add a company layer (M11). Company content
  lives in the company's layer (in its private kit repository) and never in spec-nx.
- **P8 — Simple first:** the default workflow (for data scientists) has the fewest stages that
  still give a spec, small Steps and a pull request; every other stage is opt-in.

## Inventory

**Migrate** · **Merge** (into something spec-nx already has) · **Later** · **Drop** ·
**Private** (stays in the company layer, not open source; done in the private kit repository,
"SK" below). Paths are relative to the original `.spec-kit/`.

### Prompts

| # | Item | Decision | Target in spec-nx | Spec |
|---|------|----------|-------------------|------|
| I1 | `prompts/create_spec.md` | Merge | `requirements` + `plan` stages (done) — check for missing rules (seed from deferred items) | M1 |
| I2 | `prompts/update_spec.md` | Merge | `REQUIREMENTS: <spec> — …` and `PLAN:` again (done) | — |
| I3 | `prompts/synthesize_spec.md` (`--close`) | Migrate | `implementation` stage: consolidate the spec and close it (move to `done/`) | M1 |
| I4 | `prompts/synthesize_architecture.md` | Migrate | `documentation` stage | M3 |
| I5 | `prompts/create_adr.md` | Migrate | `documentation` stage (`ADR:`); plan decisions `D<n>` can be promoted to ADRs | M3 |
| I6 | `prompts/semantic_diff.md` | Migrate | `review` stage (change record + review page + PR text) | M4 |
| I7 | `prompts/code_review.md` | Migrate | `review` stage (`CODE REVIEW:`), findings into the spec's Review Log | M4 |
| I8 | `prompts/create_improvement_spec.md` | Migrate | `improvement` stage (on demand); writes a normal spec | M5 |
| I9 | `prompts/create_setup_spec.md` | Later | `setup` stage (on demand): `SETUP TOOLING:` | M12 |
| I10 | `prompts/create_dev_env_setup_spec.md` | Later | `setup` stage (on demand): `SETUP MACHINE` | M12 |
| I11 | `prompts/create_project.md` | Migrate + Private | Generic: `stages/setup/project_spec.md`, used by Q0c for any language (D8). Company stack (Python + FastAPI, SvelteKit + pnpm, run / check scripts, ports) → the company layer `setup/` | M6, SK |
| I12 | `prompts/create_look_spec.md` | Later | `ui` stage | M7 |
| I13 | `prompts/refresh_ui_catalog.md` | Later | `ui` stage | M7 |
| I14 | `prompts/migrate_project.md` (`.vibe/` → `.spec-kit/`) | Drop | No migration from the old tools (D11) | — |
| I15 | `prompts/synthesize_project.md` | Drop | Regenerating code from all specs is rare and risky; a normal spec does it | — |

### Skills

| # | Item | Decision | Target in spec-nx | Spec |
|---|------|----------|-------------------|------|
| I16 | `skills/requirements_engineer.md` | Merge | `stages/skills/requirements_engineer.md` — port missing quality checks / anti-patterns | M1 |
| I17 | `skills/architect.md` | Merge | `stages/skills/architect.md` — port ownership of architecture / ADRs when M3 lands | M3 |
| I18 | `skills/developer.md` | Migrate | `stages/skills/developer.md` | M1 |
| I19 | `skills/reviewer.md` | Migrate | `stages/skills/reviewer.md` | M4 |
| I20 | `skills/refactorer.md` | Migrate | `stages/skills/refactorer.md` | M5 |
| I21 | `skills/ui_designer.md` | Later | `stages/skills/ui_designer.md` | M7 |
| I22 | `skills/README.md` (persona shape, handoffs) | Merge | A short section in the README; the fixed skill shape becomes a rule for `stages/skills/` | M1 |

### Guidelines

| # | Item | Decision | Target in spec-nx | Spec |
|---|------|----------|-------------------|------|
| I23 | `guidelines/python.md` | Migrate + Private | Generic → `stages/guidelines/python.md` baseline; company rules → the company layer `guidelines/python.md`; project facts → the project's `.specs/guidelines/python.md` | M2, SK |
| I24 | `guidelines/svelte.md` | Migrate + Private | Generic → `stages/guidelines/svelte.md` baseline; company rules → the company layer `guidelines/svelte.md` | M2, SK |
| I25 | `guidelines/python_pep8.md` (47 KB) | Drop | Link to PEP 8 and rely on the project's linter (ruff) config | M2 |
| I26 | `guidelines/code_review.md` | Migrate | `stages/review/` (human layered review checklist) | M4 |
| I27 | `guidelines/semantic_diff.md` | Migrate | `stages/review/` (rules of the semantic diff) | M4 |
| I28 | `guidelines/looks.md` (Looks contract) | Later | `ui` stage | M7 |
| I29 | `guidelines/design_styles.md`, `guidelines/looks/*.md` | Private | Brand content (design system, colours) → the company layer `looks/` | SK |

### Templates

| # | Item | Decision | Target in spec-nx | Spec |
|---|------|----------|-------------------|------|
| I30 | `templates/spec.md` | Merge | `stages/spec_template.md` (done) | — |
| I31 | `templates/architecture.md` | Migrate | `stages/documentation/templates/` → project file `.specs/architecture.md` | M3 |
| I32 | `templates/adr.md` | Migrate | `stages/documentation/templates/` → `.specs/decisions/NNNN-<slug>.md` | M3 |
| I33 | `templates/data_model.md`, `api_contracts.md`, `glossary.md`, `runbook.md` | Migrate | `stages/documentation/templates/`, created only when the project needs them | M3 |
| I34 | `templates/change_record.yaml`, `change_record.schema.json` | Migrate | `stages/review/` | M4 |
| I35 | `templates/ui_conventions.md`, `ui_catalog.md` | Later | `ui` stage | M7 |

### Tools

| # | Item | Decision | Target in spec-nx | Spec |
|---|------|----------|-------------------|------|
| I36 | `tools/publish_pr.ps1` (semantic-diff block into an Azure DevOps PR) | Merge | Extend `stages/tools/<host>/update_pr.*` with a second marker block, all hosts and shells | M4 |
| I37 | `tools/render_cards.mjs` (cards → PNG with Playwright) | Later | `stages/review/tools/`, optional (needs Node + Playwright) | — |

### Docs and settings

| # | Item | Decision | Target in spec-nx | Spec |
|---|------|----------|-------------------|------|
| I38 | `how_to.md`, `step_by_step.md` | Merge | Generated `.specs/kit/README.md`: the workflow for the chosen stages, with the commands; the company quick start → the private kit's README | M1, SK |
| I39 | `methodology.md` | Merge | spec-nx README (the idea); no separate methodology file | — |
| I40 | `README.md`, `MIGRATION.md` | Merge / Drop | spec-nx README; spec-kit README rewritten for the new use; `MIGRATION.md` dropped (D11) | SK |
| I41 | `settings.json` (agent permissions: deny commit/push, allow test tools) | Private + Migrate | The company's list → the company layer `agent/`; generated by M9 from the project's tools | SK, M9 |
| I42 | `.specs/decisions/0001–0004` (methodology ADRs) | Merge | Input for M4 / M5 decisions; not copied | M4, M5 |

## Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | **Programming guidelines: yes, in two layers.** spec-nx ships a short **baseline** per language (`stages/guidelines/<lang>.md`: naming, imports, errors, tests, "the linter config is the source of truth"); the generator adapts it into `.specs/kit/guidelines/` (replaced on update). Project rules live in **`.specs/guidelines/<lang>.md`** (project file, P2), created once from a scan and never overwritten; when both exist, the project file wins. | The original `python.md` mixed generic rules with project facts (a library workaround, an experiment-runner script); those must survive updates, the generic rules should improve with spec-nx and the model |
| D2 | **How guidelines are created:** the languages question (Q0b `languages`, D7) selects the baselines; a command `GUIDELINES: <lang>` scans the project (language version, `pyproject.toml` / ruff / eslint / prettier / `.editorconfig`, test layout, how it is run) and writes `.specs/guidelines/<lang>.md` if missing, or proposes a diff if it exists. The `implementation` and `review` stages load the guidelines of the languages the Step touches. | Guidelines are useful only if short and true for the project; a scan keeps them true, the diff keeps the user in control |
| D3 | **No long reference copies** (PEP 8, framework docs): link them; enforce with the project's linter. | Size and copyright; linters check better than prompts |
| D4 | New stages, in Q1 order: `requirements, plan, implementation, documentation, review, pr`, plus **on-demand** stages `improvement`, `setup`, `ui` that can be added to any kit. | Keeps Q1's rules; on-demand stages do not take part in every feature |
| D5 | The original's ADR-0001 rule stays: a code review never fixes out-of-scope findings in place; they go to an improvement spec. | Keeps pull requests small and reviewable |
| D6 | **Q0 · Project start** (key `project`: `"new"` / `"existing"`), asked first. The scan suggests `"new"` when the repository holds nothing but README, LICENSE, `.git*` files, `.specs/` and the spec-nx / spec-kit submodules; the user confirms. | The next questions differ for an empty repository; the scan makes the answer one click |
| D7 | **Q0b · Languages** (key `languages`, e.g. `["python", "typescript"]`). New project: asked openly, suggested from the company layer's defaults (M11) or none. Existing project: suggested from the scan. Selects the guideline baselines (M2) and the stacks offered in Q0c. Replaces the former Q5. | One languages answer serves guidelines and project setup |
| D8 | **Q0c · Project setup spec** (only when `project` is `"new"`; key `project_spec`: the file name, or `false`). Yes → after the kit is generated, the generator asks the framework per language (suggestions from the building block or the layer) and writes `.specs/features/<date>_<name>_project_spec.md` (Part 1 and Part 2) from `stages/setup/project_spec.md`. The first `IMPLEMENT:` builds the scaffold. Any language, not only Python + Svelte. | The original `create_project` was the best start for new work but fixed to one stack. The generator only **creates** this file, never changes an existing spec |
| D9 | **Q1 · Workflow:** two options plus Custom. **Simple** (default, data science) = `requirements, plan, implementation, pr`. **Full** = `requirements, plan, implementation, documentation, review, pr`. **Custom** shows `requirements` as a fixed "yes" and asks one yes / no per stage in Q1 order from `plan` on; a stage whose prerequisite is "no" is not asked. "Requirements only" and the former "Data science" option go away; key `stages` keeps its meaning (P3). | Two clear choices cover most users; yes / no per stage is easier than writing a list |
| D10 | **Company layer** (key `layer`: a path, e.g. `.spec-kit/layer`). An optional folder the generator reads after spec-nx: `defaults.json` (suggested answers), `guidelines/`, `setup/`, `looks/`, `agent/`. Its blocks are adapted like spec-nx's own; layer wins over the spec-nx baseline, the project's `.specs/guidelines/` wins over both. spec-nx contains no company content. | Lets a company keep private rules without forking spec-nx (P7) |
| D11 | **No migration tool.** spec-kit is tagged `legacy-v1` before it changes; projects on the old spec-kit keep their pinned commit. Switching a project = update the `.spec-kit` submodule + `GENERATE KIT`; its old specs and docs stay as they are. | Few projects; switching by hand is cheaper than a tool nobody runs twice |

## Specs to create

In the order to build them (see Phases). **Status:** ⬜ Not created · 📝 Spec created (link) ·
✅ Done · ~~Dropped~~.

| # | Phase | Spec | Covers | Needs | Status |
|---|-------|------|--------|-------|--------|
| M10 | 1 | **generator questions** — Q0 project start, Q0b languages, Q1 Simple / Full / Custom | D6, D7, D9 | — | ⬜ Not created |
| M1 | 1 | **implementation** — the implementation stage, developer skill, closing a spec, kit README | I1, I3, I16, I18, I22, I38 | M10 | ⬜ Not created |
| M2 | 1 | **guidelines** — baseline guidelines, `GUIDELINES:` | I23–I25 | M10, M1 | ⬜ Not created |
| M6 | 1 | **new project** — Q0c and the project setup spec for any language | I11, D8 | M10, M2 | ⬜ Not created |
| M11 | 1 | **company layer** — `layer` key, `defaults.json`, extra blocks | D10 | M2, M6 | ⬜ Not created |
| M3 | 4 | **documentation** — architecture, ADRs and project docs | I4, I5, I17, I31–I33 | M1 | ⬜ Not created |
| M4 | 4 | **review** — semantic diff and code review | I6, I7, I19, I26, I27, I34, I36, I37, I42 | M1, M2 | ⬜ Not created |
| M5 | 4 | **improvement** — hygiene sweep that writes an improvement spec | I8, I20 | M4 | ⬜ Not created |
| M7 | 4 | **ui** — Looks contract, UI catalog, UI designer | I12, I13, I21, I28, I35 | M3, M11 | ⬜ Not created |
| M9 | 4 | **agent permissions** — generate the AI agent's allow / ask / deny list | I41 | M11 | ⬜ Not created |
| M12 | 4 | **setup tooling** — tooling and dev-machine setup specs | I9, I10 | M6 | ⬜ Not created |
| ~~M8~~ | — | ~~**migrate**~~ — dropped 2026-11-13 (D11) | — | — | ~~Dropped~~ |

### M10 — generator questions

- **Goal:** the generator asks first whether the project is new, which languages it uses, and
  offers the workflow as Simple / Full / Custom.
- **Seed statements:** Q0 `project` with the empty-repository scan (D6); Q0b `languages`
  (D7); Q1 options Simple and Full, Custom as one yes / no per stage with the dependency rules
  (D9); the question table, settings example and `--update` (asks only the new keys) updated;
  existing kits with `stages` are not asked Q1 again.
- **Notes:** Q0c belongs to M6, `layer` to M11 — leave the hooks in the question order.

### M1 — implementation

- **Goal:** do a planned spec Step by Step, and close the spec when all Steps are done.
- **Seed statements:** `IMPLEMENT: <spec> [Step n]` does one Step: start time, tasks ticked,
  overview row, Done line with duration and model, one commit message suggested;
  `CLOSE: <spec>` consolidates the spec (what was built vs. planned), ticks the Definition of
  Done and moves it to `done/`; the generator writes `.specs/kit/README.md` with the workflow
  and commands of the chosen stages; the requirements engineer skill gains the original's
  quality checks.
- **Notes:** port `skills/developer.md` and `synthesize_spec.md --close`; loads guidelines once
  M2 exists (leave the hook).

### M2 — guidelines

- **Goal:** short, true coding guidelines per language that survive kit updates (D1–D3).
- **Seed statements:** baselines selected by Q0b `languages` (D7);
  baselines for Python, TypeScript, Svelte, PowerShell, bash; `GUIDELINES: <lang>` creates or
  proposes an update of `.specs/guidelines/<lang>.md`; project file wins over the baseline;
  each file stays under ~100 lines and names the linter config it follows.
- **Notes:** split the original `python.md` / `svelte.md` into generic (baseline, here) and
  company rules (the company layer `guidelines/`, P7).

### M3 — documentation

- **Goal:** keep the project's architecture and decisions up to date with each feature.
- **Seed statements:** `DOCS: <spec>` updates the docs the change affects; `ARCHITECTURE`
  refreshes `.specs/architecture.md` (created once from the template); `ADR: <title>` writes
  `.specs/decisions/NNNN-<slug>.md`, also from a plan decision `D<n>`; data model, API
  contracts, glossary, runbooks only when the project has or wants them.

### M4 — review

- **Goal:** what a reviewer reads first, published into the pull request.
- **Seed statements:** `REVIEW: <spec>` builds the change record (objects Before | After, linked
  to `S<n>`) and the review page; the pr tools publish it in a `semantic-diff` marker block on
  both hosts and shells; `CODE REVIEW: <spec>` runs the layered review, logs findings in the
  Review Log with the model, and sends out-of-scope findings to `improvement` (D5); card images
  are optional.
- **Notes:** the largest item — consider splitting into review page / code review.

### M5 — improvement

- **Goal:** a hygiene sweep after merges that never changes behaviour.
- **Seed statements:** `IMPROVE: <scope>` writes a normal spec (Part 1 + Part 2) with only
  structure, consistency and doc tasks; `--dry-run` lists findings only.

### M6 — new project

- **Goal:** an empty repository gets, together with its kit, a spec that builds the project's
  skeleton in the chosen languages.
- **Seed statements:** Q0c `project_spec` (D8); building block `stages/setup/project_spec.md`
  with, per language, the questions to ask (framework, package manager, test runner) and
  what Step 0 creates (build file, entry point, one passing test, run / check scripts for the
  developer's shell, README); the written spec has Part 1 and Part 2 and a Stage log row; the
  generator never overwrites an existing spec; the stack suggestions come from the layer when
  there is one (M11).
- **Notes:** port `create_project.md` without its fixed stack; its Python + SvelteKit stack is
  an example of a company layer `setup/`.

### M11 — company layer

- **Goal:** a company keeps its own defaults and rules next to spec-nx without forking it.
- **Seed statements:** key `layer` (path), suggested when a folder with a `layer.json`
  marker is found (e.g. `.spec-kit/layer/`); `defaults.json` pre-fills the suggestions of any
  question; `guidelines/`, `setup/`, `looks/`, `agent/` blocks are adapted into the kit;
  priority project > layer > spec-nx; the report names what came from the layer; `--update`
  re-reads the layer.
- **Notes:** document the layer format in the spec-nx README with a tiny generic example
  (no company content).

### M12 — setup tooling

- **Goal:** bring a project's tooling or the developer's machine up to date — each as a
  normal spec.
- **Seed statements:** `SETUP TOOLING: <scope>`; `SETUP MACHINE` (installs only what is
  missing).

### M7 — ui

- **Goal:** consistent styles and a living UI catalog for projects with a UI.
- **Seed statements:** Looks contract as a building block; `LOOK: <app>`; `UI CATALOG`;
  brand values stay in the company layer or the project (`.specs/ui/`).

### M9 — agent permissions

- **Goal:** the AI agent may run tests and linters but asks before deleting and never commits
  or pushes.
- **Seed statements:** question (which agent: Claude Code, VS Code Copilot, none); permissions
  from the project's tools; written as a project file (P2); a layer's `agent/` block is the
  starting point.

## Open questions

_None open._ Answered on 2026-11-13:

- **D1–D11:** agreed, including `.specs/guidelines/` and the on-demand stages `improvement`,
  `setup`, `ui`.
- **D9, Custom:** `requirements` stays always in the kit; Custom shows it as a fixed "yes" and
  asks from `plan` on.
- **D9, Simple:** includes `implementation` — the Steps' Done lines and the spec closing are
  what keeps the spec true.
- **Phases:** phases 1 and 4 are built together in one spec (all M items), so the code review
  and the semantic diff exist before the switch.
- **M4:** the change record, a Markdown review page and the pull-request block first; the HTML
  page and the card images (I37) are deferred.
- **M9:** in scope.
