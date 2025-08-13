
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    currency_iso_code as unique_field,
    count(*) as n_records

from "casestudy"."intermediate"."stg_staging_intermediate__fx_rates"
where currency_iso_code is not null
group by currency_iso_code
having count(*) > 1



  
  
      
    ) dbt_internal_test