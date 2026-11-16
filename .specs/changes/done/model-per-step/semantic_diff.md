### Semantic diff
Model per stage and Step, tokens and cost of every stage; nothing changes without the new settings · checks 6 pass · 2 n/a · 1 fail · findings 6 (1 fixed)

**Review here first:** [review page](https://github.com/martinnordio/spec-nx/raw/feature/model-per-step/.specs/review/2026-11-16_feature-model-per-step.html) — download it and open it in a browser ([all review pages](https://github.com/martinnordio/spec-nx/raw/feature/model-per-step/.specs/review/index.html))

| Kind | Object | Change | Statements |
|------|--------|--------|------------|
| config | Setup question Q7 *Model per Step* | modified | S1, S2, S7 |
| data-format | `.specs/spec-nx.json`: `models`, `cost` | modified | S3, S18 |
| config | `models.md`: model per stage, check, sub-agent, missing model | added | S5, S7, S9, S10 |
| command | Model name section of every stage prompt | modified | S5, S13, S20 |
| data-format | Spec Overview: **Model (suggested)** | modified | S4, S8 |
| data-format | Stage log: **Tokens**, **Cost** | modified | S13, S14, S20 |
| command | `IMPLEMENT:` Per-Step run | added | S6, S8, S10 |
| command | `CLOSE:` cost summary + ledger | modified | S17, S21 |
| output | `usage.ps1` / `.sh` | added | S13–S16 |
| output | `costs_ledger.ps1` / `.sh` → `.specs/costs.md` | added | S21 |
| message | `COSTS.md` disclaimer | added | S19, S20 |
| data-format | `.specs/kit/`: `models.md`, `COSTS.md`, scripts | modified | S12, S19 |
| message | README: the feature at the top | modified | S11 |
| data-format | Issue / pull-request summary: `## Cost summary` before the plan | modified | S23 |

**Top findings:** (1) Should-fix — VS Code transcript discovery is not per workspace (deferred); (2) Should-fix — `GENERATE KIT` with Q7 / cost not run end to end (deferred); (3) Nit — no committed tests for the new scripts (C7, deferred).
