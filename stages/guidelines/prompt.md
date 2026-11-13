# Guidelines

Short coding rules per language, in two layers:

| Layer | Where | Owned by | On `GENERATE KIT --update` |
|-------|-------|----------|----------------------------|
| **Baseline** | `.specs/kit/guidelines/<language>.md` (from spec-nx, or a company layer) | the generator | replaced |
| **Project** | `.specs/guidelines/<language>.md` | the project | never touched |

When both say something different, the **project** file wins; a company layer's guideline
wins over the spec-nx baseline. The project's linter and formatter configuration wins over
everything written here — guidelines never repeat what a linter already checks.

## Command

```
GUIDELINES: <language>
```
Writes `.specs/guidelines/<language>.md` for this project, or proposes changes to it.

## Skills to load

None.

## Files this stage uses

Paths are relative to this file, so they work both inside spec-nx (`stages/guidelines/`) and
in a generated kit (`.specs/kit/guidelines/`).

| File | Use |
|------|-----|
| `<language>.md` (next to this file) | The baseline for the language |
| `.specs/guidelines/<language>.md` | The project's rules, if they exist |
| `.specs/spec-nx.json` | `languages` |

---

## GUIDELINES

1. **Scan the project** for the language:
   - its version (`pyproject.toml` `requires-python`, `.python-version`, `package.json`
     `engines`, `tsconfig.json` `target`, `#Requires -Version`);
   - linter, formatter and type-checker configuration (ruff, black, mypy, eslint, prettier,
     PSScriptAnalyzer, shellcheck, `.editorconfig`) and the rules they set;
   - where tests live, how they are named and how they are run;
   - how the code is run (README, scripts, entry points);
   - patterns the code follows consistently (folders, naming, error handling, logging).

2. **Write only what is true and not already enforced.** Each rule must be either checked in
   the code (it is already followed) or decided by the user. Do not copy the baseline: the
   project file holds only what is **specific** to the project or **differs** from the
   baseline. Keep it under ~60 lines, in this shape:

   ```
   # <Language> — project rules

   > Baseline: .specs/kit/guidelines/<language>.md · Linter: <file> · Updated: YYYY-MM-DD

   ## Environment       version, how to install, how to run
   ## Tests             where, naming, command
   ## Rules             only project-specific rules and differences from the baseline
   ## Known issues      workarounds the code depends on, with the reason
   ```

3. **New file:** create `.specs/guidelines/<language>.md` and show it.
   **Existing file:** never overwrite it. Show a diff of what you would add, change or remove,
   with one line of reason each, and apply only what the user accepts.

4. **Report** the file, what came from the scan, and which rules need the user's decision.

## Never

- Copy long reference texts (style guides, framework docs) — link them.
- Write a rule the linter configuration already enforces, or one that contradicts it.
- Overwrite `.specs/guidelines/` without the user's consent.
