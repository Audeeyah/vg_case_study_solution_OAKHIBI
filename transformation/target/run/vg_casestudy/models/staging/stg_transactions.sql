
  
  create view "casestudy"."staging"."stg_transactions__dbt_tmp" as (
    

SELECT
  CAST(transaction_id AS BIGINT) AS transaction_id,
  CAST(account_id AS BIGINT) AS account_id,
  CAST(strptime(transaction_date, '%d.%m.%Y') AS DATE) AS transaction_date,
  UPPER(TRIM(transaction_currency)) AS currency_code,
  CAST(REPLACE(REPLACE(transaction_amount, '.', ''), ',', '.') AS DECIMAL(18,2)) AS amount_original
FROM "casestudy"."raw"."transactions"
  );
