#!/usr/bin/env python3
# ==============================================================================
# Script Name: sync_and_register.py
# Description: Connects to the local relational table to extract endpoints, 
#              and registers webhook targets dynamically using database contexts.
# ==============================================================================

import json
import requests
import bunq_db

WEBHOOK_TARGET = "https://github.io"

# Default sandbox mock variables
USER_ID = "0"
SESSION_TOKEN = "SANDBOX_SESSION_MOCK_TOKEN"

def run_database_sync_registration():
    # 1. Fetch values natively via relational lookup loops
    base_endpoint = bunq_db.get_config("api_endpoint")
    author_name = bunq_db.get_config("author")
    axiom_rule = bunq_db.get_config("axiom_constraint")

    # If the database tables are unprovisioned, stop execution gracefully
    if not base_endpoint:
        print("[-] Connection failed: Core table keys are blank. Initialize bunq_provision_db.py first.")
        return

    target_route = f"{base_endpoint}user/{USER_ID}/notification-filter-url"

    print(f"[*] Extracting system configuration state for: {author_name}")
    print(f"[*] Posting relational event context stream to: {target_route}")

    # 2. Compile network notification structures
    payload = {
        "notification_filters": [
            {
                "category": "MUTATION",
                "notification_target": WEBHOOK_TARGET
            }
        ]
    }

    headers = {
        "Content-Type": "application/json",
        "Cache-Control": "no-cache",
        "X-Bunq-Client-Authentication": SESSION_TOKEN
    }

    # 3. Transport layer dispatch
    try:
        response = requests.post(target_route, json=payload, headers=headers, timeout=10)
        print(f"[+] Server Response Handshake: {response.status_code}")
        
        # Log outcome directly back to transactional telemetry logs
        if response.status_code in [200, 201]:
            bunq_db.log_event("WEBHOOK_SYNC_SUCCESS", f"Mapped target stream to {WEBHOOK_TARGET}")
            print(f"[+] Route Map Verified under state constraint: {axiom_rule}")
        else:
            bunq_db.log_event("WEBHOOK_SYNC_DENIED", f"Server dropped transaction package with code {response.status_code}")
            print(f"[-] Registration response error: {response.text}")
            
    except Exception as e:
        bunq_db.log_event("WEBHOOK_TRANSPORT_FAULT", str(e))
        print(f"[-] Structural connection failure: {e}")

if __name__ == "__main__":
    run_database_sync_registration()
