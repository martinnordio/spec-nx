5. **Generate `.specs/kit/`.** Delete the old `.specs/kit/` if there is one, then for the
   chosen stages:
   - `<stage>/prompt.md` from `stages/<stage>/prompt.md`;
   - the skills those prompts list under *Skills to load*, into `skills/`;
   - `spec_template.md`;
   - `tools/README.md`, `tools/spec_summary.*` and `tools/<git_host>/` — only the scripts for
     the shells in `shells` — when the kit has the `pr` stage or `link_issues` is `true`.
