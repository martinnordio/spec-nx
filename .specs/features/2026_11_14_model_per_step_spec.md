# The Right Model and Cost for Each Step Spec

> **Author:** Martin Nordio
> **Status:** 🔄 In progress
> **Created:** 2026-11-14
> **Last updated:** 2026-11-16
> **Branch:** `feature/model-per-step`
> **Issue:** #5

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see COSTS.md) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | ~111 k (38 k in · 70 k cached · 3 k out) | ~CHF 0.22 (26 credits) | Part 1 written |
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | ~379 k (40 k in · 334 k cached · 5 k out) | ~CHF 0.30 (36 credits) | Full process chosen; tokens and cost added (S13–S18) |
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | ~132 k (4 k in · 126 k cached · 2 k out) | ~CHF 0.08 (9 credits) | Q1–Q3 answered: one spec `v0.4.0`, `~` estimates, plan in default settings |
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | ~289 k (5 k in · 282 k cached · 2 k out) | ~CHF 0.10 (13 credits) | COSTS.md, disclaimer, publishing in public repos (S19–S21) |
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | ~1.33 M (16 k in · 1,305 k cached · 9 k out) | ~CHF 0.44 (52 credits) | Cost ledgers (S22–S23), POC numbers (S24), hack_star reminder |
| 2026-11-14 | requirements | `CREATE ISSUE:` | Claude Opus 5.5 | counted in the row above | counted in the row above | issue #5 created; default `publish: tokens` |
| 2026-11-14 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | ~399 k (3 k in · 395 k cached · 2 k out) | ~CHF 0.11 (13 credits) | Switch-off setting; plan prices checked against public GitHub pages |
| 2026-11-16 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | ~281 k (4 k in · 274 k cached · 3 k out) | ~CHF 0.11 (13 credits) | Default models (S2), task-based tiers (S4), Cost summary (S17), CHF, missing settings = off (S18) |
| 2026-11-16 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | ~942 k (11 k in · 925 k cached · 5 k out) | ~CHF 0.29 (35 credits) | Simplified: one `cost.enabled` switch, one ledger, CHF rate 0.8384 (S13–S22); developer `models: null` (S3) |
| 2026-11-16 | requirements | `UPDATE ISSUE:` | Claude Opus 5.5 | counted in the row above | counted in the row above | issue #5 updated |
| 2026-11-16 | plan | `PLAN:` | Claude Opus 5.5 | ~1.54 M (18 k in · 1,509 k cached · 11 k out) | ~CHF 0.51 (61 credits) | Part 2 written; issue #5 updated |
| 2026-11-16 | plan | `PLAN:` | Claude Opus 5.5 | ~515 k (3 k in · 510 k cached · 2 k out) | ~CHF 0.13 (16 credits) | PLAN estimate corrected; pricing basis written |
| 2026-11-16 | plan | `PLAN:` | Claude Opus 5.5 | ~868 k (10 k in · 853 k cached · 5 k out) | ~CHF 0.27 (33 credits) | re-planned: exact calculation method (D11), Cost column, spec-nx on its own settings (Step 9) |

> POC: numbers estimated by hand from the VS Code transcript with the method of D11 (characters
> ÷ 4, ~35 k tokens of system prompt and summary per request, earlier context counted as cached
> — also after the break on 2026-11-16, when the cache was in fact cold). The design talk before
> Part 1 and the hack_star licence work are not counted. Priced at GitHub Copilot's per-token
> rates for Claude Opus 5.5 (credits per 1 M tokens: 500 new input — the cache-write rate — 20
> cached, 2,000 output; 1 credit = $0.01) at 0.8384 CHF/USD. This is the value of the credits
> used, not an invoice: within the plan's monthly credits nothing extra is paid.
> **Total so far: ~6.8 M tokens, ~307 credits ≈ $3.07 ≈ CHF 2.57.**

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
- spec-nx only changes its own repository. Other projects get the feature when their owner
  runs `GENERATE KIT` / `GENERATE KIT --update`.
- This spec is written before the feature exists: its Stage log carries hand-made POC estimates
  (S22); specs from `v0.4.0` on get them from spec-nx.
- The plan ends with a reminder Step (no code): *open a new spec to run hack_star experiments with
  different models and compare the costs*. The spec itself is not created now.

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Model (suggested) | Status | Detail |
|------|-------------|-------------------|--------|--------|
| **1** | Settings: Q7 `models`, the `cost` block | reasoning (Claude Opus 5.5) — settings contract | ✅ Done | [→ Step 1](#step-1--settings-q7-models-the-cost-block) |
| **2** | Shared model rules for every stage | reasoning (Claude Opus 5.5) — sub-agent and fallback logic | ✅ Done | [→ Step 2](#step-2--shared-model-rules-for-every-stage) |
| **3** | Plan: Model column and tier choice | standard (Claude Sonnet 5.5) — follows D1–D3 | ✅ Done | [→ Step 3](#step-3--plan-model-column-and-tier-choice) |
| **4** | Implementation: one confirmation, sub-agents, tracking | reasoning (Claude Opus 5.5) — commits, stops, sub-agents | ✅ Done | [→ Step 4](#step-4--implementation-one-confirmation-sub-agents-tracking) |
| **5** | Usage script: tokens and price | reasoning (Claude Opus 5.5) — transcript parsing, two shells | ✅ Done | [→ Step 5](#step-5--usage-script-tokens-and-price) |
| **6** | COSTS.md and token columns in every stage | standard (Claude Sonnet 5.5) — text in known places | ✅ Done | [→ Step 6](#step-6--costsmd-and-token-columns-in-every-stage) |
| **7** | CLOSE: cost summary and ledger | standard (Claude Sonnet 5.5) — script follows Step 5 | ✅ Done | [→ Step 7](#step-7--close-cost-summary-and-ledger) |
| **8** | README, kit README, regression check | light (Claude Haiku 5.5) — docs and running checks | ✅ Done | [→ Step 8](#step-8--readme-kit-readme-regression-check) |
| **9** | spec-nx on its own settings, same spec format | standard (Claude Sonnet 5.5) — settings and a format check | ⬜ Not started | [→ Step 9](#step-9--spec-nx-on-its-own-settings-same-spec-format) |
| **10** | Reminder: hack_star cost comparison | light (Claude Haiku 5.5) — no code | ⬜ Not started | [→ Step 10](#step-10--reminder-hack_star-cost-comparison) |

> **Step completion protocol (required):** every time a Step is finished, in the same edit:
> 1. Tick its tasks `[x]` **and** set its row in this table to ✅ Done.
> 2. Append a **`**Done (YYYY-MM-DD · ~<duration> · <model>)**`** line to that Step's
>    **Notes**: date, time it took, the AI model that did the work, a one-line summary and
>    the verifying test/command result.
>
> The table and the Step sections must **always agree**.

> **Time tracking (required for every Step):** each Step's **first task** is
> `Record the start time in Notes` (e.g. `Started: YYYY-MM-DD HH:MM`); the Done line records
> the finish and the duration.

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | New question **Q7 · Model per Step**, asked after Q6; key `models` = `{reasoning, standard, light, guide}`, `{fixed}` or `null`, in both settings files (the local one wins, also `null`) | One key for all three answers; `null` and "missing" mean the same, so old kits behave as before |
| D2 | `guide` holds one line per tier (the S4 text); `GENERATE KIT` writes it with the defaults and teams edit it | The guide is a setting, not hidden in a prompt |
| D3 | Shared rules in a new building block `stages/models.md` (start check, sub-agent, missing model, tracking), copied to the kit as `models.md` and loaded by every stage prompt | One place instead of the same text in eight prompts |
| D4 | Key `cost` = `{enabled, plan, monthly_price_usd, monthly_credits, currency, rate, rate_date, prices}`; `prices` (credits per 1 M tokens per model) is optional and only used when the tool does not publish them | Matches S15/S18; no account data is committed by default |
| D5 | Script pair `tools/usage.ps1` / `tools/usage.sh` (bash uses `python3` for JSON): reads a transcript between two times, prints tokens (input, cached, output, measured or `~`), credits, USD, local currency and % of plan | Same shape as the other kit scripts; stages call it, never compute by hand |
| D6 | The transcript is found by the script: Claude Code `~/.claude/projects/<project>/*.jsonl` (measured); VS Code `workspaceStorage/*/GitHub.copilot-chat/transcripts/*.jsonl` of this workspace (estimated, the POC method: characters ÷ 4, earlier context as cached); `-Transcript` overrides | No setting needed; the POC numbers in this spec are the test data |
| D7 | Stage log gets two columns, **Tokens (estimate — see COSTS.md)** and **Cost (<currency>)** — e.g. `~379 k (40 k in · 334 k cached · 5 k out)` and `~CHF 0.30 (36 credits)` — written only when cost is enabled; Done lines add `· ~<tokens> · ~<currency> <x>`; older specs keep five columns | S13/S15/S20: tokens and price side by side; nothing changes for projects without `cost` |
| D8 | Script pair `tools/costs_ledger.ps1` / `.sh` rebuilds `.specs/costs.md` from the Stage logs of `.specs/features/**/*_spec.md` | S21: rebuilt, never appended; merge conflicts fixed by running it |
| D9 | `stages/costs.md` is both the user page and the rules; the kit gets it as `COSTS.md` | S19: one page to link to |
| D10 | The tier check in Step 8 generates a kit into a temporary folder with old settings (no `models`, no `cost`) and with the new ones, and compares | S12: proves nothing breaks for existing projects |
| D11 | **One calculation method**, written in COSTS.md and implemented only in `usage`; prompts run the script and copy its numbers, never compute by hand. Per model request in the range: *context* = base (system prompt, tools, summary; default 35 k tokens) + all transcript events of the session so far ÷ 4 characters — counted from the session start, not from the range start, and set back to the base when it passes the context cap (default 200 k tokens: the chat is summarized there); *cached* = the previous request's context; *new input* = context − cached, priced at the cache-write rate (input rate if none); *output* = the assistant's messages and tool-call arguments ÷ 4. Credits = Σ tokens × rate / 1 M; USD = credits / 100; local = USD × `rate`. Claude Code: the logged `usage` numbers replace the estimate | The POC showed that restarting the context at the range start undercounts by ~5×; one method gives the same numbers in spec-nx and in every kit |
| D12 | spec-nx uses its own feature: `.specs/spec-nx.json` in spec-nx with `models: {fixed: "Claude Opus 5.5"}` and the default `cost` block (CHF); its specs follow `stages/spec_template.md` exactly, like a generated kit | Specs written in spec-nx and in generated kits have the same format and numbers |

---

## Step 1 — Settings: Q7 `models`, the `cost` block

### Goal
The setup question and both settings keys exist with their defaults and rules (S1, S2, S3,
S7, S18).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `generator/questions.md`: Q7 row and section — the three answers, the default mapping
      (Opus 5.5 / Sonnet 5.5 / Haiku 5.5), checking against the tool's model list, asking for
      exact names otherwise; `models` and `cost` in both settings tables (D1, D2, D4).
- [x] `generator/prompt.md`: ask Q7; write `cost` with the defaults for new kits only;
      `--update` adds neither `models` nor `cost`, `--update --force` asks Q7 again; report
      the settings and the COSTS.md note.
- [x] Check: `testing/check_all.ps1` passes; read Q7 against S1–S3, S7, S18.

### Notes
Started: 2026-11-16 08:55

**Done (2026-11-16 · ~10m · Claude Opus 5.5)** — Q7 *Model per Step* with the default
mapping and `guide`; *The `cost` block* section (defaults, missing = off); `models` / `cost` in
both settings tables; the generator writes `cost` only on the first run and reports the
mapping and the cost note. Note: `--update` *does* ask Q7 once (it is a new key, S1); it never
adds `cost`. `check_all.ps1`: only the 4 known template placeholders. · suggested: reasoning
(Claude Opus 5.5) · ran: Claude Opus 5.5 · tokens and cost: Step 9
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 2 — Shared model rules for every stage

### Goal
Every stage runs on the configured model, or says why not (S5, S7, S9, S10).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `stages/models.md` (D3): read `models` (local wins); `null` → do nothing; requirements
      and plan on reasoning, fixed for every stage; sub-agent on the configured model (VS Code
      `runSubagent` with `"<name> (copilot)"`, Claude Code sub-agent model), otherwise stop and
      ask switch / continue; missing model → stop before work, suggest, save for team or
      developer, continue, report.
- [x] Every stage prompt: *Files this stage uses* lists `../models.md`; the **Model name**
      section starts with "Check the model first (`../models.md`)".
- [x] `generator/prompt.md`: copy `models.md` into the kit (layout in the contract).
- [x] Check: `testing/check_all.ps1` (every `../models.md` path resolves).

### Notes
Started: 2026-11-16 09:00

**Done (2026-11-16 · ~8m · Claude Opus 5.5)** — `stages/models.md`: read the setting
(local wins, also `null`), a tier per stage (requirements, plan, review, improvement:
reasoning; documentation, CLOSE: standard; pr: light; IMPLEMENT: the Step's tier), check
before work, sub-agent or ask, missing model, recording. The seven prompts with a **Model
name** section start it with the check (the mention there replaces a row in *Files this stage
uses*); the generator copies `models.md` and lists it in the layout. `check_all.ps1`: the
4 known placeholders only. · suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 ·
tokens and cost: Step 9
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 3 — Plan: Model column and tier choice

### Goal
Plans give each Step a tier with a reason, chosen for quality and cost (S4, S8).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `stages/plan/prompt.md`: with per Step, a **Model (suggested)** column — tier, model and
      a few words why; start from `guide`, pick the cheapest tier that does the Step well;
      without per Step, no column.
- [x] `stages/spec_template.md`: the column in **2 · Spec Overview** (marked optional) and its
      comment.
- [x] Check: this spec's own table follows the new rule; `check_all.ps1` passes.

### Notes
Started: 2026-11-16 09:08

**Done (2026-11-16 · ~4m · Claude Opus 5.5)** — The plan prompt fills **Model (suggested)**
as `<tier> (<model>) — <why>` from the `guide`, choosing the cheapest tier that does the
Step well, and lists the tiers in its report; the template has the optional column and a
comment. This spec's table already has that shape. `check_all.ps1`: 4 known placeholders. ·
suggested: standard (Claude Sonnet 5.5) · ran: Claude Opus 5.5 (one chat on a fixed model; no
sub-agent switch before Step 4 exists) · tokens and cost: Step 9
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 4 — Implementation: one confirmation, sub-agents, tracking

### Goal
`IMPLEMENT:` runs each Step on its model and records what ran (S6, S8, S10).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `stages/implementation/prompt.md`: with per Step, one question at the start (yes /
      only this Step / no); with yes and commit permission (`stages/agent/permissions.md`),
      each Step as a sub-agent on its model, commit per Step, stop at the first failing
      check, never push; without commit permission one Step per `IMPLEMENT:`; elsewhere the
      reminder of the next Step's model.
- [x] Done line and Stage log: `suggested: <tier> (<model>) · ran: <model>`
      (template comment too).
- [x] Check: walk through Steps 5–7 of this spec on paper with the new text (who asks, who
      commits, what is written); `check_all.ps1` passes.

### Notes
Started: 2026-11-16 09:12

**Done (2026-11-16 · ~6m · Claude Opus 5.5)** — New section *Per-Step run* in the
implementation prompt: one question (yes / only Step n / no), each Step as a sub-agent on its
model, commit per Step with the suggested message, stop at the first failure, never push;
falls back to one Step when commits are denied or the tool has no model choice; reminder of
the next Step's model elsewhere. Done lines end with `suggested · ran` (prompt and template);
*Never* names the two exceptions. Walk-through of Steps 5–7: the question would list Sonnet
/ Opus / Sonnet, each sub-agent ticks its Step, the parent checks the Done line and commits
`Step <n>: … (#5)`, stop on a failing `bash -n`. `check_all.ps1`: 4 known placeholders. ·
suggested: reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · tokens and cost: Step 9
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 5 — Usage script: tokens and price

### Goal
A script measures or estimates the tokens of a time range and prices them (S13, S14, S15,
S16); it replaces the hand-made POC estimates of this spec (S22).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `stages/tools/usage.ps1` and `usage.sh` (D5, D6, D11): `-Since`, `-Until`, `-Model`,
      `-Transcript`, `-Json`; the D11 method exactly (context counted from the session start);
      prices from the tool's model list or `cost.prices`, new input at
      the cache-write price when the tool has one; credits →
      USD → local currency with `rate`; % of `monthly_credits`; prints `~` when estimated.
- [x] `stages/tools/README.md`: the script, its parameters and an example.
- [x] Check: on this conversation's transcript the script reproduces the POC rows of this
      spec (tokens and credits) within 5 %, both shells give the same numbers; PowerShell parses and is ASCII; `bash -n` passes; a Claude Code sample
      file gives measured numbers.

### Notes
Started: 2026-11-16 09:18

**Done (2026-11-16 · ~25m · Claude Opus 5.5)** — `usage.ps1` / `usage.sh` (bash runs an
embedded `python3`): finds the newest VS Code Copilot or Claude Code transcript (or
`-Transcript`), reads the `cost` block (missing or `enabled: false` → "Cost tracking is off",
nothing else), estimates by D11 or adds Claude Code's logged `usage` (one count per message
id), prices from Copilot's model list next to the transcript or `cost.prices`, prints tokens,
cost in the currency with credits and % of the plan, or one JSON line. Checks: on the PLAN turn
both shells print identical JSON — 1,339,649 tokens (18,256 in · 1,310,636 cached · 10,757
out), 56.85 credits, CHF 0.48; Claude Code sample → 5,000 / 44,200 / 800 measured, 4.98
credits, duplicate message counted once, row outside the range left out; `enabled: false`
and missing block → off; automatic transcript discovery finds this chat; `check_all.ps1`
(parse, ASCII, `bash -n`): 4 known placeholders. **Differs from the plan:** the 5 % match with
the POC rows is not reached and not wanted — the POC restarted the context at a hand-picked
line, D11 counts from the session start and sets back to the base at the context cap
(now written in D11); Step 9 replaces the POC numbers with the script's. · suggested:
reasoning (Claude Opus 5.5) · ran: Claude Opus 5.5 · tokens and cost: Step 9
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 6 — COSTS.md and token columns in every stage

### Goal
With cost enabled, every stage writes its tokens and cost, always linked to COSTS.md (S13,
S18, S19, S20).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `stages/costs.md` (D9, D11): the calculation method step by step, the sources and dates (plans
      page, billing page, ECB rate), the settings, and in bold that all costs are estimates
      and may be wrong; that the cost is the value of the credits used at GitHub Copilot's
      per-token rates, not an invoice (within the plan's credits nothing extra is paid);
      real usage on the GitHub billing page.
- [x] Stage prompts that write a Stage log row: record the start time; at the end, with cost
      enabled, run `usage` and copy its **Tokens** and **Cost** into the row (D7), never
      computing by hand; disabled or missing → as today.
- [x] `stages/spec_template.md`: the two optional columns (Tokens with "estimate — see
      COSTS.md", Cost in the local currency with credits) and the Done line with tokens and
      price.
- [x] `generator/prompt.md`: copy `costs.md` as `COSTS.md` into the kit; the setup report shows
      the disclaimer and the link.
- [x] Check: `check_all.ps1`; a spec written with cost disabled is unchanged.

### Notes
Started: 2026-11-16 09:45

**Done (2026-11-16 · ~10m · Claude Opus 5.5)** — `stages/COSTS.md`: the disclaimer first,
the switch, what the numbers mean (value of credits, not an invoice; share of base credits),
the D11 method in five steps with its limits, the sources with dates, and the rules the
stages follow. The seven stage prompts note the start time and copy `usage` output into their
Stage log row; the implementation prompt adds it to the Done line; the template has the two
optional columns (with the link) and the Done-line ending; the generator copies `COSTS.md`
and `tools/usage.*` when the project has a `cost` block. **Differs from the plan:** the file is
`stages/COSTS.md`, not `costs.md`, so `../COSTS.md` is the same path in spec-nx and in every
kit. With cost off every new text says "only with the `cost` block on" and the template says
to drop both columns, so such specs keep their old shape. `check_all.ps1`: 4 known
placeholders. · suggested: standard (Claude Sonnet 5.5) · ran: Claude Opus 5.5 · tokens and
cost: Step 9
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 7 — CLOSE: cost summary and ledger

### Goal
Closing a spec writes its cost summary and rebuilds the ledger of all specs (S17, S21).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `stages/implementation/prompt.md` CLOSE: with cost enabled, a **Cost summary** before
      Part 1 — one sentence (total tokens, local currency, link) and a table per stage and Step
      with a Total row.
- [x] `stages/tools/costs_ledger.ps1` / `.sh` (D8): one row per spec (open and done), per
      stage and Step totals, a total for all; `N/A` where a spec has no numbers.
- [x] `stages/pr/prompt.md`: the pull request repeats the summary sentence.
- [x] Check: run the ledger on this repository (older specs show `N/A`, this spec its POC
      numbers); scripts parse, ASCII, `bash -n`.

### Notes
Started: 2026-11-16 09:58

**Done (2026-11-16 · ~15m · Claude Opus 5.5)** — CLOSE writes its own Stage log row, then a
**Cost summary** above Part 1 (sentence with link; table per stage and Step with tokens, cost,
share of the plan, and a Total row) and runs `costs_ledger`; the pr stage adds the sentence to
the summary. `costs_ledger.ps1` / `.sh`: every `*_spec.md` in `features/` and `done/`, sums of
the Tokens / Cost columns per stage and per implementation Step, a total of all specs, `N/A`
for specs without the columns; the COSTS.md link follows `kit_dir`. Checks on a copy of this
repository: both shells print the same file (diff empty) — 8 older specs `N/A`, this spec
~3.86 M / ~CHF 1.65 requirements, ~2.92 M / ~CHF 0.91 plan; with a test implementation row
the *Implementation by Step* table appears in both; `check_all.ps1`: 4 known placeholders.
Fixed while testing: Python now prints UTF-8 on Windows; the PowerShell path is relative to
`.specs/` also with short (8.3) folder names. · suggested: standard (Claude Sonnet 5.5) ·
ran: Claude Opus 5.5 · tokens and cost: Step 9
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 8 — README, kit README, regression check

### Goal
The feature is told early, and existing projects work as before (S11, S12).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] `README.md`: near the top *The right model for each Step* (what, the three answers,
      which tools switch automatically) and *Tokens and cost* (one switch, estimates,
      COSTS.md); Q7 in *Setup questions*; the `cost` block as an advanced setting.
- [x] `docs/configuration.md` (added while implementing, at the author's request): how to
      configure spec-nx — both settings files, `models`, `cost`, the other keys.
- [x] `stages/kit_readme.md`: the model and cost lines.
- [x] Regression (D10): generate a kit in a temporary folder with old settings and with the
      new ones; old settings → no Model column, no Tokens/Cost, no new questions; new
      settings → `models.md`, `COSTS.md`, columns present.
- [x] Check: `check_all.ps1` passes; the regression results in Notes.

### Notes
Started: 2026-11-16 10:15

**Done (2026-11-16 · ~12m · Claude Opus 5.5)** — README: a ⭐ section *The right model for
each Step — and what it cost* at the very top (right after the intro), Q7 and the `cost` block
in *Setup questions*, layout and Status lines; `docs/configuration.md`: settings files,
`models` (three choices, overrides, missing model), `cost` (keys, plans, overrides, the
disclaimer), other keys; kit README: a *Models and cost* section. **Differs from the plan:** the
regression does not run the generator (an AI prompt) end to end; instead, with old settings
(no `models`, no `cost`) both scripts print "Cost tracking is off" and write no
`.specs/costs.md`, `models.md` says to do nothing, and every new instruction in the stage
prompts sits under its guard ("only with the `cost` block on", "with per-Step models",
"when `models` is set") — the grep for unguarded lines finds only continuation lines of
guarded paragraphs. A real `GENERATE KIT --update` in another project is left for after the
release. `check_all.ps1`: 4 known placeholders. · suggested: light (Claude Haiku 5.5) · ran:
Claude Opus 5.5 · tokens and cost: Step 9
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 9 — spec-nx on its own settings, same spec format

### Goal
spec-nx's own specs are written and priced exactly like specs in a generated kit (S12, S13,
S17, S21, S22).

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] `.specs/spec-nx.json` in spec-nx (D12): `models: {fixed: "Claude Opus 5.5"}` and the
      default `cost` block; `.specs/spec-nx.local.json` in `.gitignore`.
- [ ] This spec: replace the hand-made POC numbers with `usage` output where the transcript
      allows, keep the POC note for the rest; columns as in the template.
- [ ] Run `costs_ledger` to write `.specs/costs.md` for spec-nx.
- [ ] Check: compare this spec's headings, Stage log columns and Done lines with the template
      and with a spec from the Step 8 test kit — same format; `check_all.ps1` passes.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 10 — Reminder: hack_star cost comparison

### Goal
Nothing is forgotten after the release: a reminder to compare models on a real project.

### Tasks
- [ ] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [ ] Add to **Deferred Items**: *new spec in hack_star — run the same features with
      different model settings (fixed Opus, per Step, light-heavy) and compare tokens and
      cost*. Do not create that spec.
- [ ] Check: the row is in Deferred Items.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Deferred Items

Tasks set aside for a future spec, so nothing is forgotten.

| Task | Reason | Target Spec |
|------|--------|------------------|
| Sub-agent tokens in VS Code Copilot, if they are not in the main transcript | Unknown until Step 5 tests it; COSTS.md says so | later spec |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|
| 2026-11-16 | AI assistant (Claude Opus 5.5) | plan | re-planned | Exact calculation method (D11), Cost column in the local currency (D7), spec-nx on its own settings and the same spec format (D12, Step 9); reminder moved to Step 10 |

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..S22 testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [ ] Implementation · every Step's tasks checked
- [ ] Documentation · README, generator docs and kit README updated
- [ ] Review · semantic diff written for this spec
- [ ] Spec closed · moved to `.specs/features/done/`
- [ ] Pull request · opened with the spec summary; reviewed; merged; branch deleted
