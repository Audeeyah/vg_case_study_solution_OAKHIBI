
    
    

with all_values as (

    select
        transaction_type as value_field,
        count(*) as n_records

    from "casestudy"."staging"."stg_raw_staging__transactions"
    group by transaction_type

)

select *
from all_values
where value_field not in (
    'transfer','deposit','withdrawal'
)


