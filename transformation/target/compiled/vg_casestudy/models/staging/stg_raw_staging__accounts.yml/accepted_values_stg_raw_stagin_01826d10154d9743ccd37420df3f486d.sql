
    
    

with all_values as (

    select
        account_type as value_field,
        count(*) as n_records

    from "casestudy"."staging"."stg_raw_staging__accounts"
    group by account_type

)

select *
from all_values
where value_field not in (
    'savings','current'
)


