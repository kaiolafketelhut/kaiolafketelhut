#!/usr/bin/env python3
# ==============================================================================
# Script Name: fuzz_webhook.py
# Description: Generates random payment transactions and dispatches them
#              to the local webhook receiver on port 8080 for stress testing.
# ==============================================================================

import json
import random
import requests

TARGET_URL = "http://localhost:8080/"

def trigger_random_fuzzing():
    print("=" * 75)
    print("     MOSFETQ FUZZ-TESTER — GENERATING RANDOM TRANSACTION MUTATION")
    print("=" * 75)
    
    # 1. Zufällige Parameter generieren
    random_amount = round(random.uniform(5.00, 450.00), 2)
    random_id = random.randint(1000000, 9999999)
    
    names = ["SIETEHR FOUNDATION Office", "Fieldberry Distribution", "Zenodo Archivist Node", "Berlin Station Partner"]
    descriptions = ["Monograph Bulk Order", "Quantum Core Licensing", "Infrastructure Sync Fee", "Ecclesiastical Logistics"]
    
    selected_name = random.choice(names)
    selected_desc = random.choice(descriptions)

    # 2. JSON-Payload-Matrix strukturieren
    mock_payload = {
        "NotificationUrl": {
            "category": "MUTATION",
            "event_type": "Payment",
            "object": {
                "Payment": {
                    "id": random_id,
                    "description": f"{selected_desc} (Fuzz Run)",
                    "amount": {
                        "value": f"{random_amount:.2f}",
                        "currency": "EUR"
                    },
                    "counterparty_alias": {
                        "type": "EMAIL",
                        "value": "fuzz.node@candidb.internal",
                        "display_name": selected_name
                    }
                }
            }
        }
    }

    headers = {
        "Content-Type": "application/json",
        "User-Agent": "Bunq-Fuzz-Simulator/2.0"
    }

    try:
        print(f"[*] Dispatching fuzz transaction to: {TARGET_URL}")
        print(f"    - Mock-ID  : {random_id}")
        print(f"    - Amount   : €{random_amount:.2f} EUR")
        print(f"    - Entity   : {selected_name}")
        
        response = requests.post(TARGET_URL, json=mock_payload, headers=headers, timeout=5)
        print(f"[+] Handler Status Code : {response.status_code}")
        print(f"[+] Server Response     : {response.text}")
        
    except Exception as e:
        print(f"[-] Transmission failed: {e}")
        print("[-] Verification reminder: Start 'python3 mock_webhook_receiver.py' in a separate window!")
    print("=" * 75)

if __name__ == "__main__":
    trigger_random_fuzzing()
