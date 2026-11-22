### Semantic diff
Settings in three layers, work-item fields, a prompt log and the cost of one chat only · checks 6 pass · 2 n/a · 1 fail · findings 7 (3 fixed)

**Review here first:** [review page](https://github.com/martinnordio/spec-nx/raw/feature/settings-layers-and-prompt-log/.specs/review/2026-11-22_feature-settings-layers-and-prompt-log.html) — download it and open it in a browser ([all review pages](https://github.com/martinnordio/spec-nx/raw/feature/settings-layers-and-prompt-log/.specs/review/index.html))

| Kind | Object | Change | Statements |
|------|--------|--------|------------|
| config | `generator/questions.md — where the settings come from` | modified | S1, S2, S3, S6 |
| command | `stages/tools/settings.ps1 / settings.sh` | added | S1, S2, S3, S5 |
| command | `Settings section of every stage prompt` | modified | S4, S5, S12, S18 |
| data-format | `.specs/spec-nx.json keys work_items, parent, prompt_log` | modified | S7, S8, S9, S10, S12 |
| command | `stages/tools/azure_devops/create_issue.ps1 / .sh` | modified | S7, S8, S11 |
| command | `stages/tools/github/create_issue.ps1 / .sh` | modified | S8, S9, S10, S11 |
| data-format | `.specs/prompts/<yyyy_mm_dd>_<name>_prompt.md and <yyyy_mm_dd>_other_prompt.md` | added | S12, S13, S14, S15, S16, S17 |
| command | `stages/tools/usage.ps1 / .sh` | modified | S18, S19, S21 |
| output | `stages/tools/costs_ledger.ps1 / .sh → .specs/costs.md` | modified | S22, S23 |
| message | `README.md — Make it yours, and docs/customize.md` | modified | S25, S26, S27 |

**Top findings:** (1) Should-fix — `usage -Run` matched a marker as a prefix — fixed; (2) Should-fix — `-Run` shifted positional parameters — fixed; (7) Should-fix — `GENERATE KIT` not yet run end to end with the new settings — the next kit regeneration.
