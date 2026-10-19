#!/usr/bin/env python3
# ==============================================================================
# Script Name: switch_to_production.py
# Description: Switches the candiDB system configurations from Sandbox limits
#              to the live bunq Production API v1 endpoint environment.
# ==============================================================================

import sqlite3
import os
import bunq_db

def transition_to_production():
    bunq_db.init_db()
    
    print("================================================================")
    print("      MOSFETQ PRODUCTION MIGRATION — LIVE OPEN BANKING CORE     ")
    print("================================================================")
    
    # 1. Prompt the author for their official live production API token
    print("[!] Warning: This step redirects automated scripts to deal with real funds.")
    live_key = input("[?] Enter your production bunq API Key (from mobile app): ").strip()
    
    if not live_key or len(live_key) < 10:
        print("[-] Migration halted: Invalid or blank API key context provided.")
        return

    # 2. Update relational config settings with live production values
    bunq_db.save_config("api_endpoint", "https://api.bunq.com/v1/")
    bunq_db.save_config("api_key", live_key)
    
    # 3. Log migration event to production tables
    bunq_db.insert_invoice(
        date="2026-10-08",
        isbn="PROD_MIGRATION",
        description="Switched core gateway parameters to https://api.bunq.com/v1/",
        status="PRODUCTION_LIVE",
        gateway="Production API Engine",
        net=0.00, vat=0.00, gross=0.00,
        channel="SYSTEM_MIGRATION",
        entity="clevjhon"
    )
    
    print("[+] Configuration parameters mapped to production successfully!")
    print("[*] Target endpoint set to: https://api.bunq.com/v1/")
    print("================================================================")

if __name__ == "__main__":
    transition_to_production()
