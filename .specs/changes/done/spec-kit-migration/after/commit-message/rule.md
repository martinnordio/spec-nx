8. **Report and suggest the commit.** What changed (files), the check result, anything
   deferred, and a commit message:

   ```
   Step <n>: <Step description> (#<issue>)
   ```

   (`AB#<id>` for an Azure DevOps backlog item, following `../guidelines/commits.md`). If the
   spec has no issue yet, say so and offer `CREATE ISSUE:` (requirements stage) before the
   first commit. The user commits. Then the next step: `IMPLEMENT: <spec file>` for the next Step, or
   `CLOSE: <spec file>` when all Steps are done.
