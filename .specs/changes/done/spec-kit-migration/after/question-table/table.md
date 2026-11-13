| # | Question | Level | Key | Default |
|---|----------|-------|-----|---------|
| Q5 | Company layer — use one? (asked first: its defaults feed every suggestion) | project | `layer` | the layer found, or `null` |
| Q0 | Project start — a new (empty) project or an existing one? | project | `project` | from the scan |
| Q0b | Languages — which programming languages? | project | `languages` | from the scan |
| Q0c | Write a project setup spec? (new projects only) | project | `project_spec` | yes |
| Q1 | Workflow — which stages do you use? | project | `stages` | Simple: `["requirements", "plan", "implementation", "pr"]` |
| Q1b | On-demand stages — which extra commands do you want? | project | `on_demand` | `[]` |
| Q2 | Git host — where is the repository? | project | `git_host` | from the `origin` remote |
| Q2b | Keep each spec in sync with an issue / backlog item? | project | `link_issues` | `true` if there is a git host |
| Q2c | Azure DevOps: which work item type for a spec? | project | `work_item_type` | `"Product Backlog Item"` |
| Q3 | Which shell do you run the kit's scripts in? | developer | `shell` | from the operating system |
| Q4 | Share the kit with the team, or keep it personal? | project | `kit` | `"shared"` |
| Q6 | AI agent permissions — for which agents? | project | `agent` | the agents found |
