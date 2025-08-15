
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select txn_count
from "casestudy"."reporting"."fct_transactions_eur_daily"
where txn_count is null



  
  
      
    ) dbt_internal_test