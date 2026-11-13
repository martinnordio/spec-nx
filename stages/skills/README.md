# Skills

A **skill** is a role the assistant takes on: how to think, what to produce and what to avoid.
A stage prompt holds the commands; it lists the skills it needs under *Skills to load*. One
skill can serve several stages, and the generator copies only the skills the chosen stages
load.

## Shape

Every skill file has the same sections, in this order:

| Section | Holds |
|---------|-------|
| `# Skill: <Name>` and a one-line **Role** | What the role turns into what |
| **Persona** | How the role thinks, in a few sentences |
| **Used by** | The stage prompts and commands that load it |
| **Inputs** | What it reads |
| **Outputs** | What it produces |
| **Process** | Numbered steps |
| **Anti-patterns** | What it never does, with a short example |
| **Quality checks** | Checkboxes to verify before answering |
| **Handoffs** | When to pass the work to another role |

Keep a skill under ~80 lines. Project facts (folders, tools) belong in the stage prompt or the
guidelines, not in the skill.

## Roles and handoffs

| Skill | Thinks about | Used by |
|-------|--------------|---------|
| [requirements_engineer](requirements_engineer.md) | *What* is wanted | requirements, plan |
| [architect](architect.md) | *How* it fits: Steps, decisions, architecture, ADRs | plan, documentation |
| [developer](developer.md) | Doing one Step well | implementation |
| [reviewer](reviewer.md) | Does the change do what the spec says, and is it sound? | review |
| [refactorer](refactorer.md) | Clean-up without behaviour change | improvement |
| [ui_designer](ui_designer.md) | Consistent screens and looks | ui |

```
requirements engineer → architect   (requirements agreed; a design choice is needed)
architect             → developer   (plan ready)
developer             → reviewer    (spec done)
reviewer              → refactorer  (out-of-scope findings → improvement spec)
refactorer            → architect   (a clean-up needs a decision or an ADR)
```

## Adding a skill

A project or a company layer can add a role (for example a data scientist): a new file with
the shape above, listed under *Skills to load* of the prompts that use it.
