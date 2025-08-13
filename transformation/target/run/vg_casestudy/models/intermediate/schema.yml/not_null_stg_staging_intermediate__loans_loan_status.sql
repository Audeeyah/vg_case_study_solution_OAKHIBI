
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select loan_status
from "casestudy"."intermediate"."stg_staging_intermediate__loans"
where loan_status is null



  
  
      
    ) dbt_internal_test