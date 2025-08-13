
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  

    
        select *
        from "casestudy"."staging"."stg_raw_staging__customers"
        where age < 18 or age > 200
    
    


  
  
      
    ) dbt_internal_test