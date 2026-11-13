# Python — baseline

> Generic rules. The project's linter configuration (`pyproject.toml` / `ruff.toml`) and
> `.specs/guidelines/python.md` win over this file. Style reference:
> [PEP 8](https://peps.python.org/pep-0008/), [PEP 257](https://peps.python.org/pep-0257/).

## Environment

- Use the Python version the project declares (`requires-python`); write syntax for it.
- One virtual environment per project (`.venv/`); never install into the system Python.
- Dependencies are declared in one place (`pyproject.toml`, or `requirements.txt` if the
  project uses it); a new dependency is a decision in the plan.

## Layout and naming

- 4 spaces, no tabs; the line length of the linter.
- `snake_case` functions, variables and modules; `PascalCase` classes; `UPPER_SNAKE`
  constants; `_leading_underscore` for non-public names.
- Imports: standard library, third party, local — one blank line between groups; no
  `from x import *`.

## Types

- Type hints on every public function and method.
- Modern syntax: `list[str]`, `dict[str, int]`, `X | None`.
- `dataclass` (or the project's model library) for structured data — not bare dicts passed
  around.
- Avoid `Any` in public signatures.

## Errors

- Fail fast with a clear message naming the bad value:
  `raise ValueError(f"Unknown mode {mode!r}")`.
- Catch specific exceptions; never a bare `except:`; never swallow an error silently.
- Compare with `None` using `is` / `is not`.

## Files and output

- Open text files with `encoding="utf-8"`.
- Build paths with `pathlib.Path`.
- Long-running scripts log progress (`logging`, or `print(..., flush=True)` in small
  scripts).

## Docs and comments

- A one-line docstring for each public module, class and function.
- Comments say *why*, never repeat *what* the code does.

## Tests

- `pytest`, in the project's test folder; files `test_<module>.py`, functions
  `test_<behaviour>`.
- Every Step that changes behaviour adds or updates a test that would fail without it.
- Tests do not depend on network, real credentials or the order they run in.

## Checks before a Step is done

- Tests pass; the linter and formatter pass; the type checker passes if the project uses one.
