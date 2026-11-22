# Settings Layers and Prompt Log Spec

> **Author:** Martin Nordio
> **Status:** ⬜ Not started — plan ready
> **Created:** 2026-11-22
> **Last updated:** 2026-11-22
> **Branch:** `feature/settings-layers-and-prompt-log`

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../stages/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-22 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | 1.25 M (317 k in · 925 k cached · 7 k out) | CHF 1.60 (191 credits) | Part 1 written; open questions Q1–Q5 (measured from the Copilot CLI session log) |
| 2026-11-22 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | 1.30 M (326 k in · 965 k cached · 5 k out) | CHF 1.61 (192 credits) | Part 1 revised: Q1–Q5 answered (S1, S5, S13, S18); Copilot CLI costs spec finished here (S21–S24); customizing page (S25–S27) |
| 2026-11-22 | plan | `PLAN:` | Claude Opus 5.5 | 5.29 M (379 k in · 4.90 M cached · 16 k out) | CHF 2.67 (319 credits) | Part 2 written: 6 Steps, D1–D9 |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 11.04 M (50 k in · 10.96 M cached · 38 k out) | CHF 2.68 (320 credits) | Step 1 done |
| 2026-11-22 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 10.79 M (38 k in · 10.73 M cached · 31 k out) | CHF 2.47 (295 credits) | Step 2 done |

---

# Part 1 · Requirements

## Context

A shared kit (a company's kit repository) is used by several projects, and each project by
several developers. Today a developer cannot adapt the settings to their own work — another
parent feature, only the requirements stage, their own backlog area — without changing the
committed file for everyone. Backlog items are created without area, iteration or assignee,
and GitHub issues without type, assignee or parent, so they must be fixed by hand afterwards.
There is also no record of the prompts that shaped a spec, which a colleague keeps by hand
(see the example below). Finally, two chats working on the same project at the same time can
get each other's cost.

**Already in the repository:**
- `generator/questions.md` defines two settings files: the project's `.specs/spec-nx.json`
  (committed) and the developer's `.specs/spec-nx.local.json` (git-ignored). The local file
  may hold only `shell`, `stages` / `on_demand` / `model` (personal kit only), `models` and
  `cost`. `work_items` (Azure DevOps `org` / `project`) and `parent` are optional project keys
  set by hand.
- A shared kit's own `.specs/spec-nx.json` gives the defaults that the generator writes into
  the prompts ("a using project's own `.specs/spec-nx.json` still wins",
  `generator/prompt.md`, step 5). Example: a company's kit has all keys, with
  `work_items` project `ai-solutions`; a project that uses it has only `work_items` (project
  `product-x`), `parent` and `cost`.
- `stages/tools/azure_devops/create_issue.*` and `update_issue.*` create and update backlog
  items (type, title, description, parent); `stages/tools/github/` does the same for GitHub
  issues (title, body).
- `stages/tools/usage.*` measures a command's tokens and cost; without `-Transcript` it takes,
  of all logs of the project written since the start time, the one with the **most requests**
  in the range.
- `.specs/features/2026_11_21_copilot_cli_costs_spec.md` (Copilot CLI costs measured, no
  silent N/A) is implemented on `main` for S1–S9 and S11 but **not closed**: S10 (checks in
  `testing/`) and S12 (`costs_ledger` without false gaps) are open, and so is its question
  about mixing measured and estimated numbers. It is finished and closed with this spec.
- Documentation: `README.md` (section *Project and developer settings* names the two files),
  `docs/configuration.md` (the two settings files, `models`, `cost`, other settings) and
  `docs/tutorials/` (angular, python, git-host).
- The colleague's prompt history: a Markdown file with a short intro, then per prompt
  `Prompt <n> — <title>`, the prompt quoted, and `Reply summary: …`, separated by `---`.

**New:**
- Three layers of settings with clear rules for which one wins; more work-item fields for
  Azure DevOps and GitHub; an optional prompt log per spec; cost measured only for the chat
  that runs the command; the Copilot CLI costs spec finished; one easy page that explains how
  to customize all of it.

## 1 · Specs

**Settings in three layers**

- **S1 — Three layers:** the settings a stage uses come from up to three files, in this
  order, each one winning over the one before: the **kit's** settings (a shared kit's
  `.specs/spec-nx.json`), the **project's** `.specs/spec-nx.json` (committed), and the
  **developer's** `.specs/spec-nx.local.json` (never committed). A project or developer file
  may contain only the keys it changes or adds. A project that uses a shared kit from another
  repository (`<kit_ref>/`, for example `.spec-kit/`) reads the kit's settings from
  `<kit_ref>/.specs/spec-nx.json` when a stage runs, so a change of the kit's settings needs no
  regeneration in the project.
- **S2 — Merge rule:** a key in a later layer replaces the same key of the earlier one; an
  object (such as `work_items`, `cost`, `models`) is merged key by key; a list (such as
  `stages`) is replaced as a whole; `null` removes the key. The rule is written once in
  `generator/questions.md` and every stage and script follows it.
- **S3 — Any project key, locally:** every key a project may set can also be set by a
  developer — for example `parent` for another feature, `work_items` for another area, or
  `"stages": ["requirements"]` to work only on requirements. Only the keys that describe the
  generated kit itself (`version`, `spec_nx_version`, `generated`, `kit`, `kit_dir`,
  `kit_ref`, `kit_files`) stay project-only; a developer value for them is ignored with a
  warning.
- **S4 — Fewer stages locally:** with fewer `stages` in a developer's file, the commands of
  the other stages answer that they are turned off in that developer's settings (naming the
  file) and do nothing; the stages still on work as before. The committed kit and the other
  developers are not affected.
- **S5 — Settings shown:** no new command: the report of `GENERATE KIT --update` shows the
  resulting settings with, for each key, the layer it comes from; every stage's report names
  the layer of each setting it used that does not come from the kit (for example *parent
  150310 — from `.specs/spec-nx.local.json`*).
- **S6 — Old files still work:** existing settings files load unchanged and give the same
  result as today.

**Backlog items and issues**

- **S7 — Azure DevOps fields:** `work_items` may also set `area` (area path), `iteration`
  (iteration path) and `assigned_to`. `CREATE ISSUE:` fills them on the new backlog item;
  without them, Azure DevOps' defaults stay as today.
- **S8 — Assigned to me by default:** without `assigned_to`, a new backlog item or issue is
  assigned to the person who creates it ("me", the signed-in user of the git host);
  `"assigned_to": null` leaves it unassigned; another value names a person (Azure DevOps:
  e-mail; GitHub: login).
- **S9 — GitHub issue type:** for GitHub, `work_items` may set the issue `type` (for example
  Bug, Task, Feature — the types the repository or organization offers). Without it the issue
  has no type, as today.
- **S10 — GitHub parent:** `CREATE ISSUE:` on GitHub can put the new issue under a parent
  issue (from the command, the spec header's `Parent:` or the `parent` setting, as for Azure
  DevOps), and the spec header shows it.
- **S11 — Checked before creating:** an unknown area, iteration, person, issue type or parent
  stops `CREATE ISSUE:` with a message naming the setting and its layer; the dry run shows
  every field it would set.

**Prompt log**

- **S12 — Off by default:** a setting `prompt_log` turns the prompt log on. It is `false` by
  default; `GENERATE KIT` does not ask for it; a developer (or a project) sets it by hand in
  their settings layer (S1).
- **S13 — One file per spec:** with the prompt log on, every prompt the user gives to a stage
  command on a spec is added to `.specs/prompts/<yyyy_mm_dd>_<name>_prompt.md`, named after
  the spec `<yyyy_mm_dd>_<name>_spec.md`. The file is created with the spec's first prompt —
  also the `REQUIREMENTS:` prompt that creates the spec. The prompt files are committed with
  the spec; a developer who keeps them private adds `.specs/prompts/` to their own
  `.git/info/exclude`.
- **S14 — Format:** the file starts with a title and one sentence about the spec; then, per
  prompt: `Prompt <n> — <short title>`, the date, the command and the model, the prompt
  quoted exactly as given (`>` lines), and `Reply summary:` in two or three sentences;
  prompts are separated by `---`, as in the colleague's example.
- **S15 — Other prompts:** prompts that belong to no spec (for example `GENERATE KIT`,
  questions about the project) go to another file in the same folder, one per day:
  `.specs/prompts/<yyyy_mm_dd>_other_prompt.md`.
- **S16 — No secrets:** passwords, tokens and keys in a prompt are written as `«redacted»`.
- **S17 — Off means nothing:** with the prompt log off, no file in `.specs/prompts/` is
  created or changed.

**Cost of parallel chats**

- **S18 — Only this chat:** `usage` counts only the chat that runs the command, also when
  other chats (another VS Code window, Claude Code, the Copilot CLI) work on the same project
  at the same time. If it cannot tell which log belongs to the running chat, it stops with an
  error that lists the candidate logs and how to pass the right one — it never takes another
  chat's requests. To find its chat, each command writes a unique marker (for example
  `spec-nx run <id>`) into the chat at its start, and `usage` takes the log that contains it.
- **S19 — Shown in the result:** the `Source:` line names the log used, so a reader can see
  which chat was counted.

**Finish the Copilot CLI costs spec**

- **S21 — Its checks (its S10):** the `testing/` checks include a small Copilot CLI log
  sample (with a sub-agent and two models), a sample from another workspace, an empty range
  and, for S18, two chats of the same project at the same time; they pass for both scripts.
- **S22 — Cost list without false gaps (its S12):** `costs_ledger` shows a row whose cells say
  `included in <spec>` as included (not `N/A`), and shows measured numbers without `~`.
- **S23 — Measured and estimated apart (its open question):** the Cost summary of a spec and
  `costs.md` mark estimated numbers with `~` and measured ones without; when a spec or the
  list mixes both, a one-line note under the table says so and links `COSTS.md`.
- **S24 — Closed:** `2026_11_21_copilot_cli_costs_spec.md` is closed (Closing summary, Cost
  summary, moved to `done/`) with a pointer to this spec for S10 and S12.

**Documentation**

- **S25 — Customizing on one page:** a page `docs/customize.md` explains how to customize
  spec-nx, with the most important points first: the three layers and which one wins (with a
  small example of each file and the result), then how to change only what you need. It is
  reference documentation, easy to scan (short sections, tables, copy-paste examples), not a
  step-by-step tutorial.
- **S26 — Examples on the page:** it has ready-to-copy examples for: a developer working
  under another parent and only on requirements; Azure DevOps with area, iteration and
  assignee; GitHub with issue type, assignee and parent; turning the prompt log on, with a
  short sample of a prompt file; costs — the `cost` block, a developer turning cost tracking
  off or using another currency, a sample `usage` result (measured and estimated), and how to
  measure one chat when two run in parallel.
- **S27 — Easy to find:** the README highlights near the top that spec-nx can be customized
  per project and per developer and links the page; the README's *Project and developer
  settings* section, `docs/configuration.md`, `generator/questions.md` and
  `docs/tutorials/git-host.md` describe the three layers and the new keys the same way and
  link the page instead of repeating it.

**Keep working**

- **S20 — Contract kept:** the commands, the spec format, the scripts' names and existing
  parameters, and the layout of the kit stay as they are (`generator/prompt.md`, *The
  contract every kit keeps*); new settings and parameters are optional. Both shells
  (PowerShell and bash) get every change.

### Open questions

_None open._ Answered on 2026-11-22: Q1 → S1 (kit settings read at run time), Q2 → S13
(prompt files committed), Q3 → S13 (first prompt in the spec's file), Q4 → S5 (no new
command), Q5 → S18 (a marker in the chat). The Copilot CLI costs spec's open question → S23.

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **1** | Settings in three layers | ✅ Done | [→ Step 1](#step-1--settings-in-three-layers) |
| **2** | Backlog item and issue fields | ✅ Done | [→ Step 2](#step-2--backlog-item-and-issue-fields) |
| **3** | Prompt log | ⬜ Not started | [→ Step 3](#step-3--prompt-log) |
| **4** | Cost of this chat only | ⬜ Not started | [→ Step 4](#step-4--cost-of-this-chat-only) |
| **5** | Finish the Copilot CLI costs spec | ⬜ Not started | [→ Step 5](#step-5--finish-the-copilot-cli-costs-spec) |
| **6** | Customizing page, documents and final check | ⬜ Not started | [→ Step 6](#step-6--customizing-page-documents-and-final-check) |

> **Step completion protocol (required):** every time a Step is finished, in the same edit:
> 1. Tick its tasks `[x]` **and** set its row in this table to ✅ Done.
> 2. Append a **`**Done (YYYY-MM-DD · ~<duration> · <model>)**`** line to that Step's
>    **Notes**: date, time it took, the AI model that did the work, a one-line summary and
>    the verifying test/command result; with cost tracking on, end it with
>    `· <tokens> · <currency> <amount>` from the `usage` script.
>
> The table and the Step sections must **always agree**.

> **Time tracking (required for every Step):** each Step's **first task** is
> `Record the start time in Notes` (e.g. `Started: YYYY-MM-DD HH:MM`); the Done line records
> the finish and the duration.

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | The three layers are read by one helper per shell, `stages/tools/settings.ps1` / `settings.sh`, that every script uses (`usage`, `costs_ledger`, the git-host scripts); it returns the merged settings and, per key, the file it came from | One place for the merge rule (S2); the scripts stop reading `.specs/spec-nx.json` each in its own way |
| D2 | The kit layer is the `.specs/spec-nx.json` next to the kit's folder: `<kit>/.specs/spec-nx.json`, where `<kit>` is the folder above `tools/` (a kit used as a submodule is a repository with its own settings). When it is the project's own file, it counts once | Works for `.specs/kit/` and for a shared kit in `.spec-kit/` without a new setting (S1, Q1) |
| D3 | The stage prompts get the rule from a **Settings** section of the kit's `README.md` (always in the kit) and a short **Settings** paragraph in every stage prompt; no new kit file | The kit's layout stays as in the contract (S20) |
| D4 | Kit-structure keys that stay project-only: `version`, `spec_nx_version`, `generated`, `kit`, `kit_dir`, `kit_ref`, `kit_files`, `shells`, `model` (of a shared kit) | They describe the generated kit, which a developer does not change locally (S3) |
| D5 | `settings.sh` uses `python3`, like `usage.sh` and `costs_ledger.sh`; the Azure DevOps bash scripts need it too from now on (documented) | `jq` cannot track which file a key came from as simply; one dependency for all bash tools |
| D6 | Azure DevOps "me" is the signed-in identity of the REST login (`_apis/connectionData`); GitHub "me" is `@me` of `gh`. Area and iteration are checked through the classification-nodes API, a person through the identities API, a GitHub type through the organization's issue types | The checks of S11 use the same login as the scripts |
| D7 | The chat marker is `spec-nx run <yyyymmdd-hhmm>-<4 random letters>`, written by the stage into its chat at the start and given to `usage` as `-Run` / `--run`; without `-Run`, `usage` accepts only a single project log with requests in the range | Unique, short, and found in every kind of log (VS Code, Copilot CLI, Claude Code) (S18, Q5) |
| D8 | The `usage` and `costs_ledger` checks (S21, S22) are committed in `testing/usage/` (sample logs and `check_usage.ps1` / `.sh`); `.gitignore` keeps the rest of `testing/` local | Checks a reviewer can run again; the samples hold no real data |
| D9 | The prompt log rule (format, file names, `«redacted»`) lives in the kit's README section **Prompt log**, and each stage's Settings paragraph says to follow it when `prompt_log` is on | One description, every stage applies it (S12–S17) |

---

## Step 1 — Settings in three layers

### Goal
Every stage and script uses the kit's, the project's and the developer's settings with one
merge rule, and a developer can change any project key, including fewer stages (S1–S6, S20).

### Tasks
- [x] Record the start time in Notes below.
- [x] `stages/tools/settings.ps1` / `settings.sh`: find the three files (D2), merge them (S2:
      later wins, objects key by key, lists whole, `null` removes), ignore project-only keys
      from the developer file with a warning (D4), return the settings and the file of each key.
- [x] `usage.*`, `costs_ledger.*`, `azure_devops/ado.*` and the GitHub scripts read their keys
      through the helper.
- [x] `stages/kit_readme.md`: section **Settings** (the three files, the rule, project-only
      keys, how a stage turns itself off with fewer `stages`, what the report names).
- [x] Every stage prompt: a **Settings** paragraph (D3) — read the three layers; stop with
      *"<stage> is turned off in <file>"* when the stage is not in `stages` / `on_demand`;
      name in the report each setting used that does not come from the kit.
- [x] `generator/questions.md`: the three layers, the merge rule and the keys a developer may
      set; `generator/prompt.md`: copy `tools/settings.*` with any tool, the prompts read the
      kit's settings at run time (Q1), and the `--update` report shows each key's layer (S5).
- [x] Check: both helpers give the same merged result and sources on sample files (three
      layers; objects; lists; `null`; a project-only key in the local file; old files with one
      or two layers give today's result, S6); `usage` and `costs_ledger` give the same output
      as before on this repository.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 09:29

**Done (2026-11-22 · ~7m · Claude Opus 5.5)** — `stages/tools/settings.ps1` / `settings.sh` (kit layer next to the kit's folder, merge rule, project-only keys with a warning, value and source per key; run them to show every setting with its file); `usage`, `costs_ledger` and the Azure DevOps helpers read through them (bash: the wrapper reads the settings and passes them to python); a **Settings** section in the kit README template and in every stage prompt (turn off with fewer `stages`, name the settings used), `models.md`, `tools/README.md`, `generator/questions.md` (*Three layers*) and `generator/prompt.md` (copy `settings.*`, kit layer at run time, `--update` shows each key's layer). Checks: both helpers give the same output on a three-layer project (object merge, list replace, `null`, a project-only key ignored with a warning) and on a one-layer project; `usage` and `costs_ledger` (both shells) give byte-identical output to `main` on this repository; the Azure DevOps project comes from the merged layers in a real Azure DevOps project; `check_all` shows no new problem · 11.04 M · CHF 2.68

---

## Step 2 — Backlog item and issue fields

### Goal
`CREATE ISSUE:` sets area, iteration and assignee on Azure DevOps and type, assignee and
parent on GitHub, checks them first and shows them in the dry run (S7–S11).

### Tasks
- [x] Record the start time in Notes below.
- [x] `azure_devops/create_issue.*`: `area`, `iteration`, `assigned_to` from `work_items`
      (or `-Area`, `-Iteration`, `-AssignedTo`); default assignee the signed-in user, `null`
      unassigned (D6); check area, iteration and person before creating; the dry run lists
      every field with the file it came from.
- [x] `github/create_issue.*`: `type` and `assigned_to` from `work_items` (or `-Type`,
      `-AssignedTo`), default `@me`, `null` unassigned; check the type and the parent first;
      the dry run lists every field.
- [x] `stages/requirements/prompt.md` (CREATE ISSUE) and `stages/tools/README.md`: the new
      keys and parameters, the parent from the command, header or `parent` for both hosts.
- [x] `generator/questions.md`: `work_items` keys per host (`org`, `project`, `area`,
      `iteration`, `assigned_to`; `type`, `assigned_to`).
- [x] Check: dry runs on this repository (GitHub) and on an Azure DevOps test project (with and
      without each key, an unknown area / type stops with the setting and its file); both
      shells parse.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
Started: 2026-11-22 09:36

**Done (2026-11-22 · ~7m · Claude Opus 5.5)** — Azure DevOps `create_issue.ps1` / `.sh`: area, iteration and assignee from the options or `work_items` (default the signed-in user from `connectionData`, `null` / `-Unassigned` nobody), each checked first (classification nodes, identities, parent), the dry run lists every field with its file; GitHub `create_issue.ps1` / `.sh`: type (organizations only, checked against the organization's issue types) and assignee (default `@me`, checked as assignable), set after creation; `settings.*` got `-Source` / `--source` so `null` (nobody) differs from unset (you); requirements prompt (CREATE ISSUE), `tools/README.md` and `generator/questions.md` document the keys. Checks on a real Azure DevOps project, both shells with the same output: defaults (parent title, assigned to me), area and iteration paths (accepted), an unknown area and an unknown person (stopped with the option or setting and its file), `iteration` and `assigned_to: null` from the developer's file; on this GitHub repository: default `@me`, a parent, a type on a user account (refused with the reason), an unknown login (refused) · 10.79 M · CHF 2.47

---

## Step 3 — Prompt log

### Goal
With `prompt_log` on, each stage keeps its prompts in `.specs/prompts/`, one file per spec and
one per day for the rest; off, nothing is written (S12–S17).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `stages/kit_readme.md`: section **Prompt log** — the setting (default `false`, not
      asked), file names, the format of the colleague's example (title, `Prompt <n> — <title>`,
      date · command · model, the prompt quoted, `Reply summary:`, `---`), the other-prompts
      file, `«redacted»`, committed (`.git/info/exclude` to keep it private).
- [ ] Every stage prompt's Settings paragraph: with `prompt_log` on, add the prompt as the
      README says (the first `REQUIREMENTS:` prompt goes into the new spec's file).
- [ ] `generator/questions.md`: `prompt_log` (not asked, default `false`, any layer);
      `generator/prompt.md`: never asks it, never writes it.
- [ ] Check: on a scratch project with `prompt_log` on in the developer file, two stage
      commands on one spec and one other command write the two files in the format; with it
      off, `.specs/prompts/` is not created.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 4 — Cost of this chat only

### Goal
`usage` counts only the chat that runs the command, also with other chats on the same project
at the same time, and names the log it used (S18, S19).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `usage.ps1` / `usage.sh`: `-Run` / `--run` (D7) — the log that contains the marker;
      without it, an error when more than one project log has requests in the range, listing
      them with their request counts and how to pass `-Run` or `-Transcript`.
- [ ] `stages/COSTS.md` and every stage prompt's *Tokens and cost* lines: write the marker at
      the start, pass it at the end; `stages/tools/README.md`: the parameter and the error.
- [ ] Check: two sample logs of the same project in the same range — without `-Run` an error
      naming both; with `-Run` the right one; a single log works as before; both shells give
      the same numbers.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 5 — Finish the Copilot CLI costs spec

### Goal
The open parts of `2026_11_21_copilot_cli_costs_spec.md` are done and that spec is closed
(S21–S24).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `testing/usage/` (D8): sample logs (Copilot CLI with a sub-agent and two models, another
      workspace, empty range, two parallel chats) and `check_usage.ps1` / `.sh` that run both
      `usage` scripts and `costs_ledger` on them; `.gitignore` and `testing/README.md` updated.
- [ ] `costs_ledger.*`: `included in <spec>` counted as included (not `N/A`); measured numbers
      without `~`; a note under a table that mixes measured and estimated numbers (S22, S23).
- [ ] `stages/COSTS.md` and `stages/implementation/prompt.md` (Cost summary): `~` only on
      estimated numbers, the mixed note (S23).
- [ ] Close `2026_11_21_copilot_cli_costs_spec.md`: S10 and S12 point to this spec, Closing
      summary, Cost summary, local paths removed, moved to `done/` (S24).
- [ ] Check: both `check_usage` scripts pass; `costs_ledger` on this repository shows the
      included rows and the note.

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 6 — Customizing page, documents and final check

### Goal
One easy page explains how to customize spec-nx, the README points to it, and everything that
worked before still works (S25–S27, S20).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] `docs/customize.md` (S25, S26): most important first — the three layers with a small
      example of each and the result; then examples to copy: another parent and only
      requirements; Azure DevOps area, iteration, assignee; GitHub type, assignee, parent;
      the prompt log with a sample file; costs (the block, turning it off, another currency, a
      measured and an estimated `usage` result, two chats in parallel).
- [ ] `README.md`: a highlighted line near the top and the *Project and developer settings*
      section link the page; `docs/configuration.md`, `generator/questions.md`,
      `docs/tutorials/git-host.md` describe the layers the same way and link it (S27).
- [ ] Check: `testing/check_all.ps1` (links, scripts parse and ASCII, no company names) shows
      no new problem; `testing/usage/check_usage.*` pass; the contract items of
      `generator/prompt.md` are unchanged (S20).

### Notes
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|-------------|

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|

---

## Definition of Done

- [x] Requirements · Part 1 agreed (statements testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [ ] Implementation · every Step's tasks checked
- [ ] Documentation · affected docs updated
- [ ] Review · semantic diff and code review; findings routed
- [ ] Spec closed · moved to `.specs/features/done/`
- [ ] Pull request · opened with the spec summary; reviewed; merged; branch deleted
