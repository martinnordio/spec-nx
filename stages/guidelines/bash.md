# bash — baseline

> Generic rules. The project's ShellCheck configuration and `.specs/guidelines/bash.md` win
> over this file. Reference: [ShellCheck wiki](https://www.shellcheck.net/wiki/).

## Compatibility

- `#!/usr/bin/env bash`; say if the script also needs to run on macOS (bash 3.2) and avoid
  newer features (`declare -A`, `mapfile`) there.
- External tools the script needs (`curl`, `jq`, `gh`, …) are checked at the start with a
  clear message when missing.

## Safety

- `set -euo pipefail` at the top.
- Quote every variable expansion: `"$file"`, `"${args[@]}"`.
- `mktemp` for temporary files, removed with `trap '…' EXIT`.
- Changes to anything outside the script get a `--dry-run` option.
- Never print secrets; read tokens from environment variables.

## Structure

- Arguments parsed in one place (`while [[ $# -gt 0 ]]; do case "$1" in …`), with a
  `usage` function shown on `-h` / `--help` and on wrong arguments.
- `lower_snake_case` functions and local variables (`local`); `UPPER_SNAKE` for exported or
  constant values.
- `[[ … ]]` for tests, `$( … )` for command substitution.

## Errors

- Messages to standard error (`echo "error: …" >&2`) and a non-zero exit code.

## Checks before a Step is done

- `bash -n <script>` passes; ShellCheck passes if the project uses it; the dry run shows the
  expected result.
