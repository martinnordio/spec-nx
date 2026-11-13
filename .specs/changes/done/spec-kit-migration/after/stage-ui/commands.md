## Commands

```
LOOK: <app> [--looks <name>,<name>] [--logo <path|none>] [--dry-run]
```
Audits the app's styling against the Looks contract and writes a **look spec**
(`.specs/features/<yyyy_mm_dd>_<app>_look_spec.md`). With `--dry-run`, only the findings.

```
UI CATALOG [<folder>]
```
Creates or refreshes `.specs/ui/catalog.md` from the UI source.
