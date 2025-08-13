
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select account_opening_date
from "casestudy"."intermediate"."stg_staging_intermediate__accounts"
where account_opening_date is null



  
  
      
    ) dbt_internal_test