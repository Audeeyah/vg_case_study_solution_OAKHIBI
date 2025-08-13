
    
    

select
    currency_iso_code as unique_field,
    count(*) as n_records

from "casestudy"."intermediate"."stg_staging_intermediate__currencies"
where currency_iso_code is not null
group by currency_iso_code
having count(*) > 1


