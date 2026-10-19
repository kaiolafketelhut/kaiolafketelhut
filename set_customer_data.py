#!/usr/bin/env python3
# ==============================================================================
# Script Name: set_customer_data.py
# Description: Interactive provisioning utility aligned with production
#              invoice tables, logging customized user metadata to candiDB.
# ==============================================================================

import os
from datetime import datetime
import bunq_db

def run_customer_provisioning():
    # Ensure database schemas are fully initialized
    bunq_db.init_db()
    
    print("=" * 60)
    print("  OENEYE-NN INTERACTIVE BOOK & PAYMENT LINK PROVISIONER")
    print("=" * 60)
    
    # 1. Capture production user telemetry configuration variables
    user_isbn = input("[?] Enter your publication ISBN (e.g., 978-3-00-068463-0): ").strip()
    user_pay_link = input("[?] Enter your payment link (e.g., https://bunq.me): ").strip()
    
    if not user_isbn or not user_pay_link:
        print("[-] Execution halted: Input fields cannot be left blank.")
        return

    # 2. Map directly into the official production invoices ledger schema
    current_date = datetime.utcnow().strftime("%Y-%m-%d")
    
    bunq_db.insert_invoice(
        date=current_date,
        isbn=user_isbn,
        item_description="Custom User-Provisioned Reference Monograph Asset",
        status="INTERACTIVE_SET",
        gateway=user_pay_link,
        net=21.00,
        vat=1.47,
        gross=22.47,
        channel="RETAIL_PROVISIONED",
        entity="SIETEHR FOUNDATION",
        n_cage="CNNN3"
    )
    
    print("[+] Configuration parameters successfully synced to invoices matrix.")
    print("=" * 60)

if __name__ == "__main__":
    run_customer_provisioning()
