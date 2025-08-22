import duckdb

# connect to the dbt DuckDB file
con = duckdb.connect("casestudy.duckdb")

print("\n== Table schema ==")
print(con.execute("PRAGMA table_info('reporting.fct_transactions_eur_daily')").fetchdf())

print("\n== NULL count ==")
print(con.execute("""
    SELECT COUNT(*) AS null_rows
    FROM reporting.fct_transactions_eur_daily
    WHERE total_amount_eur IS NULL
""").fetchdf())

print("\n== Sample NULL rows ==")
print(con.execute("""
    SELECT transaction_date, account_id, customer_id, branch_id, txn_count, total_amount_eur
    FROM reporting.fct_transactions_eur_daily
    WHERE total_amount_eur IS NULL
    ORDER BY transaction_date DESC
    LIMIT 20
""").fetchdf())
