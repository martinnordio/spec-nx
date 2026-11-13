5. **Generate `.specs/kit/`.** Delete the old `.specs/kit/` if there is one, then for the
   stages in `stages` and `on_demand`:
   - `<stage>/prompt.md` from `stages/<stage>/prompt.md`, with the other files of the stage
     folder (templates, rules);
   - the skills those prompts list under *Skills to load*, into `skills/`;
   - `spec_template.md`;
   - `README.md` from `stages/kit_readme.md`: only the rows of the kit's stages;
   - `guidelines/prompt.md` and, for each language in `languages` that has one, the baseline
     `guidelines/<language>.md` — adapted to the project's versions and tools (never copy
     rules its linter configuration contradicts);
   - `tools/README.md`, `tools/spec_summary.*` and `tools/<git_host>/` — only the scripts for
     the shells in `shells` — when the kit has the `pr` stage or `link_issues` is `true`.
