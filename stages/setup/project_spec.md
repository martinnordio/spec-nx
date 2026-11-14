# Project setup spec (building block)

Used by the generator (Q0c) for a **new, empty** project: it writes the project's first spec,
whose Steps build a skeleton that runs and has one passing test. The spec is a normal spec —
`PLAN:` can revise it and `IMPLEMENT:` builds it.

## 1 · Ask per language

For each language in `languages`, ask in **one** short message, with a suggestion for each
item. Suggestions come from the company layer's `setup/` if there is one, otherwise from the
table below. The user may answer "your suggestion".

| Language | Kind of project (ask first) | Framework | Package manager | Tests | Lint / format |
|----------|-----------------------------|-----------|-----------------|-------|---------------|
| python | library, command-line tool, web API, notebooks / data analysis | none · Typer (CLI) · FastAPI (API) · Jupyter (data) | uv | pytest | ruff (+ mypy) |
| typescript | library, command-line tool, web app, API | none · SvelteKit / React + Vite (web) · Node (API) | pnpm | Vitest (+ Playwright for a web app) | ESLint + Prettier |
| svelte | web app (with `typescript`) | SvelteKit 2 + Svelte 5 | pnpm | Vitest + Playwright | ESLint + Prettier + svelte-check |
| powershell | scripts, module | none | — | Pester | PSScriptAnalyzer |
| bash | scripts | none | — | bats | ShellCheck |
| other | ask | ask | ask | ask | ask |

Also ask once: **the name** of the project, **what it should do** (one or two sentences), and
**where** the code goes (default: the repository root; for several parts, one folder each,
e.g. `server/` and `ui/`).

## 2 · Write the spec

File `.specs/features/<yyyy_mm_dd>_<name>_project_spec.md` from the kit's `spec_template.md`.
If the file exists, stop and say so.

**Header:** Author (`git config user.name`), Status `⬜ Not started — plan ready`, Created and
Last updated today, Branch `feature/<name>-setup`. **Stage log:** two rows, today,
`requirements` and `plan`, command `GENERATE KIT` (Q0c), your model (the model that runs the
generator now, as your runtime reports it — not copied from the settings), `project setup spec`.

**Part 1 · Requirements**

- **Context:** what the project should do, in the user's words; "a new, empty repository".
- **Already in the repository:** README, LICENSE, `.specs/` — whatever the scan found.
- **Statements** — one per part (for example server and UI), plus the shared ones:
  - **S1 — It runs:** one documented command starts each part (name the observable result:
    "prints the help", "answers `/health` with `ok`", "shows the start page").
  - **S2 — It is tested:** one documented command runs the tests; at least one test passes.
  - **S3 — It is checked:** one documented command runs the linter / formatter / type
    checker without errors.
  - **S4 — It installs from scratch:** a new developer gets it running by following the
    README only; dependency versions are pinned by a lock file.
  - **S5 —** one statement per thing the user said the project should do, if any (these are
    usually left for the next spec — say so).
- **Open questions:** none if the answers above are complete.

**Part 2 · Plan**

- **Decisions:** one per choice made in section 1 (framework, package manager, test runner,
  linter, folder layout), with "chosen at project start" or the user's reason.
- **Steps**, one per part, then the glue:
  - **Step 0 — <part> skeleton:** build file (`pyproject.toml`, `package.json`, …) with the
    chosen tools, the entry point, one passing test, linter configuration; check: the run,
    test and lint commands pass.
  - **Step 1 … — next part**, the same way (for example the UI calling the server's health
    endpoint, with one end-to-end test).
  - **Last Step — glue:** `README.md` (install, run, test, check — for each part), a run
    script for the developer's shell if there are several parts, `.gitignore` for the tools
    used; check: a fresh clone works by following the README.
- **Deferred Items:** the features the user described, with target "next spec".
- **Definition of Done:** the lines for the kit's `stages`.

## 3 · Rules

- Write the spec only; do not install tools, create files outside `.specs/`, or create the
  branch.
- Do not pin versions in the spec text: the lock files decide.
- Never put the project's code inside a submodule (`.spec-nx/` or a company kit).
