import duckdb
from pathlib import Path

DB_PATH = Path("transformation/casestudy.duckdb")
def main():
    con = duckdb.connect(str(DB_PATH), read_only=False)
    con.execute("PRAGMA threads=4;")

    # Snapshot current tables (safe when overwriting from self)
    con.execute("CREATE OR REPLACE TEMP VIEW _dim_customer_src AS SELECT * FROM dim_customer;")
    con.execute("CREATE OR REPLACE TEMP VIEW _dim_account_src  AS SELECT * FROM dim_account;")

    # Rebuild dim_customer with 1 row per customer_id
    con.execute("""
        CREATE OR REPLACE TABLE dim_customer AS
        SELECT * EXCLUDE (rn)
        FROM (
            SELECT
                s.*,
                ROW_NUMBER() OVER (
                    PARTITION BY s.customer_id
                    ORDER BY s.customer_id
                ) AS rn
            FROM _dim_customer_src AS s
        )
        WHERE rn = 1
    """)

    # Rebuild dim_account with 1 row per account_id
    con.execute("""
        CREATE OR REPLACE TABLE dim_account AS
        SELECT * EXCLUDE (rn)
        FROM (
            SELECT
                s.*,
                ROW_NUMBER() OVER (
                    PARTITION BY s.account_id
                    ORDER BY s.account_id
                ) AS rn
            FROM _dim_account_src AS s
        )
        WHERE rn = 1
    """)

 # Diagnostics
    def dup_report(table: str, key: str):
        total, distinct_pk = con.execute(f"""
            SELECT COUNT(*) AS total_rows, COUNT(DISTINCT {key}) AS distinct_pk
            FROM {table}
        """).fetchone()
        print(f"{table}: total_rows={total:,} | distinct_{key}={distinct_pk:,}")

        sample_dups = con.execute(f"""
            SELECT {key}, COUNT(*) AS cnt
            FROM {table}
            GROUP BY 1
            HAVING COUNT(*) > 1
            LIMIT 5
        """).fetchall()
        if sample_dups:
            print(f"⚠️  Duplicates still present in {table}: {sample_dups}")
        else:
            print(f"✅ No duplicates on {key} in {table}")

    print("\n== After dedup overwrite ==")
    dup_report("dim_customer", "customer_id")
    dup_report("dim_account",  "account_id")

    con.close()

if __name__ == "__main__":
    if not DB_PATH.exists():
        raise FileNotFoundError(f"Couldn't find DuckDB at {DB_PATH.resolve()}")
    main()
