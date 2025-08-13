
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select loan_term
from "casestudy"."staging"."stg_raw_staging__loans"
where loan_term is null



  
  
      
    ) dbt_internal_test