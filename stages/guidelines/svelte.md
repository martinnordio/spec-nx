# Svelte — baseline

> Generic rules for Svelte 5 (runes) and SvelteKit 2, used together with `typescript.md`.
> The project's configuration and `.specs/guidelines/svelte.md` win over this file.
> Reference: [Svelte docs](https://svelte.dev/docs/svelte), [SvelteKit docs](https://svelte.dev/docs/kit).

## Files

- Components `PascalCase.svelte`, one per file; order: `<script lang="ts">`, markup, `<style>`.
- Routes under `src/routes/`; shared code under `src/lib/`, imported as `$lib/…`.
- Modules that use runes end in `.svelte.ts`.

## Reactivity (runes)

- `$state` for local state; `$derived` (or `$derived.by`) for computed values — no side
  effects in it.
- `$props()` with a typed `Props`; `$bindable()` only for real two-way binding.
- `$effect` only for side effects after render (DOM, subscriptions); return a clean-up when
  needed. Never use it to compute state.
- No legacy syntax in new code: `export let`, `$:`, `on:` directives, `<slot>`,
  `createEventDispatcher`.

## Events and composition

- Event attributes (`onclick={…}`); component events are callback props (`onselect`).
- Snippets (`{#snippet}` / `{@render}`) instead of slots.

## SvelteKit

- Load data in `load` (`+page.ts` / `+page.server.ts`); server-only work in `.server.ts` or
  `+server.ts`.
- Changes go through form actions (`use:enhance`) or typed helpers in `$lib`.
- Links and navigation use `base` from `$app/paths` and `goto` — no hard-coded absolute URLs.
- Shared state in a `.svelte.ts` module; stores only for interop.

## Styling

- Scoped `<style>`; colours, spacing and fonts from design tokens (CSS custom properties) —
  no hard-coded colours or inline `style=""`. `:global(…)` only with a reason.

## Accessibility

- Semantic elements, a `<label>` for every input, alt text, everything usable with the
  keyboard. The compiler's accessibility warnings stay at zero.

## Checks before a Step is done

- `svelte-check`, linter and tests pass; the page renders without console errors.
