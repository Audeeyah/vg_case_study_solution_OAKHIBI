

    select *
    from "casestudy"."staging"."stg_raw_staging__accounts"
    where account_opening_date > current_date()
    
