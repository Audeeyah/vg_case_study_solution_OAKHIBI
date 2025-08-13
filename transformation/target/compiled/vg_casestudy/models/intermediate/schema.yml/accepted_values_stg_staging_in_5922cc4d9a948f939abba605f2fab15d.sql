
    
    

with all_values as (

    select
        loan_status as value_field,
        count(*) as n_records

    from "casestudy"."intermediate"."stg_staging_intermediate__loans"
    group by loan_status

)

select *
from all_values
where value_field not in (
    'approved','rejected','closed'
)


