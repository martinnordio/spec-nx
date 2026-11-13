# Agent permissions (building block)

Used by the generator (Q6) to write the AI agent's permissions for the project: the agent may
run what is safe without asking, asks before what is hard to undo, and never commits, pushes
or merges — the user does that.

## 1 · The lists

Built from the project's tools (found by the scan, the answers to Q0b and the build files),
plus a company layer's `agent/permissions.json` if there is one. Entries are **command
prefixes** (a command and its first words).

| List | What goes in it | Examples |
|------|-----------------|----------|
| **allow** | Read-only commands; the project's test, lint, format, type-check and build commands; the kit's dry runs | `git status`, `git diff`, `git log`, `pytest`, `ruff check`, `pnpm test`, `pnpm run check`, `Invoke-Pester`, `bash -n` |
| **ask** | Commands that delete, move or overwrite files, install packages, or change the environment | `rm`, `del`, `Remove-Item`, `mv`, `Move-Item`, `cp`, `pip install`, `uv add`, `pnpm add`, `git checkout`, `git stash` |
| **deny** | Commands that publish or rewrite history | `git commit`, `git push`, `git merge`, `git rebase`, `git reset --hard`, `gh pr merge` |

The kit's own scripts that write to the git host (`update_issue`, `update_pr` without dry
run) go into **ask**: the stages run them only after the user confirms.

A layer file has the same three lists:

```json
{ "allow": ["uv run pytest"], "ask": ["uv add"], "deny": ["git push"] }
```

## 2 · Files per agent

| Agent in `agent` | File (project file, committed) | Format |
|------------------|--------------------------------|--------|
| `claude_code` | `.claude/settings.json` | `permissions.allow` / `ask` / `deny`, each entry `Bash(<prefix> *)` (and `Bash(<command>)` for an exact command) |
| `copilot` | `.vscode/settings.json` | `chat.tools.terminal.autoApprove`: `"<prefix>": true` for allow; `false` for ask **and** deny — this setting cannot block a command, only require approval, so the kit's prompts keep their "never commit or push" rule |

With `agent` empty (`[]`), nothing is written.

Example for Claude Code:

```json
{
  "permissions": {
    "allow": ["Bash(git status)", "Bash(git diff *)", "Bash(pytest *)", "Bash(ruff check *)"],
    "ask": ["Bash(rm *)", "Bash(uv add *)"],
    "deny": ["Bash(git commit *)", "Bash(git push *)", "Bash(git merge *)"]
  }
}
```

Example for VS Code Copilot:

```json
{
  "chat.tools.terminal.autoApprove": {
    "git status": true,
    "/^git (diff|log)\\b/": true,
    "pytest": true,
    "rm": false,
    "/^git (commit|push|merge|rebase)\\b/": false
  }
}
```

The setting names and rule syntax are the agents' own; check their documentation when the
generator runs, and adapt if they changed.

## 3 · Writing the file

- **Missing:** create it with the lists above.
- **Existing:** never overwrite it. Show a diff that only **adds** entries (and moves an entry
  to a stricter list); never remove or loosen an entry the project has; apply what the user
  accepts. Keep every other key in the file.
- Personal files (`.claude/settings.local.json`, user settings) are never touched.
