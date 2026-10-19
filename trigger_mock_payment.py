#!/usr/bin/env python3
# ==============================================================================
# Script Name: trigger_mock_payment.py
# Description: Simulates an inbound bunq mutation callback by transmitting a
#              calibrated JSON data payload to the local webhook receiver.
# ==============================================================================

import json
import requests

TARGET_URL = "http://localhost:8080/"

def fire_simulated_payment():
    print(f"[*] Preparing simulated transaction callback envelope...")
    
    # Structural mock matching a standard bunq transaction broadcast
    mock_payload = {
        "NotificationUrl": {
            "category": "MUTATION",
            "event_type": "Payment",
            "object": {
                "Payment": {
                    "id": 9984312,
                    "description": "Monograph Fulfillment Order - Vol 1 Core",
                    "amount": {
                        "value": "22.47",
                        "currency": "EUR"
                    },
                    "counterparty_alias": {
                        "type": "EMAIL",
                        "value": "institutional.buyer@domain.eu",
                        "display_name": "SIETEHR FOUNDATION (Fulfillment Office)"
                    }
                }
            }
        }
    }
    
    headers = {
        "Content-Type": "application/json",
        "User-Agent": "Bunq-Webhook-Simulator/1.0"
    }
    
    try:
        print(f"[*] Dispatched test payload to hook receiver: {TARGET_URL}")
        response = requests.post(TARGET_URL, json=mock_payload, headers=headers, timeout=5)
        print(f"[+] Receiver Feedback Code: {response.status_code}")
        print(f"[+] Response JSON Content: {response.text}")
    except Exception as e:
        print(f"[-] Transmission failed: {e}")
        print("[-] Ensure mock_webhook_receiver.py is running in another terminal window!")

if __name__ == "__main__":
    fire_simulated_payment()
