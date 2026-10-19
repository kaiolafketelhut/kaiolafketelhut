#!/usr/bin/env python3
# ==============================================================================
# Script Name: fuzz_bluh_book.py
# Description: Implements a custom .FUZZ injector that targets your primary book 
#              ISBN and logs records under the BLUH_BLUH_BLUH channel matrix.
# ==============================================================================

import random
from datetime import datetime
import bunq_db

def run_book_fuzz_injection():
    print("=" * 75)
    print("   MOSFETQ .FUZZ LAYER — CUSTOM BLUH_BLUH_BLUH INJECTOR")
    print("=" * 75)
    
    # 1. Base Parameters Aligned with Your Book Invariants
    master_isbn = "978-3-00-068463-0"
    
    # Generate randomized transaction amounts for testing
    gross_total = round(random.uniform(22.00, 150.00), 2)
    vat_amount = round(gross_total * 0.07 / 1.07, 2)
    net_amount = round(gross_total - vat_amount, 2)
    
    current_date = datetime.utcnow().strftime("%Y-%m-%d")
    custom_channel = "BLUH_BLUH_BLUH"

    print(f"[*] Compiling Random .FUZZ Parameters for ISBN: {master_isbn}...")
    print(f"    - Target Channel : {custom_channel}")
    print(f"    - Gross Total    : €{gross_total:.2f} EUR")

    # 2. Insert directly into the production invoices schema matrix
    bunq_db.insert_invoice(
        date=current_date,
        isbn=master_isbn,
        description="Fuzz Injection: Reference Publication (Sachbuch & Wissen)",
        status="FUZZ_BLUH_SETTLED",
        gateway="https://bunq.me",
        net=net_amount,
        vat=vat_amount,
        gross=gross_total,
        channel=custom_channel,
        entity="SIETEHR FOUNDATION",
        n_cage="CNNN3"
    )
    
    print(f"[+] Successfully injected {custom_channel} book ledger into candiDB!")
    print("=" * 75)

if __name__ == "__main__":
    run_book_fuzz_injection()
