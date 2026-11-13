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
