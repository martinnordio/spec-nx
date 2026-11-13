# Stage: Setup (on demand)

Bring a project's **tooling** or a developer's **computer** up to date — each as a normal spec
whose Steps change configuration and installed tools only, never application behaviour.

A new, empty project gets its first spec from the generator instead (Q0c,
`project_spec.md` in this folder).

## Commands

```
SETUP TOOLING: <scope> [--dry-run]
```
Audits the tooling of `<scope>` (a folder, or `all`) and writes
`.specs/features/<yyyy_mm_dd>_<scope>_tooling_spec.md`.

```
SETUP MACHINE [--dry-run]
```
Compares what the project needs with what this computer has, and writes
`.specs/features/<yyyy_mm_dd>_machine_setup_spec.md` that installs **only what is missing**.

With `--dry-run`, both only show the findings and write nothing.

## Skills to load

Always: `../skills/architect.md`. Also `../skills/developer.md` for `SETUP MACHINE`.

## Files this stage uses

Paths are relative to this file, so they work both inside spec-nx (`stages/setup/`) and in a
generated kit (`.specs/kit/setup/`).

| File | Use |
|------|-----|
| `../spec_template.md` | Shape of the spec |
| `../guidelines/<language>.md` | The tools each language's baseline expects (linter, tests) |
| `.specs/spec-nx.json`, `.specs/spec-nx.local.json` | `languages`, `shell` |

---

## Detect first (both commands)

Never assume a stack. Read: runtime versions (`.python-version`, `requires-python`, `.nvmrc`,
`engines`, `global.json`, `go.mod`), package managers and lock files, editor configuration
(`.vscode/`, `.idea/`, `.editorconfig`), CI (`.github/workflows/`, `azure-pipelines.yml`,
`.gitlab-ci.yml`), existing run / check / install scripts, and how each part is tested. Put
the result as a table at the top of the spec's Context.

## SETUP TOOLING

1. **Check the baseline**, mapped to the tools of the detected stack:

   | # | Check |
   |---|-------|
   | T1 | Runtime version pinned in the repository |
   | T2 | `.editorconfig` at the root |
   | T3 | Formatter configured in the repository |
   | T4 | Linter configured in the repository |
   | T5 | Type checker in its strictest workable mode, where the language has one |
   | T6 | Test runner and at least one test that starts the program |
   | T7 | A package manager with a committed lock file |
   | T8 | One command each to install, run, test and check, written in the README |
   | T9 | Recommended editor extensions and settings committed (e.g. `.vscode/extensions.json`) |
   | T10 | CI runs the checks and the tests on every pull request |
   | T11 | `.gitignore` covers the tools' outputs, environments and secrets files |

2. **Findings:** each failed check, with impact ÷ cost.
3. **Write the spec:** statements per check that fails (`**S1 — Formatter:** one command
   formats the code the same way for everyone`), plus **`S<n> — Behaviour unchanged:** all
   tests pass before and after`. One Step per group of checks; each Step ends with the
   project's checks and tests passing. A new tool is a decision row.

## SETUP MACHINE

1. **What the project needs:** the tools and versions from *Detect first*, and the editor
   extensions it recommends.
2. **What this computer has:** run each tool's version command (`python --version`,
   `node --version`, `uv --version`, `git --version`, …) and list the editor's extensions
   if its command line is available. Note the operating system and the shell.
3. **The gap:** only what is missing or older than required.
4. **Write the spec:** Context with the needs / has / gap table; statements **S1** every
   tool the project needs is installed in the required version, **S2** the project's install,
   run and test commands work on this computer, **S3** nothing that was already installed is
   changed; one Step per missing group, with the install command for the operating system
   (e.g. `winget`, `brew`, `apt`) — never a password or token in the spec; the last Step runs
   the project's commands as the check.

## Never

- Change application code or behaviour.
- Install or upgrade anything while writing the spec — the spec's Steps do that, with the
  user.
- Put secrets, tokens or personal data in a spec.
