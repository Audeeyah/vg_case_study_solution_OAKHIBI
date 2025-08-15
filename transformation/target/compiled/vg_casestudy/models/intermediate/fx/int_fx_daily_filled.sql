

-- use only the dates that actually appear in transactions
with tx_dates as (
  select distinct cast(transaction_date as date) as fx_date
  from "casestudy"."staging"."stg_raw_staging__transactions"
),
fx_raw as (
  select
    cast(fx_rate_date as date)          as fx_date,
    upper(trim(currency_iso_code))      as currency_code,
    fx_rate                              as rate_to_eur
  from "casestudy"."staging"."stg_raw_staging__fx_rates"
),
currencies as (
  select distinct currency_code from fx_raw
),
calendar as (
  select d.fx_date, c.currency_code
  from tx_dates d
  cross join currencies c
),
filled as (
  select
    cal.fx_date,
    cal.currency_code,
    (
      select r.rate_to_eur
      from fx_raw r
      where r.currency_code = cal.currency_code
        and r.fx_date <= cal.fx_date
      order by r.fx_date desc
      limit 1
    ) as rate_to_eur
  from calendar cal
)
select * from filled