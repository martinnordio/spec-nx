# [Source] Migration Plan

> **Author:** [Your name]
> **Status:** ⬜ Draft
> **Created:** YYYY-MM-DD
> **Last updated:** YYYY-MM-DD
> **Source:** `[path or URL of what is migrated]`

<!-- File name: .specs/migrations/yyyy_mm_dd_<name>_migration.md.
     A migration plan does not build anything. It lists what the source has, decides for each
     item what happens to it, and groups the work into specs (M1, M2, …). Each spec is then
     created with the requirements stage (`REQUIREMENTS: <name> — <M-item>`) and linked back
     in the Specs to create table. -->

## Stage log

| Date | Stage | Command | Model | Note |
|------|-------|---------|-------|------|
| YYYY-MM-DD | migration plan | — | [model] | Plan written |

## Context

What is migrated, from where, and why, in two or three sentences.

## Principles

Rules every spec created from this plan follows (one line each).

- **P1:** [Principle]

## Inventory

Every item of the source, with a decision:
**Migrate** (bring as is, adapted) · **Merge** (into something spec-nx already has) ·
**Later** (wanted, not now) · **Drop** (not wanted, with the reason).

| # | Item | Kind | Decision | Target in spec-nx | Spec |
|---|------|------|----------|-------------------|------|
| I1 | `[source path]` | prompt / skill / tool / template / guideline / doc | Migrate | `[target]` | M1 |

## Decisions

| # | Decision | Why |
|---|----------|-----|
| D1 | [Choice] | [Reason] |

## Specs to create

In the order to build them. **Status:** ⬜ Not created · 📝 Spec created (link) · ✅ Done.

| # | Spec | Covers | Needs | Status |
|---|------|--------|-------|--------|
| M1 | [name] — [one line] | I1, I2 | — | ⬜ Not created |

### M1 — [name]

- **Goal:** [one sentence]
- **Seed statements:** [the requirements the spec should at least contain]
- **Notes:** [anything the requirements stage should know]

## Open questions

- [Question for the author before the first spec is created]
