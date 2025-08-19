{{ config(materialized='table') }}

with src as (
  select * from {{ ref('stg_raw_staging__accounts') }}
),
numbered as (
  select
    *,
    row_number() over (partition by account_id order by account_id) as rn
  from src
),
dedup as (
  select * from numbered where rn = 1
)
select
  account_id,
  customer_id,
  account_opening_date,
  account_type
from dedup
