# <Project> — API contracts

> **Last updated:** YYYY-MM-DD

The public interface other programs rely on: endpoints, commands or functions, with their
inputs, outputs and errors. Changing a contract is a decision (ADR) when callers outside the
project depend on it.

## Conventions

- Base path / version: `<e.g. /api/v1>`
- Format: `<e.g. JSON, UTF-8>`
- Errors: `<shape of an error response>`

## <Endpoint or command>

`<METHOD> <path>` — one line: what it does.

| | Shape |
|---|---|
| Input | `<fields, types, required>` |
| Output | `<fields, types>` |
| Errors | `<code — when>` |

## Change log

- YYYY-MM-DD — [change] ([spec](features/…))
