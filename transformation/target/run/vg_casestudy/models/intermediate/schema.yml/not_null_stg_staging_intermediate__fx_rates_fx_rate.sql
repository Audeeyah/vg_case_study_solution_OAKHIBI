
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select fx_rate
from "casestudy"."intermediate"."stg_staging_intermediate__fx_rates"
where fx_rate is null



  
  
      
    ) dbt_internal_test