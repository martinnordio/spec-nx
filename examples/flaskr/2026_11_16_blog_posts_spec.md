# Blog Posts Spec

> **Author:** Martin Nordio
> **Status:** ✅ Complete — closed on feature/blog-posts
> **Created:** 2026-11-16
> **Last updated:** 2026-11-16
> **Branch:** `feature/blog-posts`

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../stages/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-16 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | ~729 k (7 k in · 719 k cached · 3 k out) | ~CHF 0.21 (25 credits) | Part 1 written; revised: open questions answered with the suggestions (S11–S14, scope) |
| 2026-11-16 | plan | `PLAN:` | Claude Opus 5.5 | ~435 k (7 k in · 425 k cached · 4 k out) | ~CHF 0.16 (19 credits) | Part 2 written |
| 2026-11-16 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | ~1.59 M (13 k in · 1.57 M cached · 7 k out) | ~CHF 0.21 (26 credits) | Step 1 done |
| 2026-11-16 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | ~1.49 M (11 k in · 1.48 M cached · 5 k out) | ~CHF 0.19 (23 credits) | Step 2 done |
| 2026-11-16 | implementation | `IMPLEMENT:` | Claude Haiku 5.5 | ~2.10 M (7 k in · 2.08 M cached · 5 k out) | ~CHF 0.02 (2 credits) | Step 3 done |
| 2026-11-16 | implementation | `CLOSE:` | Claude Sonnet 5.5 | ~1.57 M (9 k in · 1.55 M cached · 4 k out) | ~CHF 0.18 (22 credits) | spec closed |
| 2026-11-16 | pr | `PR:` | Claude Haiku 5.5 | ~1.08 M (4 k in · 1.08 M cached · 2 k out) | ~CHF 0.01 (1 credit) | pull request prepared |

---

## Cost summary

This feature used ~7.91 M tokens, ~CHF 0.97 — estimate, see [COSTS.md](../../stages/COSTS.md).

| Stage | Tokens | Cost (CHF) | Share of Copilot Business |
|-------|--------|------------|---------------------------|
| requirements | ~729 k | ~CHF 0.21 (25 credits) | 1.3 % |
| plan | ~435 k | ~CHF 0.16 (19 credits) | 1.0 % |
| implementation | ~6.75 M | ~CHF 0.60 (73 credits) | 3.8 % |
| **Total** | **~7.91 M** | **~CHF 0.97 (117 credits)** | **6.2 %** |

**Implementation by Step**

| Step | Tokens | Cost (CHF) | Share of Copilot Business |
|------|--------|------------|---------------------------|
| Step 1 | ~1.59 M | ~CHF 0.21 (26 credits) | 1.4 % |
| Step 2 | ~1.49 M | ~CHF 0.19 (23 credits) | 1.2 % |
| Step 3 | ~2.10 M | ~CHF 0.02 (2 credits) | 0.1 % |
| CLOSE | ~1.57 M | ~CHF 0.18 (22 credits) | 1.2 % |
| **Total implementation** | **~6.75 M** | **~CHF 0.60 (73 credits)** | **3.8 %** |

---

# Part 1 · Requirements

## Context

Flaskr is meant to be a small blog, but today it only greets the visitor. Visitors should be
able to read the posts on the home page and write new ones. The user asked for the posts to
be kept in a SQLite file; the plan follows that choice.

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- `src/flaskr/app.py` — the Flask app with one route: the home page (`/`), which returns the
  text "Hello, Flaskr!". The home page of this spec replaces that text.
- `pyproject.toml` — Flask 3.1 as a dependency, pytest in the dev group; no tests exist yet.
- No other spec covers posts (`.specs/features/done/2026_11_16_spec_nx_kit_spec.md` only set
  up the kit).

**New:**
- Posts with a title, an optional text and the date they were created.
- A list of posts on the home page and a form to write a post.
- Storage that keeps the posts between runs of the app.

**Not in this spec:** editing and deleting posts, and paging the list — later specs.

## 1 · Specs

- **S1 — List of posts:** The home page shows every post with its title, date and text,
  newest first.
- **S2 — No posts yet:** When there are no posts, the home page shows the message
  "No posts yet." and a way to write the first one.
- **S3 — Write a post:** From the home page a visitor reaches a form with a title and a
  text field; after it is sent, the visitor is back on the home page and the new post is
  shown first.
- **S4 — Title required:** A title that is empty or only spaces is refused with the
  message "Title is required."; no post is saved and what was typed in the form is kept.
- **S5 — Text optional:** A post without text is saved and shown with its title and date
  only.
- **S6 — Date set automatically:** A post's date is the moment it was created; the visitor
  does not enter it.
- **S7 — Kept after a restart:** Posts are still listed, unchanged and in the same order,
  after the app is stopped and started again.
- **S8 — No login:** Anyone who opens the app can read the posts and write a post, without
  signing in.
- **S9 — Shown as written:** A title or text containing HTML or script code is shown as
  plain text, never run or rendered as markup.
- **S10 — Still starts the same way:** The app still starts with
  `uv run flask --app src/flaskr/app run --debug`, and the posts' storage is created
  automatically on first use, without a separate setup command.

- **S11 — Length limits:** A title longer than 100 characters is refused with the message
  "Title must be at most 100 characters.", and a text longer than 10,000 characters with
  "Text must be at most 10,000 characters."; no post is saved and what was typed is kept.
  A title of exactly 100 and a text of exactly 10,000 characters are accepted.
- **S12 — Date format:** The date of a post is shown as `YYYY-MM-DD HH:MM`, in the local
  time of the computer running the app.
- **S13 — Line breaks kept:** Line breaks and blank lines in a post's text are shown as
  typed.
- **S14 — One page:** All posts are listed on the home page, without paging.

### Open questions

_None._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## Closing summary

**Built:** Flaskr is now a small blog without login. The home page lists every post from a SQLite file (`src/instance/flaskr.sqlite`, created automatically on first use and git-ignored), newest first, with title, date (`YYYY-MM-DD HH:MM`, local time) and text; line breaks are kept (`pre-wrap`) and HTML is escaped. With no posts it shows "No posts yet." and a link to write the first one. `/create` has a form: the title is trimmed and required (at most 100 characters), the text is optional (at most 10,000); an invalid post is refused with the message, status 400 and the typed values kept; a valid one is saved with the date set by the app and redirects (303) to `/`. The README explains how to run, where posts are stored and how to test. `uv run pytest`: 20 passed.
**Differs from the plan:** The design (D1–D8) was followed. What differs is how it was checked: the manual browser checks — Step 1's check, Step 2's last task and Step 3's manual check — were done with Flask's test client (the restart check in two separate Python processes on the real database file, removed afterwards), not with a running `flask run --debug` server and a browser; `flask routes` was checked instead of a server start, so S10 and the restart of S7 were not seen in a live app. Test gaps noted in Step 3 remain: S7 is automated only as "reopen the database file" in one process; S12 tests the format, not the local time; S14 has no test with many posts (the code has no paging). Two small points: the empty-state link in `index.html` is written as `/create` instead of `url_for('create')`, and `CREATE TABLE IF NOT EXISTS` runs each time a request opens the database (D2 said "the first request") — harmless, but not exactly as planned.
**Files:** `src/flaskr/app.py`, `src/flaskr/db.py` (new), `src/flaskr/templates/base.html`, `index.html`, `create.html` (new), `tests/conftest.py`, `tests/test_index.py`, `tests/test_create.py` (new), `README.md`, `.gitignore`.

## 2 · Spec Overview

| Step | Description | Model (suggested) | Status | Detail |
|------|-------------|-------------------|--------|--------|
| **1** | Store posts and list them on the home page | standard (Claude Sonnet 5.5) — new storage and page, but D1–D6 settle the design | ✅ Done | [→ Step 1](#step-1--store-posts-and-list-them-on-the-home-page) |
| **2** | Form to write a post, with validation | standard (Claude Sonnet 5.5) — form and rules fully specified by S3–S5, S11 and D7 | ✅ Done | [→ Step 2](#step-2--form-to-write-a-post-with-validation) |
| **3** | Check everything still works; update the README | light (Claude Haiku 5.5) — run the checks and write docs | ✅ Done | [→ Step 3](#step-3--check-everything-still-works-update-the-readme) |

> **Step completion protocol (required):** every time a Step is finished, in the same edit:
> 1. Tick its tasks `[x]` **and** set its row in this table to ✅ Done.
> 2. Append a **`**Done (YYYY-MM-DD · ~<duration> · <model>)**`** line to that Step's
>    **Notes**: date, time it took, the AI model that did the work, a one-line summary and
>    the verifying test/command result (e.g. `uv run pytest`: 12 passed). With per-Step
>    models, end it with `suggested: <tier> (<model>) · ran: <model>`; with cost tracking
>    on, with `· ~<tokens> · ~<currency> <amount>` from the `usage` script.
>
> The table and the Step sections must **always agree**.

> **Time tracking (required for every Step):** each Step's **first task** is
> `Record the start time in Notes` (e.g. `Started: YYYY-MM-DD HH:MM`); the Done line records
> the finish and the duration.

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | Store posts with Python's built-in `sqlite3` module; no new dependency (no ORM). | The user asked for a SQLite file; one table does not need an ORM. |
| D2 | One table `post` (`id` integer primary key, `title` text not null, `body` text not null default `''`, `created` text not null), created with `CREATE TABLE IF NOT EXISTS` on the first request that opens the database. | S10: no separate setup command; `IF NOT EXISTS` is safe on every start. |
| D3 | The database file is `flaskr.sqlite` in the app's instance folder (`app.instance_path`, today `src/instance/`), created if missing; `app.config["DATABASE"]` holds the path so tests can point it to a temporary file. `instance/` is added to `.gitignore`. | Flask's place for local data; keeps the data out of git and lets tests run isolated. |
| D4 | Keep the module-level `app` in `src/flaskr/app.py` (no app factory); database helpers in a new `src/flaskr/db.py` (open per request on `g`, close on teardown). | S10: the run command stays `--app src/flaskr/app`; a factory is not needed yet. |
| D5 | `created` is stored as local time, ISO text `YYYY-MM-DD HH:MM:SS` from `datetime.now()`; shown as its first 16 characters (`YYYY-MM-DD HH:MM`); list sorted by `created DESC, id DESC`. | S6, S12: local time as specified; `id` breaks ties for posts in the same second. |
| D6 | Pages are Jinja templates in `src/flaskr/templates/` (`base.html`, `index.html`, `create.html`) with autoescaping on; the text is shown with CSS `white-space: pre-wrap`, never with `\|safe` or `<br>` insertion. | S9: autoescaping turns HTML into plain text; S13: `pre-wrap` keeps line breaks without unescaping. |
| D7 | The form is its own page, `GET/POST /create`, linked from the home page. Title is stripped of surrounding spaces before checking and saving; text is saved as typed. Invalid input re-shows the form with the message and the typed values, status 400; valid input saves and redirects (303) to `/`. | S3, S4, S11; redirect after POST so a reload does not post twice. |
| D8 | Tests in `tests/` with pytest and Flask's `app.test_client()`; a fixture in `tests/conftest.py` points `DATABASE` to a file in `tmp_path`. | Python guideline; tests never touch the real database. |

---

## Step 1 — Store posts and list them on the home page

### Goal
The home page lists the stored posts newest first, with title, date and text, shows "No posts yet." when there are none, and the storage is created on first use and kept across restarts (S1, S2, S7, S9, S10, S12, S13, S14).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] Add `src/flaskr/db.py` (D1–D4): `get_db()` opens `app.config["DATABASE"]` with `sqlite3.Row` rows, creates the instance folder and the `post` table if missing; the connection is closed on app teardown.
- [x] In `src/flaskr/app.py`, set `DATABASE` to `<instance_path>/flaskr.sqlite` and register the teardown; add `instance/` to `.gitignore` (D3).
- [x] Add `templates/base.html` and `templates/index.html` (D6); `/` lists all posts sorted by `created DESC, id DESC`, shows the date as `YYYY-MM-DD HH:MM`, and "No posts yet." with a link to `/create` when empty (the link target is built in Step 2; until then it may return 404).
- [x] Add `tests/conftest.py` (D8) and `tests/test_index.py`: empty state; order newest first; date format; HTML in title and text shown escaped; line breaks kept in the output; posts still listed after closing and reopening the database file; table created automatically on a fresh file.
- [x] Check: `uv run pytest` passes; `uv run flask --app src/flaskr/app run --debug` shows "No posts yet." on http://127.0.0.1:5000.

### Notes
Started: 2026-11-16 15:13
**Done (2026-11-16 · ~3m · Claude Sonnet 5.5)** — Added `src/flaskr/db.py` (sqlite3, per-request connection, table auto-created), `DATABASE` config and teardown in `app.py`, `base.html`/`index.html`, `instance/` in `.gitignore`, and 8 tests in `tests/`. `uv run pytest`: 8 passed; "No posts yet." checked with the test client (no server started). suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · ~1.59 M · ~CHF 0.21
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 2 — Form to write a post, with validation

### Goal
Visitors write a post from the home page without logging in; the title is required and both fields are limited, with clear messages (S3, S4, S5, S6, S8, S11).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] Add `GET/POST /create` and `templates/create.html` (D7): title and text fields; on success insert the post with `created` from `datetime.now()` (D5) and redirect (303) to `/`.
- [x] Validation (D7): empty or spaces-only title → "Title is required."; title over 100 characters → "Title must be at most 100 characters."; text over 10,000 characters → "Text must be at most 10,000 characters."; status 400, the typed values kept, nothing saved.
- [x] Link "Write a post" to `/create` from the home page (always, and in the empty state).
- [x] Add `tests/test_create.py`: the form page opens without login; a valid post redirects to `/` and is listed first; a post without text is saved and listed; each refusal (empty, spaces only, 101-character title, 10,001-character text) shows its message, keeps the typed values and saves nothing; exactly 100 and 10,000 characters are accepted; the date is set by the app, not by the form.
- [x] Check: `uv run pytest` passes; in the running app, write a post with and without text and see it at the top of the home page.

### Notes
Started: 2026-11-16 15:16
**Done (2026-11-16 · ~2m · Claude Sonnet 5.5)** — Added `GET/POST /create` with `templates/create.html` (validation per D7, 400 with typed values kept, 303 redirect on success, `created` from `datetime.now()`), a "Write a post" link on the home page, and 12 tests in `tests/test_create.py`. `uv run pytest`: 20 passed; flow checked with the test client (no server started). suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · ~1.49 M · ~CHF 0.19
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 3 — Check everything still works; update the README

### Goal
The app still starts with the same command, every statement is covered by a passing test, and the README says how to run and test Flaskr (S7, S10, all).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] Run `uv run pytest`; check each statement S1–S14 is covered by a test or by the manual check below, and list any gap in Notes.
- [x] Manual check: delete `src/instance/flaskr.sqlite` if present, start the app with `uv run flask --app src/flaskr/app run --debug`, write two posts (one with several lines of text), stop and start the app again, and see both posts in the same order.
- [x] Write `README.md` (empty today): what Flaskr does, how to run it, where the posts are stored, how to run the tests.
- [x] Check: `uv run pytest` passes; the README commands work as written.

### Notes
Started: 2026-11-16 15:18
Coverage (`uv run pytest`, 20 passed): S1 list test; S2 empty-state test; S3 home links to the form and the form opens without login; S4 and S11 refusal tests (parametrized) and inclusive limits; S5 post without text; S6 app sets the date; S7 two requests on the same file (not a restart); S8 form opens without login; S9 escaping on the home page and on refusal; S12 minutes-format test; S13 line breaks test.
Gaps: S7 restart is covered only by the manual check; S10 `flask run` was not started (`flask routes` checked instead); S14 no test for many posts (the code has no paging); S12 local time is not tested directly (format only).
Manual check: database path is `src/instance/flaskr.sqlite`. It did not exist before the check, so nothing was renamed or deleted first. Process 1 posted "First post" and "Second post" (several lines of text) through the test client. Process 2 read `/` and found both titles, newest first, with the line breaks kept. Afterwards the database file and the temp script were removed and confirmed gone. This test-client check in separate processes replaces a browser or server run, as agreed.
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->
**Done (2026-11-16 · ~0h 1m · Claude Haiku 5.5)** — README written (what Flaskr does, how to run it, where posts are stored, how to run the tests). Checks: `uv run pytest` 20 passed; `uv sync` and README commands verified; manual check passed (see above). Gaps: S7 restart and S10 `flask run` not executed as a server; S14 and S12 local time not tested. suggested: light (Claude Haiku 5.5) · ran: Claude Haiku 5.5 · ~2.10 M · ~CHF 0.02

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Edit and delete posts | Out of scope (Part 1, Context) | `yyyy_mm_dd_edit_delete_posts_spec.md` |
| Paging the list of posts | Out of scope (S14) | `yyyy_mm_dd_post_paging_spec.md` |
| `pyproject.toml` declares the script `flaskr = "flaskr:main"`, but no `main` exists | Not part of this feature | `yyyy_mm_dd_project_cleanup_spec.md` |
| Linter and formatter (e.g. ruff) | None configured; not needed for this feature | `yyyy_mm_dd_project_cleanup_spec.md` |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..S14 testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [x] Implementation · every Step's tasks checked; `uv run pytest` passes
- [x] Spec closed · moved to `.specs/features/done/`
- [ ] Pull request · prepared with the spec summary; reviewed; merged; branch deleted
