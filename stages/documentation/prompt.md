# Stage: Documentation

Keep the project's documents true after each change: README and usage, the architecture, the
decision records (ADRs), and — only when the project has or wants them — data model, API
contracts, glossary and runbooks.

## Commands

```
DOCS: <spec file>
```
Updates the documents the spec's change affects. Run it after the last Step, before `CLOSE`.

```
ARCHITECTURE
```
Creates `.specs/architecture.md` from the template, or refreshes it against the code.

```
ADR: <title> [— from <spec file> D<n>]
```
Writes the next decision record `.specs/decisions/NNNN-<slug>.md`, optionally from a plan
decision.

## Skills to load

Always: `../skills/architect.md` — the role you take in this stage.

## Model name

Wherever this prompt says *your model*, write the name of the model that runs this command
now, as your runtime reports it. Never copy it from earlier rows, from `.specs/spec-nx.json`
(its `model` is the model that generated the kit), from the kit's README or from examples. If
you cannot tell, ask the user once; otherwise write `unknown model`.

## Files this stage uses

Paths are relative to this file, so they work both inside spec-nx (`stages/documentation/`)
and in a generated kit (`.specs/kit/documentation/`).

| File | Use |
|------|-----|
| `templates/architecture.md` | Shape of `.specs/architecture.md` |
| `templates/adr.md` | Shape of `.specs/decisions/NNNN-<slug>.md` |
| `templates/data_model.md`, `templates/api_contracts.md`, `templates/glossary.md`, `templates/runbook.md` | Shapes of the optional documents in `.specs/` (`runbooks/<name>.md` for runbooks) |

**Project documents** (`README.md`, `.specs/architecture.md`, `.specs/decisions/`,
`.specs/data_model.md`, `.specs/api_contracts.md`, `.specs/glossary.md`, `.specs/runbooks/`)
belong to the project: create them from a template when they are missing and needed; when they
exist, change only what the code now contradicts, and show the diff.

---

## DOCS

1. **Find what changed.** Read the spec (statements, Steps, decisions, Closing summary if any)
   and the branch's changes (`git diff <default branch>...HEAD --stat`, then the files).
2. **List the affected documents**, one line each with the reason:
   - `README.md` / usage docs — a command, option, setup step or output changed;
   - `.specs/architecture.md` — a module was added, removed or moved, a boundary or the data
     flow changed, an external dependency was added (run `ARCHITECTURE` for it);
   - an ADR — a plan decision changes a boundary, adds an external dependency, picks a
     storage or transport, or constrains later work (offer `ADR: … — from <spec> D<n>`);
   - `.specs/data_model.md`, `.specs/api_contracts.md`, `.specs/glossary.md`, a runbook — only
     if the project has the document, or the change creates the need (offer to create it).
3. **Update them**, keeping each document's own style. Show a short summary per file.
4. **In the spec:** tick the *Documentation* line of the Definition of Done, add a **Stage
   log** row (today, `documentation`, `DOCS:`, your model, the documents updated), update
   **Last updated**.

## ARCHITECTURE

1. **Read the code**: folders, entry points, build files, how parts call each other, what is
   stored and where, external services.
2. **Missing document:** create `.specs/architecture.md` from `templates/architecture.md`,
   filled from what you read; leave out sections that do not apply.
3. **Existing document:** compare each section with the code; propose the changes (modules
   added or removed, wrong paths, outdated diagram); apply what the user accepts.
4. Add a line to its **Change log** (date, what changed, link to the spec or ADR) and set
   **Last updated**. Flag languages that have no guideline (`GUIDELINES: <language>`).

## ADR

1. **Number:** the highest `NNNN` in `.specs/decisions/` plus one, four digits (`0001` if
   none). Never reuse or accept a number from the user.
2. **Slug:** the title in lower case, words joined by `-`, at most ~50 characters.
3. **From a plan decision** (`— from <spec> D<n>`): take the context and the reason from the
   spec; link the ADR in the decision's row, and the spec in the ADR.
4. **Fill** `templates/adr.md`: Status `Proposed`, today, the deciders (the user, others they
   name), context, the decision in one sentence, consequences (positive, negative), at least
   two alternatives with the reason they were not chosen (one may be "do nothing").
5. A decision that replaces an older one: set the old ADR's status to
   `Superseded by ADR-NNNN` and link both ways. Never delete an ADR.
6. **Report** the file and remind the user to set **Accepted** once agreed.

## Never

- Overwrite a project document without showing the change.
- Document what the code does not do (plans belong in specs).
- Create optional documents the project does not need.
