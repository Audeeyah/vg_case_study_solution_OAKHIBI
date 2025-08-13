
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  

    
        select *
        from "casestudy"."staging"."stg_raw_staging__fx_rates"
        where fx_rate < 0
    
    


  
  
      
    ) dbt_internal_test