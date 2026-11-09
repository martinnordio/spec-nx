# testing — local trial runs

Everything in this folder except this README is ignored by git: use it to try the generator
and the stages on throw-away projects without pushing anything.

## Try it

1. Create a scratch project:

   ```
   cd testing
   mkdir my-trial
   cd my-trial
   git init
   ```

   Add a few files so there is something to read (a README, a small script, a folder or two).

2. Open the scratch project in your editor and, in the AI chat, load the stage you want to try,
   for example the requirements stage:

   ```
   Load ../../stages/requirements/prompt.md
   and ../../stages/spec_template.md.

   REQUIREMENTS: <short name> — <what you want, in plain words>
   ```

   *(The generator prompt in `generator/` will do this set-up for you once it exists.)*

3. Look at what was written in `.specs/features/` of the scratch project.

4. Delete the scratch project when you are done.

## Rules

- Never copy real company or customer data into a trial.
- If a trial shows a bug in a stage, write it down in the spec being worked on (Review Log or
  Open questions) — the trial itself is not kept.
