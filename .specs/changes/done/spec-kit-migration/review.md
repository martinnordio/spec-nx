# Review — feature/spec-kit-migration

| | |
|---|---|
| **Branch** | `feature/spec-kit-migration` |
| **Range** | `3cae701..HEAD` (merge base with `main`) |
| **Date** | 2026-11-13 |
| **Commits** | 12 (Step 0 … Step 11) |
| **Files** | 54 changed · +3 314 / −110 lines |
| **Written by** | `REVIEW:` · Claude Opus 5.5 |

> **Full report:** [review.html](review.html) — Before | After side by side, coloured diffs with
> concept tooltips. Download it and open it in a browser. This Markdown page has the same content.

## Summary

- spec-nx gets the rest of the method: **implementation**, **documentation** and **review**
  stages, and on demand **improvement**, **setup** and **ui**.
- The generator asks first **whether the project is new** and **which languages** it uses,
  offers the workflow as **Simple / Full / Custom**, writes a **project setup spec** for new
  projects, reads an optional private **company layer**, and writes the **AI agent's
  permissions**.
- Every kit gets **coding guidelines** for its languages and a **README** with its commands.
- The pull-request scripts publish a second block, the **semantic diff** — this page is the
  first one, written by the new review stage.
- Nothing that existed changes meaning: old settings files, commands, markers and script calls
  keep working.

## Spec

[2026_11_13_spec_kit_migration_spec.md](../../../features/done/2026_11_13_spec_kit_migration_spec.md) —
statements S1–S17, Steps 0–14; plan:
[2026_11_11_spec_kit_migration.md](../../../migrations/2026_11_11_spec_kit_migration.md).

## Semantic diff

**Why:** spec-nx had three stages and four questions, so a team could not yet replace the
original hand-written spec-kit with a generated kit. **Breaking:** none.
**Checks:** 4 pass · 4 n/a · 1 fail (C7, Nit).

| # | Check | Result |
|---|-------|--------|
| C1 | Record exists | pass |
| C2 | Record passes the schema | pass (first run failed on the example name `spec-nx.json`; fixed) |
| C3 | Every `S<n>` exists in the spec | pass (S1–S17) |
| C4 | Every block differs Before / After | pass (18 pairs) |
| C5 | Detectable changes have a block | pass (all 13 new commands, the new settings keys) |
| C6 | API / schema changes with API contracts / data model | n/a (the project has neither) |
| C7 | Command changes of code come with test changes | **fail** — see finding 1 |
| C8 | UI / tokens with UI catalog / looks | n/a |
| C9 | New dependencies have a decision | n/a (none added) |

Before / After were produced by running a script on the base revision (`git show 3cae701:…`)
and on the branch head; they are in `before/` and `after/` next to this page. Long tables are
condensed below for reading; the linked files are the complete, produced versions.

### CONFIG · question table — modified

Six new questions; Q5 (company layer) is asked first; the old keys keep their meaning.

**Before** ([before/question-table/table.md](before/question-table/table.md))

```
| Q1 | Development method — which stages do you use? | project | `stages` | ["requirements", "plan", "pr"] |
| Q2 | Git host … | Q2b | Keep each spec in sync … | Q3 | Which shell … | Q4 | Share the kit …
```

**After** ([after/question-table/table.md](after/question-table/table.md))

```
| Q5  | Company layer — use one? (asked first)            | `layer`        |
| Q0  | Project start — a new (empty) project or existing? | `project`      |
| Q0b | Languages                                          | `languages`    |
| Q0c | Write a project setup spec? (new projects only)    | `project_spec` |
| Q1  | Workflow — which stages do you use?                | `stages`  (default Simple) |
| Q1b | On-demand stages                                   | `on_demand`    |
| Q2, Q2b, Q3, Q4 unchanged                                                |
| Q6  | AI agent permissions — for which agents?           | `agent`        |
```

### CONFIG · Q1 options — modified

**Before** ([before/q1-workflow/options.md](before/q1-workflow/options.md))

```
| Full              | ["requirements", "plan", "implementation", "documentation", "review", "pr"] |
| Data science      | ["requirements", "plan", "pr"] |
| Requirements only | ["requirements"] |
| Custom            | any list that follows the rules below |
```

**After** ([after/q1-workflow/options.md](after/q1-workflow/options.md))

```
| Simple (default) | ["requirements", "plan", "implementation", "pr"] | Small teams, data science |
| Full             | ["requirements", "plan", "implementation", "documentation", "review", "pr"] |
| Custom           | your choice, one stage at a time |

requirements: yes (always)
plan:          yes / no
implementation: yes / no   (only if plan is yes)
documentation: yes / no
review:        yes / no    (only if implementation is yes)
pr:            yes / no
```

### DATA-FORMAT · `.specs/spec-nx.json` — modified

**Before** ([before/settings-file/spec-nx-json.md](before/settings-file/spec-nx-json.md))

```json
{
  "version": 1,
  "spec_nx_version": "a1b2c3d",
  "generated": "2026-11-09",
  "stages": ["requirements", "plan", "pr"],
  "git_host": "github",
  "link_issues": true,
  "shells": ["powershell", "bash"],
  "kit": "shared",
  "model": "<AI model that generated the kit>"
}
```

**After** ([after/settings-file/spec-nx-json.md](after/settings-file/spec-nx-json.md))

```json
{
  "version": 1,
  "spec_nx_version": "a1b2c3d",
  "generated": "2026-11-09",
  "layer": null,
  "project": "existing",
  "languages": ["python", "typescript"],
  "stages": ["requirements", "plan", "implementation", "pr"],
  "on_demand": ["improvement"],
  "git_host": "github",
  "link_issues": true,
  "shells": ["powershell", "bash"],
  "kit": "shared",
  "agent": ["copilot"],
  "model": "<AI model that generated the kit>"
}
```

### DATA-FORMAT · `.specs/kit/` — modified

**Before** ([before/kit-layout/generate-step-5.md](before/kit-layout/generate-step-5.md))

```
for the chosen stages:
- <stage>/prompt.md
- skills/
- spec_template.md
- tools/ (with pr or link_issues)
```

**After** ([after/kit-layout/generate-step-5.md](after/kit-layout/generate-step-5.md))

```
for the stages in `stages` and `on_demand`:
- <stage>/prompt.md, with the other files of the stage folder (templates, rules)
- skills/
- spec_template.md
- README.md            ← workflow and commands of the kit's stages
- guidelines/          ← prompt.md + a baseline per language in `languages`
- tools/ (with pr or link_issues)
```

### COMMAND · the contract every kit keeps — modified

**Before:** `REQUIREMENTS:`, `UPDATE ISSUE:`, `PLAN:`, `PR:`

**After:** `REQUIREMENTS:`, `UPDATE ISSUE:`, `PLAN:`, `IMPLEMENT:`, `CLOSE:`, `GUIDELINES:`,
`DOCS:`, `ARCHITECTURE`, `ADR:`, `REVIEW:`, `CODE REVIEW:`, `IMPROVE:`, `LOOK:`, `UI CATALOG`,
`SETUP TOOLING:`, `SETUP MACHINE`, `PR:`

### COMMAND · new stages — added

Before: absent. After (each from the stage's *Commands* section, in `after/stage-*/`):

| Stage | Commands | Statements |
|-------|----------|------------|
| implementation | `IMPLEMENT: <spec file> [Step <n>]`, `CLOSE: <spec file>` | S2, S3 |
| guidelines | `GUIDELINES: <language>` | S5 |
| documentation | `DOCS: <spec file>`, `ARCHITECTURE`, `ADR: <title> [— from <spec file> D<n>]` | S8 |
| review | `REVIEW: <spec file>`, `CODE REVIEW: <spec file>` | S9 |
| improvement | `IMPROVE: <scope> [--dry-run]` | S10 |
| setup | `SETUP TOOLING: <scope> [--dry-run]`, `SETUP MACHINE [--dry-run]` | S13 |
| ui | `LOOK: <app> [--looks …] [--logo …] [--dry-run]`, `UI CATALOG [<folder>]` | S11 |

### COMMAND · `update_pr` scripts — modified

One optional parameter in each of the four scripts; calls without it behave as before.

**Before** ([before/update-pr-parameters/github-update-pr-ps1.txt](before/update-pr-parameters/github-update-pr-ps1.txt))

```powershell
param(
    [Parameter(Mandatory)] [string] $SummaryFile,
    [string] $Title,
    [int] $Issue,
    [switch] $Draft,
    [switch] $DryRun
)
```

**After** ([after/update-pr-parameters/github-update-pr-ps1.txt](after/update-pr-parameters/github-update-pr-ps1.txt))

```powershell
param(
    [Parameter(Mandatory)] [string] $SummaryFile,
    [string] $SemanticDiffFile,
    [string] $Title,
    [int] $Issue,
    [switch] $Draft,
    [switch] $DryRun
)
```

bash, before → after: `update_pr.sh <summary-file> [--title …]` →
`update_pr.sh <summary-file> [--semantic-diff <file>] [--title …]` (both hosts).

### DATA-FORMAT · pull-request description — modified

Same input on both sides: `"Hand text"` + an old `spec-summary` block, then the new summary;
on the head also a semantic diff. Produced by running both revisions of `spec_summary.ps1`.

**Before** ([before/pr-description/with-semantic-diff.md](before/pr-description/with-semantic-diff.md))

```
Hand text

<!-- spec-summary:start -->
NEW SUMMARY
<!-- spec-summary:end -->
```

**After** ([after/pr-description/with-semantic-diff.md](after/pr-description/with-semantic-diff.md))

```
Hand text

<!-- spec-summary:start -->
NEW SUMMARY
<!-- spec-summary:end -->

<!-- semantic-diff:start -->
SEMANTIC DIFF
<!-- semantic-diff:end -->
```

### DATA-FORMAT · `review.html` — added

The HTML review report, from `stages/review/review_page.html` (S17). Before: absent.
After — its sections ([after/review-page/sections.txt](after/review-page/sections.txt)):

```
#summary  Summary
#spec  Spec
#semantic-diff  Semantic diff
#highlights  Highlights
#findings  Findings
#not-covered  Not covered
#concepts  Concepts
#checklist  Reviewer checklist
```

### Questions a reviewer will ask

- **Why one spec for twelve items?** The author wanted one review; each item is one Step and
  one commit (spec D1).
- **Why a company layer?** spec-nx is open source and names no company (S15); the layer keeps
  a company's stack, rules, Looks and permissions private without a fork (S7).
- **Can VS Code Copilot block `git push`?** No — its setting can only require approval, so
  the prompts keep "never commit or push" for every agent.

## Highlights

**1 · `stages/tools/spec_summary.ps1` — one helper for both blocks** (S9, S14)

```diff
-$script:SpecSummaryStart = '<!-- spec-summary:start -->'
-$script:SpecSummaryEnd = '<!-- spec-summary:end -->'
-
-function Set-SpecSummary {
-    param([string]$Body, [string]$Summary)
-    $block = "$SpecSummaryStart`n$($Summary.Trim())`n$SpecSummaryEnd"
+function Set-MarkedBlock {
+    param([string]$Body, [string]$Name, [string]$Text)
+    $startMarker = "<!-- $($Name):start -->"
+    $endMarker = "<!-- $($Name):end -->"
+    $block = "$startMarker`n$($Text.Trim())`n$endMarker"
…
+function Set-SpecSummary {
+    param([string]$Body, [string]$Summary)
+    Set-MarkedBlock -Body $Body -Name 'spec-summary' -Text $Summary
+}
+
+function Set-SemanticDiff {
+    param([string]$Body, [string]$Text)
+    Set-MarkedBlock -Body $Body -Name 'semantic-diff' -Text $Text
+}
```

- **What:** the marker logic is shared; `Set-SpecSummary` keeps its name and parameters.
- **Why it matters:** the issue scripts call `Set-SpecSummary` too — they must behave as before.
- **Check:** `$($Name):start` — the `$( )` is needed, `"$Name:start"` would read a drive-scoped
  variable in PowerShell.

**2 · `stages/tools/azure_devops/update_pr.ps1` — the block before the length check** (S9)

```diff
 }
+if ($SemanticDiffFile) { $new = Set-SemanticDiff -Body $new -Text (Read-Utf8 $SemanticDiffFile) }
 if ($new.Length -gt $MaxDescription) { throw "The description has $($new.Length) characters; Azure DevOps allows $MaxDescription. Shorten the summary." }
```

- **What:** the semantic diff is added before the 4 000-character check.
- **Why it matters:** a long semantic diff stops with a clear message instead of a failed API call.

**3 · `stages/tools/github/update_pr.sh` — optional `--semantic-diff`** (S9, S14)

```diff
-title='' issue='' draft='' dry_run=''
+title='' issue='' draft='' dry_run='' semantic_diff_file=''
 while [[ $# -gt 0 ]]; do
   case "$1" in
+    --semantic-diff) semantic_diff_file="$2"; shift 2 ;;
     --title) title="$2"; shift 2 ;;
…
   new="$(set_spec_summary "$body" "$summary")"
+  [[ -n "$semantic_diff_file" ]] && new="$(set_semantic_diff "$new" "$(cat "$semantic_diff_file")")"
```

- **Check:** under `set -e`, a false `[[ … ]]` before `&&` does not stop the script (bash ignores
  failures before the last `&&`); the same pattern was already used for `--draft`.

**4 · `generator/prompt.md` — the layer is read first** (S7)

```diff
+   **Find the company layer** (Q5, see `generator/layer.md`): `layer` from the settings, or a
+   folder with a `layer.json` in the project. If the user accepts it, read its `layer.json`
+   and `defaults.json` now — they are the suggestions for the questions below.
```

- **Why it matters:** the defaults must be known before Q0 is asked; the scan of the
  repository still wins over them (`generator/layer.md`, Priority).

## Findings

| # | Finding | Layer | Class | Severity | Target |
|---|---------|-------|-------|----------|--------|
| 1 | C7: the changed scripts have no committed tests; the block test and the checks ran from the git-ignored `testing/` folder | scan | test | Nit | Deferred: a spec for script tests |
| 2 | `GENERATE KIT` with the new questions was not run end to end in a scratch project; checked by read-through and static checks only | spec | test | Should-fix | Deferred: trial in `testing/` before a project switches |
| 3 | Placeholder links in templates (`../architecture.md`, `XXXX-slug.md`, `../../path`) fail a link check by design | scan | docs | Nit | none |
| 4 | Spec summary + semantic diff may exceed Azure DevOps' 4 000 characters | code | docs | Nit | none — the script stops with a clear message; the review prompt caps the text at ~2 000 |

**Good:** the new script parameter is optional, so old calls and old kits keep working; the
marker helper removed duplicated logic; every Before | After here was produced, none written
by hand.

## Not covered

- Prompt and template wording beyond the commands (read in full by the code review, not shown
  as Before | After: they are new files).
- `.specs/` documents (the spec, the migration plan): summarised above.
