#!/usr/bin/env python3
# ==============================================================================
# Script Name: export_invoices.py
# Description: Extracts records from the production invoices SQLite database 
#              and exports them cleanly into a structured CSV report format.
# ==============================================================================

import sqlite3
import csv
import os

DB_PATH = "MOSFETQexchange/output/telemetry.db"
OUTPUT_CSV_PATH = "MOSFETQexchange/output/invoice_summary_report.csv"

def export_ledger_to_csv():
    if not os.path.exists(DB_PATH):
        print(f"[-] Execution fault: Database {DB_PATH} not found.")
        return

    print("[*] Accessing SQLite database fields to compile data rows...")
    os.makedirs(os.path.dirname(OUTPUT_CSV_PATH), exist_ok=True)

    try:
        conn = sqlite3.connect(DB_PATH)
        cursor = conn.cursor()
        
        # Pull all available records from the production invoices table
        cursor.execute("""
            SELECT id, invoice_date, isbn, item_description, runtime_status, 
                   payment_gateway, net_amount_eur, vat_amount_eur, total_amount_eur, 
                   channel, entity, n_cage 
            FROM invoices
            ORDER BY id ASC
        """)
        rows = cursor.fetchall()
        
        # Define the structural CSV headers matching your production database columns
        headers = [
            "ID", "Invoice_Date", "ISBN", "Item_Description", "Runtime_Status",
            "Payment_Gateway", "Net_Amount_EUR", "VAT_Amount_EUR", "Total_Amount_EUR",
            "Channel", "Entity", "N_CAGE"
        ]

        print(f"[*] Compiling rows into flat sheet at: {OUTPUT_CSV_PATH}")
        with open(OUTPUT_CSV_PATH, "w", newline="", encoding="utf-8") as csv_file:
            writer = csv.writer(csv_file, delimiter=",", quotechar='"', quoting=csv.QUOTE_MINIMAL)
            
            # Write header row followed by extracted data matrix rows
            writer.writerow(headers)
            writer.writerows(rows)
            
        print(f"[+] Export process complete! Total rows parsed: {len(rows)}")
        conn.close()
        
    except Exception as e:
        print(f"[-] Failed exporting relational table rows: {e}")

if __name__ == "__main__":
    export_ledger_to_csv()
