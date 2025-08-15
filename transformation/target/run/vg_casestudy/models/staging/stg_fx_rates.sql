
  
  create view "casestudy"."staging"."stg_fx_rates__dbt_tmp" as (
    

SELECT
  UPPER(TRIM(currency_iso_code)) AS currency_code,
  CAST(
    COALESCE(
      try_strptime(date, '%Y-%m-%d'),
      try_strptime(date, '%d.%m.%Y')
    ) AS DATE
  ) AS rate_date,
  CAST(REPLACE(REPLACE(fx_rate, '.', ''), ',', '.') AS DECIMAL(18,8)) AS rate
FROM "casestudy"."raw"."fx_rates"
WHERE currency_iso_code IS NOT NULL AND date IS NOT NULL
  );
