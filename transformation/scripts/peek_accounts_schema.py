import duckdb
con = duckdb.connect("casestudy.duckdb")

for rel in [
    "staging.stg_raw_staging__accounts",
    "staging.stg_raw_staging__transactions",
]:
    print(f"\n== {rel} ==")
    print(con.execute(f"PRAGMA table_info('{rel}')").fetchdf())
    print(con.execute(f"SELECT * FROM {rel} LIMIT 5").fetchdf())
