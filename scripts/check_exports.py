import duckdb

con = duckdb.connect('transformation/casestudy.duckdb', read_only=True)

checks = [
    ("dim_date", "SELECT COUNT(*) FROM dim_date"),
    ("dim_branch", "SELECT COUNT(*) FROM dim_branch"),
    ("dim_account", "SELECT COUNT(*) FROM dim_account"),
    ("dim_customer", "SELECT COUNT(*) FROM dim_customer"),
    ("dim_currency", "SELECT COUNT(*) FROM dim_currency"),
    ("fct_transactions_eur_daily", "SELECT COUNT(*) FROM reporting.fct_transactions_eur_daily"),
    ("fct_transactions_original", "SELECT COUNT(*) FROM reporting.fct_transactions_original"),
]

for name, sql in checks:
    n = con.execute(sql).fetchone()[0]
    print(f"{name:30s} {n:,}")

print("\nSample fct_transactions_eur_daily:")
print(con.execute("""
SELECT transaction_date, SUM(total_amount_eur) AS eur_total
FROM reporting.fct_transactions_eur_daily
GROUP BY 1 ORDER BY 1 DESC LIMIT 5
""").fetchdf())

con.close()
