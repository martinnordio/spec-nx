# Commits — baseline

> Generic rules for commit messages, for people and for an AI agent that is allowed to commit.
> `.specs/guidelines/commits.md` (project) wins over this file.

## One commit per Step

- Each Step of a spec is one commit; the spec's Done line is in the same commit.
- Closing the spec, the Stage log row of a stage, and review fixes are commits of their own.

## The message

```
Step <n>: <Step description> (<reference>)

<why, up to three lines, only if the subject does not say it>
```

- **Subject:** imperative, at most ~72 characters, no period at the end.
- **Reference to the issue / backlog item of the spec** (from the spec header) — always, so the
  git host links the commit to it:

  | Git host | Reference | Effect |
  |----------|-----------|--------|
  | GitHub | `#<n>` | The commit appears on issue `#<n>` |
  | Azure DevOps | `AB#<id>` | The commit is linked to backlog item `<id>` (in Azure Repos, also `#<id>`) |

  Use the closing words (`Closes #<n>`, `Fixes AB#<id>`) only in the pull request, not in each
  commit — the item closes when the pull request is merged.
- A spec without an issue: no reference; say so when you suggest the message, and offer
  `CREATE ISSUE:` (requirements stage).

## Who commits

- By default the **user** commits: the stage suggests the message, with the reference.
- If the project lets the AI agent commit (agent permissions), the agent follows the same rules
  and shows the message before it commits. Never push, merge or rewrite pushed history.

## Before the pull request

- `git log <default branch>..HEAD --oneline`: every commit has the reference. Missing
  references in commits that are **not pushed yet** can be added with an interactive rebase —
  only with the user's consent; pushed commits stay as they are.
- No secrets, tokens or personal data in messages.
