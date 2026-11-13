## Command

```
IMPROVE: <scope> [--dry-run]
```
`<scope>` is a folder, a module, or `all`. Writes `.specs/features/<yyyy_mm_dd>_<scope>_improvement_spec.md`.
With `--dry-run`, only shows the findings table and writes nothing.

The review stage sends out-of-scope findings here (`CODE REVIEW:` → target `IMPROVE:`).
