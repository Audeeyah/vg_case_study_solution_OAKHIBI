
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select age
from "casestudy"."staging"."stg_raw_staging__customers"
where age is null



  
  
      
    ) dbt_internal_test