
    
    

select
    currency_iso_code as unique_field,
    count(*) as n_records

from "casestudy"."staging"."stg_raw_staging__fx_rates"
where currency_iso_code is not null
group by currency_iso_code
having count(*) > 1


