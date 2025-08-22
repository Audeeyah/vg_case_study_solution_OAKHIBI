# transformation/scripts/export_dq_csv.py
import duckdb, os, pathlib

DB = "casestudy.duckdb"
OUT_DIR = pathlib.Path("../out")
OUT_DIR.mkdir(parents=True, exist_ok=True)

con = duckdb.connect(DB)

targets = {
    "dq_transactions_missing_fx":  "select * from dq_transactions_missing_fx order by transaction_date desc, account_id",
    "dq_fct_transactions_eur_daily_nulls": "select * from dq_fct_transactions_eur_daily_nulls order by transaction_date desc, account_id",
}

exported = []
for table, sql in targets.items():
    # check table exists (in any schema)
    exists = con.execute("""
        select table_schema, table_name
        from information_schema.tables
        where table_name = ?
        limit 1
    """, [table]).fetchone()
    if not exists:
        print(f"Skipped (not found): {table}")
        continue

    out_path = OUT_DIR / f"{table}.csv"
    con.execute(f"COPY ({sql}) TO '{out_path.as_posix()}' WITH (HEADER, DELIMITER ',');")
    exported.append(out_path)

# Print a small summary including file sizes
print("\n== Export summary ==")
for p in exported:
    size_kb = p.stat().st_size / 1024
    print(f"Exported: {p}  ({size_kb:.1f} KB)")
if not exported:
    print("No files exported.")

print("\nFiles in out/:")
for p in sorted(OUT_DIR.glob("*.csv")):
    print(" -", p.name)
