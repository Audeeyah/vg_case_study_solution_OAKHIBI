
  
    
    

    create  table
      "casestudy"."reporting"."dim_branch__dbt_tmp"
  
    as (
      
select distinct branch_id
from "casestudy"."staging"."stg_raw_staging__customers"
    );
  
  