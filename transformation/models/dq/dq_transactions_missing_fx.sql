{{ config(materialized='table') }}

-- Transactions that could not be converted to EUR because no FX rate existed
with tx as (
  select
    t.transaction_id,
    t.account_id,
    a.customer_id,
    t.transaction_date,
    t.transaction_currency,
    t.transaction_amount
  from {{ ref('stg_raw_staging__transactions') }} as t
  left join {{ ref('stg_raw_staging__accounts') }} as a
    using (account_id)
),
fx as (
  select
    fx_rate_date as fx_date,
    currency_iso_code as currency_code,
    fx_rate
  from {{ ref('stg_raw_staging__fx_rates') }}
)
select
  tx.transaction_id,
  tx.account_id,
  tx.customer_id,
  tx.transaction_date,
  tx.transaction_currency as currency_code,
  tx.transaction_amount   as amount_original,
  'NO_FX_RATE_FOR_DATE_CURRENCY' as issue_reason
from tx
left join fx
  on fx.fx_date = tx.transaction_date
 and fx.currency_code = tx.transaction_currency
where tx.transaction_currency <> 'EUR'
  and fx.fx_rate is null
