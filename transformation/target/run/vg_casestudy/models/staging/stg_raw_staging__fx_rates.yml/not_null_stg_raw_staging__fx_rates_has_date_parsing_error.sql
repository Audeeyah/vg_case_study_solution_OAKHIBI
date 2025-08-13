
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select has_date_parsing_error
from "casestudy"."staging"."stg_raw_staging__fx_rates"
where has_date_parsing_error is null



  
  
      
    ) dbt_internal_test