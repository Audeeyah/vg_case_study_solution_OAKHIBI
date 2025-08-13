
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select currency_iso_code
from "casestudy"."intermediate"."stg_staging_intermediate__currencies"
where currency_iso_code is null



  
  
      
    ) dbt_internal_test