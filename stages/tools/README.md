# Git-host tools

Small scripts that keep an issue / backlog item and a pull request in sync with a spec. They do
not read the spec: the stage prompt (the AI assistant) builds the **summary** from the spec and
writes it to a file; the script puts that text into the description, between the markers

```
<!-- spec-summary:start -->
…
<!-- spec-summary:end -->
```

Text outside the markers (written by hand) is kept. Without markers, the block is added at the
end. Every script has a dry run that prints the new description and changes nothing.

The pull-request scripts also fill a second block, `<!-- semantic-diff:start -->` …
`<!-- semantic-diff:end -->`, when they get a semantic-diff file (`-SemanticDiffFile` /
`--semantic-diff`), written by the review stage. Without it, that block is left as it is.

| Host | Script (PowerShell / bash) | Does |
|------|----------------------------|------|
| GitHub | `github/update_issue.ps1` / `.sh` | Issue description |
| GitHub | `github/update_pr.ps1` / `.sh` | Pull request of the current branch; creates it (draft allowed, `Closes #<issue>`) if there is none |
| Azure DevOps | `azure_devops/update_issue.ps1` / `.sh` | Backlog item (work item) description, stored as Markdown |
| Azure DevOps | `azure_devops/update_pr.ps1` / `.sh` | Pull request of the current branch; creates it (draft allowed, linked to the backlog item) if there is none |

**Needs:** GitHub — the GitHub CLI `gh`, logged in. Azure DevOps — a personal access token in
`AZURE_DEVOPS_EXT_PAT` (Work Items and Code: read and write); the bash scripts also need `curl`
and `jq`. PowerShell scripts run in Windows PowerShell 5.1 and PowerShell 7.

## Examples

```
pwsh stages/tools/github/update_issue.ps1 -Issue 12 -SummaryFile summary.md -DryRun
bash stages/tools/github/update_issue.sh 12 summary.md --dry-run

pwsh stages/tools/github/update_pr.ps1 -SummaryFile summary.md -Title "Login page (#12)" -Issue 12 -Draft
bash stages/tools/github/update_pr.sh summary.md --title "Login page (#12)" --issue 12 --draft

pwsh stages/tools/github/update_pr.ps1 -SummaryFile summary.md -SemanticDiffFile semantic_diff.md -DryRun
bash stages/tools/github/update_pr.sh summary.md --semantic-diff semantic_diff.md --dry-run
```

## The summary

Built by the stage prompt from the spec file, in this form:

```markdown
### <Spec title>

**Spec:** [<file name>](<link to the spec on the branch>) · **Status:** <Status from the header>

**Requirements**
- **S1 — <name>:** <first sentence of S1>
- **S2 — <name>:** <first sentence of S2>

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
- Keep it short: Azure DevOps allows 4000 characters in a pull-request description.
