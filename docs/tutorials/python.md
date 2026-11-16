# Tutorial: blog posts in Python with Flask

Build one small feature of *Flaskr*, the blog of the official Flask tutorial — a page that
lists posts and a form to write one, stored in SQLite — and go once through the whole spec-nx
workflow: **requirements → plan → implementation → close**. Everything stays on your computer;
no GitHub or Azure DevOps account is needed. Connecting a git host is an
[optional last part](git-host.md).

Only the idea of the app comes from Flask's tutorial; spec-nx and your AI model write the
code.

## You need

- **git**
- **Python** (3.10 or newer) and **[uv](https://docs.astral.sh/uv/)**
- **VS Code** with **GitHub Copilot** in agent mode — or Claude Code
- The models of the default settings (Claude Opus, Sonnet, Haiku); with other models, answer
  the model question with yours (step 2)

## 1 · Create the project

```
uv init flaskr
cd flaskr
uv add flask
uv add --dev pytest
```

Delete `main.py` and create `app.py`:

```python
from flask import Flask

app = Flask(__name__)


@app.get("/")
def index():
    return "Hello, Flaskr!"
```

Check that it runs: `uv run flask --app app run --debug`, open http://127.0.0.1:5000 and stop
it with Ctrl+C. `uv init` created a git repository; make the first commit and open VS Code:

```
git add -A
git commit -m "Flask app"
code .
```

## 2 · Add spec-nx and generate your kit

In the terminal:

```
git submodule add https://github.com/martinnordio/spec-nx .spec-nx
```

In the Copilot chat (agent mode):

```
Load .spec-nx/generator/prompt.md.

GENERATE KIT
```

The assistant scans the project, says what it found (*an existing Python project, no git
host*) and suggests an answer to each question. For this tutorial:

| Question | Answer |
|----------|--------|
| Languages | `python` (suggested) |
| Workflow | **Simple** (suggested) |
| On-demand stages | **none** |
| Shared or personal kit | **shared** (suggested) |
| AI agent permissions | **VS Code Copilot** (or Claude Code) |
| Model per Step | **per Step** with the suggested models |

You get `.specs/kit/` (the stage prompts), `.specs/spec-nx.json` (your answers, with cost
tracking on) and the agent permissions. Commit them:

```
git add -A
git commit -m "Add spec-nx kit"
```

## 3 · Requirements

In the chat:

```
Load .specs/kit/requirements/prompt.md.

REQUIREMENTS: blog posts — the home page lists the blog posts, newest first, with title, date
and text. A form creates a post: the title is required, the text is optional. Posts are
stored in a SQLite file and kept after a restart. No login.
```

The assistant writes **Part 1** of a new spec, `.specs/features/<date>_blog_posts_spec.md`:
statements `S1`, `S2`, … and maybe a few open questions. Read it. Answer open questions with
`REQUIREMENTS: <spec file> — <your answers>`, until you agree with Part 1.

This stage runs on the *reasoning* model: if your chat is on another model, the assistant
says so first.

## 4 · Plan

```
Load .specs/kit/plan/prompt.md.

PLAN: .specs/features/<date>_blog_posts_spec.md
```

The assistant adds **Part 2** to the same file: small Steps, each with its tasks, and a
**Model (suggested)** column — the cheapest model that does each Step well, and why. Change a
Step or its model in the file if you disagree.

## 5 · Implement

```
Load .specs/kit/implementation/prompt.md.

IMPLEMENT: .specs/features/<date>_blog_posts_spec.md
```

- The assistant offers to create the branch `feature/blog-posts` — say yes.
- It asks **once**: *"Run Steps 1–n with their models, committing each Step?"* Say **yes**:
  every Step runs as a sub-agent on its model, runs the checks (`uv run pytest`), ticks its
  tasks, writes a *Done* line with its model and cost, and is committed. Nothing is pushed.
- The agent permissions make VS Code ask before every `git commit` — allow it. In Claude Code
  they deny commits: the assistant then does one Step at a time; commit it yourself with the
  suggested message and run `IMPLEMENT:` again.
- It stops at the first failing check or open question and tells you why.

Try the app again: `uv run flask --app app run --debug`, http://127.0.0.1:5000.

## 6 · Close

```
CLOSE: .specs/features/<date>_blog_posts_spec.md
```

The spec moves to `.specs/features/done/`, gets a **Cost summary** — by stage, then the
implementation by Step — and `.specs/costs.md` lists it. Commit, then merge the branch into
your default branch (`main` or `master`):

```
git add -A
git commit -m "Close the blog posts spec"
git switch master   # or main: the branch `uv init` created
git merge feature/blog-posts
```

## 7 · What you have

- `.specs/features/done/<date>_blog_posts_spec.md`: what was wanted (Part 1), how it was built
  (Part 2), the **Stage log** with the model, tokens and cost of every stage and Step, and
  the cost summary.
- One commit per Step on the feature branch.
- `.specs/costs.md`: the cost of every spec of the project.

**Costs are estimates and may be wrong** — see the kit's `COSTS.md`.

## Next

- [Connect GitHub or Azure DevOps](git-host.md): an issue for the next feature, and a pull
  request.
- More stages (documentation, review with a semantic diff): `GENERATE KIT --update --force` and
  choose **Full**.
- Change models or cost settings: [configuration](../configuration.md).
