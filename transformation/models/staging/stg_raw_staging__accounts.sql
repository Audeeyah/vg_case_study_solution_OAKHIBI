with source as (
  select *
  from {{ source('raw', 'accounts') }}
),

renamed as (
  select
      account_id,
      customer_id,
      lower(trim(account_type)) as account_type,         -- normalize
      {{ date_format_case('account_opening_date') }} as account_opening_date,
      account_opening_date as account_opening_date_raw
  from source
  where lower(trim(account_type)) in ('savings','current')  -- <-- whitelist
),

final as (
  select
      account_id,
      customer_id,
      account_type,
      account_opening_date,
      case
        when account_opening_date is null
         and account_opening_date_raw is not null
        then true else false
      end as has_date_parsing_error
  from renamed
)

select * from final
