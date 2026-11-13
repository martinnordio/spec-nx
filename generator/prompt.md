# Generator

Generate a **spec kit** for this project: scan the repository, suggest answers to the setup
questions, ask the user, save the answers, and have the AI model adapt spec-nx's building
blocks to the project. Run it again with `--update` to regenerate the kit from a newer spec-nx
or with a newer model, without asking again.

## Commands

```
GENERATE KIT
```
First time in a project, or for a new team member (only the questions without an answer are
asked).

```
GENERATE KIT --update
```
Regenerate `.specs/kit/` from the saved answers; asks only questions that are new.

## Where things are

This file is `<spec-nx>/generator/prompt.md`, where `<spec-nx>` is spec-nx in the project
(usually `.spec-nx/`, a git submodule). The project is the repository that contains it.

| In spec-nx | What |
|------------|------|
| `generator/questions.md` | The setup questions, how to suggest answers, what each answer selects, and the format of the two settings files |
| `generator/layer.md` | The format of a company layer and how it is used |
| `stages/<stage>/prompt.md` | Reference prompt of each stage (`requirements`, `plan`, `pr`, …) |
| `stages/skills/<role>.md` | Reference roles the stage prompts load |
| `stages/spec_template.md` | Reference spec template |
| `stages/kit_readme.md` | Reference README of the kit (workflow and commands) |
| `stages/guidelines/` | `GUIDELINES:` prompt and the baseline coding rules per language |
| `stages/setup/project_spec.md` | How to write the project setup spec of a new project (Q0c) |
| `stages/tools/` | Reference git-host scripts (PowerShell and bash) and their README |

| In the project | What |
|----------------|------|
| `.specs/spec-nx.json` | Project settings (committed) |
| `.specs/spec-nx.local.json` | Developer settings (not committed) |
| `.specs/kit/` | The generated kit — replaced on every generation |
| `<layer>/` | A company layer, if the project uses one (`layer` in the settings) |
| `.specs/features/` | The project's specs — **never** changed by the generator |

## The contract every kit keeps

The kit is the model's adaptation of the building blocks, so it can differ in wording and
examples from project to project. These must stay exactly as in spec-nx, so that kits stay
compatible with updates and with each other:

- The **commands**: `REQUIREMENTS:`, `UPDATE ISSUE:`, `PLAN:`, `IMPLEMENT:`, `CLOSE:`,
  `GUIDELINES:`, `PR:` and their arguments.
- The **spec file**: name `yyyy_mm_dd_<name>_spec.md`; the Stage log (date, stage, command,
  model) above Part 1 · Requirements, the marker line `<!-- spec-nx:plan -->`, Part 2 · Plan;
  statements `S<n>`, Steps, decisions `D<n>`. Every stage that writes to the spec adds a
  Stage log row with the model it ran on.
- The **summary block** markers `<!-- spec-summary:start -->` / `<!-- spec-summary:end -->`.
- The **scripts**: names, parameters, `-DryRun` / `--dry-run`, and what they change.
- The **layout** of the kit: `README.md`, `<stage>/prompt.md`, `skills/`, `spec_template.md`,
  `tools/`
  (the stage prompts use paths relative to themselves).
- The **settings keys** in `generator/questions.md`.

---

## GENERATE KIT

1. **Read the settings.** Load `.specs/spec-nx.json` and `.specs/spec-nx.local.json` if they
   exist. Every question whose key already has a value is not asked again.

   **Find the company layer** (Q5, see `generator/layer.md`): `layer` from the settings, or a
   folder with a `layer.json` in the project. If the user accepts it, read its `layer.json`
   and `defaults.json` now — they are the suggestions for the questions below.

2. **Scan the project** to suggest answers (see "Suggest from …" in `generator/questions.md`):
   - is the repository empty (only README, LICENSE, `.git*` files, `.specs/`, submodules)?
   - `git remote get-url origin`, the operating system;
   - languages, main folders, how the project is built, run and tested (README, build files,
     test folders);
   - existing `.specs/` content, a pull-request template, `.gitignore`.

   Tell the user in a few lines what you found.

3. **Ask the questions** of `generator/questions.md` that have no answer yet, in the order of
   its question table, one short message each, with your **suggestion** and the options.
   Respect the rules there (for example Q2b only with a git host; Custom in Q1 one stage at a
   time; Q1 and Q1b at developer level for a personal kit). If a chosen stage does not exist
   yet in `stages/`, say so and leave it out.

4. **Save the answers.**
   - `.specs/spec-nx.json`: `version`, `spec_nx_version` (`git -C <spec-nx> rev-parse --short
     HEAD`), `generated` (today), and the project answers; add the developer's `shell` to
     `shells`; `model` (the name of the model you are) when the kit is shared.
   - `.specs/spec-nx.local.json`: `version`, `shell`; `stages`, `on_demand` and `model` when
     the kit is personal.
   - `.gitignore` of the project: add `.specs/spec-nx.local.json`; add `.specs/kit/` when the
     kit is personal. Do not change other lines.

5. **Generate `.specs/kit/`.** Delete the old `.specs/kit/` if there is one, then for the
   stages in `stages` and `on_demand`:
   - `<stage>/prompt.md` from `stages/<stage>/prompt.md`;
   - the skills those prompts list under *Skills to load*, into `skills/`;
   - `spec_template.md`;
   - `README.md` from `stages/kit_readme.md`: only the rows of the kit's stages;
   - `guidelines/prompt.md` and, for each language in `languages` that has one, the baseline
     `guidelines/<language>.md` — adapted to the project's versions and tools (never copy
     rules its linter configuration contradicts);
   - `tools/README.md`, `tools/spec_summary.*` and `tools/<git_host>/` — only the scripts for
     the shells in `shells` — when the kit has the `pr` stage or `link_issues` is `true`.

   **Adapt** each prompt and skill to the project while keeping the contract:
   - use the project's own words, folders and examples (its language, how it is run and
     tested, where its docs are) instead of generic ones;
   - leave out parts about stages the kit does not have (for example, `UPDATE ISSUE` when
     `link_issues` is `false`; *Skills to load* lines for skills not copied);
   - keep instructions short and concrete; do not add new commands.

   Scripts are copied **unchanged** unless the project needs a change (for example a
   different default branch); any change must keep their parameters and behaviour.

   **With a company layer** (`generator/layer.md`):
   - its `guidelines/<language>.md` replaces the spec-nx baseline of that language;
   - its `notes/<stage>.md` is added to the end of that stage's prompt under a heading
     **Company notes** — leave out and report any note that contradicts the contract;
   - its `skills/<role>.md` is copied when a prompt or note loads it;
   - its `looks/` is copied to `ui/looks/` when the kit has the `ui` stage;
   - its `setup/` gives the suggestions of the project setup spec (step 8).

6. **Check the kit.**
   - Every `../…` path in the generated prompts exists inside `.specs/kit/`.
   - The contract items above are present in the generated files.
   - Scripts: PowerShell files parse and contain only ASCII characters (Windows PowerShell
     5.1 misreads other characters in files without a byte-order mark); bash files pass
     `bash -n`; with a git host and network, run the issue script with the dry run on an
     existing issue if the user names one.

7. **Prepare the specs folder.** Create `.specs/features/` and `.specs/features/done/` (with a
   `.gitkeep`) if they do not exist. Never change files already there.

8. **Project setup spec** (only when Q0c was answered yes in this run): follow
   `stages/setup/project_spec.md` — ask per language, then write the spec as a **new** file in
   `.specs/features/` (stop if it exists). Save its file name as `project_spec`.

9. **Report:** the answers, the kit's files, what was adapted (one line per file), what came
   from the company layer (one line per file), the checks,
   and how to start: `Load .specs/kit/requirements/prompt.md` → `REQUIREMENTS: <name> — <request>`
   (the whole workflow is in `.specs/kit/README.md`). With a project setup spec, start with
   `Load .specs/kit/implementation/prompt.md` → `IMPLEMENT: <project spec>` instead.
   Remind the user to commit `.specs/spec-nx.json` (and `.specs/kit/` when shared).

## GENERATE KIT --update

1. Read both settings files. If `.specs/spec-nx.json` does not exist, run `GENERATE KIT`
   instead.
2. Ask **only** the questions of `generator/questions.md` whose key is missing (questions added
   to spec-nx since), and stages the user chose earlier that now exist in `stages/`
   (offer them; do not add them without asking).
3. Update `spec_nx_version`, `generated` and `model`; keep every other answer. Read the company
   layer again (`layer`), if there is one: it may have changed with its repository.
4. Regenerate `.specs/kit/` as in steps 5–6 above, from the current building blocks and with
   the current model.
5. Report what changed in the kit compared to before (new or removed files, notable changes),
   and the old and new `spec_nx_version` / `model`.

## Never

- Change, move or delete anything in `.specs/features/` (the generator only **adds** the
  project setup spec, Q0c).
- Write tokens, passwords or personal data into the settings or the kit.
- Commit or push — the user does that.
