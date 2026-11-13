# Looks — the style contract

A **Look** is one complete visual style: two font families and a set of colours, each filling
a **role**. Apps use roles, never literal colours, so Looks can be swapped and checked.

spec-nx defines only the roles and two neutral Looks. *How* a project applies them (CSS custom
properties, a Tailwind theme, a `[data-theme]` attribute, a theme store) is decided in its
look spec. Brand Looks come from a company layer (`looks/<name>.md`, same roles) or from the
project.

**Baseline:** every app with a user interface offers at least one **dark** and one **light**
Look, chosen by the user on a settings page and remembered.

## Colour roles

| Role | Meaning |
|------|---------|
| `bg` | Page background |
| `surface` | Panels, bars |
| `surface-elevated` | Raised surfaces: cards, menus, inputs |
| `border` / `border-subtle` | Separators, normal and faint |
| `primary` / `on-primary` | Main action and the text on it |
| `accent` | Selection, focus, highlight |
| `secondary` | Secondary action surface |
| `success` / `success-bg` | Positive state: text / background |
| `danger` / `danger-bg` | Error or destructive: text / background |
| `warning` | Caution |
| `text` / `text-dim` / `text-muted` | Main, secondary and disabled text |

## Type roles

| Role | Meaning |
|------|---------|
| `font-sans` | Main UI font, with fallbacks |
| `font-mono` | Monospace font for code and numbers |

Sizes, weights and spacing are not part of a Look; they belong to the project's tokens.

## Compliance

An app follows the contract when:

1. it defines every role;
2. every colour and font in the UI comes from a role;
3. it ships every Look it should offer (at least dark and light);
4. the user can switch Looks at runtime from a settings page;
5. text on `bg`, `surface` and `primary` meets WCAG AA contrast (4.5 : 1, 3 : 1 for large text).

## Neutral Looks

Used when neither the company layer nor the project provides Looks.

| Role | `dark` | `light` |
|------|--------|---------|
| `bg` | `#111418` | `#f7f8fa` |
| `surface` | `#1a1e24` | `#ffffff` |
| `surface-elevated` | `#232830` | `#ffffff` |
| `border` | `#343a44` | `#d5d9e0` |
| `border-subtle` | `#262b33` | `#e8ebef` |
| `primary` | `#2f6fe0` | `#2563eb` |
| `on-primary` | `#ffffff` | `#ffffff` |
| `accent` | `#5ec4b6` | `#0d9488` |
| `secondary` | `#2b313a` | `#eef1f5` |
| `success` / `success-bg` | `#4ade80` / `#12301f` | `#15803d` / `#dcfce7` |
| `danger` / `danger-bg` | `#f87171` / `#3a1717` | `#b91c1c` / `#fee2e2` |
| `warning` | `#fbbf24` | `#b45309` |
| `text` | `#e6e8eb` | `#1a1d21` |
| `text-dim` | `#a8afb9` | `#4b5563` |
| `text-muted` | `#6b7280` | `#9ca3af` |
| `font-sans` | `system-ui, -apple-system, "Segoe UI", Roboto, sans-serif` | same |
| `font-mono` | `ui-monospace, "Cascadia Code", Menlo, Consolas, monospace` | same |
