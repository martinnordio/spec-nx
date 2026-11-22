# Git-host tools

Small scripts that keep an issue / backlog item and a pull request in sync with a spec. They do
not read the spec: the stage prompt (the AI assistant) builds the **summary** from the spec and
writes it to a file; the script puts that text into the description, between the markers

```
[//]: # (spec-summary:start)

…

[//]: # (spec-summary:end)
```

The markers are Markdown comment lines: they are not shown, and Azure DevOps keeps them in a
work item's description (it removes HTML comments). Blocks between the older markers
`<!-- spec-summary:start -->` … `<!-- spec-summary:end -->` are still found and replaced.

Text outside the markers (written by hand) is kept. Without markers, the block is added at the
end. Every script has a dry run that prints the new description and changes nothing.

The pull-request scripts also fill a second block, `[//]: # (semantic-diff:start)` …
`[//]: # (semantic-diff:end)`, when they get a semantic-diff file (`-SemanticDiffFile` /
`--semantic-diff`), written by the review stage. Without it, that block is left as it is.

| Host | Script (PowerShell / bash) | Does |
|------|----------------------------|------|
| GitHub | `github/create_issue.ps1` / `.sh` | Creates an issue with the summary; optionally a sub-issue of a parent issue; type (`-Type`, `work_items.type`, organizations only) and assignee (`-AssignedTo`, `work_items.assigned_to`; default you, `null` / `-Unassigned` none), checked first; prints its number |
| GitHub | `github/update_issue.ps1` / `.sh` | Issue description |
| GitHub | `github/update_pr.ps1` / `.sh` | Pull request of the current branch; creates it (draft allowed, `Closes #<issue>`) if there is none |
| Azure DevOps | `azure_devops/create_issue.ps1` / `.sh` | Creates a backlog item (type from `work_item_type`) with the summary; optionally under a parent work item; area, iteration and assignee (`-Area`, `-Iteration`, `-AssignedTo` or `work_items.area`, `.iteration`, `.assigned_to`; default you, `null` / `-Unassigned` none), checked first; prints its id |
| Azure DevOps | `azure_devops/update_issue.ps1` / `.sh` | Backlog item (work item) description, stored as Markdown |
| Azure DevOps | `azure_devops/update_pr.ps1` / `.sh` | Pull request of the current branch; creates it (draft allowed, linked to the backlog item) if there is none |

**Needs:** GitHub — the GitHub CLI `gh`, logged in. Azure DevOps — your git login (Git
Credential Manager, the one `git fetch` uses; organisation and project come from the `origin`
remote), or a personal access token in `AZURE_DEVOPS_EXT_PAT` (Work Items and Code: read and
write), which wins when set; the bash scripts also need `curl` and `jq`. Credentials are never
printed. PowerShell scripts run in Windows PowerShell 5.1 and PowerShell 7.

## Settings

`settings.ps1` / `settings.sh` read the settings in three layers — the kit's
`<kit>/.specs/spec-nx.json` (only when the kit is a repository of its own), the project's
`.specs/spec-nx.json` and the developer's `.specs/spec-nx.local.json` — and merge them: a later
layer wins, objects are merged key by key, lists are replaced, `null` removes a key; the keys
that describe the generated kit come from the project's file only. Every other script reads
its settings through them. `settings.sh` needs `python3`.

```
pwsh tools/settings.ps1                       # every setting with the file it comes from
pwsh tools/settings.ps1 -Get work_items.area  # one value (JSON for objects and lists)
pwsh tools/settings.ps1 -Source parent        # the file it comes from
bash tools/settings.sh --json                 # all settings as JSON
```

## Examples

```
pwsh stages/tools/github/update_issue.ps1 -Issue 12 -SummaryFile summary.md -DryRun
bash stages/tools/github/update_issue.sh 12 summary.md --dry-run

pwsh stages/tools/github/update_pr.ps1 -SummaryFile summary.md -Title "Login page (#12)" -Issue 12 -Draft
bash stages/tools/github/update_pr.sh summary.md --title "Login page (#12)" --issue 12 --draft

pwsh stages/tools/github/update_pr.ps1 -SummaryFile summary.md -SemanticDiffFile semantic_diff.md -DryRun
bash stages/tools/github/update_pr.sh summary.md --semantic-diff semantic_diff.md --dry-run
```

## Tokens and cost

`usage.ps1` / `usage.sh` measure (Claude Code) or estimate (VS Code Copilot) the tokens of a
time range of the AI chat and price them, by the method of `../COSTS.md`. They read the
`cost` block of `.specs/spec-nx.json` (and `.local.json`); without it,
or with `enabled: false`, they print that cost tracking is off and do nothing. They change no
file. The bash script needs `python3`.

| Parameter (PowerShell / bash) | Meaning |
|-------------------------------|---------|
| `-Since` / `--since` | Start of the range: the stage's or Step's start time (local time or ISO with `Z`) |
| `-Until` / `--until` | End of the range (default: now) |
| `-Model` / `--model` | The model that ran, as named in the tool's model list or in `cost.prices` (a Copilot CLI log names its models itself) |
| `-Transcript` / `--transcript` | The chat log (default: of all logs of this project written since `-Since` — Copilot CLI sessions, VS Code Copilot chats of this workspace, Claude Code sessions — the one with the most requests in the range) |
| `-Root` / `--root` | The project root (default: the current folder) |
| `-ContextCap` / `--context-cap` | Context size at which the chat is assumed to be summarized (default 200000) |
| `-Agent` / `--agent` | `all` (default), `main` (only the chat's own requests) or `subagents` (only its sub-agents') — Copilot CLI logs only; a `Split:` line always shows both parts |
| `-Json` / `--json` | One JSON line instead of the three text lines |

```
pwsh stages/tools/usage.ps1 -Since "2026-11-16 08:55" -Model "Claude Opus 5.5"
bash stages/tools/usage.sh --since "2026-11-16 08:55" --model "Claude Opus 5.5" --json
```

Output (`~` = estimated; measured numbers have none):

```
Tokens: ~1.34 M (18 k in · 1.31 M cached · 11 k out)
Cost: ~CHF 0.48 (57 credits, 3.0 % of Copilot Business)
Source: estimated from <transcript> · 17 requests · Claude Opus 5.5
```

With no request in the range it stops with an error that lists the logs it checked.

`costs_ledger.ps1` / `costs_ledger.sh` rebuild `.specs/costs.md` — every spec in
`.specs/features/` and `done/` with its tokens and cost per stage, per Step and in total, and
the total of all specs — from the Tokens and Cost columns of the Stage logs; specs without
them show `N/A`. Run at `CLOSE:`; after a merge conflict in `.specs/costs.md`, run it again.
Parameters: `-Root` / `--root`, `-CostsLink` / `--costs-link` (path from `.specs/` to
COSTS.md; default from `kit_dir`), `-DryRun` / `--dry-run` (print, write nothing).

```
pwsh stages/tools/costs_ledger.ps1 -DryRun
bash stages/tools/costs_ledger.sh
```

## The summary

Built by the stage prompt from the spec file, in this form:

```markdown
### <Spec title>

**Spec:** [<file name>](<link to the spec on the branch>) · **Status:** <Status from the header>

**Requirements**
- **S1 — <name>:** <first sentence of S1>
- **S2 — <name>:** <first sentence of S2>

## Cost summary
This feature used ~<tokens> tokens, ~<currency> <amount> — estimate, see [COSTS.md](<full URL of COSTS.md>).

| Stage | Models | Tokens | Cost (<currency>) | Share of <plan> |
|-------|--------|--------|-------------------|-----------------|
| requirements | <model> | ~… | ~… | … % |
| **Total** | | **~…** | **~…** | **… %** |

**Implementation by Step**

| Step | Model | Tokens | Cost (<currency>) | Share of <plan> |
|------|-------|--------|-------------------|-----------------|
| Step 1 | <model> | ~… | ~… | … % |
| **Total implementation** | | **~…** | **~…** | **… %** |

**Plan**
| Step | Description | Status |
|------|-------------|--------|
| 0 | <description> | ✅ Done |
| 1 | <description> | ⬜ Not started |
```

- The link is a full URL to the spec, so it works from the issue and the pull request
  (GitHub: `https://github.com/<owner>/<repo>/blob/<branch>/<path>`). While the spec is open,
  link to the feature branch; once it is closed (in `.specs/features/done/`), link to the
  default branch — the feature branch is deleted after the merge, the default branch stays.
- While the spec has no plan yet (requirements stage), the **Plan** part is left out.
- **Cost summary:** only when the spec has one (written by `CLOSE:` with cost tracking on):
  its sentence and both tables (by stage, implementation by Step), copied as they are, before
  the **Plan** part. Make its links full
  URLs on the default branch (the COSTS.md of the kit, e.g.
  `https://github.com/<owner>/<repo>/blob/<default>/<kit_ref>/COSTS.md`) — never local or
  editor links.
- Keep it short: Azure DevOps allows 4000 characters in a pull-request description. If the
  Azure DevOps pull request would be longer, keep only the Cost summary's sentence there; the
  backlog item always gets the whole section.
