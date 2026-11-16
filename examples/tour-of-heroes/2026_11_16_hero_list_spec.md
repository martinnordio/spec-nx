# Hero List Spec

> **Author:** Martin Nordio
> **Status:** ✅ Complete — closed on feature/hero-list
> **Created:** 2026-11-16
> **Last updated:** 2026-11-16
> **Branch:** `feature/hero-list`

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../stages/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-16 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | ~867 k (7 k in · 856 k cached · 4 k out) | ~CHF 0.24 (29 credits) | Part 1 written; revised: open questions answered (S10–S15) |
| 2026-11-16 | plan | `PLAN:` | Claude Opus 5.5 | ~283 k (5 k in · 275 k cached · 3 k out) | ~CHF 0.12 (14 credits) | Part 2 written |
| 2026-11-16 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | ~1.99 M (12 k in · 1.97 M cached · 6 k out) | ~CHF 0.24 (29 credits) | Step 1 done |
| 2026-11-16 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | ~968 k (6 k in · 959 k cached · 3 k out) | ~CHF 0.12 (15 credits) | Step 2 done |
| 2026-11-16 | implementation | `IMPLEMENT:` | Claude Sonnet 5.5 | ~1.83 M (12 k in · 1.81 M cached · 6 k out) | ~CHF 0.23 (27 credits) | Step 3 done |
| 2026-11-16 | implementation | `IMPLEMENT:` | Claude Haiku 5.5 | ~1.29 M (8 k in · 1.28 M cached · 4 k out) | ~CHF 0.01 (2 credits) | Step 4 done |
| 2026-11-16 | implementation | `CLOSE:` | Claude Sonnet 5.5 | ~1.07 M (5 k in · 1.06 M cached · 2 k out) | ~CHF 0.12 (14 credits) | spec closed |

## Cost summary

This feature used ~8.30 M tokens, ~CHF 1.08 — estimate, see [COSTS.md](../../stages/COSTS.md).

| Stage | Tokens | Cost (CHF) | Share of Copilot Business |
|-------|--------|------------|---------------------------|
| requirements | ~867 k | ~0.24 | 1.5 % |
| plan | ~283 k | ~0.12 | 0.7 % |
| implementation | ~7.15 M | ~0.72 | 4.6 % |
| pr | N/A | N/A | N/A |
| **Total** | **~8.30 M** | **~1.08** | **6.8 %** |

**Implementation by Step**

| Step | Tokens | Cost (CHF) | Share of Copilot Business |
|------|--------|------------|---------------------------|
| Step 1 | ~1.99 M | ~0.24 | 1.5 % |
| Step 2 | ~968 k | ~0.12 | 0.8 % |
| Step 3 | ~1.83 M | ~0.23 | 1.4 % |
| Step 4 | ~1.29 M | ~0.01 | 0.1 % |
| CLOSE | ~1.07 M | ~0.12 | 0.7 % |
| **Total implementation** | **~7.15 M** | **~0.72** | **4.6 %** |

---

# Part 1 · Requirements

## Context

The app is still the Angular CLI starter page. As its first feature it should show a list of
heroes and let the user pick one to see and edit its details, all within one page and with
the data kept in the app (no server, no navigation).

**Already in the repository** (found by the requirements stage — reuse, don't rebuild):
- `src/app/app.ts` / `src/app/app.html` — the root component `App`; its template is the CLI
  placeholder page (heading "Hello, tour-of-heroes") followed by `<router-outlet />`.
- `src/app/app.spec.ts` — two tests: the app is created, and the `h1` contains
  "Hello, tour-of-heroes".
- `src/app/app.routes.ts` — an empty route list; `src/app/app.config.ts` provides the router.
- No hero data, component or spec exists yet (`.specs/features/` holds only the kit spec).

**New:**
- A fixed list of heroes, a list view, a detail view below it, and name editing.

## 1 · Specs

- **S1 — Show the heroes:** When the app opens, the page shows a list of all heroes of the
  app's fixed list; each entry shows the hero's id and name.
- **S2 — Fixed data:** The heroes come from a list inside the app; the app makes no network
  request for them.
- **S3 — Select a hero:** Clicking a hero in the list shows that hero's details (id and name)
  below the list; clicking another hero shows that hero's details instead.
- **S4 — Nothing selected:** Before any hero is clicked, no details are shown.
- **S5 — Show the selection:** The hero whose details are shown is visibly marked in the list.
- **S6 — Edit the name:** In the details, the name is in a labelled text field; the id is
  shown but cannot be edited.
- **S7 — Name updates at once:** While the user types in the name field, the new name shows
  in the list and in the details heading at once, without saving or reloading.
- **S8 — Keyboard:** A hero can be selected with the keyboard (Tab to it, Enter or Space) as
  well as with the mouse.
- **S9 — Single page:** Everything is on one page; the address in the browser does not change
  when a hero is selected.
- **S10 — Page heading:** The hero list replaces the Angular CLI placeholder page; none of its
  content remains, and the page heading is "Tour of Heroes".
- **S11 — The heroes:** The list holds these ten heroes, in this order: 12 Dr. Nice,
  13 Bombasto, 14 Celeritas, 15 Magneta, 16 RubberMan, 17 Dynama, 18 Dr. IQ, 19 Magma,
  20 Tornado, 21 Mr. Nice.
- **S12 — Empty name:** When the name field is emptied, the details show the message "Name is
  required" and the list keeps the hero's last non-empty name; the message disappears as soon
  as a name is typed.
- **S13 — Name length:** The name field accepts at most 30 characters.
- **S14 — Not kept:** Edited names are not kept: after the page is reloaded, every hero has
  its name from S11 again.
- **S15 — Selection stays:** Once a hero is selected, a hero stays selected; clicking the
  selected hero again keeps it selected.

### Open questions

_None._

<!-- spec-nx:plan -->

---

# Part 2 · Plan

## Closing summary

**Built:** The app's page is now "Tour of Heroes" with a list of ten fixed heroes (id and name, from data inside the app). Clicking a hero, or pressing Enter or Space on it, selects it: the entry is marked and its details (heading with the name, id, a labelled Name field of at most 30 characters) show below the list. Typing in the field updates the list and the heading at once; an emptied field shows "Name is required" and the list keeps the last non-empty name. Nothing is saved, and the address never changes.
**Differs from the plan:**
- Step 1 also reformatted `app.config.ts` and `app.routes.ts` for prettier (`app.routes.ts` ended up unchanged in the commit; only `app.config.ts` differs).
- The `ng serve` checks of Steps 1–3 were not run; the behaviour is covered by component tests. Step 4's `ng serve` walkthrough of S1–S15 was replaced by an S→test mapping, which has no direct test for S2 (no network request), S8 (keyboard activation not simulated, only button elements asserted), S10 (only "Congratulations" asserted absent), S13 (`maxlength` attribute only) and S14 (new instance, not a real reload).
- Known gap: an emptied name field stays empty if another hero with the identical name is selected (cannot occur with the S11 names).

**Files:** `src/app/heroes/hero.ts`, `src/app/heroes/mock-heroes.ts`, `src/app/heroes/heroes.ts`, `src/app/heroes/heroes.html`, `src/app/heroes/heroes.css`, `src/app/heroes/heroes.spec.ts`, `src/app/app.ts`, `src/app/app.html`, `src/app/app.spec.ts`, `src/app/app.config.ts`, `README.md`.

## 2 · Spec Overview

| Step | Description | Model (suggested) | Status | Detail |
|------|-------------|-------------------|--------|--------|
| **1** | Hero data and the list on the new page | standard (Claude Sonnet 5.5) — new component and data, clear tasks | ✅ Done | [→ Step 1](#step-1--hero-data-and-the-list-on-the-new-page) |
| **2** | Select a hero and show its details | standard (Claude Sonnet 5.5) — signals, template and keyboard tests from the plan | ✅ Done | [→ Step 2](#step-2--select-a-hero-and-show-its-details) |
| **3** | Edit the name | standard (Claude Sonnet 5.5) — the empty-name rule is spelled out in D4 | ✅ Done | [→ Step 3](#step-3--edit-the-name) |
| **4** | Final check and README | light (Claude Haiku 5.5) — run checks, short doc edit | ✅ Done | [→ Step 4](#step-4--final-check-and-readme) |

> **Step completion protocol (required):** every time a Step is finished, in the same edit:
> 1. Tick its tasks `[x]` **and** set its row in this table to ✅ Done.
> 2. Append a **`**Done (YYYY-MM-DD · ~<duration> · <model>)**`** line to that Step's
>    **Notes**: date, time it took, the AI model that did the work, a one-line summary and
>    the verifying test/command result. With per-Step models, end it with
>    `suggested: <tier> (<model>) · ran: <model>`; with cost tracking on, with
>    `· ~<tokens> · ~<currency> <amount>` from the `usage` script.
>
> The table and the Step sections must **always agree**.

> **Time tracking (required for every Step):** each Step's **first task** is
> `Record the start time in Notes` (e.g. `Started: YYYY-MM-DD HH:MM`); the Done line records
> the finish and the duration.

### Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | The data lives in `src/app/heroes/hero.ts` (`interface Hero { id: number; name: string }`) and `src/app/heroes/mock-heroes.ts` (`HEROES: readonly Hero[]`, the ten heroes of S11). | Keeps the fixed data apart from the view; no service is needed for data that never leaves the app (S2). |
| D2 | One standalone component `Heroes` (`app-heroes`, `src/app/heroes/heroes.ts/.html/.css/.spec.ts`) holds the list and the details. | The feature is one page with one piece of state; a separate detail component would only add an input/output pair. Can be split later. |
| D3 | State in signals inside `Heroes`: `heroes = signal<Hero[]>(HEROES.map(h => ({ ...h })))`, `selectedId = signal<number \| null>(null)`, `selectedHero = computed(...)`. | Copies of `HEROES` keep the constant unchanged, so a reload (a new component) shows the original names (S14); signals are the project's pattern (`App.title`). |
| D4 | The name field is bound with `[value]` and `(input)`, no `FormsModule`. A non-empty value replaces the hero's name in `heroes` (new array, new object); an empty value only sets a `nameError` signal and leaves the name as it is. `maxlength="30"` on the field. | Implements S7, S12 and S13 directly with no extra module; the list and the heading read the same signal, so both update at once. |
| D5 | Each list entry is a `<button type="button">` with `[attr.aria-pressed]` and a `selected` CSS class for the selected hero. | Buttons are focusable and react to Enter and Space without extra code (S8); `aria-pressed` makes the mark of S5 visible to screen readers too. |
| D6 | `App` keeps `provideRouter(routes)` with the empty route list and its `<router-outlet />`; nothing is routed. | S9 needs no routing; removing the router is outside this feature. |
| D7 | The CLI placeholder in `app.html` is replaced by `<h1>Tour of Heroes</h1>` and `<app-heroes />`; `app.spec.ts` checks the new heading. | S10. |

---

## Step 1 — Hero data and the list on the new page

### Goal
The page shows "Tour of Heroes" and the ten heroes with id and name, from data inside the app (S1, S2, S10, S11).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] Add `src/app/heroes/hero.ts` and `src/app/heroes/mock-heroes.ts` with the ten heroes of S11 (D1).
- [x] Create the `Heroes` component (`npx ng generate component heroes`, adjusted to D2) that lists every hero with its id and name, using `@for` with `track hero.id`.
- [x] Replace the placeholder in `src/app/app.html` with the heading and `<app-heroes />`; import `Heroes` in `App` (D7).
- [x] Update `src/app/app.spec.ts`: the `h1` reads "Tour of Heroes" and the placeholder text is gone.
- [x] Add `src/app/heroes/heroes.spec.ts`: ten entries in the order of S11, each showing id and name.
- [x] Check: `npx ng test --watch=false` and `npx ng build` pass; `npx ng serve` shows the list.

### Notes
Started: 2026-11-16 14:32
**Done (2026-11-16 · ~3m · Claude Sonnet 5.5)** — `Hero`, `HEROES` and the `Heroes` component (`@for` list of id and name) added; `app.html` now holds `<h1>Tour of Heroes</h1>`, `<app-heroes />` and `<router-outlet />`; specs updated and added; `app.config.ts` and `app.routes.ts` only reformatted so `prettier --check src/app` passes. `npx ng test --watch=false` 4 passed, `npx ng build` OK, `npx prettier --check src/app` OK; `ng serve` not run (list covered by the component test) · suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · ~1.99 M · ~CHF 0.24

<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Step 2 — Select a hero and show its details

### Goal
Clicking or pressing Enter/Space on a hero shows its details below the list and marks it, without changing the address (S3, S4, S5, S8, S9, S15).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] Add `selectedId` and `selectedHero` (D3); make each entry a button that selects its hero (D5); clicking the selected hero keeps it selected.
- [x] Show the details (heading with the name, the id) below the list with `@if (selectedHero(); as hero)`; nothing before a selection.
- [x] Mark the selected entry (`selected` class, `aria-pressed`) with a visible style in `heroes.css`.
- [x] Tests in `heroes.spec.ts`: no details at start; click shows the right hero; another click switches; clicking the selected hero again keeps it; the entries are buttons (keyboard); the selected entry has `aria-pressed="true"`; `Location.path()` is unchanged after selecting.
- [x] Check: `npx ng test --watch=false` and `npx ng build` pass; in `npx ng serve`, Tab + Enter selects a hero.

### Notes
Started: 2026-11-16 14:36
**Done (2026-11-16 · ~1m · Claude Sonnet 5.5)** — `Heroes` now has `selectedId` and `selectedHero` signals; each entry is a `<button type="button">` with `aria-pressed` and a `selected` class (visible style in `heroes.css`); details (heading with the name, id) show below the list via `@if (selectedHero(); as hero)`; clicking the selected hero keeps it selected; 7 tests added to `heroes.spec.ts`, including an unchanged `Location.path()`. `npx ng test --watch=false` 11 passed, `npx ng build` OK, `npx prettier --check src/app` OK; `ng serve` not run, keyboard selection is covered by the button test · suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · ~968 k · ~CHF 0.12

---

## Step 3 — Edit the name

### Goal
The selected hero's name can be edited in a labelled field and shows in the list and the details heading at once, with the empty-name and length rules (S6, S7, S12, S13, S14).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] In the details, add a `<label>` "Name" and an `<input>` bound as in D4, with `maxlength="30"`; the id stays plain text.
- [x] Update the hero's name in `heroes` on each non-empty input; on an empty input show "Name is required" and keep the last name (D4); clear the message when a name is typed.
- [x] Tests in `heroes.spec.ts`: typing updates the list entry and the details heading; emptying shows the message and the list keeps the old name; typing again removes the message; the field has `maxlength` 30 and a label; a new `Heroes` instance after an edit shows the S11 names (S14).
- [x] Check: `npx ng test --watch=false` and `npx ng build` pass; try it in `npx ng serve`.

### Notes
Started: 2026-11-16 14:37
**Done (2026-11-16 · ~2m · Claude Sonnet 5.5)** — the details now have a labelled `Name` field (`maxlength="30"`, `[value]` + `(input)`, no `FormsModule`); a non-empty value replaces the hero in `heroes` immutably so the list and heading update at once; an empty value sets `nameError` ("Name is required", `role="alert"`) and keeps the last name; typing again or selecting another hero clears it; `HEROES` is never mutated (S14 tested with a second `Heroes` instance); the field stays empty while emptied (tested); 8 tests added. `npx ng test --watch=false` 19 passed, `npx ng build` OK, `npx prettier --check src/app` OK; `ng serve` not run, behaviour covered by component tests · suggested: standard (Claude Sonnet 5.5) · ran: Claude Sonnet 5.5 · ~1.83 M · ~CHF 0.23

---

## Step 4 — Final check and README

### Goal
Everything that worked before still works, and the README says what the app does (all S).

### Tasks
- [x] Record the start time in Notes below (e.g. `Started: YYYY-MM-DD HH:MM`).
- [x] Run `npx ng test --watch=false`, `npx ng build` and `npx prettier --check src/app`.
- [x] Add a short "What the app does" section to `README.md` (hero list, details, name editing; data is fixed and not saved).
- [x] Check: all three commands pass; walk through S1–S15 once in `npx ng serve` (replaced by the S1–S15 test mapping, see Done line).

### Notes
Started: 2026-11-16 14:39
**Done (2026-11-16 · ~1m · Claude Haiku 5.5)** — README gained a "What the app does" section (4 bullets, other text unchanged). The `ng serve` walkthrough was replaced by the S1–S15 → test mapping in `heroes.spec.ts` and `app.spec.ts`; statements without a direct test: S2 (no network request, no test), S8 (keyboard activation not simulated, only button elements asserted), S10 (only "Congratulations" asserted absent), S13 (`maxlength` attribute only), S14 (new instance, not a real reload). `npx ng test --watch=false` 19 passed, `npx ng build` OK, `npx prettier --check src/app` OK · suggested: light (Claude Haiku 5.5) · ran: Claude Haiku 5.5 · ~1.29 M · ~CHF 0.01
<!-- On completion, append: **Done (YYYY-MM-DD · ~Xh Ym · model)** — summary + verifying result. -->

---

## Deferred Items

| Task | Reason | Target Spec |
|------|--------|------------------|
| Keep edited names after a reload | Out of scope (S14) | — |
| Load heroes from a server | "No server" in the request | — |
| Split the details into their own component | Not needed for one page (D2) | — |

---

## Review Log

| Date | Reviewer | Scope | Outcome | Findings |
|------|----------|-------|---------|----------|

---

## Definition of Done

- [x] Requirements · Part 1 agreed (S1..S15 testable, open questions answered)
- [x] Plan · Part 2 written; every Step has a goal and tasks
- [x] Implementation · every Step's tasks checked; `ng test` and `ng build` pass
- [x] Spec closed · moved to `.specs/features/done/`
- [ ] Pull request · opened (or merged by hand) with the spec summary; reviewed; merged; branch deleted
