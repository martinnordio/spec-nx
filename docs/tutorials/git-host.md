# Tutorial, optional part: issue and pull request

After the [Angular](angular.md) or [Python](python.md) tutorial, connect the project to
GitHub or Azure DevOps and build a **second small feature**: this time the spec gets an issue
(GitHub) or a backlog item (Azure DevOps), and the work ends in a pull request that shows the
spec's summary and cost.

Skip this part on a first try — it needs an account and a repository on the host.

## 1 · Create the repository on the host

The repository must exist on the host **before** spec-nx can create issues or pull requests.

**GitHub**

- A GitHub account and the GitHub CLI `gh`, logged in: `gh auth login`.
- Create the repository from your project and push it:

  ```
  gh repo create <name> --private --source . --push
  ```

**Azure DevOps**

- An Azure DevOps **organisation** and a **project** in it — create them on
  https://dev.azure.com if you have none. The project's process decides the type of backlog
  item: *Scrum* creates a Product Backlog Item (spec-nx's default); for *Agile*, *CMMI* or
  *Basic*, set `work_item_type` ([configuration](../configuration.md)).
- A **repository** in that project (Repos → New repository, without a README).
- A git login: Git Credential Manager (part of Git for Windows) signs you in on the first
  push. On macOS / Linux the bash scripts also need `curl` and `jq`.
- Add it as `origin` and push:

  ```
  git remote add origin https://dev.azure.com/<organisation>/<project>/_git/<repository>
  git push -u origin --all
  ```

## 2 · Tell spec-nx about the host

In `.specs/spec-nx.json`, set `"git_host"` to `"github"` or `"azure_devops"`, and
`"link_issues"` to `true` (each spec gets an issue / backlog item). Then in the chat:

```
Load .spec-nx/generator/prompt.md.

GENERATE KIT --update
```

The kit now has the scripts for your host. Commit:

```
git add -A
git commit -m "Connect spec-nx to the git host"
git push
```

**Your own backlog fields:** area, iteration and assignee (Azure DevOps) or issue type and
assignee (GitHub) can be set for the team or only for you — see
[Customizing spec-nx](../customize.md#examples-to-copy).

## 3 · The second feature

| Tutorial | Second feature |
|----------|----------------|
| Angular | `REQUIREMENTS: hero search — a search box above the list filters the heroes by name as you type; an empty box shows all heroes.` |
| Python | `REQUIREMENTS: delete a post — each post on the home page has a Delete button; it asks for confirmation and removes the post.` |

1. `REQUIREMENTS: …` as above. When Part 1 is agreed, the assistant offers **`CREATE ISSUE:`**
   — say yes. It shows a dry run first, then creates the issue / backlog item and writes its
   number into the spec.
2. `PLAN:`, `IMPLEMENT:` and `CLOSE:` as in the first feature. Commit messages now carry the
   reference (`#<n>` on GitHub, `AB#<id>` on Azure DevOps).
3. The pull request:

   ```
   Load .specs/kit/pr/prompt.md.

   PR: .specs/features/done/<date>_<name>_spec.md
   ```

   The assistant shows a dry run, then pushes the branch, opens the pull request with the
   spec's summary and **Cost summary**, and updates the issue / backlog item the same way.

4. Review and merge the pull request on the host — spec-nx never merges.
