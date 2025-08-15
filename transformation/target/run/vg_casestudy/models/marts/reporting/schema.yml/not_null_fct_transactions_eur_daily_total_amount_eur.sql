
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select total_amount_eur
from "casestudy"."reporting"."fct_transactions_eur_daily"
where total_amount_eur is null



  
  
      
    ) dbt_internal_test