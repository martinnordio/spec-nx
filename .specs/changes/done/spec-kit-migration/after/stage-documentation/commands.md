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
