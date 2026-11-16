# Tutorial: a hero list in Angular

Build one small feature of the classic Angular *Tour of Heroes* app — a list of heroes and a
detail view where a hero's name can be edited — and go once through the whole spec-nx
workflow: **requirements → plan → implementation → close**. Everything stays on your computer;
no GitHub or Azure DevOps account is needed. Connecting a git host is an
[optional last part](git-host.md).

Only the idea of the app comes from Angular's tutorial; spec-nx and your AI model write the
code.

## You need

- **git**
- **Node.js** (an LTS version) and npm
- **VS Code** with **GitHub Copilot** in agent mode — or Claude Code
- The models of the default settings (Claude Opus, Sonnet, Haiku); with other models, answer
  the model question with yours (step 2)

## 1 · Create the project

```
npx @angular/cli@latest new tour-of-heroes --defaults
cd tour-of-heroes
code .
```

`ng new` creates the app and a git repository with a first commit (on `master` or `main`,
as your git is set up). Check that it runs: `npx ng serve`, then open http://localhost:4200
and stop it with Ctrl+C; `npx ng test --watch=false` runs its two tests.

## 2 · Add spec-nx and generate your kit

In the terminal:

```
git submodule add https://github.com/martinnordio/spec-nx .spec-nx
```

In the Copilot chat (agent mode):

```
Load .spec-nx/generator/prompt.md.

GENERATE KIT
```

The assistant scans the project, says what it found (*an existing TypeScript project, no git
host*) and suggests an answer to each question. For this tutorial:

| Question | Answer |
|----------|--------|
| Languages | `typescript` (suggested) |
| Workflow | **Simple** (suggested) |
| On-demand stages | **none** (it may suggest `ui` because of the HTML templates) |
| Shared or personal kit | **shared** (suggested) |
| AI agent permissions | **VS Code Copilot** (or Claude Code) |
| Model per Step | **per Step** with the suggested models |

You get `.specs/kit/` (the stage prompts), `.specs/spec-nx.json` (your answers, with cost
tracking on) and the agent permissions. Commit them:

```
git add -A
git commit -m "Add spec-nx kit"
```

## 3 · Requirements

In the chat:

```
Load .specs/kit/requirements/prompt.md.

REQUIREMENTS: hero list — show a list of heroes (id and name) from a fixed list in the app.
Clicking a hero shows its details below the list, where its name can be edited; the new name
shows in the list at once. No server and no routing.
```

The assistant writes **Part 1** of a new spec, `.specs/features/<date>_hero_list_spec.md`:
statements `S1`, `S2`, … and maybe a few open questions. Read it. Answer open questions with
`REQUIREMENTS: <spec file> — <your answers>`, until you agree with Part 1.

This stage runs on the *reasoning* model: if your chat is on another model, the assistant
says so first.

## 4 · Plan

```
Load .specs/kit/plan/prompt.md.

PLAN: .specs/features/<date>_hero_list_spec.md
```

The assistant adds **Part 2** to the same file: small Steps, each with its tasks, and a
**Model (suggested)** column — the cheapest model that does each Step well, and why. Change a
Step or its model in the file if you disagree.

## 5 · Implement

```
Load .specs/kit/implementation/prompt.md.

IMPLEMENT: .specs/features/<date>_hero_list_spec.md
```

- The assistant offers to create the branch `feature/hero-list` — say yes.
- It asks **once**: *"Run Steps 1–n with their models, committing each Step?"* Say **yes**:
  every Step runs as a sub-agent on its model, runs the checks (build, tests), ticks its tasks,
  writes a *Done* line with its model and cost, and is committed. Nothing is pushed.
- The agent permissions make VS Code ask before every `git commit` — allow it. In Claude Code
  they deny commits: the assistant then does one Step at a time; commit it yourself with the
  suggested message and run `IMPLEMENT:` again.
- It stops at the first failing check or open question and tells you why.

Try the app again: `npx ng serve`, http://localhost:4200.

## 6 · Close

```
CLOSE: .specs/features/<date>_hero_list_spec.md
```

The spec moves to `.specs/features/done/`, gets a **Cost summary** — by stage, then the
implementation by Step — and `.specs/costs.md` lists it. Commit, then merge the branch into
your default branch (`main` or `master`):

```
git add -A
git commit -m "Close the hero list spec"
git switch master   # or main: the branch `ng new` created
git merge feature/hero-list
```

## 7 · What you have

- `.specs/features/done/<date>_hero_list_spec.md`: what was wanted (Part 1), how it was built
  (Part 2), the **Stage log** with the model, tokens and cost of every stage and Step, and
  the cost summary.
- One commit per Step on the feature branch.
- `.specs/costs.md`: the cost of every spec of the project.

**Costs are estimates and may be wrong** — see the kit's `COSTS.md`.

## Next

- [Connect GitHub or Azure DevOps](git-host.md): an issue for the next feature, and a pull
  request.
- More stages (documentation, review with a semantic diff): `GENERATE KIT --update --force` and
  choose **Full**.
- Change models or cost settings: [configuration](../configuration.md).
