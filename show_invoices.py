#!/usr/bin/env python3
# ==============================================================================
# Script Name: show_invoices.py
# Description: Connects to the local candiDB schema and prints all allocated
#              rows inside the invoices relational transaction ledger.
# ==============================================================================

import sqlite3
import os

DB_PATH = "MOSFETQexchange/output/telemetry.db"

def list_all_invoices():
    if not os.path.exists(DB_PATH):
        print(f"[-] Execution fault: Database {DB_PATH} not found.")
        return

    print("=" * 85)
    print("                      candiDB — FULL INVOICES TABLE LEDGER")
    print("=" * 85)
    print(f"{'ID':<3} | {'DATE':<10} | {'ISBN / KEY REFERENCE':<22} | {'STATUS':<14} | {'GROSS (EUR)'} | {'CAGE'}")
    print("-" * 85)

    try:
        conn = sqlite3.connect(DB_PATH)
        cursor = conn.cursor()
        
        # Pull all 28 rows allocated inside your corporate transaction schema
        cursor.execute("""
            SELECT id, invoice_date, isbn, runtime_status, total_amount_eur, n_cage 
            FROM invoices 
            ORDER BY id ASC
        """)
        rows = cursor.fetchall()
        
        for row in rows:
            print(f"{row[0]:<3} | {row[1]:<10} | {row[2]:<22} | {row[3]:<14} | €{row[4]:<10.2f} | {row[5]}")
            
        print("-" * 85)
        print(f"[+] Diagnostic trace complete! Total allocated candidates listed: {len(rows)}")
        conn.close()
        
    except Exception as e:
        print(f"[-] Failed executing database readout iteration: {e}")
    print("=" * 85)

if __name__ == "__main__":
    list_all_invoices()
