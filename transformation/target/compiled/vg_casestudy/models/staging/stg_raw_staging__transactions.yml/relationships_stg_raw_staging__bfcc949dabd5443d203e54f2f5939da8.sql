
    
    

with child as (
    select account_id as from_field
    from "casestudy"."staging"."stg_raw_staging__transactions"
    where account_id is not null
),

parent as (
    select account_id as to_field
    from "casestudy"."staging"."stg_raw_staging__accounts"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


