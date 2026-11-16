3. **Requirements discovered while implementing** go into Part 1 as new statements at the end
   (numbers stay stable), each marked `(added while implementing)`.

   **Cost summary** (only with cost tracking on, `../COSTS.md`): first add this command's own
   Stage log row with its `usage` numbers, then write, directly above `# Part 1 ·
   Requirements`:

   ```
   ## Cost summary

   This feature used ~<tokens> tokens, ~<currency> <amount> — estimate, see [COSTS.md](<link>).

   | Stage | Tokens | Cost (<currency>) | Share of <plan> |
   |-------|--------|-------------------|-----------------|
   | requirements | … | … | … % |
   | plan | … | … | … % |
   | implementation | … | … | … % |
   | review | … | … | … % |
   | pr | … | … | … % |
   | **Total** | **…** | **…** | **… %** |

   **Implementation by Step**

   | Step | Tokens | Cost (<currency>) | Share of <plan> |
   |------|--------|-------------------|-----------------|
   | Step 1 | … | … | … % |
   | … | | | |
   | CLOSE | … | … | … % |
   | **Total implementation** | **…** | **…** | **… %** |
   ```

   The numbers are the sums of the Stage log rows per stage (`CREATE ISSUE:` / `UPDATE
   ISSUE:` under requirements, `CLOSE:` under implementation, `CODE REVIEW:` under review;
   leave out the rows of stages the kit does not have, and put any other stage, such as
   documentation, in its own row). The second table splits implementation into its Steps and
   `CLOSE:`; its total equals the implementation row. The share is credits ÷
   `monthly_credits`. A row without numbers reads `N/A`. Then rebuild the list of all specs:
   `../tools/costs_ledger.ps1` / `../tools/costs_ledger.sh` (writes `.specs/costs.md`).
