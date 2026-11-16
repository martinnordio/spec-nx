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
