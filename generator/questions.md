# Setup questions

The generator (`GENERATE KIT`) asks these questions to decide which kit to write into a
project. For each question it first **scans the repository** (and, for developer questions,
the computer) and **suggests** an answer; the user confirms or changes it.

Answers are saved at two levels, so `GENERATE KIT --update` never asks them again — only
questions whose key is missing (questions added to spec-nx later):

| Level | File | Shared? | Holds |
|-------|------|---------|-------|
| **Project** | `.specs/spec-nx.json` | Committed; the same for the whole team | How the team works: stages, git host, issues, the shells the kit supports |
| **Developer** | `.specs/spec-nx.local.json` | Ignored by git; one per developer | How *you* work: your shell |

| # | Question | Level | Key | Default |
|---|----------|-------|-----|---------|
| Q1 | Development method — which stages do you use? | project | `stages` | `["requirements", "plan", "pr"]` |
| Q2 | Git host — where is the repository? | project | `git_host` | from the `origin` remote |
| Q2b | Keep each spec in sync with an issue / backlog item? | project | `link_issues` | `true` if there is a git host |
| Q3 | Which shell do you run the kit's scripts in? | developer | `shell` | from the operating system |
| Q4 | Share the kit with the team, or keep it personal? | project | `kit` | `"shared"` |

New questions get the next number and their own key; existing keys never change meaning.

---

## Q1 · Development method

**Ask:** *Which stages do you want in your kit?*

| Option | `stages` |
|--------|----------|
| Full | `["requirements", "plan", "implementation", "documentation", "review", "pr"]` |
| Data science | `["requirements", "plan", "pr"]` |
| Requirements only | `["requirements"]` |
| Custom | any list that follows the rules below |

**Rules**

- `requirements` is always included.
- `plan` needs `requirements`; `implementation` needs `plan`; `review` needs `implementation`.
- `documentation` and `pr` can be added to any set.
- The list is kept in this order: requirements, plan, implementation, documentation, review, pr.

**Available today:** `requirements`, `plan`, `pr`. If the user picks a stage that spec-nx
does not have yet, the generator says so, keeps it out of the kit and does not save it — it is
offered again by `--update` once it exists.

**Suggest from the repository**

| Found | Suggests |
|-------|----------|
| `.specs/spec-nx.json` | its `stages` (this is an update) |
| Specs in `.specs/features/` with a plan part (Steps) | `plan` |
| A pull-request template, or merged pull requests | `pr` |
| Nothing of the above | the default |

**Selects:** each stage folder `stages/<stage>/` → `.specs/kit/<stage>/`; the skills those
stages load (`stages/skills/<skill>.md` → `.specs/kit/skills/`, see each prompt's *Skills to
load*); the spec template `stages/spec_template.md` → `.specs/kit/spec_template.md`.

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
| Shared | `"shared"` | `.specs/kit/` is committed; Q1 (stages) is a project answer; everyone uses the same kit |
| Personal | `"personal"` | `.specs/kit/` is added to `.gitignore`; Q1 becomes a developer answer, so each contributor picks the stages for their role and generates the kit with their own AI model |

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
  "stages": ["requirements", "plan", "pr"],
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
| `stages` | Answer to Q1 (only when `kit` is `"shared"`). |
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
| `model` | AI model that generated your personal kit (only when `kit` is `"personal"`). |
