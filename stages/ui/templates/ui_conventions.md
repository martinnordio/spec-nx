# <Project> — UI conventions

> **Last updated:** YYYY-MM-DD · written by people; `UI CATALOG` proposes changes

## Components

- Names: `<Purpose><Kind>` in `PascalCase` (`SubmitButton`, `ResultCard`); no `Component`
  suffix.
- One component per file; reusable ones in the components folder and in the catalog.

## Pages and routes

- URL segments in `kebab-case`; one folder per route (as the framework expects).

## Inputs and events

- Boolean inputs say what is true (`disabled`, `visible`), never a negation.
- Callbacks are `on<Event>` (`onSelect`, `onSubmit`) and pass an object, not a bare value.

## State

- Shared state is named for what it holds (`user`, `unreadCount`), not for how
  (`userStore`).

## Design tokens

- Colours and fonts come from the Look roles (`.specs/ui/looks.md`); spacing and sizes from
  the project's token scale. Literal values only for hairlines.

## Accessibility

- Every control is reachable and usable with the keyboard, with a visible focus.
- Every image has `alt` (empty for decoration); every input has a label.
- Each page has `<header>`, `<nav>` and `<main>` landmarks.
- Contrast meets WCAG AA.
