# Requirements → Plan → PR Spec

> **Author:** Martin Nordio
> **Status:** 🔄 In progress — Steps 0–6 done
> **Created:** 2026-11-09
> **Last updated:** 2026-11-09
> **Branch:** `feature/spec-plan-pr` (all Steps; one pull request at the end)
> **Issue:** #1

---

# Part 1 · Requirements

## Context

spec-nx is a generator: users add it to their project, answer a few setup questions (or let
spec-nx read them from the repository), and an AI assistant generates the spec kit they need —
only the stages they use. This first feature defines the idea and builds the three stages a
small team needs to start: **requirements → plan → pr**, plus a minimum generator that
writes the kit into a project and can update it later. A command-line tool, the other stages
and the first example kit come in later specs.

**Already in the repository:** `LICENSE` (MIT).

**New:** everything else — README, layout, spec template, setup questions, three stages.

| Document | Purpose |
|----------|---------|
| [README.md](../../README.md) | The idea, stages, setup questions, layout, status |
| [stages/spec_template.md](../../stages/spec_template.md) | The spec file template (Part 1 · Requirements, Part 2 · Plan) |
| [.specs/README.md](../README.md) | Where spec-nx's own specs live and how they are named |

## 1 · Specs

- **S1 — The idea is written down:** the README explains the goal (software engineering for
  vibe coding: requirements first, small steps, evidence), the generator, the stages, the
  setup questions, "requirements first, then the plan", the git-host connection, how to add
  spec-nx to a project and what works today.
- **S2 — One spec file, two parts:** the spec template has Part 1 · Requirements and
  Part 2 · Plan, separated by a marker line, so one file grows from requirements to plan.
  Spec files are named `yyyy_mm_dd_<name>_spec.md` and keep their name when closed.
- **S3 — Setup questions:** `generator/questions.md` lists the setup questions with their
  options and how each can be read from an existing repository; it contains at least
  Q1 (development method = which stages) and Q2 (git host: none, GitHub, Azure DevOps, and
  whether specs are linked to an issue / backlog item).
- **S4 — Requirements stage:** with one prompt, the assistant creates a new spec file with
  Part 1 filled, after reading the repository (README, existing specs, folder structure) and
  listing what already exists and what is new; it asks the author open questions instead of
  guessing, and does not write Part 2. On request, it updates the linked issue / backlog item
  with the current requirements (S10).
- **S5 — Plan stage:** with one prompt, the assistant fills Part 2 of an existing spec from
  its agreed Part 1 and the repository: Steps with goals and tasks, decisions, deferred items
  and the Definition of Done for the stages in use; it does not change Part 1 (it adds open
  questions instead).
- **S6 — Pull-request stage:** with one prompt, the branch is pushed and a pull request is
  opened or updated on GitHub or Azure DevOps; only the `spec-summary` block of its
  description is replaced, with the spec title, the requirements (S1…Sn), the Steps with their
  status and a link to the spec. The stage **always** updates the linked issue / backlog item
  in the same way, so spec, issue and pull request say the same (S10). A dry run shows the
  result without changing anything.
- **S7 — Local testing:** `testing/` is ignored by git except its README, which explains how
  to try the stages on a throw-away project.
- **S8 — Clean content:** nothing in the repository names a company, customer, internal
  system, internal URL, local path or credential, and no person except the author; every
  commit is checked before it is pushed.
- **S9 — Used on itself:** this spec is written with the template, planned with the plan
  stage's rules, and its pull request is opened by its own pr stage, which also updates
  issue #1.
- **S10 — Issue sync:** the spec header names its issue (GitHub `#<n>`) or backlog item
  (Azure DevOps ID). A script per git host replaces only the `spec-summary` block of the
  issue / backlog item description with the spec summary; text written by hand outside the
  block is kept; a dry run shows the result first. The requirements stage uses it on request,
  the pr stage always.
- **S11 — Generate a kit:** in a project, one prompt command (`GENERATE KIT`) scans the
  repository, suggests an answer for each setup question, asks the user to confirm or change
  each one, saves the answers in `.specs/spec-nx.json`, and generates the kit for the chosen
  stages into `.specs/kit/`: the user's AI model takes spec-nx's stage prompts, spec template
  and git-host tools as the starting point and adapts them to the project, keeping their
  commands, file names and markers; generated scripts pass a dry run. It creates
  `.specs/` and `.specs/features/` if they do not exist and never touches existing specs.
- **S12 — Update a kit:** `GENERATE KIT --update` reads `.specs/spec-nx.json`, asks nothing
  (except questions added to spec-nx since the file was written), and regenerates
  `.specs/kit/` from the current spec-nx with the current AI model; the configuration records
  the spec-nx version and the model it was generated with.
- **S13 — Project and developer settings:** answers about how the team works (stages, git
  host, issues) are saved for the project in `.specs/spec-nx.json` (committed); answers about
  how one developer works (Q3: shell — PowerShell 7 or bash, suggested from the operating
  system) are saved in `.specs/spec-nx.local.json` (ignored by git). The kit contains the
  git-host scripts for every shell used in the team, so it works on Windows, macOS and Linux.
- **S14 — Shared or personal kit:** a project answer (Q4) decides whether `.specs/kit/` is
  committed and shared by the team, or ignored by git so that each contributor generates their
  own kit with their own stages (Q1 becomes a developer answer) and AI model; the specs in
  `.specs/features/` are shared either way.

### Open questions

_None open._ Q-A (script language) was answered while writing Step 1: the kit offers
PowerShell 7 and bash, chosen per developer (Q3, S13).

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## 2 · Spec Overview

| Step | Description | Status | Detail |
|------|-------------|--------|--------|
| **0** | Bootstrap: layout, README, template, testing README, this spec | ✅ Done | [→ Step 0](#step-0--bootstrap) |
| **1** | Setup questions Q1, Q2 | ✅ Done | [→ Step 1](#step-1--setup-questions) |
| **2** | Git-host tools: update issue / backlog item and pull request (GitHub, Azure DevOps) | ✅ Done | [→ Step 2](#step-2--git-host-tools) |
| **3** | Requirements stage (+ optional issue update) | ✅ Done | [→ Step 3](#step-3--requirements-stage) |
| **4** | Plan stage | ✅ Done | [→ Step 4](#step-4--plan-stage) |
| **5** | Pull-request stage (pull request + issue, always) | ✅ Done | [→ Step 5](#step-5--pull-request-stage) |
| **6** | Generator: `GENERATE KIT` (scan, suggest, ask, configuration, kit) and `--update` | ✅ Done | [→ Step 6](#step-6--generator) |
| **7** | Use it on this spec, close it, update issue #1 and the pull request | ⬜ Not started | [→ Step 7](#step-7--use-it-on-this-spec-and-close-it) |

> **Step completion protocol (required):** every time a Step is finished, in the same edit:
> tick its tasks `[x]`, set its row above to ✅ Done, and append a
> **`**Done (YYYY-MM-DD · ~<duration>)**`** line to its Notes (summary + verifying result).

> **Time tracking (required for every Step):** each Step's first task is
> `Record the start time in Notes`; the Done line records the finish and the duration.

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | One branch and **one pull request per spec**; **one commit per Step**, pushed after each Step; merged with a **merge commit** | One review per feature; each Step stays visible in the history |
| D2 | The pr stage writes a **spec summary** only (title, S1…Sn, Steps with status, link); the semantic diff comes with the review stage later | Smallest useful pull request for teams without a review stage |
| D3 | Folder layout: `generator/` (questions, generator prompt) and `stages/<stage>/` (prompt, scripts); the spec template is shared at `stages/spec_template.md` | A kit is assembled by picking stage folders |
| D4 | Stage prompts are adapted from an earlier private kit and rewritten generically, never copied as is | S8 |
| D5 | The generator is a **prompt** run in the AI chat (`generator/prompt.md`); a command-line tool comes in a later feature and reads the same configuration | Nothing to install; the configuration format keeps the CLI easy to add |
| D6 | Git-host scripts live in `stages/tools/`, shared by the stages and selected by Q2 — not inside `stages/pr/` | A kit with only the requirements stage also needs the issue update |
| D7 | In a project, everything spec-nx writes lives in `.specs/`: `spec-nx.json` (answers + spec-nx version), `kit/` (generated, replaced on update), `features/` (the project's specs, never overwritten) | One folder to find, review and commit; updating the kit cannot touch specs |
| D8 | The stage prompt (the AI assistant) builds the summary text from the spec; the git-host scripts only put that text into the `spec-summary` block of an issue or pull request | Scripts stay tiny, so writing each in PowerShell 7 and bash is cheap |
| D9 | spec-nx's own repository is built and tested in Windows PowerShell 5.1 (the author's shell; the scripts also run in PowerShell 7); the bash scripts are tested in `testing/` with Git Bash | What the author uses is separate from what the kit offers (S13) |
| D10 | spec-nx's `stages/` are the **reference building blocks**; a generated kit is the user's model's adaptation of them. The contract every kit keeps: the commands, the spec template's parts and marker, the `spec-summary` markers, the configuration keys. Scripts are checked with a dry run | A newer model gives a better kit without a new spec-nx release, and the contract keeps kits compatible with updates |
| D11 | **Prompts and skills are separate files**, as in the earlier private kit: `stages/<stage>/prompt.md` holds the commands and rules and lists its *Skills to load*; roles live in `stages/skills/<role>.md`, shared by the stages; the generator copies the skills the chosen stages need | One role serves several stages; roles and commands change independently; the generator can adapt a role to a team without touching the commands |

---

## Step 0 — Bootstrap

### Goal
The repository has the layout, the README with the idea, the two-part spec template, the
testing README and this spec.

### Tasks
- [x] Record the start time in Notes below.
- [x] `README.md`: idea, stages, requirements first, setup questions, layout, status, license (S1).
- [x] `stages/spec_template.md`: Part 1 · Requirements, marker, Part 2 · Plan (S2).
- [x] `.gitignore` with `testing/*` except `testing/README.md`, and `*.local.md`; `testing/README.md` (S7).
- [x] `examples/README.md` (placeholder), `.specs/README.md`, `.github/pull_request_template.md` with the `spec-summary` block.
- [x] This spec, Part 1 and Part 2.
- [x] Clean-content check (S8).

### Notes
Started: 2026-11-09.

- Replaces an earlier, uncommitted plan (a kit with a semantic-diff loop) after the project
  was re-scoped as a generator and renamed spec-nx.
- Branch renamed from `spec/spec-plan-pr` to `feature/spec-plan-pr`: branches are always
  `feature/<name>`; "spec" is only the file (see README, Terms).

**Done (2026-11-09 · ~1h)** — layout, README, template, testing README and this spec; clean-content check clean.

---

## Step 1 — Setup questions

### Goal
The setup questions Q1 and Q2 are defined (S3).

### Tasks
- [x] Record the start time in Notes below.
- [x] `generator/questions.md`: Q1 development method (stages, with the three example sets), Q2 git host (none / GitHub / Azure DevOps; link specs to an issue / backlog item: yes / no); for each: options, default, how to read it from a repository, which stage folders and tools it selects.
- [x] Room for later questions (numbered, one table).
- [x] Clean-content check (S8); commit "Step 1: setup questions (#1)"; push.

### Notes
Started: 2026-11-09.

- Q2 is split into Q2 (git host) and Q2b (`link_issues`), asked only with a git host.
- The format of `.specs/spec-nx.json` is documented in `questions.md` (keys `version`,
  `spec_nx_version`, `generated`, `stages`, `git_host`, `link_issues`); Step 6 decides
  whether a JSON schema file is also needed.
- Stages not yet in spec-nx are not saved, so `--update` offers them once they exist.
- Also in this commit: spec updated for issue sync (S10), the generator (S11, S12, Step 6),
  shared git-host tools (D6), the `.specs/` layout in projects (D7), and project vs developer
  settings (S13, Q3 shell, D8, D9); README "How it works" and "Project and developer settings".

**Done (2026-11-09 · ~1h)** — `generator/questions.md` with Q1, Q2, Q2b, Q3 and both configuration formats; clean-content check clean.

---

## Step 2 — Git-host tools

### Goal
For each git host, a PowerShell 7 and a bash script put a given summary text into the
`spec-summary` block of an issue / backlog item and of a pull request (S6, S10, S13).

### Tasks
- [x] Record the start time in Notes below.
- [x] Format of the summary block (title, S1…Sn, Steps with status, link to the spec) — written down for the stage prompts that build it (D8).
- [x] `stages/tools/github/`: `update_issue` and `update_pr` in `.ps1` and `.sh`, using `gh`: replace only the block (add it at the end if missing); `update_pr` finds or creates the pull request of the current branch (draft allowed); `--dry-run` prints the new description.
- [x] `stages/tools/azure_devops/`: the same in `.ps1` and `.sh`, using the REST API with `AZURE_DEVOPS_EXT_PAT`.
- [x] Dry run against issue #1 with both shells (nothing changed on GitHub).
- [x] Clean-content check (S8); commit "Step 2: git-host tools (#1)"; push.

### Notes
Started: 2026-11-09.

- Files: `stages/tools/README.md` (what each script does, needs, the summary format),
  `spec_summary.ps1` / `.sh` (shared: put a text between the markers), `github/` and
  `azure_devops/` with `update_issue` and `update_pr` in both shells; `azure_devops/ado.ps1` /
  `.sh` read organisation, project and repository from the remote.
- PowerShell scripts run in **Windows PowerShell 5.1** as well as PowerShell 7 (the author's
  computer has only 5.1). Bash scripts tested with Git Bash; `.gitattributes` keeps `*.sh` in
  LF and they are committed executable.
- Checked: block replacement (empty body, no markers, existing block, idempotent) in both
  shells; `update_issue` and `update_pr` dry runs against issue #1 and this branch in both
  shells (would create a draft pull request with `Closes #1`); all `.ps1` parse, all `.sh` pass
  `bash -n`; Azure DevOps remote parsing with a made-up URL.
- **Not yet run against Azure DevOps** (no Azure DevOps project to test with); the scripts
  follow the REST API (work item description stored as Markdown; pull request description
  limit 4000 characters checked). To try when an Azure DevOps project is available.
- Azure DevOps bash scripts need `curl` and `jq`; the GitHub ones only `gh`.

**Done (2026-11-09 · ~1h30)** — git-host tools for GitHub and Azure DevOps in PowerShell and bash; dry runs on issue #1 and this branch in both shells.

---

## Step 3 — Requirements stage

### Goal
The assistant can write Part 1 of a new spec from a short request and the repository, and on
request update the linked issue / backlog item (S4, S10).

### Tasks
- [x] Record the start time in Notes below.
- [x] `stages/requirements/prompt.md`: command `REQUIREMENTS: <name> — <request>`; reads the repository first; writes the file name with today's date; fills Part 1 only; lists "already in the repository" and "new"; asks open questions.
- [x] Command `UPDATE ISSUE: <spec file>` in the same prompt: calls the git-host tool for the issue / backlog item in the spec header (dry run first).
- [x] Role text for the assistant (requirements engineer) inside the prompt or as `stages/requirements/role.md`.
- [x] Try it in `testing/` on a throw-away project; note the result in this Step's Notes.
- [x] Clean-content check (S8); commit "Step 3: requirements stage (#1)"; push.

### Notes
Started: 2026-11-09.

- One file, `stages/requirements/prompt.md`, with the role inside it and three commands:
  `REQUIREMENTS: <name> — <request>` (new spec), `REQUIREMENTS: <spec file> — <change>`
  (revise Part 1; statement numbers stay stable), `UPDATE ISSUE: <spec file>` (dry run, then
  the real update after confirmation; host from `spec-nx.json` or the remote, shell from
  `spec-nx.local.json` or the operating system).
- The prompt uses paths relative to itself (`../spec_template.md`, `../tools/…`), so it works
  in spec-nx and in a generated kit; `generator/questions.md` now keeps the same layout in the
  kit (`.specs/kit/tools/<git_host>/`).
- Part 2 is replaced by a one-line placeholder under the marker until the plan stage runs.
- Trial (`testing/todo-trial`, a small command-line to-do list, not pushed):
  `REQUIREMENTS: save_tasks — keep my tasks after I close the program, and let me mark a task
  as done` → `2026_11_09_save_tasks_spec.md` with "already in the repository" (`todo.py`
  `add`/`list`, README), 5 testable statements (kept between runs, `done <n>`, wrong number,
  first run, existing usage) and 2 open questions (where to keep the tasks; `done` twice).
  No remote, so `UPDATE ISSUE` takes the "no git host" path; the issue dry run itself was
  checked in Step 2.

**Done (2026-11-09 · ~45m)** — requirements stage prompt with `REQUIREMENTS` and `UPDATE ISSUE`; trial spec written as expected.

- Changed in Step 4 (D11): the role moved out of the prompt into
  `stages/skills/requirements_engineer.md`; the prompt now lists it under *Skills to load*.

---

## Step 4 — Plan stage

### Goal
The assistant can fill Part 2 of a spec from its agreed Part 1 (S5).

### Tasks
- [x] Record the start time in Notes below.
- [x] `stages/plan/prompt.md`: command `PLAN: <spec file>`; refuses while Part 1 has unanswered open questions; writes Steps (each starting with the start-time task), decisions, deferred items and a Definition of Done for the stages in use; never edits Part 1.
- [x] Skills as separate files (D11): `stages/skills/architect.md` (new) and `stages/skills/requirements_engineer.md` (moved out of the requirements prompt); both prompts list their *Skills to load*.
- [x] Try it in `testing/` on the spec from Step 3; note the result.
- [x] Clean-content check (S8); commit "Step 4: plan stage (#1)"; push.

### Notes
Started: 2026-11-09.

- `PLAN: <spec file>` checks Part 1 first (open questions, untestable or compound statements)
  and stops without writing if it is not ready; writes Overview, Decisions, Steps (goal with
  the statements covered, start-time task first, a check last), Deferred, Review Log and a
  Definition of Done for the stages in `stages`; sets the status to "plan ready". `PLAN` again
  keeps Steps already done and re-plans the rest, with a Review Log line.
- Skills adapted generically from the earlier private kit: persona, used by, inputs, outputs,
  process, anti-patterns; the architect is scoped to planning (ADRs and architecture documents
  come with later stages).
- README: new "Prompts and skills" section and `skills/` in the layout; `questions.md`: the
  generator also copies the skills the chosen stages load.
- Trial on `testing/todo-trial` (not pushed): `PLAN` on the Step 3 spec stopped because of the
  2 open questions (as intended); `REQUIREMENTS: <spec> — <answers>` folded them into S1 and a
  new S6 (statement numbers kept); `PLAN` then wrote 3 Steps covering S1–S6 (1: keep tasks in
  `tasks.json`; 2: `done`; 3: README and final check), 3 decisions (JSON format, one file,
  `unittest` with a temporary folder) and 1 deferred item (delete a task).

**Done (2026-11-09 · ~1h)** — plan stage prompt, skills split out; trial: gate on open questions, revise, plan with full coverage.

---

## Step 5 — Pull-request stage

### Goal
The branch is pushed and the pull request and the issue / backlog item show the same spec
summary (S6, S10).

### Tasks
- [x] Record the start time in Notes below.
- [x] `stages/pr/prompt.md`: command `PR: <spec file>` (and `--dry-run`): push the branch; open or update the pull request; **always** update the linked issue / backlog item; both via the git-host tools.
- [x] Open this branch's pull request as a **draft** with the stage (`Closes #1` in the description); check the dry run for issue #1.
- [x] Clean-content check (S8); commit "Step 5: pull-request stage (#1)"; push.

### Notes
Started: 2026-11-09.

- `PR: <spec file>`: checks the branch matches the spec header and nothing is uncommitted;
  finds host and shell; builds the full summary (statements + Plan table) in the format of
  `stages/tools/README.md`; title `<spec title> (#<issue>)`; draft while the spec is open; dry
  run of both the pull request and the issue, then push and the real updates after
  confirmation; marks ready only when asked; never merges. No skill needed (mechanical).
- Run on this spec: summary of S1–S14 and Steps 0–7 (2216 characters, under the Azure DevOps
  limit). Dry runs: "would create a draft pull request 'Requirements → Plan → PR (#1)' from
  `feature/spec-plan-pr` with `Closes #1`"; issue #1 keeps its hand-written text with the
  summary added below. The real draft pull request and issue update are made by the author
  right after this commit (the author runs git and GitHub writes).
- When a script is started as a separate `powershell -File` process, the console may show
  `→` or `·` garbled; the text sent to GitHub is UTF-8 and correct (checked in the same session).

**Done (2026-11-09 · ~40m)** — pr stage prompt; dry runs of the draft pull request and issue #1 with this spec's summary.

---

## Step 6 — Generator

### Goal
In a project, `GENERATE KIT` creates `.specs/spec-nx.json` and `.specs/kit/` from the answers,
and `GENERATE KIT --update` regenerates the kit without asking again (S11, S12).

### Tasks
- [x] Record the start time in Notes below.
- [x] `generator/prompt.md`: `GENERATE KIT` — scan the repository (git remote, languages, folders, existing `.specs/`), suggest answers to the questions of `generator/questions.md`, ask the user to confirm each, write `.specs/spec-nx.json`, generate `.specs/kit/` by adapting the chosen stage prompts, spec template and git-host tools to the project (D10), dry-run the generated scripts, create `.specs/features/` if missing.
- [x] `GENERATE KIT --update`: read the configuration; ask only questions it does not contain; regenerate `.specs/kit/` with the current model; record the spec-nx version and the model; never touch `.specs/features/`.
- [x] Developer settings: ask Q3 on each computer, write `.specs/spec-nx.local.json`, add it to the project's `.gitignore`, add the shell to the project's `shells` (S13).
- [x] Shared or personal kit (Q4): with `"personal"`, add `.specs/kit/` to `.gitignore` and keep `stages` and `model` in the developer file (S14).
- [x] `generator/spec-nx.schema.json` (or a documented format in `questions.md`): `version`, `spec_nx_version`, `stages`, `git_host`, `link_issues`.
- [x] Try both commands in `testing/` on a throw-away project (GitHub remote, no `.specs/`); note the result.
- [x] Clean-content check (S8); commit "Step 6: generator (#1)"; push.

### Notes
Started: 2026-11-09.

- `generator/prompt.md`: where spec-nx's building blocks are and what the generator writes in
  the project; **the contract** every kit keeps (commands, spec file parts and marker, summary
  markers, script names and parameters, kit layout, settings keys); `GENERATE KIT` in 8 steps
  (read settings, scan, ask, save, generate and adapt, check, prepare `.specs/features/`,
  report); `--update` (ask only missing keys and newly available stages; regenerate; report
  the differences). Never touches `.specs/features/`, never commits.
- The configuration format stays documented in `generator/questions.md`; no JSON schema file
  for now (the generator is a prompt; a CLI can add one later).
- Trial on `testing/todo-trial` (made-up GitHub remote, not pushed):
  - Scan found GitHub, Windows, a Python command line without tests, one spec with Steps, no
    pull-request template; suggestions requirements → plan → pr, GitHub, issues yes,
    PowerShell, shared.
  - Wrote both settings files and `.gitignore` (`.specs/spec-nx.local.json`); kit with the
    3 stage prompts, 2 skills, the template and the GitHub PowerShell tools only (no bash, no
    Azure DevOps). Adaptation: project files and `python -m unittest` in the prompts and
    skills; host and shell fixed instead of detected; examples about tasks.
  - Checks (`testing/check_kit.ps1`): every `../` path resolves, contract items present,
    scripts parse, block replacement idempotent — ok.
  - `--update` with a settings file missing `kit` (as if from an older spec-nx): asked only Q4,
    kept all other answers, regenerated the kit (checks ok); the spec in `.specs/features/`
    was byte-identical before and after. The update replayed the copy only; adaptation would
    run again as in the first run.
- Found during the trial: Windows PowerShell 5.1 misreads non-ASCII characters in `.ps1`
  files without a byte-order mark. spec-nx's scripts are ASCII only (checked); the generator
  now checks this for generated scripts too.

**Done (2026-11-09 · ~1h15)** — generator prompt with `GENERATE KIT` and `--update`; trial: generate, adapt, check, update without asking again, specs untouched.

---

## Step 7 — Use it on this spec and close it

### Goal
spec-nx's first feature is delivered with its own stages; issue #1 and the pull request match
the spec (S9, S10).

### Tasks
- [ ] Record the start time in Notes below.
- [ ] README Status updated.
- [ ] Close the spec: move it to `.specs/features/done/`; fix links; tick the Definition of Done.
- [ ] Clean-content check (S8); commit "Step 7: close the spec (#1)"; push.
- [ ] `PR:` on this spec: pull request and issue #1 updated (the hand-written part of the issue is kept); mark the pull request ready; review; merge with a merge commit; delete the branch.

### Notes

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| 🔜 DEFERRED — Command-line tool (`spec-nx init` / `spec-nx update`) that calls an LLM and reads the same `.specs/spec-nx.json` | Prompt first (D5) | CLI spec |
| 🔜 DEFERRED — First example kit `examples/requirements-plan-pr/` | Done on another branch, with the generator from Step 6 | example spec |
| 🔜 DEFERRED — Implementation, documentation and review (semantic diff) stages | Not needed for requirements → plan → pr | later specs |
| 🔜 DEFERRED — Prompt that closes a spec | Done by hand once here | later spec |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..S14 testable)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [ ] Implementation · every Step's tasks checked
- ~~Documentation · affected docs updated — N/A (the README is a task of Steps 0 and 7)~~
- [ ] Spec closed · moved to `.specs/features/done/`
- [ ] Pull request · opened with the spec summary by the pr stage; reviewed; merged; branch deleted

### Run guide

All Steps on the branch `feature/spec-plan-pr`; one commit per Step, pushed as a backup:

```
Load .specs/features/2026_11_09_spec_plan_pr_spec.md
and stages/spec_template.md.

DO STEP <N> — <goal from the Overview>
```

```
git add -A
git commit -m "Step <N>: <goal>"
git push
```
