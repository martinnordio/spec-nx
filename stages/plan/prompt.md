# Stage: Plan

Write **Part 2 · Plan** of a spec whose requirements (Part 1) are agreed: Steps with goals and
tasks, decisions, deferred items and a Definition of Done. The plan says *how*; it never
changes *what* (Part 1).

## Command

```
PLAN: <spec file>
```
Writes Part 2 of the spec. Run it again after Part 1 changes: Steps that are already done are
kept; the rest is re-planned.

## Skills to load

- Always: `../skills/architect.md` — the role you take in this stage.
- Also: `../skills/requirements_engineer.md` — to check that Part 1 is ready (first step below).

## Settings

Read the settings in their three layers (the kit's README, section *Settings*): the kit's,
the project's `.specs/spec-nx.json` and the developer's `.specs/spec-nx.local.json`, the later
winning. If the settings list `stages` and this stage is neither in it nor in `on_demand`,
answer *"The <stage> stage is turned off in <file>."* and do nothing else. In your report,
name each setting you used that does not come from the kit, with its file (for example
*parent 150310 — from `.specs/spec-nx.local.json`*).
With `prompt_log` on, add the prompt you were given to the prompt log at the start and its reply
summary at the end (the kit's README, section *Prompt log*).

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

Paths are relative to this file, so they work both inside spec-nx (`stages/plan/`) and in a
generated kit (`.specs/kit/plan/`).

| File | Use |
|------|-----|
| `../skills/architect.md` | Your role while planning |
| `../skills/requirements_engineer.md` | How to judge whether Part 1 is ready |
| `../spec_template.md` | The shape of Part 2 (Overview, Decisions, Steps, Deferred, Review Log, Definition of Done) |
| `.specs/spec-nx.json` / `.specs/spec-nx.local.json` | `stages`: which stages the project uses (for the Definition of Done) |

---

## PLAN

1. **Check that Part 1 is ready.** Stop and tell the user — without writing a plan — if:
   - **Open questions** are not empty: list them and suggest
     `REQUIREMENTS: <spec file> — <answers>`;
   - a statement is not testable, or mixes several concerns: say which and why.

   Never change Part 1 yourself.

2. **Read the code the requirements touch.** Use *Already in the repository* as the starting
   point; look at how the project is structured, built, run and tested.

3. **Write Part 2** below the marker line `<!-- spec-nx:plan -->`, replacing the placeholder,
   in the shape of `../spec_template.md`:
   - **2 · Spec Overview:** one row per Step, status `⬜ Not started`, with an anchor link to
     the Step. Keep the template's *Step completion protocol* and *Time tracking* notes.
     **With per-Step models** (`models` has tiers, `../models.md`): fill the **Model
     (suggested)** column — `<tier> (<model>) — <a few words why>`. Start from the tier's
     `guide`, then judge the Step itself: pick the **cheapest tier that does it well** —
     reasoning for design, refactorings, security, tricky logic, open decisions or complex
     work such as graphics-heavy Steps; standard for work a clear plan describes; light for
     mechanical edits and docs. With `fixed` or no `models`, leave the column out.
   - **Decisions:** `D1`, `D2`, … — every choice another person might make differently (where
     the code goes, a new dependency, a file or data format), with the reason.
   - **Steps:** `Step 0` only if setup is needed, then `Step 1`, … Each Step has:
     - **Goal:** one sentence, naming the statements it covers (`(S1, S3)`);
     - **Tasks:** first task always `Record the start time in Notes below.`; then concrete
       tasks; last task how the Step is checked (test, command, or what to look at);
     - **Notes:** empty, with the hint to add the `Done` line.

     Every statement S… is covered by at least one Step. Each Step leaves the project working
     and is small enough to review in one sitting. The last Step checks that what worked before
     still works, and updates the documents the change affects (README, usage).
   - **Deferred Items:** what is consciously left out, with reason and target; empty table if
     nothing.
   - **Review Log:** the empty table from the template.
   - **Definition of Done:** only the lines for the stages in `stages` (from the project or
     developer settings; if there are none, ask the user which stages they use). Tick
     *Requirements* and *Plan*.

4. **Update the header:** **Status** `⬜ Not started — plan ready`; **Last updated** today.
   Add a **Stage log** row: today, `plan`, `PLAN:`, your model,
   `Part 2 written` (add the section from the template above Part 1 if the spec has none).
   With per-Step models, the report lists each Step's tier so the user can change one before
   implementing.

5. **Report to the user:** the Steps in one line each, the decisions, anything deferred, and
   the next step — implement Step 0 (or Step 1), or, if the kit has the pr stage, open the
   pull request when the work is done. If the spec has an issue, suggest updating it so it
   shows the plan (`UPDATE ISSUE`, requirements stage).

## PLAN again (Part 1 changed)

- Keep Steps marked ✅ Done unchanged, with their Notes.
- Re-plan the Steps not started; if a Step in progress is affected, say so and ask before
  changing it.
- Add a line to the Review Log: date, "re-planned", and why.
- Add a **Stage log** row: today, `plan`, `PLAN:`, your model, `re-planned: <why>`.

## Never

- Change Part 1, or plan while Part 1 has open questions.
- Write code — the plan only describes the work.
- Leave a statement without a Step, or a Step without a check.
