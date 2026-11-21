# Copilot CLI Costs Spec

> **Author:** Martin Nordio
> **Status:** 🔄 In progress — S1–S9, S11 done on `main`; S10, S12 open
> **Created:** 2026-11-21
> **Last updated:** 2026-11-21
> **Branch:** `feature/copilot-cli-costs`

## Stage log

| Date | Stage | Command | Model | Tokens (estimate — see [COSTS.md](../../stages/COSTS.md)) | Cost (CHF) | Note |
|------|-------|---------|-------|--------|------|------|
| 2026-11-21 | requirements | `REQUIREMENTS:` | Claude Opus 5.5 | 3.64 M (36 k in · 3.59 M cached · 22 k out) | CHF 1.12 (133 credits) | Part 1 written, together with the reference fix in the hack_star project (measured from the Copilot CLI session log) |
| 2026-11-21 | implementation | `IMPLEMENT:` | Claude Opus 5.5 | 8.81 M (43 k in · 8.74 M cached · 26 k out) | CHF 2.09 (249 credits) | S1–S9, S11 implemented in `stages/` (ps1 and sh), S11–S12 added; checked on real logs (also covers the hack_star kit's `-Agent` change) |

---

# Part 1 · Requirements

## Context

Projects that run the stages in the **Copilot CLI** (also used by VS Code's "agent host"
chats) get `N/A` in every Tokens and Cost cell, so the cost of a feature is silently missing.
In hack_star the whole implementation, review and `CLOSE:` of the worlds feature (~2,700
credits, ~CHF 23) was recorded as `N/A`, and its totals read "requirements and plan only".
Cost per feature is a key promise of spec-nx; it must never be lost without a loud error.

**Already in the repository:**
- `stages/tools/usage.ps1` and `usage.sh` find a log by taking the **newest transcript of any
  VS Code workspace** (or the Claude Code project folder), then treat any file whose first
  line is `{"type":"session.start"` as a VS Code transcript.
- `stages/COSTS.md` rule 3: "If the script fails or finds no transcript, write `N/A`".
- `stages/spec_template.md`: "`N/A` if it could not run".

**What goes wrong** (seen in hack_star, 2026-11-18 to 2026-11-21):
1. A Copilot CLI log (`~/.copilot/session-state/<session>/events.jsonl`) also starts with
   `session.start`, so it is read as a VS Code transcript; the price lookup then fails with
   *No price for "Claude Opus 5.5"* (no `debug-logs/<id>/models.json` beside it). Yet the log
   holds a `session.usage_record` per request with its tokens (`inputTokens`,
   `cacheReadTokens`, `cacheWriteTokens`, `outputTokens`) and the billed AI credits
   (`copilotUsage.totalNanoAiu`, 10⁹ nano = 1 credit; `tokenDetails` with `costPerBatch`),
   sub-agents included.
2. Without `-Transcript`, the newest transcript of **another workspace** (`c:\repo` instead
   of `c:\repo\hack_star`) was used: 0 requests, printed as `CHF 0.00` with success.
3. A result of 0 requests is not an error, so a wrong time range or log goes unnoticed.
4. The rules let a stage write `N/A` without trying the right log.
5. Unknown to the method: VS Code transcripts hold **no tool results** (each
   `tool.execution_complete` is only `"success": true`), so file contents and test output are
   not counted and estimates can be several times too low; and some models are billed at a
   higher tier for long prompts (Claude Haiku 5.5 above ~100 k prompt tokens: 5× the list
   price), which the model list does not show.

**Reference fix:** hack_star's kit copy `.specs/kit/tools/usage.ps1` (with `COSTS.md`,
`tools/README.md` and `spec_template.md`) implements S1–S4, S6, S7 and S9 below; on the same
VS Code transcript it gives byte-identical results to the current script (S8), and on the
worlds run's CLI log it matches the billed credits.

**New:**
- Measured tokens and cost from Copilot CLI logs; a log search limited to the project; an
  error instead of 0; stricter rules for `N/A`.

## 1 · Specs

- **S1 — Copilot CLI measured:** `usage` reads a Copilot CLI `events.jsonl` and reports, for
  the time range, the requests, tokens (new input = `inputTokens − cacheReadTokens`, cached,
  output) and the **billed** credits from `session.usage_record` — no price list needed;
  sub-agents' requests are included; the output names the models found and says `measured`
  (no `~`).
- **S2 — Only this project's logs:** Without `-Transcript`, `usage` considers only logs of
  the project: Copilot CLI sessions whose `workspace.yaml` `cwd` or `git_root` is the project
  root or inside it, VS Code chats of the workspace whose `workspace.json` `folder` is the
  project root or inside it, and the project's Claude Code folder.
- **S3 — Right log:** Of those written since `-Since`, it uses the one with the most requests
  in the range, and names it in the `Source:` line.
- **S4 — Never a silent zero:** With no request in the range, `usage` stops with an error
  (non-zero exit) that lists every log it checked and how to pass `-Transcript`.
- **S5 — Both shells:** `usage.ps1` and `usage.sh` give the same numbers on the same log and
  range.
- **S6 — Rules:** `COSTS.md` lists the Copilot CLI as *measured*; adds the two limits of the
  VS Code estimate (no tool results; tier prices); allows `N/A` only after the script still
  fails with the right start time and log, with its error copied into the Note; and says
  that one command writing several specs puts the numbers on the first spec and
  `included in <spec>` on the others.
- **S7 — Template and tools README:** The template's comment and `tools/README.md` match S2–S6.
- **S8 — Unchanged estimates:** For the same VS Code transcript and range, the numbers are
  exactly those of the current script.
- **S9 — Windows PowerShell 5.1:** Workspace folders written as file URIs with encoded
  characters (`file:///c%3A/repo/x`) are matched correctly.
- **S10 — Checked:** The `testing/` checks include a small Copilot CLI log sample (with a
  sub-agent and two models), a sample from another workspace, and an empty range; they pass
  for both scripts.
- **S11 — Orchestrator and sub-agents apart:** For a Copilot CLI log, `usage` can count only
  the chat's own requests or only its sub-agents' (`-Agent main|subagents`), and always shows
  both parts; in a per-Step run each Step row counts its sub-agent and one extra Stage log
  row counts the orchestrating chat, so the rows add up to the run's total. (In hack_star the
  orchestrator was ~500 of ~820 credits and was in no row.)
- **S12 — Cost list without false gaps:** `costs_ledger` shows a row whose cells say
  `included in <spec>` as included (not `N/A`), and shows measured numbers without `~`.

### Open questions

- **Comparing tools:** measured (CLI, Claude Code) and estimated (VS Code) numbers differ by
  method — in hack_star the VS Code estimates were several times lower. Should the cost
  summary and `costs.md` mark estimated rows, and warn when a spec mixes both? Suggestion:
  yes — a short note under the table when estimated and measured rows are mixed.

<!-- spec-nx:plan -->

---

# Part 2 · Plan

_No plan stage ran: the author asked for the fix to be made directly from the working
reference in hack_star (2026-11-21)._

**Done** (commit "Count Copilot CLI costs; no silent N/A"):
- S1–S9 and S11: `stages/tools/usage.ps1` (copied from hack_star's kit) and `usage.sh`
  (ported); `stages/COSTS.md`, `stages/spec_template.md`, `stages/tools/README.md`,
  `stages/implementation/prompt.md` (per-Step run: orchestrator row).
- Checked on real logs: both scripts give identical JSON on a Copilot CLI run (824.2175
  credits = main 498.2273 + sub-agents 325.9902), on a VS Code transcript (929.7881 credits,
  byte-identical to the previous script), on a CLI Step window (142.572); both stop with
  exit 1 on an empty range; `-Agent main` on a VS Code log is refused.

**Open:**
- S10 — sample logs and checks in `testing/` for both scripts.
- S12 — `costs_ledger.ps1` / `.sh`: `included in <spec>` and measured numbers without `~`.
