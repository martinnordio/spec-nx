# Company layer

A **layer** is a folder with a company's (or a team's) own defaults and rules, kept outside
spec-nx — typically in a private repository that also contains spec-nx as a submodule. The
generator reads it after spec-nx's building blocks, so the company never forks spec-nx and
spec-nx never contains company content.

```
my-company-kit/            the private repository, added to projects as a submodule
  .spec-nx/                spec-nx (submodule, pinned to a tag)
  layer/                   the layer
    layer.json             marker (required)
    defaults.json          suggested answers
    guidelines/<language>.md
    setup/<language>.md
    looks/
    agent/permissions.json
    notes/<stage>.md
    skills/<role>.md
```

Every file except `layer.json` is optional.

## Files

| File | Holds | Used by |
|------|-------|---------|
| `layer.json` | `{ "name": "<layer name>", "version": 1 }` — marks the folder as a layer | Q5 (finding the layer) |
| `defaults.json` | Any subset of the keys of `.specs/spec-nx.json` (`languages`, `stages`, `on_demand`, `git_host`, `link_issues`, `shells`, `kit`, `agent`) | Suggestions of every question |
| `guidelines/<language>.md` | The company's rules for a language, same shape as `stages/guidelines/<language>.md` | Replaces the spec-nx baseline for that language in `.specs/kit/guidelines/` |
| `setup/<language>.md` | The company's stack for a language: the answers of the table in `stages/setup/project_spec.md` (framework, package manager, tests, lint) plus fixed conventions (folders, ports, run scripts) | Suggestions of the project setup spec (Q0c) |
| `looks/` | Brand looks (colours, fonts, components) in the shape of `stages/ui/looks.md` | The ui stage (`LOOK:`) |
| `agent/permissions.json` | Extra `allow` / `ask` / `deny` entries, same shape as in `stages/agent/permissions.md` | Agent permissions (Q6) |
| `notes/<stage>.md` | A few extra rules for one stage (for example "pull-request titles in English", "every spec names its data source") | Added to that stage's prompt in the kit, under **Company notes** |
| `skills/<role>.md` | Extra roles in the shape of `stages/skills/README.md` | Copied to `.specs/kit/skills/` when a note or prompt loads them |

## Priority

1. What the **project** says: its `.specs/guidelines/`, its answers, what the scan finds in
   the repository (for example the `origin` remote decides `git_host`, even if
   `defaults.json` says otherwise).
2. The **layer**.
3. **spec-nx**.

The layer can **add** and **replace** building blocks, but not change the contract (commands,
spec file, markers, scripts, settings keys): a note that contradicts the contract is left out
and reported.

## Example

A tiny layer for a team that works in Python and Azure DevOps:

`layer/layer.json`
```json
{ "name": "example team", "version": 1 }
```

`layer/defaults.json`
```json
{
  "languages": ["python"],
  "stages": ["requirements", "plan", "implementation", "pr"],
  "git_host": "azure_devops",
  "shells": ["powershell"]
}
```

`layer/notes/requirements.md`
```markdown
- Every spec that uses data names its data source and who owns it.
```

## Versions

The layer is versioned with its repository. Projects update it like spec-nx
(`git submodule update --remote`), then run `GENERATE KIT --update`.
