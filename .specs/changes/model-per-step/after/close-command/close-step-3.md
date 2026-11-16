3. **Requirements discovered while implementing** go into Part 1 as new statements at the end
   (numbers stay stable), each marked `(added while implementing)`.

   **Cost summary** (only with cost tracking on, `../COSTS.md`): first add this command's own
   Stage log row with its `usage` numbers, then write, directly above `# Part 1 ·
   Requirements`:

   ```
   ## Cost summary

   This feature used ~<tokens> tokens, ~<currency> <amount> — estimate, see [COSTS.md](<link>).

   | Stage / Step | Tokens | Cost (<currency>) | Share of <plan> |
   |--------------|--------|-------------------|-----------------|
   | requirements | … | … | … % |
   | plan | … | … | … % |
   | Step 1 | … | … | … % |
   | … | | | |
   | **Total** | **…** | **…** | **… %** |
   ```

   The numbers are the sums of the Stage log rows (requirements, plan, each Step, other
   commands such as `CLOSE:` and `REVIEW:` under their stage); the share is credits ÷
   `monthly_credits`. A row without numbers reads `N/A`. Then rebuild the list of all specs:
   `../tools/costs_ledger.ps1` / `../tools/costs_ledger.sh` (writes `.specs/costs.md`).
