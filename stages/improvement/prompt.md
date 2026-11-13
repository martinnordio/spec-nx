# Stage: Improvement (on demand)

A **clean-up sweep** after some features are merged: find what drifted — structure,
conventions, documents, dead code, missing decisions — and write it as a **normal spec** whose
Steps change nothing a user or a caller can observe.

## Command

```
IMPROVE: <scope> [--dry-run]
```
`<scope>` is a folder, a module, or `all`. Writes `.specs/features/<yyyy_mm_dd>_<scope>_improvement_spec.md`.
With `--dry-run`, only shows the findings table and writes nothing.

The review stage sends out-of-scope findings here (`CODE REVIEW:` → target `IMPROVE:`).

## Skills to load

Always: `../skills/refactorer.md`. Also `../skills/architect.md` when the scope has an
architecture document or decision records.

## Files this stage uses

Paths are relative to this file, so they work both inside spec-nx (`stages/improvement/`) and
in a generated kit (`.specs/kit/improvement/`).

| File | Use |
|------|-----|
| `../skills/refactorer.md` | Your role in this stage |
| `../spec_template.md` | Shape of the improvement spec |
| `../guidelines/<language>.md`, `.specs/guidelines/<language>.md` | Conventions to check against |
| `.specs/architecture.md`, `.specs/decisions/`, `.specs/glossary.md`, `.specs/data_model.md`, `.specs/api_contracts.md`, `.specs/ui/` | The documents to check, when the project has them |
| Review Logs of specs in `.specs/features/` and `done/` | Findings sent here by `CODE REVIEW:` |

---

## IMPROVE

1. **Read the scope** and the project documents above that exist.

2. **Look for findings**, class by class:

   | Class | Look for |
   |-------|----------|
   | architecture | Folders and modules that differ from `.specs/architecture.md` |
   | guideline | Code that breaks the guidelines (naming, types, errors, missing tests) |
   | ui | Screens that bypass design tokens or are missing from the UI catalog |
   | adr-gap | Decisions visible in the code (framework, external service, data format) without an ADR |
   | glossary | Domain words missing from, or stale in, the glossary |
   | data-api | Stored shapes or interfaces that differ from the data model / API contracts |
   | dead-code | Unused code, imports, files; circular imports; untested public interfaces |
   | docs | README, runbooks or documents that no longer match |
   | review | Open out-of-scope findings in Review Logs |

   Check before calling code dead: tests, scripts, dynamic imports and configuration may use
   it.

3. **Sort the findings out.** A finding that would change behaviour (output, interface,
   stored data, error handling) does **not** belong here: list it under **Deferred Items** with
   target "new spec" and leave it out of the Steps.

4. **Rank** by impact (High / Medium / Low) divided by cost (High / Medium / Low), highest
   first. With `--dry-run`, show the table and stop.

5. **Write the spec** from `../spec_template.md` (header Status `⬜ Not started — plan ready`,
   Branch `feature/<scope>-improvement`, Stage log rows for `requirements` and `plan`, command
   `IMPROVE:`, your model):
   - **Part 1:** Context (scope, why now); one statement per class with findings, phrased as
     the state after the clean-up (`**S1 — Architecture matches:** …`), plus always
     **`S<n> — Behaviour unchanged:** all existing tests pass, and no output, interface or
     stored data changes.`
   - **Part 2:** the ranked findings table first; then one Step per class (each fits one
     working session; split bigger ones), each ending with "all tests pass"; Deferred Items
     for the behaviour changes; Definition of Done.

6. **Report:** the spec, the top three findings, the ADRs to write (`ADR:`), and the next step
   `IMPLEMENT: <spec>`.

## Never

- Put a behaviour change into an improvement spec — not even a "small" one.
- Change code: this stage only writes the spec.
- Rename or move public names without saying who calls them.
