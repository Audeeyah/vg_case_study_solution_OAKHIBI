SELECT 
  loan_amount,
  interest_rate,
  -- Add any other relevant columns you want to check
  COUNT(*) OVER() as total_rows
FROM 
  "casestudy"."intermediate"."stg_staging_intermediate__loans"
LIMIT 100;  -- Adjust sample size as needed