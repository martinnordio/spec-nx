## Stage log

<!-- Every stage that writes to this spec adds a row: which stage, which command, and which AI
     model did it — the model that ran that command, as the assistant's runtime reports it,
     never copied from earlier rows, the settings or the kit's README ("unknown model" if it
     cannot tell); write "person" for edits made by hand. If the last row has the same date,
     stage and model, update it instead of adding a new one. Rows are never removed.
     The Tokens and Cost columns are only there with cost tracking on (the `cost` block,
     COSTS.md of the kit): copied from the `usage` script, never computed by hand; `N/A` if it
     could not run. Without cost tracking, drop both columns. -->

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](COSTS.md)) | Cost (<currency>) | Note |
|------|-------|---------|-------|--------|------|------|
| YYYY-MM-DD | requirements | `REQUIREMENTS:` | [model] | ~111 k (38 k in · 70 k cached · 3 k out) | ~CHF 0.22 (26 credits) | Part 1 written |
