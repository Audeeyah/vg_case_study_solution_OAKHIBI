import duckdb
con = duckdb.connect("casestudy.duckdb")

for rel in [
    "staging.stg_raw_staging__transactions",
    "intermediate.stg_staging__intermediate__fx_rates",
]:
    print(f"\n== {rel} ==")
    print(con.execute(f"PRAGMA table_info('{rel}')").fetchdf())
