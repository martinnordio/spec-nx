# Stage: Review

Give the reviewer what to read first, and review the change against its spec.

- **Semantic diff** — not the lines that changed, but the **objects** that changed (a command,
  an endpoint, a file format, a screen, a setting), each shown **Before | After** with the
  smallest example, linked to the spec's statements. It goes into the pull request.
- **Code review** — a layered review (spec, architecture, code, quick scan) whose findings go
  into the spec's Review Log.

## Commands

```
REVIEW: <spec file>
```
Writes the change record, the review page and the pull-request text of the semantic diff. Run
it again after more Steps or review fixes: hand-written parts of the record are kept.

```
CODE REVIEW: <spec file>
```
Reviews the branch's changes layer by layer and logs the findings in the spec.

## Skills to load

Always: `../skills/reviewer.md` — the role you take in this stage.

## Files this stage uses

Paths are relative to this file, so they work both inside spec-nx (`stages/review/`) and in a
generated kit (`.specs/kit/review/`).

| File | Use |
|------|-----|
| `semantic_diff.md` | Rules: what needs a record, kinds of objects, how Before / After are made, checks |
| `change_record.yaml` | Template of the change record |
| `change_record.schema.json` | Schema the record must pass |
| `code_review.md` | The layered checklist and the finding table |
| `review_page.html` | Template of the HTML review page (styles, sections, tooltips, metadata) |
| `../guidelines/<language>.md`, `.specs/guidelines/<language>.md` | Coding rules of the languages changed |
| `.specs/architecture.md` | Module boundaries, if the project has it |

**Output folder:** `.specs/changes/<name>/`, where `<name>` is the branch without `feature/`
(`/` → `-`); `.specs/changes/done/<name>/` once the spec is closed.

---

## REVIEW

1. **Range.** The default branch (`git symbolic-ref --short refs/remotes/origin/HEAD`, without
   `origin/`; else `main`); base = `git merge-base HEAD <default>`; head = `HEAD` plus
   uncommitted changes. The current branch must be the spec's **Branch**.

2. **Record** (`change_record.yaml`, only when `semantic_diff.md` says it is required):
   - read the spec (Context, statements, Steps, decisions) and `git diff --stat -M <base>`;
   - one block per changed **object**, with its kind, `added` / `modified` / `removed`, the
     statements it serves, a one-line `note` of what to look at, and the smallest example
     that shows the change on both sides;
   - `why` (2–6 lines, from the spec's Context), `breaking`, and up to four `review`
     questions and answers for choices a reviewer will ask about;
   - check it against `change_record.schema.json`; on a re-run, keep what the author edited
     and only add.

   **Show the record and ask the user to confirm it** before going on.

3. **Before | After.** For each block and example, produce both sides as described for its kind
   in `semantic_diff.md` — from the base revision (`git show <base>:<path>`, or a temporary
   `git worktree add --detach <tmp> <base>`, removed afterwards) and from the head. Same
   input, same settings on both sides. If a side cannot be produced, mark the block `manual`
   with the reason — never invent output.

4. **Checks.** Run the checks of `semantic_diff.md` (C1–C9): `pass`, `fail` or `n/a`. Each
   failure is a finding.

5. **Review page**, in two forms with the same content:
   - **`review.html`** — the full report, from `review_page.html`: Before | After side by
     side with the changed lines shaded, the highlights as coloured diffs with **concept
     tooltips**, the findings, a reviewer checklist and the `review-meta` data. One
     self-contained file: no external files (images as `data:` URIs while it stays under
     ~5 MB), works without JavaScript, every code character escaped, relative links only.
   - **`review.md`** — the same sections in Markdown, so the page can also be read on the
     git host without downloading anything.

   Sections, in this order:
   1. **Header** — branch, base..head, date, commits, files, `+/-` lines.
   2. **Summary** — three to five bullets in plain words.
   3. **Spec** — link, statements covered, Steps.
   4. **Semantic diff** — `why`, `breaking`, the checks; then one card per block:
      `<KIND> · <object> — <change>`, the note, the example input, and Before | After.
   5. **Highlights** — at most 12 real diff hunks (≤ 40 lines each, with line numbers, never
      reformatted or invented), most relevant first: public interfaces, non-trivial logic,
      security, statements' acceptance; for each: what changed, why it matters, what to
      check. In the HTML page, 2–5 **concept tooltips** per hunk: the concept in one
      sentence, then why it is used on that line (≤ 40 words), correct for the versions in
      use; each concept also once in **Concepts**.
   6. **Findings** — the table of `code_review.md` (failed checks included).
   7. **Not covered** — what was left out (lock files, generated files, renames, formatting),
      with the reason.
   8. **Concepts** and **Reviewer checklist** (HTML page only).

   Then add the page to **`.specs/changes/index.html`** (create it if missing): one row per
   review page, newest first — date, branch, spec, checks, open findings, link.

6. **Pull-request text** `semantic_diff.md` (at most ~2 000 characters, so the description
   stays under the Azure DevOps limit together with the spec summary):

   ```markdown
   ### Semantic diff
   <why, one line> · checks <n pass · n n/a · n fail> · findings <n>

   **Review here first:** [review page](<full URL of review.md on the branch>) · full report
   with Before | After and tooltips: [review.html](<URL to download review.html>) (open it in
   a browser)

   | Kind | Object | Change | Statements |
   |------|--------|--------|------------|
   | <kind> | <object> | <added / modified / removed> | S1, S2 |

   **Top findings:** <up to three, one line each, or "none">
   ```

   The pr stage puts it into the pull request's `semantic-diff` block.

7. **In the spec:** tick the *Review* line of the Definition of Done when the page exists; add
   a Review Log row (today, the AI model, `semantic diff`, `—`, link to the page) and a
   **Stage log** row (today, `review`, `REVIEW:`, your model, `semantic diff written`).

8. **Report:** the record's blocks per kind, the checks, the page, the top findings, and the
   next step (`CODE REVIEW:`, `CLOSE:`, or `PR:` to publish).

## CODE REVIEW

1. **Read** the spec, the review page if `REVIEW:` was run, then the diff
   (`git diff <base>...HEAD`).
2. **Review layer by layer** with `code_review.md`: spec alignment, architecture, code quality
   against the guidelines of the languages changed, quick scan.
3. **Findings** in the table of `code_review.md`, each with a **target**:
   - in the spec's scope and no change of behaviour → *fix now* (the user runs
     `IMPLEMENT:` again or fixes it);
   - clean-up outside the scope → *improvement* (`IMPROVE: <scope>`) — never fixed in place;
   - a change of behaviour that the spec does not ask for → *new spec*
     (`REQUIREMENTS: <name> — …`);
   - a missing decision → `ADR: <title>`.
4. **In the spec:** under **Review Log**, add a row (today, `AI assistant (<model>)`, `diff`,
   the outcome, the number of findings per severity) and, below the table, a
   `### Code review YYYY-MM-DD` section with the finding table. Add a **Stage log** row
   (today, `review`, `CODE REVIEW:`, your model, the outcome).
5. **Outcome:** **Approve** (no Blocking), **Request changes**, or **Blocked on a decision**.

## Never

- Change code — this stage writes only `.specs/changes/` and the spec's logs.
- Write Before | After by hand without marking it `manual` with the reason.
- Invent code, line numbers or output.
- Put secrets, tokens, internal URLs or personal data into the record, the page or the pull
  request; replace them with `«redacted»` and raise a Blocking finding.
