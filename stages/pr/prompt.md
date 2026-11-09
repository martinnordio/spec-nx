# Stage: Pull request

Push the branch and open or update its **pull request** with a summary of the spec, and update
the spec's **issue** (GitHub) or **backlog item** (Azure DevOps) with the same summary, so the
spec, the issue and the pull request always say the same.

## Command

```
PR: <spec file>
```
Dry run first, then the real update after the user confirms. Run it again whenever the spec
changes (Steps done, spec closed): only the `spec-summary` blocks are rewritten.

## Skills to load

None — this stage is mechanical: it summarises the spec and runs the git-host tools.

## Files this stage uses

Paths are relative to this file, so they work both inside spec-nx (`stages/pr/`) and in a
generated kit (`.specs/kit/pr/`).

| File | Use |
|------|-----|
| `../tools/README.md` | The summary format and the scripts |
| `../tools/<git_host>/update_pr.*` | Open or update the pull request of the current branch |
| `../tools/<git_host>/update_issue.*` | Update the issue / backlog item |
| `.specs/spec-nx.json` | `git_host`, `link_issues` (if the project has it) |
| `.specs/spec-nx.local.json` | `shell` (if the project has it) |

---

## PR

1. **Check the branch.**
   - The current branch is the spec's **Branch** (header). If not, stop and say so.
   - No uncommitted changes (`git status`); otherwise ask the user to commit first.
   - The spec has Part 1 (statements) — a pull request needs at least the requirements.

2. **Find the git host and shell.** `git_host` from `.specs/spec-nx.json`, otherwise from
   `git remote get-url origin` (`github.com` → GitHub; `dev.azure.com` or `visualstudio.com`
   → Azure DevOps). `shell` from `.specs/spec-nx.local.json`, otherwise PowerShell on Windows
   and bash on macOS / Linux. With no git host, explain how to open the pull request by hand
   and stop.

3. **Build the summary** in the format of `../tools/README.md`: title, link to the spec on the
   branch, status, the statements (one line each) and — if Part 2 has Steps — the Plan table
   with each Step's status. Write it to a temporary file outside the repository.

4. **Title and issue.**
   - Title of a new pull request: the spec title, followed by the issue reference if there is
     one (`<title> (#<n>)`).
   - Issue / backlog item: from the spec header (`Issue:` / `Backlog item:`). If `link_issues`
     is `true` and the header has none, ask for it.
   - New pull requests are opened as a **draft** while the spec is not closed (not yet in
     `.specs/features/done/`).

5. **Dry run** — show the user both results:

   | Host | Shell | Pull request | Issue / backlog item |
   |------|-------|--------------|----------------------|
   | GitHub | PowerShell | `../tools/github/update_pr.ps1 -SummaryFile <file> -Title <title> -Issue <n> [-Draft] -DryRun` | `../tools/github/update_issue.ps1 -Issue <n> -SummaryFile <file> -DryRun` |
   | GitHub | bash | `../tools/github/update_pr.sh <file> --title <title> --issue <n> [--draft] --dry-run` | `../tools/github/update_issue.sh <n> <file> --dry-run` |
   | Azure DevOps | PowerShell | `../tools/azure_devops/update_pr.ps1 -SummaryFile <file> -Title <title> -Issue <id> [-Draft] -DryRun` | `../tools/azure_devops/update_issue.ps1 -Issue <id> -SummaryFile <file> -DryRun` |
   | Azure DevOps | bash | `../tools/azure_devops/update_pr.sh <file> --title <title> --issue <id> [--draft] --dry-run` | `../tools/azure_devops/update_issue.sh <id> <file> --dry-run` |

6. **After the user confirms:**
   1. Push the branch (`git push -u origin <branch>` the first time, `git push` after).
   2. Run the pull-request script without the dry run.
   3. If the spec has an issue / backlog item, **always** run the issue script without the dry
      run too.
   4. Delete the temporary file and show the pull request link.

7. **Ready for review.** When the spec is closed and the user asks for it, mark the pull
   request ready: GitHub `gh pr ready`; Azure DevOps: publish the draft in the pull request
   page. The user reviews and merges — this stage never merges.

## Never

- Merge, close, or force-push.
- Change text outside the `spec-summary` blocks of the pull request or the issue.
- Put secrets, tokens, internal URLs or personal data into a summary.
