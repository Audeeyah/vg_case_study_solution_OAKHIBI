# Branch Analysis  One-Pager

**Repo / Branch:** `vg_case_study_data_analyst` / `fix/dim-account-and-staging`  
**Date:** $(Get-Date -Format "yyyy-MM-dd")  
**Goal:** Enable branch-focused analysis of daily EUR transactions and surface data-quality issues (FX gaps and null totals) in Power BI.

## What we built
- **Dbt models**
  - **Fact:** `reporting.fct_transactions_eur_daily`
    - Keys: `transaction_date`, `branch_id`, `account_id`, `customer_id`
    - Metrics: `txn_count`, `total_amount_eur`, `non_eur_without_fx_rows`
  - **Dimensions:** `dim_branch`, `dim_account`, `dim_customer`, `dim_currency`, `dim_date`
  - **DQ models:**
    - `dq_transactions_missing_fx`  non-EUR transactions with **no matching FX rate** for (date, currency)
    - `dq_fct_transactions_eur_daily_nulls`  days where the **facts** `total_amount_eur` was NULL
- **Exports (for Power BI)**  written to `out/`
  - Core: `fct_transactions_eur_daily.csv`, `dim_date.csv`, `dim_account.csv`, `dim_branch.csv`, `dim_currency.csv`, `dim_customer.csv`
  - DQ: `dq_transactions_missing_fx.csv`, `dq_fct_transactions_eur_daily_nulls.csv`
- **Power BI model**
  - Relationships (single direction, active)  
    - `dim_date[date] → fct_transactions_eur_daily[transaction_date]`  
    - `dim_branch[branch_id] → fct_transactions_eur_daily[branch_id]`  
    - `dim_account[account_id] → fct_transactions_eur_daily[account_id]`  
    - `dim_customer[customer_id] → fct_transactions_eur_daily[customer_id]`
    - DQ tables also relate via `dim_date` (and `dim_account` where applicable)
  - Measures (selection): `Total EUR`, `Txn Count`, `Avg EUR per Txn`, `Branch EUR Share %`,  
    `Missing FX Txns`, `Null Days (EUR total)`, `Non-EUR w/o FX (fact)`

## Earlier issue: `branch_id` errors — root cause & fix
**Symptom (dbt build failures):** Binder errors like  
“Values list `a` does not have a column named `branch_id`” /  
“Referenced column `currency_code` not found in FROM clause” etc.

**Root cause:** We initially tried to select `branch_id` (and some FX columns) from CTEs/tables that don’t contain them:
- `branch_id` is **not** present in raw `transactions`/FX staging; it comes from **accounts** (and is present in the **fact**).
- FX column names differed from our first draft (`fx_rate_date` / `currency_iso_code` vs. `fx_date` / `currency_code`).

**Resolution implemented:**
- Normalized the FX join by using the **intermediate FX model** that exposes the canonical names (or aliasing as needed).
- Removed `branch_id` from the DQ query that didn’t have access to it; the **fact** carries `branch_id` for branch analytics.
- `dbt build` passes; reporting fact includes valid `branch_id`.

**Options for DQ by branch (documented & supported):**
1. **Model-side (preferred):** join `dim_account` in `dq_transactions_missing_fx` to include `branch_id`.
2. **Power BI measure:** create **inactive** rel `dim_branch[branch_id]` ↔ `dim_account[branch_id]` and use  
   `Missing FX Txns (by Branch) = CALCULATE([Missing FX Txns], USERELATIONSHIP(dim_branch[branch_id], dim_account[branch_id]))`.

## Power BI loading note (locale)
Some CSVs use `.` as decimal. To avoid `610.56` → `61056`, force locale when typing:
`Table.TransformColumnTypes(…, {{"total_amount_eur", Currency.Type}}, "en-US")`.

## Reproduce (quick)
```bash
# from transformation/
dbt build
python .\scripts\export_core_csv.py
python .\scripts\export_dq_csv.py
# Power BI: load from /out, apply relationships, paste measures

git add $path
git commit -m "docs: add branch-analysis one-pager incl. branch_id issue and resolution"
git push

### Where its saved
`docs\branch_analysis_one_pager.md` (relative to your repo root).

### (Optional) verify
```powershell
Get-Content docs\branch_analysis_one_pager.md -Head 10
git log -1 --name-status

