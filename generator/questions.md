# Setup questions

The generator (`GENERATE KIT`) asks these questions to decide which kit to write into a
project. For each question it first **scans the repository** and **suggests** an answer; the
user confirms or changes it. The answers are saved in `.specs/spec-nx.json` of the project, so
`GENERATE KIT --update` never asks them again — only questions whose key is missing from the
file (questions added to spec-nx later).

| # | Question | Key in `spec-nx.json` | Default |
|---|----------|-----------------------|---------|
| Q1 | Development method — which stages do you use? | `stages` | `["requirements", "plan", "pr"]` |
| Q2 | Git host — where is the repository? | `git_host` | from the `origin` remote |
| Q2b | Keep each spec in sync with an issue / backlog item? | `link_issues` | `true` if there is a git host |

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

**Selects:** each stage folder `stages/<stage>/` → `.specs/kit/<stage>/`; the spec template
`stages/spec_template.md` → `.specs/kit/spec_template.md`.

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
  (never written to a file).

**Selects:** the tools for the host, `stages/tools/<git_host>` → `.specs/kit/tools/`, when
`pr` is in `stages` or `link_issues` is `true`. With `"none"`, the `pr` stage only explains
the manual steps and no tools are copied.

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

## `.specs/spec-nx.json`

Written by `GENERATE KIT`, read by `GENERATE KIT --update`. Commit it with the project.

```json
{
  "version": 1,
  "spec_nx_version": "a1b2c3d",
  "generated": "2026-11-09",
  "stages": ["requirements", "plan", "pr"],
  "git_host": "github",
  "link_issues": true
}
```

| Key | Meaning |
|-----|---------|
| `version` | Format of this file (1). |
| `spec_nx_version` | spec-nx commit (short hash) or tag the kit was generated from. |
| `generated` | Date of the last `GENERATE KIT` or `--update`. |
| `stages` | Answer to Q1. |
| `git_host` | Answer to Q2. |
| `link_issues` | Answer to Q2b. |
