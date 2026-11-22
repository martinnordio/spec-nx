## Prompt log

Off by default. With `"prompt_log": true` in your settings (usually your own
`.specs/spec-nx.local.json`), every stage that runs adds the prompt it was given — the
command and its text as the user typed them, without `Load …` lines — at its start, and fills
in its reply summary when it ends:

- `.specs/prompts/<yyyy_mm_dd>_<name>_prompt.md` — the prompts of the spec
  `<yyyy_mm_dd>_<name>_spec.md`; the first `REQUIREMENTS:` uses the name the spec is about to
  get;
- `.specs/prompts/<yyyy_mm_dd>_other_prompt.md` — the day's prompts that belong to no spec
  (for example `GUIDELINES:`, `GENERATE KIT`).

A new file starts with `# Prompt history`, one sentence about what it holds (the spec, or "the
prompts of <date> that belong to no spec") and `---`. Prompts are numbered per file. Each
prompt:

```markdown
## Prompt <n> — <short title>

<yyyy-mm-dd> · `<COMMAND:>` · <model>

> <the prompt, exactly as given, every line quoted>

Reply summary: <two or three sentences: what was done or decided>

---
```

A stage that stops early writes why in its reply summary; a stage that is turned off writes nothing.

Passwords, tokens and keys are written as `«redacted»`. The files are committed with the
spec; to keep them private, add `.specs/prompts/` to your `.git/info/exclude`. With the log
off, nothing in `.specs/prompts/` is created or changed.
