# TypeScript — baseline

> Generic rules. The project's `tsconfig.json`, ESLint and Prettier configuration and
> `.specs/guidelines/typescript.md` win over this file. Reference:
> [TypeScript handbook](https://www.typescriptlang.org/docs/handbook/).

## Environment

- Use the package manager the project uses (its lock file decides: `pnpm-lock.yaml`,
  `package-lock.json`, `yarn.lock`); never mix them.
- `strict` mode on; a new dependency is a decision in the plan.

## Layout and naming

- `camelCase` variables and functions; `PascalCase` types, interfaces, classes and
  components; `UPPER_SNAKE` for true constants.
- File names follow the project (`camelCase.ts` or `kebab-case.ts`); one main export per file.
- ES modules (`import` / `export`); no default export unless the framework needs one.

## Types

- No `any`; use `unknown` and narrow it.
- Type every exported function's parameters and return value.
- Prefer `type` aliases and union types over enums, unless the project uses enums.
- Validate data at the boundary (API responses, user input, files) before trusting its type.

## Errors and async

- `async` / `await`, never unhandled promises; every `await` that can fail is handled where
  the user can see the error.
- Throw `Error` objects with a clear message; never throw strings.
- No `console.log` left in committed code (use the project's logger if it has one).

## Comments

- Comments say *why*; types and names say *what*.

## Tests

- The project's test runner (Vitest, Jest, Playwright for end-to-end); files
  `<name>.test.ts` next to the code or in the test folder the project uses.
- Every Step that changes behaviour adds or updates a test that would fail without it.

## Checks before a Step is done

- Type check (`tsc --noEmit` or the framework's check), linter and tests pass.
