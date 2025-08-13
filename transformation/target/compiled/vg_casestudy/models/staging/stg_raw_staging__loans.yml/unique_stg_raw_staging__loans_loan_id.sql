
    
    

select
    loan_id as unique_field,
    count(*) as n_records

from "casestudy"."staging"."stg_raw_staging__loans"
where loan_id is not null
group by loan_id
having count(*) > 1


