

    select *
    from "casestudy"."staging"."stg_raw_staging__fx_rates"
    where fx_rate_date > current_date()
    
