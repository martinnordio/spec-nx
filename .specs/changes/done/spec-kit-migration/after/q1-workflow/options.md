## Q1 · Workflow

**Ask:** *Which workflow do you want?*

| Option | `stages` | For |
|--------|----------|-----|
| **Simple** (default) | `["requirements", "plan", "implementation", "pr"]` | Small teams, data science: a spec, small Steps, a pull request |
| **Full** | `["requirements", "plan", "implementation", "documentation", "review", "pr"]` | Product code: also documents and a semantic diff for the reviewer |
| **Custom** | your choice, one stage at a time | Anything else |

**Custom** asks one short question per stage, in this order, and shows the rule:

```
requirements: yes (always)
plan:          yes / no
implementation: yes / no   (only if plan is yes)
documentation: yes / no
review:        yes / no    (only if implementation is yes)
pr:            yes / no
```
