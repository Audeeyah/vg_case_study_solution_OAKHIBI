{{ config(materialized='table') }}

select
  transaction_date,
  account_id,
  customer_id,
  branch_id,
  txn_count,
  total_amount_eur,
  non_eur_without_fx_rows,
  case
    when non_eur_without_fx_rows > 0 and total_amount_eur is null
      then 'ALL_TXN_ROWS_NON_EUR_WITHOUT_FX'
    when total_amount_eur is null
      then 'TOTAL_NULL_OTHER_CAUSE'
    else 'OK'
  end as issue_reason
from {{ ref('fct_transactions_eur_daily') }}
where total_amount_eur is null
   or non_eur_without_fx_rows > 0
