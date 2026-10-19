#!/usr/bin/env python3
# ==============================================================================
# Script Name: bunq_provision.py
# Description: Programmatically requests an official sandbox user account and 
#              API key from bunq's public sandbox allocation engine.
# ==============================================================================

import os
import json
import requests

CONFIG_PATH = "MOSFETQexchange/output/bunq_sandbox_config.json"
SANDBOX_USER_ENDPOINT = "https://bunq.com"

def provision_sandbox_environment():
    if not os.path.exists(os.path.dirname(CONFIG_PATH)):
        os.makedirs(os.path.dirname(CONFIG_PATH), exist_ok=True)

    print("[*] Contacting bunq sandbox engine to request a live test account...")
    
    try:
        # bunq permits open POST requests to this endpoint to spawn test accounts
        response = requests.post(SANDBOX_USER_ENDPOINT, headers={"Cache-Control": "no-cache"}, timeout=15)
        
        if response.status_code == 200 or response.status_code == 201:
            data = response.json()["Response"][0]["ApiKey"]
            api_key = data["api_key"]
            
            print(f"[+] Success! Allocated Sandbox API Key: {api_key[:8]}...[REDACTED]")
            
            # Update your book's master configuration file with authentic variables
            config_payload = {
                "gateway_type": "Bunq Sandbox API v1",
                "api_endpoint": "https://bunq.com",
                "api_key": api_key,
                "settlement_reference": "https://bunq.me",
                "namespace": "NN",
                "author": "Kai Olaf Ketelhut",
                "orcid": "0000-0001-6049-8873",
                "station_coordinates": "52.5200° N, 13.4050° E (Berlin)",
                "axiom_constraint": "1 + 0 = 1",
                "status": "Provisioned Sandbox Engine"
            }
            
            with open(CONFIG_PATH, "w") as f:
                json.dump(config_payload, f, indent=4)
            print(f"[+] Local configuration updated at: {CONFIG_PATH}")
            
        else:
            print(f"[-] Allocation refused by server. Status Code: {response.status_code}")
            print(response.text)
            
    except Exception as e:
        print(f"[-] Infrastructure transport breakdown: {e}")

if __name__ == "__main__":
    provision_sandbox_environment()
