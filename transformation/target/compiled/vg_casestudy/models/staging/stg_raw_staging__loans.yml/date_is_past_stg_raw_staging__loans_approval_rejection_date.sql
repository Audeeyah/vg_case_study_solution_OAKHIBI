

    select *
    from "casestudy"."staging"."stg_raw_staging__loans"
    where approval_rejection_date > current_date()
    
