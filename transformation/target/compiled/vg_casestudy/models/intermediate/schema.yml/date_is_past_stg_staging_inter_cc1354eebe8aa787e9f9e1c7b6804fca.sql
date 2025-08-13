

    select *
    from "casestudy"."intermediate"."stg_staging_intermediate__accounts"
    where account_opening_date > current_date()
    
