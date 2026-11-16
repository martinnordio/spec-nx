## Per-Step run

Only with per-Step models (`models` has tiers). Fixed or no `models`: one Step per
`IMPLEMENT:` as above.

1. **Ask once**, before any work: *"Run Steps <n>–<m> with their models (<n>: <model>, …,
   <m>: <model>), committing each Step with its suggested message? — yes / only Step <n> /
   no"*. Nothing is pushed in any case.
2. **Yes:** for each Step in order, run *IMPLEMENT* steps 3–7 as a **sub-agent on the Step's
   model** (`../models.md`), give it the spec file, the Step number and this prompt; when it
   returns, check its Done line and commit with the suggested message. Stop at the first
   failing check, an open question, or a missing model, and report. Ask nothing else in
   between.
   - If the agent's permissions deny `git commit` (`.claude/settings.json`, the user's
     answer), or the tool has no sub-agents with a model choice, do **only Step <n>** and say
     why.
3. **Only Step <n>:** that Step on its model (as a sub-agent where possible), then stop; the
   user commits.
4. **No:** stop.
5. **Tools without sub-agents:** at the end of each Step, name the next Step's model:
   *"Step <m> is set to <model> — switch before `IMPLEMENT:`."*
