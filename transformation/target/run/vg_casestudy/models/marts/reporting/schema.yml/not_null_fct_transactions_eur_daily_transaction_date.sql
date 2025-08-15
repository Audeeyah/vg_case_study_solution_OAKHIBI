
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select transaction_date
from "casestudy"."reporting"."fct_transactions_eur_daily"
where transaction_date is null



  
  
      
    ) dbt_internal_test