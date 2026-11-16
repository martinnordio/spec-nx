## `.specs/spec-nx.json` (project)

Written by `GENERATE KIT`, read by `GENERATE KIT --update`. Commit it with the project.

```json
{
  "version": 1,
  "spec_nx_version": "a1b2c3d",
  "generated": "2026-11-09",
  "layer": null,
  "project": "existing",
  "languages": ["python", "typescript"],
  "stages": ["requirements", "plan", "implementation", "pr"],
  "on_demand": ["improvement"],
  "git_host": "github",
  "link_issues": true,
  "shells": ["powershell", "bash"],
  "kit": "shared",
  "agent": ["copilot"],
  "model": "<AI model that generated the kit>"
}
```

| Key | Meaning |
|-----|---------|
| `version` | Format of this file (1). |
| `spec_nx_version` | spec-nx commit (short hash) or tag the kit was generated from. |
| `generated` | Date of the last `GENERATE KIT` or `--update`. |
| `layer` | Answer to Q5: path of the company layer, or `null`. |
| `project` | Answer to Q0. |
| `languages` | Answer to Q0b. |
| `project_spec` | Answer to Q0c: the project setup spec's file name, or `false` (only when `project` is `"new"`). |
| `stages` | Answer to Q1 (only when `kit` is `"shared"`). |
| `on_demand` | Answer to Q1b (only when `kit` is `"shared"`). |
| `git_host` | Answer to Q2. |
| `link_issues` | Answer to Q2b. |
| `work_item_type` | Answer to Q2c (Azure DevOps only). |
| `work_items` | Answer to Q2d (Azure DevOps only): `{ "org", "project" }` of the backlog items. |
| `parent` | Optional, set by hand: the default parent (issue number / work item id) of `CREATE ISSUE`, used when neither the command nor the spec header names one. |
| `shells` | Shells the kit's scripts are generated for: every developer's Q3 answer. |
| `kit` | Answer to Q4. |
| `kit_dir` | Answer to Q4b (missing = `".specs/kit"`). |
| `kit_ref` | Answer to Q4c (missing = `kit_dir`). |
| `kit_files` | Top-level files and folders of the last generation, relative to `kit_dir` (only when `kit_dir` is not `".specs/kit"`). |
| `agent` | Answer to Q6: the AI agents whose permissions the generator writes. |
| `model` | AI model that generated the shared kit (only when `kit` is `"shared"`). Not the model of a stage run: the Stage log names the model that ran each command. |
