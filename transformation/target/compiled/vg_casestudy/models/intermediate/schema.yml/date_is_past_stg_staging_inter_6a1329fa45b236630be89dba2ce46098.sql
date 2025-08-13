

    select *
    from "casestudy"."intermediate"."stg_staging_intermediate__loans"
    where approval_rejection_date > current_date()
    
