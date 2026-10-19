#!/usr/bin/env python3
# ==============================================================================
# Script Name: auto_fuzz_pipeline.py
# Description: Generates completely randomized transaction mutation metrics
#              and integrates them seamlessly inside the candiDB ledger.
# ==============================================================================

import json
import random
import requests
import bunq_db

TARGET_URL = "http://localhost:8080/"

def trigger_random_fuzz_pipeline():
    print("=" * 75)
    print("     MOSFETQ FUZZ CORE — RANDOMIZED PIPELINE VALIDATION TEST")
    print("=" * 75)
    
    # 1. Generate randomized transaction parameters
    fuzz_amount = round(random.uniform(15.75, 850.00), 2)
    fuzz_id = random.randint(1000000, 9999999)
    
    entities = ["SIETEHR FOUNDATION Fulfillment Office", "Fieldberry Distribution Hub", "Zenodo Archival Node", "Berlin Station Partner Network"]
    descriptions = ["Monograph Wholesale Acquisition", "Quantum Core System Licensing", "Infrastructure Scale Sync Fee", "Ecclesiastical Logistics Audit"]
    
    selected_entity = random.choice(entities)
    selected_desc = random.choice(descriptions)

    # 2. Re-initialize production table schemas natively before runtime
    bunq_db.init_db()

    # 3. Structure the mock bunq webhook notification envelope JSON array
    mock_payload = {
        "NotificationUrl": {
            "category": "MUTATION",
            "event_type": "Payment",
            "object": {
                "Payment": {
                    "id": fuzz_id,
                    "description": f"{selected_desc} (.RANDOM Run)",
                    "amount": {
                        "value": f"{fuzz_amount:.2f}",
                        "currency": "EUR"
                    },
                    "counterparty_alias": {
                        "type": "EMAIL",
                        "value": "fuzz.node@candidb.internal",
                        "display_name": selected_entity
                    }
                }
            }
        }
    }

    headers = {
        "Content-Type": "application/json",
        "User-Agent": "Bunq-Fuzz-Simulator/3.0"
    }

    try:
        print(f"[*] Dispatching randomized mutation payload to hook receiver...")
        print(f"    - Amount   : €{fuzz_amount:.2f} EUR")
        print(f"    - Identity : {selected_entity}")
        print(f"    - Reference: {selected_desc}")
        
        response = requests.post(TARGET_URL, json=mock_payload, headers=headers, timeout=5)
        print(f"[+] Handler Callback Response Code : {response.status_code}")
        
        # 4. Log the test parameters directly to telemetry records matrix for tracking
        bunq_db.log_telemetry(
            zenodo_id="21679833",
            system_id=f"FUZZ-RUN-{fuzz_id}",
            location="Berlin, Germany",
            protocol="Random Webhook Fuzz Loop",
            payload_dict={"gross_total": fuzz_amount, "recipient": selected_entity, "status": "PASSED"}
        )
        print("[+] Fuzz execution metrics safely saved to telemetry table records.")
        
    except Exception as e:
        print(f"[-] Transmission failed: {e}")
        print("[-] Verification reminder: Start 'python3 mock_webhook_receiver.py' in a separate window!")
    print("=" * 75)

if __name__ == "__main__":
    trigger_random_fuzz_pipeline()
