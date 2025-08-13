
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        loan_type as value_field,
        count(*) as n_records

    from "casestudy"."staging"."stg_raw_staging__loans"
    group by loan_type

)

select *
from all_values
where value_field not in (
    'personal','mortgage','auto'
)



  
  
      
    ) dbt_internal_test