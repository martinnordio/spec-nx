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
   Add a **Stage log** row: today, `plan`, `PLAN:`, the exact name of the AI model you are,
   `Part 2 written` (add the section from the template above Part 1 if the spec has none).

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
