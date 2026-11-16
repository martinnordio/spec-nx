# Configuring spec-nx

How to change what `GENERATE KIT` set up: the two settings files, the AI model per stage and
Step, tokens and cost, and the other answers. A full tutorial will follow in its own page.

## The two settings files

| File | Who | Committed? | Holds |
|------|-----|------------|-------|
| `.specs/spec-nx.json` | the team | yes | the answers to the setup questions, `models`, `cost` |
| `.specs/spec-nx.local.json` | you | no (git-ignored) | your shell, and your own overrides of `models` and `cost` |

Both are plain JSON: edit them by hand, or run `GENERATE KIT --update --force` to be asked
again. A key in the local file wins over the same key in the project file. After a change that
affects the kit (stages, languages, git host, shells), run `GENERATE KIT --update`.

Every key and every question: [generator/questions.md](../generator/questions.md).

## The model for each stage and Step (`models`)

Set by question Q7. Three choices:

**1. A model per Step** — strong where it matters, cheap where it does not:

```json
"models": {
  "reasoning": "Claude Opus 5.5",
  "standard": "Claude Sonnet 5.5",
  "light": "Claude Haiku 5.5",
  "guide": {
    "reasoning": "Requirements, plans, architecture, refactorings, security, tricky logic, open decisions, complex work such as graphics-heavy Steps",
    "standard": "Implementation that follows a clear plan, with tests",
    "light": "Mechanical edits, renames, copies, docs"
  }
}
```

- Requirements, plans, reviews and clean-ups run on `reasoning`; `PR:` on `light`; documents
  and `CLOSE:` on `standard` ([stages/models.md](../stages/models.md)).
- The plan gives each Step a tier in a **Model (suggested)** column, starting from `guide` but
  picking the cheapest tier that does the Step well. Change a tier in the spec before
  `IMPLEMENT:` if you disagree.
- `IMPLEMENT:` asks once — *"Run Steps 2–5 with their models, committing each Step?"* — then
  runs every Step as a sub-agent on its model (VS Code Copilot agent mode, Claude Code). It
  never pushes. In other tools it tells you which model the next Step wants.
- Use the names exactly as your tool's model picker shows them (Claude Code: `opus`,
  `sonnet`, `haiku`). Edit `guide` to fit your project.

**2. One fixed model** for every stage and Step:

```json
"models": { "fixed": "Claude Opus 5.5" }
```

**3. No model handling** — always the model selected in your tool; nothing is checked,
switched or asked:

```json
"models": null
```

(or no `models` key at all — older kits behave like this).

**Just for you:** put `models` in `.specs/spec-nx.local.json` — other names (your licence lacks
a model) or `null` (always your tool's model), whatever the team chose.

**A model that no longer exists:** the stage stops before any work, suggests a replacement and
asks whether to save it for the team or only for you. It never switches silently.

## Tokens and cost (`cost`)

Written by the first `GENERATE KIT` with these defaults; `--update` never adds it.

```json
"cost": {
  "enabled": true,
  "plan": "Copilot Business",
  "monthly_price_usd": 19,
  "monthly_credits": 1900,
  "currency": "CHF",
  "rate": 0.8384,
  "rate_date": "2026-11-13"
}
```

| Key | Change it when |
|-----|----------------|
| `enabled` | `false` (or no `cost` block) turns everything off: no tokens, no cost, nothing written |
| `plan`, `monthly_price_usd`, `monthly_credits` | Your Copilot plan is not Business: Enterprise $39 / 3,900, Pro $10 / 1,000, Pro+ $39 / 3,900, Max $100 / 10,000 (base credits) |
| `currency`, `rate`, `rate_date` | Another currency (units per USD), or a newer rate |
| `prices` | Your tool does not publish its prices (Claude Code): `{ "<model>": { "input": 400, "cache_write": 500, "cached": 20, "output": 2000 } }` in credits per 1 M tokens |
| `base_tokens` | Estimates look too high or too low: tokens of system prompt and tools per request (default 35000) |

**Just for you:** another currency, or tracking off only for you:

```json
{ "version": 1, "shell": "powershell", "cost": { "currency": "EUR", "rate": 0.86, "rate_date": "2026-11-16" } }
```

With cost tracking on, every Stage log row gets **Tokens** and **Cost** columns, every Step's
Done line ends with its tokens and cost, `CLOSE:` adds a **Cost summary** above Part 1, and
`.specs/costs.md` lists all specs. Check the numbers yourself any time:

```
pwsh .specs/kit/tools/usage.ps1 -Since "2026-11-16 08:55" -Model "Claude Opus 5.5"
```

> **All costs are estimates and may be wrong** — the prices, the plan and the rate in the
> settings can be outdated or edited. In public repositories, everyone sees them. How they are
> counted and where the values come from: [stages/COSTS.md](../stages/COSTS.md) (`COSTS.md` in
> your kit).

## Other settings worth knowing

| Key | What | Set by |
|-----|------|--------|
| `stages`, `on_demand` | Which stages and on-demand commands the kit has | Q1, Q1b |
| `git_host`, `link_issues` | GitHub / Azure DevOps, and whether each spec has an issue | Q2, Q2b |
| `work_item_type` | Azure DevOps backlog item type, only for another process than Scrum: `"User Story"` (Agile), `"Requirement"` (CMMI), `"Issue"` (Basic); missing = `"Product Backlog Item"` | by hand |
| `work_items` | Azure DevOps: the project of the backlog items, only when it is not the repository's: `{ "org": "<org>", "project": "<project>" }` | by hand |
| `parent` | Default parent issue / work item of `CREATE ISSUE` | by hand |
| `shells` / `shell` | Shells the kit's scripts are written for / yours — taken from the operating system; for Git Bash on Windows set `"shell": "bash"` in the local file and run `GENERATE KIT --update` | not asked |
| `kit`, `kit_dir`, `kit_ref` | Shared or personal kit, where it lives, how other repositories refer to it | Q4, Q4b, Q4c |
| `layer` | Your company's layer of defaults and rules | Q5 |
| `agent` | AI agents whose permissions were written | Q6 |
