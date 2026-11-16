# Example: the Angular tutorial

The two specs that spec-nx wrote during one run of the [Angular tutorial](../../docs/tutorials/angular.md)
on 2026-11-16, copied unchanged (only the links to `COSTS.md` point to spec-nx's own copy). The
app's code is not here — the specs are the point: what was asked, how it was planned, what was
built, with which model and at what cost.

| File | What it is |
|------|------------|
| [2026_11_16_spec_nx_kit_spec.md](2026_11_16_spec_nx_kit_spec.md) | Written by `GENERATE KIT`: the settings it chose (S1–S11) and what setting up the kit cost |
| [2026_11_16_hero_list_spec.md](2026_11_16_hero_list_spec.md) | The feature: requirements, plan, four Steps, the closing summary and the cost summary |
| [spec-nx.json](spec-nx.json) | The project settings the run used |

## What to look at in the hero list spec

- **Part 1 · Requirements** — the one-paragraph request became 9 testable statements; the
  assistant's open questions, answered with its suggestions, added S10–S15 (heading, the ten
  heroes, the empty-name rule, length, no saving, selection).
- **Already in the repository** — the requirements stage read the starter app first and noted
  what the feature replaces (the placeholder page and its test).
- **Part 2 · Plan** — four small Steps, decisions D1–D7, and a **Model (suggested)** column:
  Sonnet for the three code Steps, Haiku for the final check and README.
- **Each Step's Done line** — what was done, the checks and their result (`ng test`: 4, then
  11, then 19 tests), the model suggested and the model that ran, and its tokens and cost.
- **Closing summary** — what was built, and honestly what differs from the plan: the
  `ng serve` walkthrough was replaced by tests, and which statements have no direct test.
- **Stage log and Cost summary** — every stage with its model, tokens and cost; the
  implementation split by Step.

## What it cost

| | Tokens | Cost | Share of Copilot Business |
|---|---|---|---|
| Setting up the kit (`GENERATE KIT`) | ~1.43 M | ~CHF 0.96 (114 credits) | 6.0 % |
| The feature: requirements, plan, 4 Steps, close | ~8.30 M | ~CHF 1.08 (130 credits) | 6.8 % |
| **Together** | **~9.73 M** | **~CHF 2.04 (244 credits)** | **12.8 %** |

The Haiku Step cost ~CHF 0.01 for ~1.29 M tokens; the Sonnet Steps ~CHF 0.12–0.24 each.
**All costs are estimates and may be wrong** — see [COSTS.md](../../stages/COSTS.md).
