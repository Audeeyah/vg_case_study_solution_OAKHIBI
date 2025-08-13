
    
    

with all_values as (

    select
        loan_status as value_field,
        count(*) as n_records

    from "casestudy"."staging"."stg_raw_staging__loans"
    group by loan_status

)

select *
from all_values
where value_field not in (
    'approved','rejected','closed'
)


