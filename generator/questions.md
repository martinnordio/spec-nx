# Setup questions

The generator (`GENERATE KIT`) asks these questions to decide which kit to write into a
project. For each question it first **scans the repository** (and, for developer questions,
the computer) and **suggests** an answer; the user confirms or changes it.

Answers are saved at two levels, so `GENERATE KIT --update` never asks them again — only
questions whose key is missing (questions added to spec-nx later):

| Level | File | Shared? | Holds |
|-------|------|---------|-------|
| **Project** | `.specs/spec-nx.json` | Committed; the same for the whole team | What the project is and how the team works: project start, languages, stages, git host, issues, the shells the kit supports |
| **Developer** | `.specs/spec-nx.local.json` | Ignored by git; one per developer | How *you* work: your shell |

The questions are **asked in the order of this table**:

| # | Question | Level | Key | Default |
|---|----------|-------|-----|---------|
| Q0 | Project start — a new (empty) project or an existing one? | project | `project` | from the scan |
| Q0b | Languages — which programming languages? | project | `languages` | from the scan |
| Q1 | Workflow — which stages do you use? | project | `stages` | Simple: `["requirements", "plan", "implementation", "pr"]` |
| Q1b | On-demand stages — which extra commands do you want? | project | `on_demand` | `[]` |
| Q2 | Git host — where is the repository? | project | `git_host` | from the `origin` remote |
| Q2b | Keep each spec in sync with an issue / backlog item? | project | `link_issues` | `true` if there is a git host |
| Q3 | Which shell do you run the kit's scripts in? | developer | `shell` | from the operating system |
| Q4 | Share the kit with the team, or keep it personal? | project | `kit` | `"shared"` |

New questions get the next number and their own key; existing keys never change meaning.

---

## Q0 · Project start

**Ask:** *Is this a new, empty project, or a project that already has code?*

| Option | `project` |
|--------|-----------|
| New (empty) | `"new"` |
| Existing | `"existing"` |

**Suggest from the repository:** `"new"` when the repository holds nothing but a README,
LICENSE, `.git*` files, `.specs/` and git submodules (such as `.spec-nx/`); otherwise
`"existing"`. Tell the user what you found ("only README and LICENSE" / "Python package in
`src/`, 40 files").

**Effect:** with `"new"`, Q0b is asked openly and the project setup spec is offered after the
kit is generated (see the generator).

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

**Selects:** the guideline baselines `stages/guidelines/<language>.md` →
`.specs/kit/guidelines/`, for each language that has one.

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
- Azure DevOps: a personal access token in the environment variable `AZURE_DEVOPS_EXT_PAT`
  (never written to a file); the bash scripts also need `curl` and `jq`.

**Selects:** the tools for the host, `stages/tools/<git_host>/` → `.specs/kit/tools/<git_host>/`
(with the shared `spec_summary` script and `README.md` in `.specs/kit/tools/`, the same layout as
in spec-nx, so the stage prompts' relative paths work in both), in
every shell listed in the project's `shells` (see Q3), when `pr` is in `stages` or
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

- The spec template gets an `Issue:` line in its header.
- The requirements stage offers `UPDATE ISSUE: <spec file>` (on request).
- The pr stage always updates the issue / backlog item together with the pull request.

---

## Q3 · Your shell (developer)

Asked when the kit has tools (a git host is set). Each developer answers it on their own
computer.

**Ask:** *Which shell do you run the kit's scripts in?*

| Option | `shell` |
|--------|---------|
| PowerShell (Windows PowerShell 5.1 or PowerShell 7; Windows, also macOS / Linux) | `"powershell"` |
| bash or zsh (macOS, Linux, Git Bash on Windows) | `"bash"` |

**Suggest from the computer:** Windows → `"powershell"`; macOS or Linux → `"bash"`.

**Effect**

- Saved in `.specs/spec-nx.local.json` (developer level); the generator adds that file to the
  project's `.gitignore`.
- The answer is also added to the project's `shells` list (if not there yet), so the kit
  contains the scripts for every shell the team uses. The stage prompts call the script for
  the developer's own `shell`.

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

## `.specs/spec-nx.json` (project)

Written by `GENERATE KIT`, read by `GENERATE KIT --update`. Commit it with the project.

```json
{
  "version": 1,
  "spec_nx_version": "a1b2c3d",
  "generated": "2026-11-09",
  "project": "existing",
  "languages": ["python", "typescript"],
  "stages": ["requirements", "plan", "implementation", "pr"],
  "on_demand": ["improvement"],
  "git_host": "github",
  "link_issues": true,
  "shells": ["powershell", "bash"],
  "kit": "shared",
  "model": "<AI model that generated the kit>"
}
```

| Key | Meaning |
|-----|---------|
| `version` | Format of this file (1). |
| `spec_nx_version` | spec-nx commit (short hash) or tag the kit was generated from. |
| `generated` | Date of the last `GENERATE KIT` or `--update`. |
| `project` | Answer to Q0. |
| `languages` | Answer to Q0b. |
| `stages` | Answer to Q1 (only when `kit` is `"shared"`). |
| `on_demand` | Answer to Q1b (only when `kit` is `"shared"`). |
| `git_host` | Answer to Q2. |
| `link_issues` | Answer to Q2b. |
| `shells` | Shells the kit's scripts are generated for: every developer's Q3 answer. |
| `kit` | Answer to Q4. |
| `model` | AI model that generated the shared kit (only when `kit` is `"shared"`). |

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
| `shell` | Answer to Q3. |
| `stages` | Answer to Q1 (only when the project's `kit` is `"personal"`). |
| `on_demand` | Answer to Q1b (only when the project's `kit` is `"personal"`). |
| `model` | AI model that generated your personal kit (only when `kit` is `"personal"`). |
