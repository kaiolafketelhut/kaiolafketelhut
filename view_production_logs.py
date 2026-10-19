#!/usr/bin/env python3
# ==============================================================================
# Script Name: view_production_logs.py
# Description: Queries and displays data from the production invoices and
#              hardware telemetry tables natively inside Termux.
# ==============================================================================

import sqlite3
import os

DB_PATH = "MOSFETQexchange/output/telemetry.db"

def inspect_production_ledger():
    if not os.path.exists(DB_PATH):
        print("[-] Operational database file does not exist yet.")
        return

    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    
    print("\n" + "="*85)
    print("                      PRODUCTION INVOICES TABLE LEDGER")
    print("="*85)
    print(f"{'ID':<3} | {'DATE':<10} | {'ISBN':<17} | {'STATUS':<14} | {'GROSS (EUR)':<11} | {'CAGE'}")
    print("-"*85)
    
    cursor.execute("SELECT id, invoice_date, isbn, runtime_status, total_amount_eur, n_cage FROM invoices")
    for row in cursor.fetchall():
        print(f"{row[0]:<3} | {row[1]:<10} | {row[2]:<17} | {row[3]:<14} | €{row[4]:<10.2f} | {row[5]}")

    print("\n" + "="*85)
    print("                      HARDWARE TELEMETRY RECORDS TABLE")
    print("="*85)
    print(f"{'ID':<3} | {'ZENODO ID':<10} | {'SYSTEM IDENTIFIER':<28} | {'PROTOCOL'}")
    print("-"*85)
    
    cursor.execute("SELECT id, zenodo_id, system_identifier, protocol FROM telemetry_records")
    for row in cursor.fetchall():
        print(f"{row[0]:<3} | {row[1]:<10} | {row[2]:<28} | {row[3]}")
    print("="*85 + "\n")
    
    conn.close()

if __name__ == "__main__":
    inspect_production_ledger()
