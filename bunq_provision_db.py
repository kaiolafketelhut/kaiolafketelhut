#!/usr/bin/env python3
# ==============================================================================
# Script Name: bunq_provision_db.py
# Description: Requests an official sandbox key and registers it natively 
#              inside your relational SQLite database tracking layers.
# ==============================================================================

import requests
import bunq_db

SANDBOX_USER_ENDPOINT = "https://bunq.com"

def execute_provisioning_pipeline():
    # Initialize DB structure
    bunq_db.init_db()
    
    print("[*] Dispatching request to bunq public sandbox allocation system...")
    
    headers = {
        "Cache-Control": "no-cache",
        "User-Agent": "Oeneye-Automation-Agent/1.0",
        "X-Bunq-Language": "en_US",
        "X-Bunq-Region": "de_DE",
        "X-Bunq-Geolocation": "13.4050 52.5200 0 0 DE"
    }
    
    try:
        response = requests.post(SANDBOX_USER_ENDPOINT, headers=headers, timeout=15)
        
        if response.status_code in:
            resp_data = response.json()
            api_key = resp_data["Response"][0]["ApiKey"]["api_key"]
            
            print(f"[+] Allocated API Key: {api_key[:8]}...[REDACTED]")
            
            # Save core variables straight to your database tables
            bunq_db.save_config("api_key", api_key)
            bunq_db.save_config("api_endpoint", "https://bunq.com")
            bunq_db.save_config("axiom_constraint", "1 + 0 = 1")
            
            bunq_db.log_event("PROVISIONING", "Successfully updated relational schema parameters.")
            print("[+] Database transactional state successfully synced.")
            
        else:
            print(f"[-] Infrastructure allocation refused. Code: {response.status_code}")
            bunq_db.log_event("ERROR", f"Provisioning failed with status {response.status_code}")
            
    except Exception as e:
        print(f"[-] Connection layer failure: {e}")

if __name__ == "__main__":
    execute_provisioning_pipeline()
