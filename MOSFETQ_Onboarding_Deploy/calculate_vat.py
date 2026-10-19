#!/usr/bin/env python3
# ==============================================================================
# Script Name: calculate_vat.py
# Description: Queries the active invoices table to calculate and aggregate
#              cumulative net revenues, VAT pools, and gross totals.
# ==============================================================================

import sqlite3
import os

DB_PATH = "MOSFETQexchange/output/telemetry.db"

def compute_financial_metrics():
    if not os.path.exists(DB_PATH):
        print(f"[-] Execution failure: Database file {DB_PATH} not found.")
        return

    print("=" * 65)
    print("      MOSFETQ EXCHANGE — REVENUE & TAX METRICS SUMMARY")
    print("=" * 65)

    try:
        conn = sqlite3.connect(DB_PATH)
        cursor = conn.cursor()
        
        # Aggregate the financial metrics columns using explicit SQL SUM functions
        cursor.execute("""
            SELECT 
                SUM(net_amount_eur), 
                SUM(vat_amount_eur), 
                SUM(total_amount_eur),
                COUNT(id)
            FROM invoices
        """)
        net_sum, vat_sum, gross_sum, transaction_count = cursor.fetchone()
        
        # Substitute None values with zero if the table is empty
        net_sum = net_sum if net_sum else 0.0
        vat_sum = vat_sum if vat_sum else 0.0
        gross_sum = gross_sum if gross_sum else 0.0

        print(f"[*] Total Processed Transactions : {transaction_count} ledger rows")
        print(f"[*] Cumulative Net Revenue       : €{net_sum:.2f}")
        print(f"[*] Accumulated VAT Pool (7%)    : €{vat_sum:.2f}")
        print("-" * 65)
        print(f"[+] Total Gross Settlement Pool  : €{gross_sum:.2f}")
        print("=" * 65)
        
        conn.close()
        
    except Exception as e:
        print(f"[-] Data aggregation layer exception: {e}")

if __name__ == "__main__":
    compute_financial_metrics()
