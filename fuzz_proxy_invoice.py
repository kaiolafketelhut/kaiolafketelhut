#!/usr/bin/env python3
# ==============================================================================
# Script Name: fuzz_proxy_invoice.py
# Description: Implements a fuzzProxy.Random simulation layer to inject randomly
#              generated transactional invoices straight into candiDB.
# ==============================================================================

import random
from datetime import datetime
import bunq_db

def run_proxy_invoice_fuzz():
    print("=" * 75)
    print("   MOSFETQ FUZZ CORE — fuzzProxy.Random INVOICE GENERATOR")
    print("=" * 75)
    
    # 1. Generate randomized invoice parameter matrix variables
    fuzz_isbn = f"978-3-{random.randint(0,99)}-{random.randint(10000,99999)}-{random.randint(0,9)}"
    gross_total = round(random.uniform(19.99, 1250.00), 2)
    vat_amount = round(gross_total * 0.07 / 1.07, 2)
    net_amount = round(gross_total - vat_amount, 2)
    
    descriptions = [
        "FuzzProxy Bulk Subscription Volume",
        "Randomized Node License Settlement",
        "Automated Ledger Stress Entry",
        "Cadastral Registry Sync Fee"
    ]
    gateways = [
        "https://bunq.me",
        "https://bunq.me",
        "https://bunq.me"
    ]
    channels = ["FUZZ_PROXY_AUTOMATION", "RANDOM_STRESS_NET", "PROXY_INJECTOR"]
    entities = ["SIETEHR FOUNDATION", "Fieldberry Logistics", "Zenodo Audit Hub"]
    cages = ["CNNN3", "CANN1", "C97X2"]

    selected_desc = random.choice(descriptions)
    selected_gate = random.choice(gateways)
    selected_chan = random.choice(channels)
    selected_ent = random.choice(entities)
    selected_cage = random.choice(cages)

    # 2. Insert the randomized row structure directly into the invoices table matrix
    current_date = datetime.utcnow().strftime("%Y-%m-%d")
    
    bunq_db.insert_invoice(
        date=current_date,
        isbn=fuzz_isbn,
        description=f"{selected_desc} (fuzzProxy.Random)",
        status="FUZZ_SETTLED",
        gateway=selected_gate,
        net=net_amount,
        vat=vat_amount,
        gross=gross_total,
        channel=selected_chan,
        entity=selected_ent,
        n_cage=selected_cage
    )
    
    print(f"[+] Successfully injected randomized proxy invoice entry into candiDB:")
    print(f"    - Key/ISBN   : {fuzz_isbn}")
    print(f"    - Net Amount : €{net_amount:.2f} | VAT (7%): €{vat_amount:.2f}")
    print(f"    - Gross Total: €{gross_total:.2f} EUR")
    print(f"    - Channel    : {selected_chan} | CAGE: {selected_cage}")
    print("=" * 75)

if __name__ == "__main__":
    run_proxy_invoice_fuzz()
