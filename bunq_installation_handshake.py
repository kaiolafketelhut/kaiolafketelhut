#!/usr/bin/env python3
# ==============================================================================
# Script Name: bunq_installation_handshake.py
# Description: Submits the local RSA public key to bunq's /installation 
#              endpoint to initialize a verified client tracking context.
# ==============================================================================

import os
import json
import requests

CONFIG_PATH = "MOSFETQexchange/output/bunq_sandbox_config.json"
PUBLIC_KEY_PATH = "bunq_public.pem"

def execute_installation_handshake():
    if not os.path.exists(CONFIG_PATH) or not os.path.exists(PUBLIC_KEY_PATH):
        print("[-] Missing bunq_sandbox_config.json or bunq_public.pem keyframe.")
        return

    with open(CONFIG_PATH, "r") as f:
        config = json.load(f)
    
    with open(PUBLIC_KEY_PATH, "r") as k:
        public_key_pem = k.read()

    if "api_key" not in config:
        print("[-] Run bunq_provision.py first to obtain a sandbox api_key.")
        return

    endpoint = f"{config['api_endpoint']}installation"
    
    payload = {
        "client_public_key": public_key_pem
    }

    headers = {
        "Content-Type": "application/json",
        "Cache-Control": "no-cache",
        "X-Bunq-Client-Authentication": config["api_key"]
    }

    print(f"[*] Shipping public key signature to endpoint: {endpoint}")
    
    try:
        response = requests.post(endpoint, json=payload, headers=headers, timeout=15)
        print(f"[+] Server Handshake Code: {response.status_code}")
        
        if response.status_code in:
            print("[+] Public key context mapped successfully inside the sandbox framework!")
            print(json.dumps(response.json(), indent=2))
        else:
            print("[-] Handshake refused by sandbox server.")
            print(response.text)
            
    except Exception as e:
        print(f"[-] Connection breakdown: {e}")

if __name__ == "__main__":
    execute_installation_handshake()
