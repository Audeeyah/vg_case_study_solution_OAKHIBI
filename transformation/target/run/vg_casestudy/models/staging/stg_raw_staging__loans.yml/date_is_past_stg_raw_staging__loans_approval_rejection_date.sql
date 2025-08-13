
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  

    select *
    from "casestudy"."staging"."stg_raw_staging__loans"
    where approval_rejection_date > current_date()
    

  
  
      
    ) dbt_internal_test