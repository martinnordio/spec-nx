# .specs — spec-nx's own specs

spec-nx is built with spec-nx. Every change starts as a spec here, written with the template
[stages/spec_template.md](../stages/spec_template.md): Part 1 (requirements) first, then
Part 2 (plan), then the Steps, one commit each, and one pull request per spec.

## Layout

```
.specs/
  features/              open specs
  features/done/         closed specs (moved here when the spec is closed)
  changes/done/          semantic diffs (review stage) of closed specs: record, Before / After, review page
```

## Naming

`yyyy_mm_dd_<name>_spec.md`, where the date is the day the spec was **created**.

- Files sort by start date in any file browser.
- The name never changes, also when the spec moves to `done/`, so links stay stable.
- `<name>` is short, lowercase, words joined by `_` (e.g. `2026_11_06_pr_loop_spec.md`).
