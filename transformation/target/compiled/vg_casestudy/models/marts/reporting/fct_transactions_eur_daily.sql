

WITH base AS (
  SELECT
    j.transaction_date,
    j.currency_code,
    j.amount_eur,
    a.account_id,
    a.customer_id,
    c.branch_id
  FROM "casestudy"."intermediate"."int__transactions_eur" j
  JOIN "casestudy"."raw"."accounts"  a ON a.account_id  = j.account_id
  JOIN "casestudy"."raw"."customers" c ON c.customer_id = a.customer_id
)
SELECT
  customer_id,
  account_id,
  branch_id,
  transaction_date,
  CAST(SUM(amount_eur) AS DECIMAL(18,2)) AS total_amount_eur,
  COUNT(*)                                AS txn_count,
  SUM(CASE WHEN currency_code <> 'EUR' AND amount_eur IS NULL THEN 1 ELSE 0 END) AS non_eur_without_fx_rows
FROM base
GROUP BY 1,2,3,4
ORDER BY transaction_date DESC, branch_id, account_id