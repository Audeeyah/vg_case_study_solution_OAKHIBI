
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select loan_amount
from "casestudy"."staging"."stg_raw_staging__loans"
where loan_amount is null



  
  
      
    ) dbt_internal_test