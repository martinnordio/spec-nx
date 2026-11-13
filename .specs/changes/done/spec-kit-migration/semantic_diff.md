### Semantic diff
New stages, questions, company layer and agent permissions; nothing existing changes meaning · checks 4 pass · 4 n/a · 1 fail · findings 4

**Review here first:** [review page](https://github.com/martinnordio/spec-nx/raw/feature/spec-kit-migration/.specs/review/2026-11-13_feature-spec-kit-migration.html) — download it and open it in a browser ([all review pages](https://github.com/martinnordio/spec-nx/raw/feature/spec-kit-migration/.specs/review/index.html))

| Kind | Object | Change | Statements |
|------|--------|--------|------------|
| config | Setup questions: Q5, Q0, Q0b, Q0c, Q1b, Q6 | modified | S1, S6, S7, S12 |
| config | Q1: Simple / Full / Custom | modified | S1 |
| data-format | `.specs/spec-nx.json`: `layer`, `project`, `languages`, `on_demand`, `agent` | modified | S1, S7, S12 |
| data-format | `.specs/kit/`: `README.md`, `guidelines/` | modified | S4, S5 |
| command | `IMPLEMENT:`, `CLOSE:` | added | S2, S3 |
| command | `GUIDELINES:` | added | S5 |
| command | `DOCS:`, `ARCHITECTURE`, `ADR:` | added | S8 |
| command | `REVIEW:`, `CODE REVIEW:` | added | S9 |
| command | `IMPROVE:`, `SETUP TOOLING:`, `SETUP MACHINE`, `LOOK:`, `UI CATALOG` | added | S10, S11, S13 |
| command | `update_pr` (4 scripts): optional semantic-diff file | modified | S9, S14 |
| data-format | Pull-request description: `semantic-diff` block | modified | S9 |
| data-format | HTML review pages in `.specs/review/` + `index.html` | added | S17 |
| command | `CREATE ISSUE:` (optional parent) + `create_issue` scripts | added | S18, S19 |
| data-format | Commit message: always the `#<n>` / `AB#<id>` reference | added | S20 |

**Top findings:** (1) Should-fix — `GENERATE KIT` with the new questions not yet tried end to end in a scratch project (deferred); (2) Nit — no committed tests for the changed scripts (C7, deferred); (3) Nit — placeholder links in templates.
