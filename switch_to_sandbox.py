#!/usr/bin/env python3
# ==============================================================================
# Script Name: switch_to_sandbox.py
# Description: Redirects the local candiDB configurations back to bunq's
#              public sandbox simulation environment loop.
# ==============================================================================

import bunq_db

def transition_to_sandbox():
    bunq_db.init_db()
    
    print("================================================================")
    print("      MOSFETQ ENVIRONMENT ENGINE — REVERTING TO SANDBOX CORE    ")
    print("================================================================")
    
    # 1. Update config settings back to safe testing parameters
    bunq_db.save_config("api_endpoint", "https://public-api.sandbox.bunq.com/v1/")
    
    # 2. Log environment update event to your tables
    bunq_db.insert_invoice(
        date="2026-10-08",
        isbn="SANDBOX_REVERSION",
        description="Redirected core gateway back to https://public-api.sandbox.bunq.com/v1/",
        status="SANDBOX_ACTIVE",
        gateway="Sandbox API Engine",
        net=0.00, vat=0.00, gross=0.00,
        channel="SYSTEM_ENV_SHIFT",
        entity="clevjhon"
    )
    
    print("[+] Configuration parameters re-mapped to sandbox successfully!")
    print("[*] Target endpoint set to: https://public-api.sandbox.bunq.com/v1/")
    print("================================================================")

if __name__ == "__main__":
    transition_to_sandbox()
