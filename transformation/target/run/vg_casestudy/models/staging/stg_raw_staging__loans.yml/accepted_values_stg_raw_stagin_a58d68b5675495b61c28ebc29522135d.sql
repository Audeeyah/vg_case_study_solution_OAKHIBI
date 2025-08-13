
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        loan_term as value_field,
        count(*) as n_records

    from "casestudy"."staging"."stg_raw_staging__loans"
    group by loan_term

)

select *
from all_values
where value_field not in (
    '12','24','36','48','60'
)



  
  
      
    ) dbt_internal_test