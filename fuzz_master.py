#!/usr/bin/env python3
# ==============================================================================
# Script Name: fuzz_master.py
# Description: Central control matrix executing all custom network, proxy, 
#              and .FUZZ channel validation modules in a single automated step.
# ==============================================================================

import subprocess
import os
import sys

def fire_fuzz_node(command_list, description):
    print(f"\n[*] Triggering Fuzz Stream: {description}...")
    try:
        subprocess.run(command_list, check=True)
        return True
    except subprocess.CalledProcessError as e:
        print(f"[-] Fuzz injection anomaly caught on node: {e}")
        return False

def run_global_fuzz_suite():
    print("=" * 75)
    print("     MOSFETQ MASTER .FUZZ CONTAINER — UNIFIED TESTING SUITE     ")
    print("=" * 75)

    # 1. Fire Inbound Network Callback Fuzz Simulation
    if os.path.exists("fuzz_webhook.py"):
        fire_fuzz_node([sys.executable, "fuzz_webhook.py"], "Network Webhook Mutation")

    # 2. Fire Automated Pipeline Array Fuzzer
    if os.path.exists("auto_fuzz_pipeline.py"):
        fire_fuzz_node([sys.executable, "auto_fuzz_pipeline.py"], "Automated Random Fuzz Pipeline")

    # 3. Fire Proxy Layer Invoice Injector
    if os.path.exists("fuzz_proxy_invoice.py"):
        fire_fuzz_node([sys.executable, "fuzz_proxy_invoice.py"], "fuzzProxy.Random Core Injection")

    # 4. Fire Specialized Book Channel Injector (.FUZZ)
    if os.path.exists("fuzz_bluh_book.py"):
        fire_fuzz_node([sys.executable, "fuzz_bluh_book.py"], "Custom BLUH_BLUH_BLUH Channel")

    print("\n" + "=" * 75)
    print("[+] All randomized testing vectors completed and saved into candiDB tables!")
    print("=" * 75)

if __name__ == "__main__":
    run_global_fuzz_suite()
