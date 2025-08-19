# Solution Overview

**Repo:** `vg_case_study_solution_OAKHIBI`  
**Stack:** DuckDB + dbt (ELT), CSV exports → Power BI (Import, Folder connector)  
**Owner:** Odia Akhibi

---

## 1) Approach & Rationale
- **Lightweight ELT** with DuckDB (no infra) and **dbt** for versioned, testable SQL.
- **Layered modeling**
  - **staging/** cleans raw sources (trim/normalize types, date parsing, whitelists).
  - **marts/dimensions/** builds conformed dimensions: Account, Customer, Date, Branch, Currency.
  - **marts/reporting/** exposes a daily transactions fact table for fast visuals.
- **Data quality is explicit**
  - dbt tests: `not_null`, `unique`, `relationships`, `accepted_values`.
  - Additional flags (e.g., `has_date_parsing_error`) so we **show** issues instead of dropping rows.
- **Don’t hide problems**
  - “Orphan transactions” (facts whose `account_id` has no matching account) are **kept and labeled**.
  - Business can quantify impact and fix upstream data.

---

## 2) What changed & why

### Accounts (staging + dim)
- **Normalized `account_type`** to exactly `savings` or `current` (lower/trim + whitelist).  
  Raw had blanks/dashes/mixed-case → we standardize and filter empties.
- **Counts after cleaning:**  
  - `savings` = **2,507**  
  - `current` = **2,492**  
  - **Total = 4,999** (vs 5,000 originally due to one invalid/duplicate/empty case)
- **Date parsing** preserved as a **flag**: `has_date_parsing_error` (instead of dropping rows).

### Orphan transactions
- 9 `account_id`s referenced by transactions don’t exist in Account master.
- Kept in the fact table; flagged in Power BI with an **Orphan** slicer to quantify and triage.

---

## 3) Data Ingestion (Power BI)

- **Export source:** dbt/DuckDB writes CSVs to **`out/duckdb_export/`**  
  Files:
  - `dim_account.csv`, `dim_customer.csv`, `dim_branch.csv`, `dim_currency.csv`, `dim_date.csv`
  - `fct_transactions_eur_daily.csv`
  - *(diagnostic)* `orphan_transactions_counts.csv`
- **Connection:** Power BI → **Get data → Folder** → point to `out/duckdb_export/`.  
  Use “Combine” and retain separate queries per file. Refresh picks up updated CSVs.

---

## 4) Data Model

- **Star schema in Power BI**
  - Fact: `fct_transactions_eur_daily` (many)  
  - Dims: `dim_account` (one) → `dim_customer`, `dim_branch`, `dim_date`, `dim_currency`
- **Relationships:** single-direction from dims to fact for predictable totals.

---

## 5) Testing & Data Quality

- dbt tests on keys/relationships/accepted values across staging & marts.  
- Additional diagnostics exported:
  - `orphan_transactions_counts.csv` — surfaces integrity gaps for the business.
- We **retain** problematic records (date parsing failures, orphans) with flags to avoid silent data loss.

---

## 6) Documentation & Screenshots

- Screenshots of key report pages live in: `docs/screenshots/` (PNG).  
  Suggested names:  
  `kpi_overview.png`, `txn_trends.png`, `customer_segmentation.png`, `orphan_txn_view.png`.

---

## 7) Business Summary (short)

- Deposits/withdrawals distribution is stable; outliers surfaced by daily EUR fact.  
- **Data quality actions:** 9 orphan accounts to investigate; a handful of date parsing errors to cleanse.  
- Recommend: add upstream validation on account master loads and date formats.

---

**Note:** No Power BI Service publish (org account unavailable). PBIX provided locally and refreshes from `out/duckdb_export/`.
