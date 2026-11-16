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

| Stage | Tokens | Cost (<currency>) | Share of <plan> |
|-------|--------|-------------------|-----------------|
| requirements | ~… | ~… | … % |
| **Total** | **~…** | **~…** | **… %** |

**Implementation by Step**

| Step | Tokens | Cost (<currency>) | Share of <plan> |
|------|--------|-------------------|-----------------|
| Step 1 | ~… | ~… | … % |
| **Total implementation** | **~…** | **~…** | **… %** |

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
