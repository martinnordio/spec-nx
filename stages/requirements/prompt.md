# Stage: Requirements

Write **Part 1 · Requirements** of a spec: *what* is wanted, as short, testable statements,
after checking what already exists in the repository. The plan (Part 2) is written later by
the plan stage, once the requirements are agreed.

## Commands

```
REQUIREMENTS: <name> — <what you want, in plain words>
```
Creates a new spec file with Part 1 filled.

```
REQUIREMENTS: <spec file> — <what to add or change>
```
Revises Part 1 of an existing spec (for example after the open questions are answered).

```
CREATE ISSUE: <spec file> [parent <n>]
```
Creates the issue (GitHub) or backlog item (Azure DevOps) of the spec, optionally under a
parent, with the summary of the spec; writes its number (and the parent) into the spec header.
Offered automatically when Part 1 is finished.

```
UPDATE ISSUE: <spec file>
```
Puts a summary of the spec into its issue (GitHub) or backlog item (Azure DevOps): a dry run
first, then the real update after the user confirms.

## Skills to load

Always: `../skills/requirements_engineer.md` — the role you take in this stage.

## Settings

Read the settings in their three layers (the kit's README, section *Settings*): the kit's,
the project's `.specs/spec-nx.json` and the developer's `.specs/spec-nx.local.json`, the later
winning. If the settings list `stages` and this stage is neither in it nor in `on_demand`,
answer *"The <stage> stage is turned off in <file>."* and do nothing else. In your report,
name each setting you used that does not come from the kit, with its file (for example
*parent 150310 — from `.specs/spec-nx.local.json`*).

## Model name

**Check the model first** (`../models.md`): with `models` set in the settings, run on the
configured model, as a sub-agent or after asking; with no `models`, use the tool's model.

**Tokens and cost** (`../COSTS.md`): only with the `cost` block on. Note the start time; at
the end run `../tools/usage.ps1` / `../tools/usage.sh` with it and your model, and copy its
Tokens and Cost into your Stage log row — never compute them yourself.

Wherever this prompt says *your model*, write the name of the model that runs this command
now, as your runtime reports it. Never copy it from earlier rows, from `.specs/spec-nx.json`
(its `model` is the model that generated the kit), from the kit's README or from examples. If
you cannot tell, ask the user once; otherwise write `unknown model`.

## Files this stage uses

Paths are relative to this file, so they work both inside spec-nx (`stages/requirements/`)
and in a generated kit (`.specs/kit/requirements/`).

| File | Use |
|------|-----|
| `../skills/requirements_engineer.md` | Your role: how to think and what to avoid |
| `../spec_template.md` | The spec template (Part 1 · Requirements, marker, Part 2 · Plan) |
| `../tools/README.md` | The summary format and the git-host scripts |
| `.specs/spec-nx.json`, `.specs/spec-nx.local.json` (and the kit's settings) | The settings (section *Settings* above): `git_host`, `link_issues`, `work_item_type`, `work_items`, `parent`, `shell` |

---

## REQUIREMENTS: new spec

1. **Read the repository first.** Before writing anything, look at:
   - the README and any docs folder;
   - the specs in `.specs/features/` and `.specs/features/done/` — is this feature, or part of
     it, already specified or built?
   - the folder structure and main entry points, and search the code for the words of the
     request (names of pages, commands, data, files).

   Write down what you found: it goes into **Already in the repository**.

2. **Ask before writing if something blocks you.** If the request cannot be turned into
   requirements without an answer (who uses it, what "done" looks like, a choice between two
   very different meanings), ask the user now — at most three short questions. Smaller
   doubts go into **Open questions** in the spec.

3. **Create the file** `.specs/features/<yyyy_mm_dd>_<name>_spec.md`:
   - `<yyyy_mm_dd>` is today's date; `<name>` is short, lowercase, words joined by `_`.
   - Create `.specs/features/` if it does not exist. If the file already exists, stop and say
     so.
   - Copy `../spec_template.md`.

4. **Fill the header:**
   - **Author:** the user (from `git config user.name`, or ask).
   - **Status:** `⬜ Requirements in progress`.
   - **Created** and **Last updated:** today.
   - **Branch:** `feature/<name>` (with `-` instead of `_`). Do not create the branch.
   - **Issue:** add the line `> **Issue:** #<n>` (GitHub) or `> **Backlog item:** <id>`
     (Azure DevOps) if the user gave one. If there is none yet, it is created at the end
     (`CREATE ISSUE`, step 7).
   - **Parent:** add `> **Parent:** #<n>` (GitHub parent issue) or `> **Parent:** <id>`
     (Azure DevOps, usually a Feature or Epic) if the user gave one.
   - **Stage log:** replace the example row with today, `requirements`, `REQUIREMENTS:`,
     your model, and `Part 1 written`.

5. **Fill Part 1:**
   - **Context:** two or three sentences — the problem and why it matters.
   - **Already in the repository:** what you found in step 1, with file paths. Say how the new
     feature uses or extends it.
   - **New:** what does not exist yet.
   - **1 · Specs:** `S1`, `S2`, … — one concern each:
     - **Testable:** someone can check it is met (an observable result, a number, a message).
     - **What, not how:** no frameworks, tables or function names — those belong in the plan.
     - **Short:** one or two sentences; a bold name, then the statement
       (`**S1 — Add a task:** …`).
     - Check what is often forgotten: errors and empty states, limits (sizes, numbers),
       speed, who may do it, accessibility, and what must keep working as before.
     - If an existing spec already covers part of it, refer to it instead of repeating it.
   - **Open questions:** what you could not decide; one line each, ending with your
     suggestion (`Suggestion: …`).
   - Delete the template's example block and placeholder rows.

6. **Leave Part 2 for the plan stage.** Keep the marker line `<!-- spec-nx:plan -->` and
   replace everything below it with:

   ```
   ---

   # Part 2 · Plan

   _Written by the plan stage once Part 1 is agreed._
   ```

7. **Report to the user:** the file name, the statements in one line each, the open questions,
   and the next step: *answer the open questions (`REQUIREMENTS: <spec file> — <answers>`, or
   `— take your suggestions`), then run the plan stage.* If the spec has an issue, offer `UPDATE ISSUE`.

   **When the requirements are finished** (no open questions left) and the project has a git
   host, ask: *"Create the issue / backlog item for this spec now? If it belongs under a parent
   (Azure DevOps: usually a Feature or Epic; GitHub: a parent issue), give its number."* — and
   run `CREATE ISSUE` if the user says yes. Ask only if the header has no `Issue:` /
   `Backlog item:` yet.

## REQUIREMENTS: revise an existing spec

- Change **Part 1 only**; never touch anything below `<!-- spec-nx:plan -->`.
- Keep statement numbers stable: add new ones at the end, mark removed ones
  `~~S4 — …~~ (removed: <reason>)` instead of renumbering.
- Move answered open questions into the statements, and remove them from the list.
- Update **Last updated**. If Part 2 already has a plan, tell the user which Steps the change
  may affect.
- Add a **Stage log** row: today, `requirements`, `REQUIREMENTS:`, your model, `Part 1
  revised: <what changed>`. If the spec has no Stage log (older spec), add the section from
  the template above Part 1.
- If the revision leaves no open questions, the requirements are finished: offer
  `CREATE ISSUE` as in step 7 above.

## CREATE ISSUE

1. **Check.** The header has no `Issue:` / `Backlog item:` (otherwise use `UPDATE ISSUE`).
   Find the git host and the shell as in `UPDATE ISSUE` steps 2–3; with no git host, stop.
2. **Parent.** From the command (`parent <n>`), the header's `Parent:` line, `parent` from
   the settings, or ask once:
   *"Is there a parent? (number, or none)"*. The dry run names the parent — check it.
   GitHub: the new issue becomes a **sub-issue** of
   the parent. Azure DevOps: the new backlog item gets the parent as its **Parent** link.
3. **Title and type.** Title: the spec title without the trailing "Spec". Azure DevOps type:
   `work_item_type` from the settings, otherwise `Product Backlog Item`. If Azure
   DevOps rejects the type, ask for the right one (User Story — Agile, Requirement — CMMI,
   Issue — Basic) and offer to save it as `work_item_type`. The item is created in the
   project of `work_items` (Azure DevOps), otherwise in the repository's project; the dry run
   names it — check it is the right one.
   **More fields** from the settings' `work_items` (the scripts read them; the command can
   override them): Azure DevOps `area`, `iteration`, `assigned_to`; GitHub `type`,
   `assigned_to`. Without `assigned_to` the item is assigned to the user who creates it;
   `"assigned_to": null` leaves it unassigned. The dry run lists every field with the file it
   comes from, and stops with a message naming the setting and its file when a value does not
   exist (an unknown area, iteration, person, type or parent).
4. **Summary** as in `UPDATE ISSUE` step 4, in a temporary file outside the repository.
5. **Dry run** and show it:

   | Host | PowerShell | bash |
   |------|------------|------|
   | GitHub | `../tools/github/create_issue.ps1 -Title <title> -SummaryFile <file> [-Parent <n>] [-Type <type>] [-AssignedTo <login> \| -Unassigned] -DryRun` | `../tools/github/create_issue.sh <title> <file> [--parent <n>] [--type <type>] [--assigned-to <login> \| --unassigned] --dry-run` |
   | Azure DevOps | `../tools/azure_devops/create_issue.ps1 -Title <title> -SummaryFile <file> -Type <type> [-Parent <id>] [-Area <path>] [-Iteration <path>] [-AssignedTo <email> \| -Unassigned] -DryRun` | `../tools/azure_devops/create_issue.sh <title> <file> --type <type> [--parent <id>] [--area <path>] [--iteration <path>] [--assigned-to <email> \| --unassigned] --dry-run` |

6. **After the user confirms,** run it without the dry run; it prints the new number. Delete
   the temporary file.
7. **In the spec header:** `> **Issue:** #<n>` (GitHub) or `> **Backlog item:** <id>` (Azure
   DevOps), and `> **Parent:** …` if there is one; **Last updated** today; a **Stage log** row
   (today, `requirements`, `CREATE ISSUE:`, your model, `issue #<n> created` / `backlog item
   <id> created`).
8. **Report** the link, and remind the user that from now on every commit message carries the
   reference (`#<n>` on GitHub, `AB#<id>` on Azure DevOps — `../guidelines/commits.md`).

## UPDATE ISSUE

1. Read the spec header for `Issue:` / `Backlog item:`. If there is none, offer
   `CREATE ISSUE`, or ask for the number of an existing one and add it to the header.
2. Find the git host: `git_host` from the settings, otherwise from
   `git remote get-url origin` (`github.com` → GitHub; `dev.azure.com` or `visualstudio.com` →
   Azure DevOps). With no git host, explain that there is nothing to update.
3. Find the shell: `shell` from the settings, otherwise PowerShell on Windows and
   bash on macOS / Linux.
4. Build the **summary** in the format of `../tools/README.md`. While Part 2 has no Steps,
   leave the **Plan** part out. If the spec has a **Cost summary** (closed with cost tracking
   on), add it as `## Cost summary` (its sentence and both tables) before the **Plan** part,
   links as full URLs. Write it to a
   temporary file outside the repository.
5. Run the issue script for the host and shell **with the dry run** and show the result:

   | Host | PowerShell | bash |
   |------|------------|------|
   | GitHub | `../tools/github/update_issue.ps1 -Issue <n> -SummaryFile <file> -DryRun` | `../tools/github/update_issue.sh <n> <file> --dry-run` |
   | Azure DevOps | `../tools/azure_devops/update_issue.ps1 -Issue <id> -SummaryFile <file> -DryRun` | `../tools/azure_devops/update_issue.sh <id> <file> --dry-run` |

6. After the user confirms, run it again without the dry run, then delete the temporary file.

## Never

- Write code, or Part 2.
- Change other specs (refer to them instead).
- Put secrets, tokens, internal URLs or personal data into a spec or an issue.
