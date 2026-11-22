Answers are saved at two levels, so `GENERATE KIT --update` never asks them again — only
questions whose key is missing (questions added to spec-nx later). `GENERATE KIT --update
--force` asks them all again, with the saved answers as suggestions:

| Level | File | Shared? | Holds |
|-------|------|---------|-------|
| **Project** | `.specs/spec-nx.json` | Committed; the same for the whole team | What the project is and how the team works: project start, languages, stages, git host, issues, the shells the kit supports |
| **Developer** | `.specs/spec-nx.local.json` | Ignored by git; one per developer | How *you* work: your shell; overrides of `models` and `cost` |
