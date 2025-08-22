# transformation/scripts/export_core_csv.py
import duckdb, os, pathlib

DB = "casestudy.duckdb"
OUT_DIR = pathlib.Path("../out")
OUT_DIR.mkdir(parents=True, exist_ok=True)

con = duckdb.connect(DB)

core_tables = [
    "dim_date",
    "dim_customer",
    "dim_account",
    "dim_currency",
    "dim_branch",
    "fct_transactions_eur_daily",
]

# Preferred sort columns (will only be used if they exist)
order_map = {
    "dim_date": ["date"],
    "dim_customer": ["customer_id"],
    "dim_account": ["account_id"],
    "dim_currency": ["currency_code"],
    "dim_branch": ["branch_id"],
    "fct_transactions_eur_daily": ["transaction_date", "account_id"],
}

def get_schema(table):
    row = con.execute(
        """
        select table_schema
        from information_schema.tables
        where table_name = ?
        order by case when table_schema='main' then 0 else 1 end
        limit 1
        """,
        [table],
    ).fetchone()
    return row[0] if row else None

def get_columns(schema, table):
    return [
        r[1]
        for r in con.execute(
            f"PRAGMA table_info('{schema}.{table}')"
        ).fetchall()
    ]

exported = []
for tbl in core_tables:
    schema = get_schema(tbl)
    if not schema:
        print(f"Skipped (not found): {tbl}")
        continue

    cols = [c.lower() for c in get_columns(schema, tbl)]
    order_cols = [c for c in order_map.get(tbl, []) if c.lower() in cols]
    order_clause = ""
    if order_cols:
        order_clause = " ORDER BY " + ", ".join(order_cols)

    sql = f'SELECT * FROM "{schema}"."{tbl}"{order_clause}'
    out_path = OUT_DIR / f"{tbl}.csv"
    con.execute(f"COPY ({sql}) TO '{out_path.as_posix()}' WITH (HEADER, DELIMITER ',');")
    size_kb = out_path.stat().st_size / 1024
    print(f"Exported: {out_path}  ({size_kb:.1f} KB)")

print("\nDone.")
