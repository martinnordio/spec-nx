# The Right Model and Cost for Each Step Spec

> **Author:** Martin Nordio
> **Status:** ⬜ Requirements in progress
> **Created:** 2026-11-14
> **Last updated:** 2026-11-14
> **Branch:** `feature/model-per-step`
> **Issue:** #5

## Stage log

| Date | Stage | Command | Model | Tokens — estimate, see [COSTS.md](../../COSTS.md) | Note |
|------|-------|---------|-------|--------|------|
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | ~111 k (38 k in · 70 k cached · 3 k out) | Part 1 written |
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | ~379 k (40 k in · 334 k cached · 5 k out) | Full process chosen; tokens and cost added (S13–S18) |
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | ~132 k (4 k in · 126 k cached · 2 k out) | Q1–Q3 answered: one spec `v0.4.0`, `~` estimates, plan in default settings |
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | ~289 k (5 k in · 282 k cached · 2 k out) | COSTS.md, disclaimer, publishing in public repos (S19–S21) |
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | ~101 k so far (2 k in · 99 k cached · 1 k out) | Cost ledgers (S22–S23), POC numbers (S24), hack_star reminder |
| 2026-11-14 | requirements | `CREATE ISSUE:` | Claude Opus 5.5 | counted in the row above | issue #5 created; default `publish: tokens` |
| 2026-11-16 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | not yet counted | Default models (S2), task-based tiers (S4), Cost summary (S17), CHF, missing settings = off (S18) |
| 2026-11-16 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | not yet counted | Simplified: one `cost.enabled` switch, one ledger, CHF rate 0.8384 (S13–S22) |
| 2026-11-16 | requirements | `UPDATE ISSUE:` | Claude Opus 5.5 | not yet counted | issue #5 updated |

> POC: numbers estimated by hand from the VS Code transcript (characters ÷ 4, ~35 k tokens of
> system prompt and summary per request, earlier context counted as cached). The design talk
> before Part 1 was not counted. Requirements so far: **~1.0 M tokens**.

---

# Part 1 · Requirements

## Context

Strong models are needed for requirements, plans and hard Steps; routine Steps can run on
cheaper, faster models. Today the whole spec runs on whatever model the chat has, and switching
by hand per Step is easy to forget. spec-nx lets a project choose: a suggested model per Step
that implementation switches to by itself, one fixed model for everything, or no model handling
at all — and it records which model actually ran each Step.

**Already in the repository:**
- `generator/questions.md` (Q0–Q6, settings files), `generator/prompt.md`.
- `stages/plan/prompt.md` writes the Step table (**2 · Spec Overview**); `stages/spec_template.md`
  defines it, the Done line and the Stage log.
- `stages/implementation/prompt.md`: one Step per `IMPLEMENT:`, the user commits.
- Every stage prompt has the **Model name** rule (v0.3.3): logs name the model of the run.
- `stages/agent/permissions.md` decides whether the agent may commit.
- `README.md` lists the features under *Why spec-nx*.

**New:** model tiers per Step, a setup question, sub-agent runs on a chosen model, model checks
at the start of stages, tracking of suggested vs. actual model.

## 1 · Specs

- **S1 — Setup question:** `GENERATE KIT` asks *"Should spec-nx choose the model?"* with three
  answers: **per Step** (with the assistant's suggested mapping, or the user's own),
  **fixed** (one model for everything) or **no** (always the model selected in the tool).
  Existing projects get the question on their next `GENERATE KIT --update`; until then they
  behave as **no**.
- **S2 — Suggesting the models:** for **per Step**, the assistant proposes the defaults —
  **reasoning** Claude Opus 5.5, **standard** Claude Sonnet 5.5, **light** Claude Haiku 5.5 (the
  cheapest in the model picker, 40× cheaper output than Opus 5.5; GPT-6 Luna costs the same).
  Where the tool shows its model list (VS Code Copilot), it checks that each default is enabled
  and offers the nearest enabled one otherwise; elsewhere it asks for the exact names from the
  model picker (for Claude Code: the `opus` / `sonnet` / `haiku` aliases). The user confirms or
  changes each one.
- **S3 — Saved per project, overridable per developer:** the answer is saved in
  `.specs/spec-nx.json` (`models`: the three tiers, one fixed model, or `null`); a developer can
  override names in `.specs/spec-nx.local.json` (for example when their licence lacks a model),
  or set `models: null` there to always use the model selected in their tool, whatever the team
  chose.
- **S4 — Tier per Step in the plan:** with **per Step**, `PLAN:` gives every Step a tier and a
  reason of a few words in a **Model** column of the Step table. The settings carry a **guide**
  per tier — reasoning: requirements, plans, architecture, refactorings, security, tricky logic,
  open decisions and other complex work such as Steps heavy in graphics definitions; standard:
  implementation that follows a clear plan; light: mechanical edits, renames, copies and docs.
  The guide is a starting point: the plan judges each Step itself and picks the cheapest tier
  that can do it well, balancing quality and cost. The user can change a tier before
  implementing.
- **S5 — Requirements and plan on the reasoning model:** with **per Step**, `REQUIREMENTS:` and
  `PLAN:` run on the reasoning model; with **fixed**, every stage runs on the fixed model. When
  the chat runs on another model, the stage runs its work as a sub-agent on the configured model
  where the tool supports it; otherwise it stops and asks the user to switch or to continue on
  the current model.
- **S6 — Implementation switches models:** with **per Step**, `IMPLEMENT:` asks **once** at the
  start: *"Run Steps n–m with their models (n: …, m: …)?"* — yes / only this Step / no. With yes,
  each Step runs as a sub-agent on its model, one after the other, without further questions,
  and stops at the first failing check. Running several Steps in one go needs the agent to be
  allowed to commit each Step with its suggested message; otherwise one Step runs per
  `IMPLEMENT:` as today, still on its model. Nothing is ever pushed.
- **S7 — No means no:** with **no**, nothing is checked, switched or asked; every stage, Step and
  sub-task runs on the model selected in the tool.
- **S8 — Tracking:** the Step table shows the suggested tier and model; each Done line adds
  `suggested: <tier> (<model>) · ran: <model>`; the Stage log gets a row per Step with the model
  that ran it (the **Model name** rule). A Step that ran on another model than suggested is
  visible in the table.
- **S9 — A model that no longer exists:** when a configured model cannot be used, the stage stops
  before doing any work, shows the mapping, suggests a replacement and asks; the answer is saved
  for the team (`.specs/spec-nx.json`) or for the developer only (`.specs/spec-nx.local.json`),
  then the stage continues and the report names the change. Never a silent fallback.
- **S10 — Tools:** the automatic switch works in VS Code Copilot (agent mode) and Claude Code,
  through sub-agents with a chosen model; elsewhere the stage says at the end of each Step which
  model the next Step suggests.
- **S11 — Told early:** the README presents the feature near the top as *The right model for
  each Step*: what it does, the three answers, which tools switch automatically.
- **S12 — Nothing breaks:** kits and specs without `models`, and Step tables without a Model
  column, work as before; commands, markers and script parameters do not change.

### Tokens and cost

- **S13 — Tokens per stage:** every stage records the tokens it used — input, cached input and
  output — in its Stage log row. `IMPLEMENT:` records them per Step (Done line and Stage log)
  and as a total for the whole implementation.
- **S14 — Measured or estimated, always said:** where the tool writes token usage to its session
  log (Claude Code: `usage` on every message of the session file) the numbers are measured.
  Where it does not (VS Code Copilot: the chat transcript has turns and tool calls but no token
  counts) a script estimates them from the transcript text between the stage's start and end,
  and the numbers carry `~`. Never a number without saying which one it is.
- **S15 — Cost estimate:** the tokens are priced with the model's price per million tokens
  (input, cached input, output) — read from the tool where it publishes them (VS Code Copilot
  keeps them in its model list, in GitHub AI credits; 1 credit = $0.01), otherwise from a price
  table in the settings — and shown in AI credits, USD and the local currency (default CHF).
- **S16 — Share of the subscription:** the cost is also shown as a percentage of the plan's
  monthly base credits (Business $19 = 1,900 credits).
- **S17 — Cost summary:** `CLOSE:` adds a **Cost summary** before Part 1: one sentence on top
  with the total tokens and cost in the local currency (*"This feature used ~2.4 M tokens,
  ~CHF 1.50 — estimate, see COSTS.md"*), then a table with one row per stage and per Step —
  tokens, credits, USD, local currency, % of the subscription — and a **Total** row. The pull
  request description repeats the sentence.
- **S18 — One switch:** setup asks nothing about cost. `GENERATE KIT` writes a `cost` block
  into `.specs/spec-nx.json` — `enabled: true`, plan **Copilot Business**, $19 and 1,900
  credits per month, currency **CHF** at **0.8384 CHF per USD** (ECB reference rate of
  2026-11-13) with the rate's date — documented in the README as an advanced setting and edited
  by hand. **Enabled:** tokens and price are calculated and written everywhere (Stage log, Done
  lines, Cost summary, ledger, pull request). **Disabled, or no `cost` block:** nothing is
  calculated or written. `--update` does not add the block. A developer may override values in
  `.specs/spec-nx.local.json`. The same holds for `models`: missing means **no** (S1).
- **S19 — A cost README:** `GENERATE KIT` and `GENERATE KIT --update` write `COSTS.md` in the
  kit folder: how tokens are measured or estimated, where prices, plan values and the rate come
  from (and their date), the settings that change them, and in bold that **all costs are
  estimates and may be wrong** — the settings can be outdated or edited, so specs may carry
  wrong numbers, also in public repositories; the real usage is on the GitHub billing page.
  The setup report shows this note and the link.
- **S20 — Every number links to it:** the Cost summary, the Stage log column header and the
  cost line in the pull request start with *"Estimate — see COSTS.md"* (link). No cost number
  appears anywhere without it.
- **S21 — Cost ledger:** `.specs/costs.md` lists every spec — open and done — with its
  tokens and cost per stage, per Step and in total, and a total for all specs. `CLOSE:` (and
  `GENERATE KIT --update`) rebuild it from all spec files on the branch, so specs closed by
  other people appear too and a merge conflict is fixed by rebuilding. Specs from before
  `v0.4.0`, or rows without numbers, show `N/A`.
- **S22 — This spec as proof of concept:** until the feature exists, this spec's Stage log gets
  token estimates made by hand from the transcript, for requirements, plan and each Step; from
  `v0.4.0` on, spec-nx writes them itself.

### Decisions

- Full process: branch `feature/model-per-step`, a GitHub issue and a pull request.
- One spec, one release `v0.4.0` (models, tokens and cost together).
- VS Code Copilot numbers are `~` estimates from the transcript; Claude Code numbers are measured.
- The plan and its price are default settings, not setup questions (S18). Defaults follow
  GitHub's plans page (2026-11-14): Business $19 / 1,900 credits, Enterprise $39 / 3,900,
  Pro $10 / 1,500, Pro+ $39 / 7,000, Max $100 / 20,000. Default plan: Copilot Business.
  All public: docs.github.com/en/copilot/get-started/plans and
  docs.github.com/en/copilot/concepts/billing-and-usage/individuals/billing (1 credit = $0.01).
  Pro, Pro+ and Max include a variable "flex" part, so `COSTS.md` uses base credits for the % and
  says so; discounts (auto model selection, promotions) are ignored.
- Model prices are read at run time (the tool's model list, or the public page "Models and
  pricing for GitHub Copilot"); spec-nx never commits account-specific data.
- Simple cost rule: `cost.enabled` on = tokens and price calculated and written; off or missing
  = nothing. No publish levels, no private ledger.
- Default rate 0.8384 CHF per USD: European Central Bank reference rate of 2026-11-13 (latest on
  2026-11-16), via api.frankfurter.app.
- spec-nx only changes its own repository. Other projects (spec-kit, AcceleratorHub, hack_star,
  Incubator) get the feature when their owner runs `GENERATE KIT` / `GENERATE KIT --update`.
- This spec is written before the feature exists: its Stage log carries hand-made POC estimates
  (S22); specs from `v0.4.0` on get them from spec-nx.
- The plan ends with a reminder Step (no code): *open a new spec to run hack_star experiments with
  different models and compare the costs*. The spec itself is not created now.

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_Written by the plan stage once Part 1 is agreed._
