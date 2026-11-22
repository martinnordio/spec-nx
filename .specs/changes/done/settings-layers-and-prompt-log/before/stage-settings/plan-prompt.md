## Skills to load

- Always: `../skills/architect.md` — the role you take in this stage.
- Also: `../skills/requirements_engineer.md` — to check that Part 1 is ready (first step below).

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
