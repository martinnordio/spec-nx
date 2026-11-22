# Setup questions

The generator (`GENERATE KIT`) asks these questions to decide which kit to write into a
project. For each question it first **scans the repository** (and the computer) and
**suggests** an answer; the user confirms or changes it.

Answers are saved at two levels, so `GENERATE KIT --update` never asks them again — only
questions whose key is missing (questions added to spec-nx later). `GENERATE KIT --update
--force` asks them all again, with the saved answers as suggestions:

| Level | File | Shared? | Holds |
|-------|------|---------|-------|
| **Project** | `.specs/spec-nx.json` | Committed; the same for the whole team | What the project is and how the team works: project start, languages, stages, git host, issues, the shells the kit supports |
| **Developer** | `.specs/spec-nx.local.json` | Ignored by git; one per developer | How *you* work: your shell; any project key you want different for you |

### Three layers

When a stage or script runs, it reads up to three files, each winning over the one before:

| Layer | File | When |
|-------|------|------|
| **Kit** | `<kit>/.specs/spec-nx.json` — the settings of the kit's own repository | Only when the kit is a repository of its own (a shared kit added as a submodule, `kit_ref`); read when a stage runs, so a change there needs no regeneration in the projects |
| **Project** | `.specs/spec-nx.json` | Always |
| **Developer** | `.specs/spec-nx.local.json` | Always (never committed) |

**Merge rule:** a file holds only the keys it changes or adds. A key replaces the same key of
an earlier layer; an object (`work_items`, `cost`, `models`) is merged key by key; a list
(`stages`, `languages`) is replaced as a whole; `null` removes the key.

**Project-only keys:** `version`, `spec_nx_version`, `generated`, `kit`, `kit_dir`, `kit_ref`,
`kit_files`, `shells` (and `model`, unless the kit is personal) describe the generated kit and
are read from the project's file only; in the developer's file they are ignored with a
warning. Every other key may be set in any layer — for example `parent`, `work_items` or
`"stages": ["requirements"]` for one developer. With fewer `stages`, the other stages answer
that they are turned off in that file.

`tools/settings.ps1` / `settings.sh` of the kit apply the rule for the scripts and show every
setting with the file it comes from. Examples: `docs/customize.md` in spec-nx.

The questions are **asked in the order of this table**:

| # | Question | Level | Key | Default |
|---|----------|-------|-----|---------|
| Q5 | Company layer — use one? (asked first: its defaults feed every suggestion) | project | `layer` | the layer found, or `null` |
| Q0b | Languages — which programming languages? | project | `languages` | from the scan |
| Q0c | Write a project setup spec? (new projects only) | project | `project_spec` | yes |
| Q1 | Workflow — which stages do you use? | project | `stages` | Simple: `["requirements", "plan", "implementation", "pr"]` |
| Q1b | On-demand stages — which extra commands do you want? | project | `on_demand` | `[]` |
| Q2 | Git host — where is the repository? | project | `git_host` | from the `origin` remote |
| Q2b | Keep each spec in sync with an issue / backlog item? | project | `link_issues` | `true` if there is a git host |
| Q4 | Share the kit with the team, or keep it personal? | project | `kit` | `"shared"` |
| Q4b | Kit folder — where should the kit go? | project | `kit_dir` | `".specs/kit"` |
| Q4c | Kit used from other repositories — under which folder? (only when `kit_dir` is not the default) | project | `kit_ref` | `kit_dir` |
| Q6 | AI agent permissions — for which agents? | project | `agent` | the agents found |
| Q7 | Model per Step — should spec-nx choose the model? | project | `models` | per Step, with the default mapping |

Not a question: the **`cost` block** (tokens and price of every stage) is written with its
defaults by the first `GENERATE KIT` and changed by hand — see [The `cost` block](#the-cost-block).

Not asked either, taken from the repository or the computer and changed by hand for special
cases: [new or existing project](#q0--project-start-not-asked), [your shell](#your-shell-developer-not-asked), and on Azure DevOps the
[backlog item type](#backlog-item-type-azure-devops-not-asked) and the
[backlog project](#backlog-project-azure-devops-not-asked).

New questions get the next number and their own key; existing keys never change meaning.

In this file `.specs/kit/` stands for the kit folder, `kit_dir` (Q4b).

---

## Q5 · Company layer

Asked first, but only when a layer is found or the user names one.

**Ask:** *I found the layer `<name>` in `<path>`. Use its defaults and rules?*

| Option | `layer` |
|--------|---------|
| Yes | the path of the layer folder, relative to the project root (e.g. `".my-kit/layer"`) |
| No | `null` |

**Suggest from the repository:** a folder with a `layer.json`, at most three levels deep,
including submodules (for example `.my-kit/layer/`); ignore `.spec-nx/`, `node_modules/`
and virtual environments. With none found, the question is not asked and `layer` is `null`.

**Effect:** see [layer.md](layer.md) — `defaults.json` becomes the suggestion of every
later question (the scan of the repository still wins), and the layer's blocks are added to
the kit.

---

## Q0 · Project start (not asked)

The generator decides from the scan and **states it** in its scan summary, without asking:
*"Only README and LICENSE found: treating this as a new project — say 'existing' if not."*
The user can still correct it before the questions start.

| Found | `project` |
|-------|-----------|
| Nothing but a README, LICENSE, `.git*` files, `.specs/` and git submodules (such as `.spec-nx/`) | `"new"` |
| Anything else ("Python package in `src/`, 40 files") | `"existing"` |

Saved in `.specs/spec-nx.json`; to change it later, edit `project` by hand.

**Effect:** with `"new"`, Q0b is asked openly and the project setup spec (Q0c) is offered
after the kit is generated (see the generator).

---

## Q0b · Languages

**Ask:** *Which programming languages does the project use?* (several allowed)

**Options:** `python`, `typescript`, `javascript`, `svelte`, `powershell`, `bash`, or any other
language name in lower case. Frameworks (FastAPI, React, …) are not languages — they are asked
by the project setup spec.

**Suggest**

| `project` | Suggests |
|-----------|----------|
| `"existing"` | the languages of the source files and build files found (`pyproject.toml` → `python`, `package.json` + `.ts` → `typescript`, `.svelte` → `svelte`, `*.ps1` → `powershell`, `*.sh` → `bash`), most used first; ignore `.specs/` and submodules |
| `"new"` | nothing — ask openly; one short example list helps ("e.g. python, or python + typescript") |

**Selects:** `stages/guidelines/prompt.md` and the baselines `stages/guidelines/<language>.md`
→ `.specs/kit/guidelines/`, for each language that has one.

---

## Q0c · Project setup spec

Asked only when `project` is `"new"`.

**Ask:** *Should I write a first spec that sets up the project — a skeleton in your languages
that runs and has one passing test?*

| Option | `project_spec` |
|--------|----------------|
| Yes | the file name of the spec, once written |
| No | `false` |

**Suggest:** yes.

**Effect:** after the kit is generated, the generator asks the framework, package manager and
test tools per language and writes the spec, following `stages/setup/project_spec.md`. The
answer is saved so `--update` never asks again or writes a second spec.

---

## Q1 · Workflow

**Ask:** *Which workflow do you want?*

| Option | `stages` | For |
|--------|----------|-----|
| **Simple** (default) | `["requirements", "plan", "implementation", "pr"]` | Small teams, data science: a spec, small Steps, a pull request |
| **Full** | `["requirements", "plan", "implementation", "documentation", "review", "pr"]` | Product code: also documents and a semantic diff for the reviewer |
| **Custom** | your choice, one stage at a time | Anything else |

**Custom** asks one short question per stage, in this order, and shows the rule:

```
requirements: yes (always)
plan:          yes / no
implementation: yes / no   (only if plan is yes)
documentation: yes / no
review:        yes / no    (only if implementation is yes)
pr:            yes / no
```

**Rules**

- `requirements` is always included.
- `plan` needs `requirements`; `implementation` needs `plan`; `review` needs `implementation`.
  A stage whose prerequisite is "no" is not asked.
- `documentation` and `pr` can be added to any set.
- The list is kept in this order: requirements, plan, implementation, documentation, review, pr.

If the user picks a stage that spec-nx does not have yet, the generator says so, keeps it out
of the kit and does not save it — it is offered again by `--update` once it exists.

**Suggest from the repository**

| Found | Suggests |
|-------|----------|
| `.specs/spec-nx.json` | its `stages` (this is an update) |
| `.specs/architecture.md` or `.specs/decisions/` | Full |
| Nothing of the above | Simple |

**Selects:** each stage folder `stages/<stage>/` → `.specs/kit/<stage>/`; the skills those
stages load (`stages/skills/<skill>.md` → `.specs/kit/skills/`, see each prompt's *Skills to
load*); the spec template `stages/spec_template.md` → `.specs/kit/spec_template.md`.

---

## Q1b · On-demand stages

**Ask:** *Do you also want these commands? They are used now and then, not for every feature.*

| Stage | Commands | Useful when |
|-------|----------|-------------|
| `improvement` | `IMPROVE:` | After a few merges: a clean-up spec that never changes behaviour |
| `setup` | `SETUP TOOLING:`, `SETUP MACHINE` | Bringing linters, tests, CI or a developer's computer up to date |
| `ui` | `LOOK:`, `UI CATALOG` | The project has a user interface |

`on_demand` is a list of these names, possibly empty.

**Suggest from the repository:** `ui` when a UI framework is found (`.svelte`, `.tsx`, `.vue`,
HTML templates); `setup` when `project` is `"new"`; `improvement` when `review` is in
`stages`.

**Selects:** `stages/<stage>/` → `.specs/kit/<stage>/` and the skills they load, like Q1.

---

## Q2 · Git host

**Ask:** *Where is the repository hosted?*

| Option | `git_host` |
|--------|------------|
| GitHub | `"github"` |
| Azure DevOps | `"azure_devops"` |
| None, or another host | `"none"` |

**Suggest from the repository:** `git remote get-url origin`

| Remote contains | Suggests |
|-----------------|----------|
| `github.com` | `"github"` |
| `dev.azure.com` or `visualstudio.com` | `"azure_devops"` |
| no remote, or another host | `"none"` |

Organisation, project and repository names are read from the remote each time the tools run;
they are not saved.

**Needs**

- GitHub: the GitHub CLI `gh`, logged in (`gh auth status`).
- Azure DevOps: an https `origin` remote and a git login (the one `git fetch` / `git push` use,
  through Git Credential Manager) — no token to create. Optional: a personal access token in
  `AZURE_DEVOPS_EXT_PAT` (never written to a file), used instead when set, e.g. in CI. The
  bash scripts also need `curl` and `jq`.

**Selects:** the tools for the host, `stages/tools/<git_host>/` → `.specs/kit/tools/<git_host>/`
(with the shared `spec_summary` script and `README.md` in `.specs/kit/tools/`, the same layout as
in spec-nx, so the stage prompts' relative paths work in both), in
every shell listed in the project's `shells` (see [Your shell](#your-shell-developer-not-asked)), when `pr` is in `stages` or
`link_issues` is `true`. With `"none"`, the `pr` stage only explains the manual steps and no
tools are copied.

---

## Q2b · Keep specs in sync with issues

Asked only when `git_host` is not `"none"`.

**Ask:** *Should each spec be linked to an issue (GitHub) or backlog item (Azure DevOps), and
its description kept in sync with the spec?*

| Option | `link_issues` |
|--------|---------------|
| Yes | `true` |
| No | `false` |

**Suggest from the repository:** `true` when commit messages mention issues (`#<n>` on GitHub,
`AB#<n>` on Azure DevOps); otherwise `true` as the default.

**Effect**

- The spec header gets an `Issue:` / `Backlog item:` line, and optionally a `Parent:` line.
- When the requirements of a spec are finished, the requirements stage asks whether to create
  the issue / backlog item (`CREATE ISSUE:`, optionally under a parent); `UPDATE ISSUE:` on
  request.
- Commit messages carry the reference (`#<n>` / `AB#<id>`, `guidelines/commits.md`).
- The pr stage always updates the issue / backlog item together with the pull request.

---

## Backlog item type (Azure DevOps, not asked)

`CREATE ISSUE:` creates a **Product Backlog Item** (the Scrum process). Nothing is asked and
nothing is saved. The parent (a Feature or Epic) is asked per spec, not here.

**Special case — another process:** add `work_item_type` to `.specs/spec-nx.json` by hand:

| Process | `work_item_type` |
|---------|------------------|
| Scrum (default) | `"Product Backlog Item"` |
| Agile | `"User Story"` |
| CMMI | `"Requirement"` |
| Basic | `"Issue"` |

The dry run of `CREATE ISSUE:` names the type. If Azure DevOps rejects it, the requirements
stage asks for the right one and offers to save it as `work_item_type`.

---

## Backlog project (Azure DevOps, not asked)

The backlog items are created and read in the repository's own organisation and project (from
`git remote get-url origin`, e.g. `https://dev.azure.com/<org>/<project>/_git/<repo>`).
Nothing is asked and nothing is saved.

**Special case — backlog items in another project:** add `work_items` to
`.specs/spec-nx.json` by hand:

```json
"work_items": { "org": "<org>", "project": "<project>" }
```

**More fields (optional, any layer):** `work_items` can also set the fields of a new backlog
item — `"area": "<project>\\<team>"`, `"iteration": "<project>\\<sprint>"` and
`"assigned_to": "<email>"`. Without `assigned_to` the item is assigned to the user who creates
it; `"assigned_to": null` leaves it unassigned. On GitHub, `work_items` can set
`"type": "<issue type>"` (Bug, Task, Feature … — organizations only) and
`"assigned_to": "<login>"` (default `@me`). `CREATE ISSUE:` checks every value before it creates
the item.

**Effect:** `CREATE ISSUE:` and `UPDATE ISSUE:` read and create the backlog items in this
project; pull requests stay in the repository's project and still link the item by its id
(ids are unique in the organisation). Without the key, the repository's project is used. Signing
in to another organisation needs a login or token for it. No regeneration needed: the scripts
read the key each time they run.

---

## Your shell (developer, not asked)

The generator takes it from the operating system: Windows → `"powershell"` (Windows
PowerShell 5.1 or PowerShell 7); macOS or Linux → `"bash"` (bash or zsh). Nothing is asked.

| `shell` | Runs in |
|---------|---------|
| `"powershell"` | Windows PowerShell 5.1 or PowerShell 7; Windows, also macOS / Linux |
| `"bash"` | bash or zsh: macOS, Linux, Git Bash on Windows |

**Special case — another shell** (for example Git Bash on Windows): set `"shell": "bash"` in
`.specs/spec-nx.local.json` and run `GENERATE KIT --update`, so the kit also gets the scripts
for that shell.

**Effect**

- Saved in `.specs/spec-nx.local.json` (developer level), unless it is already there; the
  generator adds that file to the project's `.gitignore`.
- It is also added to the project's `shells` list (if not there yet), so the kit contains the
  scripts for every shell the team uses. The stage prompts call the script for the
  developer's own `shell`.

---

## Q4 · Shared or personal kit

**Ask:** *Should the whole team use one kit, or should each contributor generate their own?*

| Option | `kit` | Effect |
|--------|-------|--------|
| Shared | `"shared"` | `.specs/kit/` is committed; Q1 and Q1b (stages) are project answers; everyone uses the same kit |
| Personal | `"personal"` | `.specs/kit/` is added to `.gitignore`; Q1 and Q1b become developer answers, so each contributor picks the stages for their role and generates the kit with their own AI model |

**Suggest from the repository:** `"shared"` if `.specs/kit/` is already committed;
`"personal"` if it is in `.gitignore`; otherwise the default.

Either way the specs in `.specs/features/` and the project settings are shared.

---

## Q4b · Kit folder

**Ask:** *Where should the kit go? Normally `.specs/kit/`. Choose another folder only when
this repository is itself a kit that other repositories add as a submodule.*

| Option | `kit_dir` |
|--------|-----------|
| Default | `".specs/kit"` |
| Repository root — this repository is the kit | `"."` |
| Another folder | the path relative to the project root |

**Suggest from the repository:** the layer's `kit_dir`, if any; otherwise the default.

**Effect:** the kit is written to `kit_dir`. Outside `.specs/kit/` the kit is always shared
(`kit` `"shared"`), and a regeneration deletes only the entries of `kit_files` (see
`generator/prompt.md`, step 5).

---

## Q4c · Kit used from other repositories

Asked only when `kit_dir` is not `".specs/kit"`.

**Ask:** *Do other repositories add this kit as a submodule? Under which folder?*

| Option | `kit_ref` |
|--------|-----------|
| No — only this repository uses it | the same as `kit_dir` |
| Yes | the submodule folder in those repositories, e.g. `".my-kit"` |

**Suggest from the repository:** the layer's `kit_ref`, if any; otherwise `kit_dir`.

**Effect:** every path the kit shows to its users starts with `kit_ref` (for example
`Load .my-kit/requirements/prompt.md`). When `kit_ref` differs from `kit_dir`, the kit's
README starts with how to add it to a project, and the prompts carry this repository's
answers as defaults, because the using projects have no settings of their own.

---

## Q6 · AI agent permissions

**Ask:** *Should I write the permissions of your AI agent, so it runs tests and linters
without asking, asks before deleting or installing, and never commits or pushes?*

| Option | `agent` |
|--------|---------|
| Claude Code | `["claude_code"]` |
| VS Code Copilot | `["copilot"]` |
| Both | `["claude_code", "copilot"]` |
| None | `[]` |

**Suggest from the repository:** the agents whose settings exist (`.claude/` →
`claude_code`; `.vscode/settings.json` with `chat.` keys → `copilot`); otherwise the editor
you are running in.

**Effect:** the generator writes or proposes each agent's permissions file, following
`stages/agent/permissions.md`. These are project files: never overwritten, only extended
after the user agrees.

---

## Q7 · Model per Step

**Ask:** *Should spec-nx choose the AI model for each stage and Step — a strong model where it
matters, a cheaper one for routine work?*

| Option | `models` |
|--------|----------|
| **Per Step** (default) | `{ "reasoning": "<model>", "standard": "<model>", "light": "<model>", "guide": { … } }` |
| **Fixed** — one model for everything | `{ "fixed": "<model>" }` |
| **No** — always the model selected in my tool | `null` |

**Per Step** proposes the default mapping, then asks to confirm or change each tier:

| Tier | Default | Used for (`guide`) |
|------|---------|--------------------|
| `reasoning` | Claude Opus 5.5 | Requirements, plans, architecture, refactorings, security, tricky logic, open decisions, and other complex work such as Steps heavy in graphics definitions |
| `standard` | Claude Sonnet 5.5 | Implementation that follows a clear plan, with tests |
| `light` | Claude Haiku 5.5 | Mechanical edits, renames, copies, docs |

The `guide` texts are saved with the answer; teams edit them by hand. They are a starting
point: the plan stage judges each Step and picks the cheapest tier that does it well.

**Suggest from the tool:** where the tool shows its model list (VS Code Copilot: the model
picker), check that each default is enabled and offer the nearest enabled model of the same
kind otherwise. Where it does not, say so and ask for the exact names from the model picker
(Claude Code: the aliases `opus`, `sonnet`, `haiku`). **Fixed** suggests the model you are
running on. Never invent a model name.

**Effect:** the stage prompts follow `stages/models.md` — check the model at the start, run
as a sub-agent on the configured model where the tool allows it, and record the suggested and
the actual model. `null` or a missing key: nothing is checked, switched or asked. A developer
can override the names — or set `null` to always use their tool's model — in
`.specs/spec-nx.local.json`.

---

## The `cost` block

Not asked. The first `GENERATE KIT` in a project writes it into `.specs/spec-nx.json` with
these defaults; teams change it by hand, a developer overrides keys in
`.specs/spec-nx.local.json`. `GENERATE KIT --update` never adds it: **no `cost` block, or
`enabled: false`, means no tokens and no cost are calculated or written.**

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

| Key | Meaning |
|-----|---------|
| `enabled` | `true`: every stage records its tokens and their price (`COSTS.md`); `false`: nothing |
| `plan` | Name of the subscription, shown in the cost summary |
| `monthly_price_usd`, `monthly_credits` | Price and monthly base credits of the plan (1 GitHub AI credit = $0.01); the share of the subscription is cost ÷ `monthly_credits` |
| `currency`, `rate`, `rate_date` | Local currency, its units per USD and the date of that rate |
| `prices` | Optional: `{ "<model>": { "input": 400, "cache_write": 500, "cached": 20, "output": 2000 } }` in credits per 1 M tokens, for tools that do not publish their prices |
| `base_tokens` | Optional: tokens of system prompt and tools sent with every request in estimates (default 35000) |

The defaults follow GitHub's public plans page and the European Central Bank reference rate of
`rate_date`; `COSTS.md` in the kit names the sources and says that **all costs are
estimates and may be wrong**.

---

## `.specs/spec-nx.json` (project)

Written by `GENERATE KIT`, read by `GENERATE KIT --update`. Commit it with the project.

```json
{
  "version": 1,
  "spec_nx_version": "a1b2c3d",
  "generated": "2026-11-09",
  "layer": null,
  "project": "existing",
  "languages": ["python", "typescript"],
  "stages": ["requirements", "plan", "implementation", "pr"],
  "on_demand": ["improvement"],
  "git_host": "github",
  "link_issues": true,
  "shells": ["powershell", "bash"],
  "kit": "shared",
  "agent": ["copilot"],
  "models": {
    "reasoning": "Claude Opus 5.5",
    "standard": "Claude Sonnet 5.5",
    "light": "Claude Haiku 5.5",
    "guide": {
      "reasoning": "Requirements, plans, architecture, refactorings, security, tricky logic, open decisions, complex work such as graphics-heavy Steps",
      "standard": "Implementation that follows a clear plan, with tests",
      "light": "Mechanical edits, renames, copies, docs"
    }
  },
  "cost": { "enabled": true, "plan": "Copilot Business", "monthly_price_usd": 19, "monthly_credits": 1900, "currency": "CHF", "rate": 0.8384, "rate_date": "2026-11-13" },
  "model": "<AI model that generated the kit>"
}
```

| Key | Meaning |
|-----|---------|
| `version` | Format of this file (1). |
| `spec_nx_version` | spec-nx commit (short hash) or tag the kit was generated from. |
| `generated` | Date of the last `GENERATE KIT` or `--update`. |
| `layer` | Answer to Q5: path of the company layer, or `null`. |
| `project` | `"new"` or `"existing"`, from the scan (Q0, not asked). |
| `languages` | Answer to Q0b. |
| `project_spec` | Answer to Q0c: the project setup spec's file name, or `false` (only when `project` is `"new"`). |
| `stages` | Answer to Q1 (only when `kit` is `"shared"`). |
| `on_demand` | Answer to Q1b (only when `kit` is `"shared"`). |
| `git_host` | Answer to Q2. |
| `link_issues` | Answer to Q2b. |
| `work_item_type` | Optional, set by hand (Azure DevOps only): the backlog item type for another process than Scrum (missing = `"Product Backlog Item"`). |
| `work_items` | Optional, set by hand. Azure DevOps: `org`, `project` (backlog items in another project), `area`, `iteration`, `assigned_to` (email; missing = you, `null` = nobody). GitHub: `type` (an issue type of the organization), `assigned_to` (login; missing = `@me`, `null` = nobody). |
| `parent` | Optional, set by hand: the default parent (issue number / work item id) of `CREATE ISSUE`, used when neither the command nor the spec header names one. |
| `shells` | Shells the kit's scripts are generated for: every developer's `shell`. |
| `kit` | Answer to Q4. |
| `kit_dir` | Answer to Q4b (missing = `".specs/kit"`). |
| `kit_ref` | Answer to Q4c (missing = `kit_dir`). |
| `kit_files` | Top-level files and folders of the last generation, relative to `kit_dir` (only when `kit_dir` is not `".specs/kit"`). |
| `agent` | Answer to Q6: the AI agents whose permissions the generator writes. |
| `models` | Answer to Q7: the model per tier with its `guide`, one `fixed` model, or `null` (missing = `null`). |
| `cost` | The `cost` block (not asked; missing = disabled). |
| `model` | AI model that generated the shared kit (only when `kit` is `"shared"`). Not the model of a stage run: the Stage log names the model that ran each command. |

## `.specs/spec-nx.local.json` (developer)

Written by `GENERATE KIT` on each developer's computer; never committed.

```json
{
  "version": 1,
  "shell": "bash"
}
```

| Key | Meaning |
|-----|---------|
| `version` | Format of this file (1). |
| `shell` | From the operating system (not asked): `"powershell"` or `"bash"`; change it by hand. |
| `stages` | Answer to Q1 (only when the project's `kit` is `"personal"`). |
| `on_demand` | Answer to Q1b (only when the project's `kit` is `"personal"`). |
| `model` | AI model that generated your personal kit (only when `kit` is `"personal"`). Not the model of a stage run. |
| `models` | Optional: your own model names (any tier, or `fixed`), or `null` to always use the model selected in your tool. Wins over the project's `models`. |
| `cost` | Optional: keys of the `cost` block that differ for you (for example `currency` and `rate`, or `enabled: false`). |
| *any project key* | Optional: every key of the project's file except the project-only keys ([Three layers](#three-layers)) — for example `parent`, `work_items`, `stages`. |
