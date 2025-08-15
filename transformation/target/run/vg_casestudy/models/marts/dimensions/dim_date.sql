
  
    
    

    create  table
      "casestudy"."reporting"."dim_date__dbt_tmp"
  
    as (
      

    
    with
        base_dates as (
    with
        date_spine as (

            

    
    with
        rawdata as (

            

    

    with
        p as (
            select 0 as generated_number
            union all
            select 1
        ),
        unioned as (

            select

                
                    p0.generated_number * power(2, 0)
                     + 
                
                    p1.generated_number * power(2, 1)
                     + 
                
                    p2.generated_number * power(2, 2)
                     + 
                
                    p3.generated_number * power(2, 3)
                     + 
                
                    p4.generated_number * power(2, 4)
                     + 
                
                    p5.generated_number * power(2, 5)
                     + 
                
                    p6.generated_number * power(2, 6)
                     + 
                
                    p7.generated_number * power(2, 7)
                     + 
                
                    p8.generated_number * power(2, 8)
                     + 
                
                    p9.generated_number * power(2, 9)
                     + 
                
                    p10.generated_number * power(2, 10)
                    
                
                + 1 as generated_number

            from

            
                    p as p0  cross join 
            
                    p as p1  cross join 
            
                    p as p2  cross join 
            
                    p as p3  cross join 
            
                    p as p4  cross join 
            
                    p as p5  cross join 
            
                    p as p6  cross join 
            
                    p as p7  cross join 
            
                    p as p8  cross join 
            
                    p as p9  cross join 
            
                    p as p10 
            

        )

    select *
    from unioned
    where generated_number <= 1095
    order by generated_number



        ),

        all_periods as (

            select
                (
                    

    date_add(cast('2023-01-01' as timestamp), interval ((row_number() over (order by 1) - 1)) day)


                ) as date_day
            from rawdata

        ),

        filtered as (

            select * from all_periods where date_day <= cast('2025-12-31' as timestamp)

        )

    select *
    from filtered



        )
    select
        cast(d.date_day as timestamp) as date_day
    from date_spine d

),
        dates_with_prior_year_dates as (

            select
                cast(d.date_day as date) as date_day,
                cast(
                    

    date_add(d.date_day, interval (-1) year)

 as date
                ) as prior_year_date_day,
                cast(
                    

    date_add(d.date_day, interval (-364) day)

 as date
                ) as prior_year_over_year_date_day
            from base_dates d

        )
    select
        d.date_day,
        cast(

    date_add(d.date_day, interval (-1) day)

 as date) as prior_date_day,
        cast(

    date_add(d.date_day, interval (1) day)

 as date) as next_date_day,
        d.prior_year_date_day as prior_year_date_day,
        d.prior_year_over_year_date_day,
        -- Sunday(1) to Saturday (7)
        cast(date_part('dow', d.date_day) + 1 as integer) as day_of_week,
        -- Monday(1) to Sunday (7)
        cast(date_part('isodow', d.date_day) as integer) as day_of_week_iso,
        dayname(d.date_day) as day_of_week_name,
        substr(dayname(d.date_day), 1, 3) as day_of_week_name_short,
        date_part('day', d.date_day) as day_of_month,
        date_part('dayofyear', d.date_day) as day_of_year,

        -- Sunday as week start date
    cast(
        

    date_add(date_trunc('week', 

    date_add(d.date_day, interval (1) day)

), interval (-1) day)

 as date
    ) as week_start_date,
        cast(

    date_add(-- Sunday as week start date
    cast(
        

    date_add(date_trunc('week', 

    date_add(d.date_day, interval (1) day)

), interval (-1) day)

 as date
    ), interval (6) day)

 as date) as week_end_date,
        -- Sunday as week start date
    cast(
        

    date_add(date_trunc('week', 

    date_add(d.prior_year_over_year_date_day, interval (1) day)

), interval (-1) day)

 as date
    )
        as prior_year_week_start_date,
        cast(

    date_add(-- Sunday as week start date
    cast(
        

    date_add(date_trunc('week', 

    date_add(d.prior_year_over_year_date_day, interval (1) day)

), interval (-1) day)

 as date
    ), interval (6) day)

 as date)
        as prior_year_week_end_date,
        cast(ceil(dayofyear(d.date_day) / 7) as int) as week_of_year,

        cast(date_trunc('week', d.date_day) as date) as iso_week_start_date,
        cast(

    date_add(cast(date_trunc('week', d.date_day) as date), interval (6) day)

 as date) as iso_week_end_date,
        cast(date_trunc('week', d.prior_year_over_year_date_day) as date)
        as prior_year_iso_week_start_date,
        cast(

    date_add(cast(date_trunc('week', d.prior_year_over_year_date_day) as date), interval (6) day)

 as date)
        as prior_year_iso_week_end_date,
        -- postgresql week is isoweek, the first week of a year containing January 4 of
    -- that year.
    cast(date_part('week', d.date_day) as integer) as iso_week_of_year,

        cast(ceil(dayofyear(d.prior_year_over_year_date_day) / 7) as int)
        as prior_year_week_of_year,
        -- postgresql week is isoweek, the first week of a year containing January 4 of
    -- that year.
    cast(date_part('week', d.prior_year_over_year_date_day) as integer)
        as prior_year_iso_week_of_year,

        cast(
            date_part('month', d.date_day) as integer
        ) as month_of_year,
        monthname(d.date_day) as month_name,
        substr(monthname(d.date_day), 1, 3) as month_name_short,

        cast(date_trunc('month', d.date_day) as date) as month_start_date,
        cast(cast(
        

    date_add(

    date_add(date_trunc('month', d.date_day), interval (1) month)

, interval (-1) day)


        as date) as date) as month_end_date,

        cast(
            date_trunc('month', d.prior_year_date_day) as date
        ) as prior_year_month_start_date,
        cast(
            cast(
        

    date_add(

    date_add(date_trunc('month', d.prior_year_date_day), interval (1) month)

, interval (-1) day)


        as date) as date
        ) as prior_year_month_end_date,

        cast(
            date_part('quarter', d.date_day) as integer
        ) as quarter_of_year,
        cast(
            date_trunc('quarter', d.date_day) as date
        ) as quarter_start_date,
        cast(-- duckdb dateadd does not support quarter interval.
    cast(
        

    date_add(

    date_add(date_trunc('quarter', d.date_day), interval (3) month)

, interval (-1) day)


        as date) as date) as quarter_end_date,

        cast(
            date_part('year', d.date_day) as integer
        ) as year_number,
        cast(date_trunc('year', d.date_day) as date) as year_start_date,
        cast(cast(
        

    date_add(

    date_add(date_trunc('year', d.date_day), interval (1) year)

, interval (-1) day)


        as date) as date) as year_end_date
    from dates_with_prior_year_dates d
    order by 1


    );
  
  