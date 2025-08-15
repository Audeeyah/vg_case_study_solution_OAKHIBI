
  
  create view "casestudy"."intermediate"."int__transactions_eur__dbt_tmp" as (
    

WITH ranked AS (
  SELECT
    t.transaction_id,
    t.account_id,
    t.transaction_date,
    t.currency_code,
    t.amount_original,
    f.rate,
    ROW_NUMBER() OVER (
      PARTITION BY t.transaction_id
      ORDER BY f.rate_date DESC
    ) AS rn
  FROM "casestudy"."staging"."stg_transactions" t
  LEFT JOIN "casestudy"."staging"."stg_fx_rates" f
    ON f.currency_code = t.currency_code
   AND f.rate_date    <= t.transaction_date
)
SELECT
  transaction_id,
  account_id,
  transaction_date,
  currency_code,
  amount_original,
  CASE
    WHEN currency_code = 'EUR' THEN amount_original
    WHEN rate IS NULL            THEN NULL
    ELSE amount_original / rate   -- correct direction for your data
  END AS amount_eur
FROM ranked
WHERE rn = 1
  );
