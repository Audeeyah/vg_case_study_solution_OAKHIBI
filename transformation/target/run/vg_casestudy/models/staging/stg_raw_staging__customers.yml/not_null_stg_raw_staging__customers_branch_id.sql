
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select branch_id
from "casestudy"."staging"."stg_raw_staging__customers"
where branch_id is null



  
  
      
    ) dbt_internal_test