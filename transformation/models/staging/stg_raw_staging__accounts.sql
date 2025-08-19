with source as (
  select * from {{ source('raw', 'accounts') }}
),
renamed as (
  select
    account_id,
    customer_id,
    lower(trim(account_type)) as account_type_raw,
    {{ date_format_case('account_opening_date') }} as account_opening_date,
    account_opening_date as account_opening_date_raw
  from source
),
normalized as (
  select
    account_id,
    customer_id,
    case
      when account_type_raw in ('savings','current') then account_type_raw
      when account_type_raw is null or account_type_raw in ('','-') then 'unknown'
      else 'other'
    end as account_type,
    account_opening_date,
    case
      when account_opening_date is null and account_opening_date_raw is not null
      then true else false
    end as has_date_parsing_error
  from renamed
),
final as (
  select *
  from normalized
  where account_id is not null
)
select * from final
