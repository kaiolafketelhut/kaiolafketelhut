#!/usr/bin/env python3
# ==============================================================================
# Script Name: bunq_installation_db.py
# Description: Queries the local relational SQLite database for parameters,
#              then signs and executes the public key installation handshake.
# ==============================================================================

import os
import json
import requests
import bunq_db

PUBLIC_KEY_PATH = "bunq_public.pem"

def execute_db_handshake():
    # 1. Structural requirements check
    if not os.path.exists(PUBLIC_KEY_PATH):
        print(f"[-] Infrastructure key failure: Missing {PUBLIC_KEY_PATH}")
        return

    with open(PUBLIC_KEY_PATH, "r") as k:
        public_key_pem = k.read()

    # 2. Extract configuration parameters directly via SQL query methods
    api_key_record = bunq_db.get_config("api_key")
    endpoint_record = bunq_db.get_config("api_endpoint")

    if not api_key_record or not endpoint_record:
        print("[-] Database query returned empty fields. Please execute bunq_provision_db.py first.")
        return

    api_key = api_key_record[0]
    base_url = endpoint_record[0]
    handshake_endpoint = f"{base_url}installation"

    # 3. Compile transport headers and body payload frames
    payload = {"client_public_key": public_key_pem}
    headers = {
        "Content-Type": "application/json",
        "Cache-Control": "no-cache",
        "X-Bunq-Client-Authentication": api_key
    }

    print(f"[*] Extracting DB Context... Handshaking with server: {handshake_endpoint}")

    try:
        response = requests.post(handshake_endpoint, json=payload, headers=headers, timeout=15)
        print(f"[+] Server Handshake Code: {response.status_code}")

        if response.status_code in:
            print("[+] Public key context mapped successfully inside the database framework!")
            
            # Log the successful handshake transaction step to your relational state ledger
            bunq_db.log_event("HANDSHAKE_SUCCESS", f"Handshake complete. HTTP {response.status_code}")
            print(json.dumps(response.json(), indent=2))
        else:
            print("[-] Handshake refused by sandbox server.")
            bunq_db.log_event("HANDSHAKE_REFUSED", f"Server responded with status code {response.status_code}")
            print(response.text)

    except Exception as e:
        print(f"[-] Connection layer failure: {e}")
        bunq_db.log_event("TRANSPORT_ERROR", str(e))

if __name__ == "__main__":
    execute_db_handshake()
