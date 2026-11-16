# spec-nx

**Software engineering for vibe coding.**

spec-nx generates the spec kit your team needs to build software with AI the right way: clear
requirements, a plan in small steps, and a pull request that shows the code does what was
asked.

For anyone who builds software with AI: developers, students, scientists, and curious kids.

## ⭐ The right model for each Step — and what it cost

**spec-nx picks the AI model for every stage and Step, and tells you what each one cost.**

- **The right model, automatically.** Requirements, plans and hard Steps (architecture,
  security, tricky logic, graphics-heavy work) run on a strong *reasoning* model; routine Steps
  on a *standard* one; renames and docs on a cheap *light* one. The plan chooses the cheapest
  model that does each Step well and shows why; `IMPLEMENT:` asks **once** and then runs every
  Step on its model — as a sub-agent in VS Code Copilot and Claude Code.
- **Your choice per project:** a model per Step (default: Claude Opus 5.5 / Sonnet 5.5 /
  Haiku 5.5), **one fixed model** for everything, or **none** — always the model selected in
  your tool. Each developer can override it for themselves.
- **Tokens and cost of every stage and Step,** written into the spec: measured in Claude Code,
  estimated in VS Code Copilot — in tokens, GitHub AI credits, your currency (default CHF) and
  % of your Copilot plan. Closing a spec adds a **cost summary**, and `.specs/costs.md` lists
  every spec with its total. One switch turns it off.
- **Every Step records the model it was meant for and the model that ran it**, so you can
  compare models on real work.

> Costs are **estimates and may be wrong** — see
> [stages/COSTS.md](stages/COSTS.md). How to set it up:
> [docs/configuration.md](docs/configuration.md).
