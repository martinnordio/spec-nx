Answers are saved at two levels, so `GENERATE KIT --update` never asks them again — only
questions whose key is missing (questions added to spec-nx later). `GENERATE KIT --update
--force` asks them all again, with the saved answers as suggestions:

| Level | File | Shared? | Holds |
|-------|------|---------|-------|
| **Project** | `.specs/spec-nx.json` | Committed; the same for the whole team | What the project is and how the team works: project start, languages, stages, git host, issues, the shells the kit supports |
| **Developer** | `.specs/spec-nx.local.json` | Ignored by git; one per developer | How *you* work: your shell; any project key you want different for you |

### Three layers

When a stage or script runs, it reads up to three files, each winning over the one before:

| Layer | File | When |
|-------|------|------|
| **Kit** | `<kit>/.specs/spec-nx.json` — the settings of the kit's own repository | Only when the kit is a repository of its own (a shared kit added as a submodule, `kit_ref`); read when a stage runs, so a change there needs no regeneration in the projects |
| **Project** | `.specs/spec-nx.json` | Always |
| **Developer** | `.specs/spec-nx.local.json` | Always (never committed) |

**Merge rule:** a file holds only the keys it changes or adds. A key replaces the same key of
an earlier layer; an object (`work_items`, `cost`, `models`) is merged key by key; a list
(`stages`, `languages`) is replaced as a whole; `null` removes the key.

**Project-only keys:** `version`, `spec_nx_version`, `generated`, `kit`, `kit_dir`, `kit_ref`,
`kit_files`, `shells` (and `model`, unless the kit is personal) describe the generated kit and
are read from the project's file only; in the developer's file they are ignored with a
warning. Every other key may be set in any layer — for example `parent`, `work_items` or
`"stages": ["requirements"]` for one developer. With fewer `stages`, the other stages answer
that they are turned off in that file.

`tools/settings.ps1` / `settings.sh` of the kit apply the rule for the scripts and show every
setting with the file it comes from. Examples: [Customizing spec-nx](../docs/customize.md).
