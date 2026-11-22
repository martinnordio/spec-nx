# testing — local trial runs

Everything in this folder except this README is ignored by git: use it to try the generator
and the stages on throw-away projects without pushing anything.

## Committed checks: `usage/`

`usage/check_usage.ps1` checks the `usage` and `costs_ledger` scripts of both shells on the
sample logs and specs in `usage/samples/` (no real data): a Copilot CLI chat with a sub-agent
and two models, two chats of one project at the same time (`-Run`), a chat of another project,
an empty range, and a cost list with measured, estimated and `included in` rows.

```
powershell -File testing/usage/check_usage.ps1              # Windows (Git Bash for the bash scripts)
pwsh testing/usage/check_usage.ps1 -Bash bash               # macOS / Linux
```

The bash scripts need `python3` (pass `-BashPath <folder>` to put one first on the path). It
prints one line per check and exits with 1 when one fails.

## Try it

1. Create a scratch project:

   ```
   cd testing
   mkdir my-trial
   cd my-trial
   git init
   ```

   Add a few files so there is something to read (a README, a small script, a folder or two).

2. Open the scratch project in your editor and, in the AI chat, load the stage you want to try,
   for example the requirements stage:

   ```
   Load ../../stages/requirements/prompt.md
   and ../../stages/spec_template.md.

   REQUIREMENTS: <short name> — <what you want, in plain words>
   ```

   *(The generator prompt in `generator/` will do this set-up for you once it exists.)*

3. Look at what was written in `.specs/features/` of the scratch project.

4. Delete the scratch project when you are done.

## Rules

- Never copy real company or customer data into a trial.
- If a trial shows a bug in a stage, write it down in the spec being worked on (Review Log or
  Open questions) — the trial itself is not kept.
