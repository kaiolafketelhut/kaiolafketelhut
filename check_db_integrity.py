#!/usr/bin/env python3
# ==============================================================================
# Script Name: check_db_integrity.py
# Description: Automated database diagnostic tool verifying row integrity,
#              schema definitions, and active candidate records.
# ==============================================================================

import sqlite3
import os

DB_PATH = "MOSFETQexchange/output/telemetry.db"

def run_db_diagnostic():
    if not os.path.exists(DB_PATH):
        print(f"[-] Diagnostic failure: Target database {DB_PATH} does not exist.")
        return

    print("=" * 70)
    print("        candiDB — CORE DATABASE SYSTEM INTEGRITY DIAGNOSTIC")
    print("=" * 70)

    try:
        conn = sqlite3.connect(DB_PATH)
        cursor = conn.cursor()

        # 1. Verify Low-Level SQLite Page Integrity
        cursor.execute("PRAGMA integrity_check;")
        status = cursor.fetchone()[0]
        print(f"[+] Low-Level File Integrity Status : {status}")

        # 2. Extract and List Active Database Tables
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
        tables = [t[0] for t in cursor.fetchall()]
        print(f"[+] Discovered System Tables         : {', '.join(tables)}")
        print("-" * 70)

        # 3. Print Row Allocation Metrics for Each Table Matrix
        for table in tables:
            cursor.execute(f"SELECT COUNT(*) FROM {table};")
            row_count = cursor.fetchone()[0]
            print(f"[*] Candidate Rows Allocated inside '{table:<17}': {row_count} rows")

        print("=" * 70)
        conn.close()

    except Exception as e:
        print(f"[-] Critical exception during schema validation: {e}")

if __name__ == "__main__":
    run_db_diagnostic()
