#!/usr/bin/env python3
# ==============================================================================
# Script Name: view_logs.py
# Description: Queries and displays stored telemetric events and tracking logs
#              natively from the local SQLite operational database.
# ==============================================================================

import sqlite3
import os

DB_PATH = "MOSFETQexchange/output/telemetry.db"

def print_telemetry_ledger():
    if not os.path.exists(DB_PATH):
        print("[-] Log ledger database file does not exist yet.")
        return

    print("=" * 78)
    print(f"   TELEMETRY LEDGER TRANSACTION STATE LOGGER — DATABASE: {DB_PATH}")
    print("=" * 78)
    print(f"{'ID':<4} | {'TIMESTAMP (UTC)':<20} | {'EVENT TYPE':<18} | {'DETAILS'}")
    print("-" * 78)

    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    
    # Query your tracking history logs ordered sequentially
    cursor.execute("SELECT id, timestamp, event_type, details FROM telemetry_logs ORDER BY id ASC")
    rows = cursor.fetchall()
    
    for row in rows:
        print(f"{row[0]:<4} | {row[1]:<20} | {row[2]:<18} | {row[3]}")
        
    conn.close()
    print("=" * 78)

if __name__ == "__main__":
    print_telemetry_ledger()
