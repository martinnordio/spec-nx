5. **Generate `.specs/kit/`.** Delete the old kit: the whole `.specs/kit/` folder; for another
   `kit_dir`, only the entries listed in `kit_files` — never `.specs/`, `.spec-nx/`, the layer
   or any other file. If a new kit file would replace a file that is not in `kit_files`, stop
   and ask. Then for the
   stages in `stages` and `on_demand`:
   - `<stage>/prompt.md` from `stages/<stage>/prompt.md`, with the other files of the stage
     folder (templates, rules);
   - the skills those prompts list under *Skills to load*, into `skills/`;
   - `spec_template.md`;
   - `models.md` from `stages/models.md` (always — with no `models` setting it tells the
     stages to do nothing);
   - `COSTS.md` from `stages/COSTS.md`, and `tools/usage.*` and `tools/costs_ledger.*` for
     the shells in `shells`, when the project has a `cost` block;
   - `README.md` from `stages/kit_readme.md`: only the rows of the kit's stages;
   - `guidelines/prompt.md`, `guidelines/commits.md` (always) and, for each language in
     `languages` that has one, the baseline
     `guidelines/<language>.md` — adapted to the project's versions and tools (never copy
     rules its linter configuration contradicts);
   - `tools/README.md`, `tools/spec_summary.*` and `tools/<git_host>/` — only the scripts for
     the shells in `shells` — when the kit has the `pr` stage or `link_issues` is `true`.
