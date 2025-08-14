import os
import duckdb

# checking that the directory exists
os.makedirs("out/duckdb_export", exist_ok=True)

# Connect to the DuckDB file created by dbt
con = duckdb.connect('transformation/casestudy.duckdb', read_only=False)

# -------------------------
# CREATING THE DIMENSION CSV TABLES
# -------------------------

# dim_branch (from customers)
con.execute("""
CREATE OR REPLACE TABLE dim_branch AS
SELECT DISTINCT branch_id
FROM raw.customers
ORDER BY branch_id
""")
con.execute("""
COPY dim_branch TO 'out/duckdb_export/dim_branch.csv' (HEADER, DELIMITER ',')
""")

# dim_date (Date in format DD.MM.YYYY)
con.execute("""
CREATE OR REPLACE TABLE dim_date AS
WITH parsed AS (
  SELECT CAST(strptime(transaction_date, '%d.%m.%Y') AS DATE) AS transaction_date
  FROM raw.transactions
),
minmax AS (
  SELECT MIN(transaction_date) AS min_date, MAX(transaction_date) AS max_date
  FROM parsed
)
SELECT
  d::DATE                            AS date,
  year(d)                            AS year,
  month(d)                           AS month,
  day(d)                             AS day,
  strftime(d, '%B')                  AS month_name,
  CAST(strftime(d, '%V') AS INTEGER) AS iso_week,
  CAST(strftime(d, '%u') AS INTEGER) AS iso_weekday
FROM minmax, range(min_date, max_date + INTERVAL 1 DAY, INTERVAL 1 DAY) AS t(d)
ORDER BY d
""")
con.execute("""
COPY dim_date TO 'out/duckdb_export/dim_date.csv' (HEADER, DELIMITER ',')
""")

# dim_account (safe date matching)
con.execute("""
CREATE OR REPLACE TABLE dim_account AS
SELECT
  a.account_id,
  a.customer_id,
  c.branch_id,
  a.account_type,
  CAST(
    COALESCE(
      try_strptime(NULLIF(a.account_opening_date, ''), '%d.%m.%Y'),
      try_strptime(NULLIF(a.account_opening_date, ''), '%Y-%m-%d')
    ) AS DATE
  ) AS account_opening_date
FROM raw.accounts a
JOIN raw.customers c ON c.customer_id = a.customer_id
ORDER BY a.account_id
""")
con.execute("""
COPY dim_account TO 'out/duckdb_export/dim_account.csv' (HEADER, DELIMITER ',')
""")

# dim_customer (safe date matching)
con.execute("""
CREATE OR REPLACE TABLE dim_customer AS
SELECT
  customer_id,
  branch_id,
  firstname,
  lastname,
  city,
  CAST(
    COALESCE(
      try_strptime(NULLIF(creation_date, ''), '%d.%m.%Y'),
      try_strptime(NULLIF(creation_date, ''), '%Y-%m-%d')
    ) AS DATE
  ) AS creation_date
FROM raw.customers
ORDER BY customer_id
""")
con.execute("""
COPY dim_customer TO 'out/duckdb_export/dim_customer.csv' (HEADER, DELIMITER ',')
""")

# dim_currency 
con.execute("""
CREATE OR REPLACE TABLE dim_currency AS
SELECT currency_code
FROM (
    SELECT DISTINCT UPPER(TRIM(currency_iso_code)) AS currency_code FROM raw.fx_rates
    UNION
    SELECT DISTINCT UPPER(TRIM(transaction_currency)) AS currency_code FROM raw.transactions
    UNION
    SELECT 'EUR' AS currency_code
)
WHERE currency_code IS NOT NULL AND currency_code <> ''
ORDER BY 1
""")
con.execute("""
COPY dim_currency TO 'out/duckdb_export/dim_currency.csv' (HEADER, DELIMITER ',')
""")

# -------------------------
# FACT TABLES
# -------------------------

# Transaction-level fact with original + EUR (joins to account/customer/branch)
con.execute("""
CREATE OR REPLACE TABLE reporting.fct_transactions_original AS
SELECT
  j.transaction_id,
  j.transaction_date,
  j.account_id,
  a.customer_id,
  c.branch_id,
  j.currency_code,
  j.amount_original,
  j.amount_eur
FROM intermediate.int__transactions_eur AS j
JOIN raw.accounts  AS a ON a.account_id  = j.account_id
JOIN raw.customers AS c ON c.customer_id = a.customer_id
""")

# Export: ; delimiter + comma decimals (locale-friendly)
con.execute("""
COPY (
  SELECT
    transaction_id,
    account_id,
    customer_id,
    branch_id,
    transaction_date,
    currency_code,
    REPLACE(CAST(ROUND(amount_original, 2) AS VARCHAR), '.', ',') AS amount_original,
    REPLACE(CAST(ROUND(amount_eur,      2) AS VARCHAR), '.', ',') AS amount_eur
  FROM reporting.fct_transactions_original
)
TO 'out/duckdb_export/fct_transactions_original.csv'
(HEADER, DELIMITER ';', QUOTE '"')
""")

# Daily EUR fact (already built by dbt) — export with comma delimiter
con.execute("""
COPY reporting.fct_transactions_eur_daily
TO 'out/duckdb_export/fct_transactions_eur_daily.csv'
(HEADER, DELIMITER ',')
""")

con.close()
print("All dimensions and facts exported to out/duckdb_export/")
