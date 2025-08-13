
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select customer_id
from "casestudy"."intermediate"."stg_staging_intermediate__accounts"
where customer_id is null



  
  
      
    ) dbt_internal_test