# Example: the Python tutorial

The two specs that spec-nx wrote during one run of the [Python tutorial](../../docs/tutorials/python.md)
on 2026-11-16, copied unchanged except for two things: the links to `COSTS.md` point to
spec-nx's own copy, and a local folder path was shortened to `src/instance/flaskr.sqlite`.
The app's code is not here — the specs are the point.

This run used plain `uv init`, which created a `src/` package; that is why the app is in
`src/flaskr/app.py`. The tutorial now uses `uv init --app --no-package` for a flat project.

| File | What it is |
|------|------------|
| [2026_11_16_spec_nx_kit_spec.md](2026_11_16_spec_nx_kit_spec.md) | Written by `GENERATE KIT`: the settings it chose and what setting up the kit cost |
| [2026_11_16_blog_posts_spec.md](2026_11_16_blog_posts_spec.md) | The feature: requirements, plan, three Steps, the closing summary, the cost summary and the `PR:` row |
| [spec-nx.json](spec-nx.json) | The project settings the run used |

## What to look at in the blog posts spec

- **Part 1 · Requirements** — the request became 10 statements; the open questions, answered
  with the assistant's suggestions, added S11–S14 (length limits, date format, line breaks, one
  page). *Not in this spec* names what was left out on purpose: editing, deleting, paging.
- **Part 2 · Plan** — three Steps and decisions D1–D8 (plain `sqlite3`, the instance folder,
  autoescaping against HTML in posts, redirect after the form). **Model (suggested):** Sonnet
  for the two code Steps, Haiku for the final check and README.
- **Each Step's Done line** — the checks and their result (`uv run pytest`: 8, then 20
  tests), the model suggested and the model that ran, and the tokens and cost.
- **Closing summary and Step 3** — which statements each test covers, and the gaps said
  openly (the restart and `flask run` were checked with the test client, not a server).
- **Stage log and Cost summary** — every stage with its model, tokens and cost.

## What it cost

| | Tokens | Cost | Share of Copilot Business |
|---|---|---|---|
| Setting up the kit (`GENERATE KIT`) | ~1.45 M | ~CHF 0.89 (106 credits) | 5.6 % |
| The feature: requirements, plan, 3 Steps, close, `PR:` | ~8.99 M | ~CHF 0.98 (118 credits) | 6.2 % |
| **Together** | **~10.44 M** | **~CHF 1.87 (224 credits)** | **11.8 %** |

The Haiku Step cost ~CHF 0.02 for ~2.10 M tokens; the Sonnet Steps ~CHF 0.19–0.21 each.
**All costs are estimates and may be wrong** — see [COSTS.md](../../stages/COSTS.md).
