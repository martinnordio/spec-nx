# Customizing spec-nx

You can change how spec-nx works **for a whole team, for one project, or only for yourself**
— without editing the kit. This page has the most important points first, then examples to
copy. Every key and every setup question: [generator/questions.md](../generator/questions.md).

## The three settings files

| # | File | Who | Committed? |
|---|------|-----|------------|
| 1 | `<kit>/.specs/spec-nx.json` | the kit — only when the kit is a repository of its own, added to projects as a submodule (for example `.my-kit/`) | in the kit's repository |
| 2 | `.specs/spec-nx.json` | the project | yes |
| 3 | `.specs/spec-nx.local.json` | you | **no** (git-ignored) |

**Each file wins over the one before**, and holds only what it changes:

- a key replaces the same key of an earlier file;
- an object (`work_items`, `cost`, `models`) is merged key by key, so you can change one part;
- a list (`stages`, `languages`) is replaced as a whole;
- `null` removes the key.

The stages and scripts read the files when they run: a change needs no regeneration (only
changes of `stages`, `languages`, `git_host` or `shells` need `GENERATE KIT --update` to add or
remove files of the kit).

**Not for your own file:** `version`, `spec_nx_version`, `generated`, `kit`, `kit_dir`,
`kit_ref`, `kit_files`, `shells` (and `model` of a shared kit) describe the generated kit. They
are read from the project's file only; in your file they are ignored with a warning.

### An example

```jsonc
// 1  .my-kit/.specs/spec-nx.json — the company's kit
{ "stages": ["requirements", "plan", "implementation", "pr"],
  "git_host": "azure_devops", "link_issues": true,
  "work_items": { "org": "acme", "project": "ai-solutions" },
  "cost": { "enabled": true, "currency": "CHF", "rate": 0.84 } }

// 2  .specs/spec-nx.json — the project "product-x"
{ "work_items": { "project": "product-x", "area": "product-x\\Team A" },
  "parent": 4100 }

// 3  .specs/spec-nx.local.json — you
{ "stages": ["requirements"], "parent": 4231, "cost": { "currency": "EUR" } }
```

What the stages use — `<kit>/tools/settings.ps1` (or `settings.sh`) prints it, with the file
of every key:

```
stages = [requirements]   (.specs/spec-nx.local.json)
git_host = azure_devops   (.my-kit/.specs/spec-nx.json)
work_items.org = acme   (.my-kit/.specs/spec-nx.json)
work_items.project = product-x   (.specs/spec-nx.json)
work_items.area = product-x\Team A   (.specs/spec-nx.json)
parent = 4231   (.specs/spec-nx.local.json)
cost.currency = EUR   (.specs/spec-nx.local.json)
cost.rate = 0.84   (.my-kit/.specs/spec-nx.json)
```

Every stage also names, in its report, the settings it used that do not come from the kit
(*parent 4231 — from `.specs/spec-nx.local.json`*).

## Examples to copy

All of them go into your own `.specs/spec-nx.local.json` (only you) or the project's
`.specs/spec-nx.json` (the team). Start your file with `{ "version": 1, … }`.

### Another parent feature, only the requirements

```json
{ "version": 1, "parent": 4231, "stages": ["requirements"] }
```

New backlog items and issues go under 4231. `PLAN:`, `IMPLEMENT:` and the other stages answer
*"The plan stage is turned off in .specs/spec-nx.local.json."* — for you only. `GUIDELINES:` is
never turned off. Remove the `stages` line to work normally again.

### Azure DevOps: area, iteration and who it is assigned to

```json
{ "version": 1,
  "work_items": { "area": "product-x\\Team A", "iteration": "product-x\\Sprint 12",
                  "assigned_to": "ana@example.com" } }
```

| Key | Without it | Value |
|-----|-----------|-------|
| `area` | the project's default area | an area path of the backlog project (`<project>\<team>`; `\\` in JSON) |
| `iteration` | the project's default iteration | an iteration path (`<project>\<sprint>`) |
| `assigned_to` | **you** — the user who runs `CREATE ISSUE:` | an e-mail of the organisation; `null` = nobody |
| `org`, `project` | the repository's project | the backlog items' organisation and project, when they are elsewhere |

`CREATE ISSUE:` checks every value first and shows them in its dry run, with the file each one
comes from:

```
Would create Product Backlog Item 'Login page' in https://dev.azure.com/acme/product-x with:
  Parent:      4231 'Customer portal'
  Area:        product-x\Team A   (work_items.area in .specs/spec-nx.json)
  Iteration:   product-x\Sprint 12   (work_items.iteration in .specs/spec-nx.local.json)
  Assigned to: ana@example.com   (default: you, the signed-in user)
```

An area, iteration, person or parent that does not exist stops it with a message naming the
setting and its file.

### GitHub: issue type, assignee, parent

```json
{ "version": 1, "parent": 12,
  "work_items": { "type": "Feature", "assigned_to": "octocat" } }
```

| Key | Without it | Value |
|-----|-----------|-------|
| `type` | no type | an issue type of the organization (Bug, Task, Feature …); user accounts have no types |
| `assigned_to` | **you** (`@me`) | a login that can be assigned issues; `null` = nobody |
| `parent` | asked once per spec | an issue number: the new issue becomes its sub-issue |

### Models

```json
{ "version": 1, "models": { "light": "Claude Sonnet 5.5" } }
```

Changes only the light tier. `{ "fixed": "<model>" }` runs everything on one model;
`"models": null` always uses the model selected in your tool. Details:
[stages/models.md](../stages/models.md).

### The prompt log

```json
{ "version": 1, "prompt_log": true }
```

Off by default and never asked by `GENERATE KIT`. When on, every stage keeps the prompts it is
given:

- `.specs/prompts/<yyyy_mm_dd>_<name>_prompt.md` — the prompts of the spec
  `<yyyy_mm_dd>_<name>_spec.md`, from its first `REQUIREMENTS:`;
- `.specs/prompts/<yyyy_mm_dd>_other_prompt.md` — the day's prompts that belong to no spec.

The files are committed with the spec; to keep them only for you, add `.specs/prompts/` to
`.git/info/exclude`. Passwords and keys are written as `«redacted»`. A file looks like this:

```markdown
# Prompt history

The prompts of the spec `2026_11_22_todo_cli_spec.md`: a tiny command-line to-do list.

---

## Prompt 1 — New spec todo_cli

2026-11-22 · `REQUIREMENTS:` · Claude Opus 5.5

> REQUIREMENTS: todo_cli — a tiny command-line to-do list: add a task, list tasks, mark a
> task done; tasks are kept in a JSON file

Reply summary: Wrote Part 1 with S1–S10 (add, list, done, errors, empty file) and four open
questions with suggestions.

---

## Prompt 2 — Plan

2026-11-22 · `PLAN:` · Claude Opus 5.5

> PLAN: .specs/features/2026_11_22_todo_cli_spec.md

Reply summary: Wrote Part 2: Steps 0–4 covering S1–S13 and decisions D1–D7.

---
```

### Costs

The `cost` block — written once by the first `GENERATE KIT`, then changed by hand:

```json
"cost": { "enabled": true, "plan": "Copilot Business", "monthly_price_usd": 19,
          "monthly_credits": 1900, "currency": "CHF", "rate": 0.8384, "rate_date": "2026-11-13" }
```

| You want | In your `.specs/spec-nx.local.json` |
|----------|-------------------------------------|
| no costs for you | `{ "version": 1, "cost": { "enabled": false } }` |
| another currency | `{ "version": 1, "cost": { "currency": "EUR", "rate": 0.92, "rate_date": "2026-11-20" } }` |
| another plan | `{ "version": 1, "cost": { "plan": "Copilot Pro+", "monthly_price_usd": 39, "monthly_credits": 3900 } }` |

Each stage measures itself with `tools/usage` and writes the result into its Stage log row:

```
Tokens: 2.92 M (133 k in · 2.77 M cached · 17 k out)
Cost: CHF 1.31 (157 credits, 8.2 % of Copilot Business)
Source: measured from ~/.copilot/session-state/<session>/events.jsonl · 19 requests · Claude Opus 5.5
```

**Measured** (Copilot CLI, Claude Code: the tokens and credits the tool logged) or
**estimated** (VS Code Copilot chats, marked `~`: counted from the text of the chat, can be
several times too low). A cost summary that mixes both says so. How and why:
[stages/COSTS.md](../stages/COSTS.md).

**Two chats at the same time** (two editor windows, or an editor and Claude Code) on the same
project: each command writes a marker into its chat at its start —
`spec-nx run 20261122-0926-kqzt` — and passes it to `usage`, so only its own chat is counted:

```
pwsh <kit>/tools/usage.ps1 -Since "2026-11-22 09:26" -Model "Claude Opus 5.5" -Run 20261122-0926-kqzt
```

Without the marker, `usage` stops when it finds more than one chat with requests in the time
range and lists them — it never takes the other chat's cost. You can also name the log:
`-Transcript <file>`.
