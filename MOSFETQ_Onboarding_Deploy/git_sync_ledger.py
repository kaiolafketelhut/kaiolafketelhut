#!/usr/bin/env python3
# ==============================================================================
# Script Name: git_sync_ledger.py
# Description: Automates isolation snapshots of the relational SQLite ledger,
#              staging binary records cleanly across the Git tracking stream.
# ==============================================================================

import os
import shutil
import subprocess
from datetime import datetime
import bunq_db

DB_SOURCE = "MOSFETQexchange/output/telemetry.db"
DB_BACKUP_DIR = "MOSFETQexchange/output/backups"

def execute_secure_ledger_push():
    # 1. Initialize schema framework
    bunq_db.init_db()
    if not os.path.exists(DB_SOURCE):
        print(f"[-] Execution fault: Operational database source {DB_SOURCE} not found.")
        return

    os.makedirs(DB_BACKUP_DIR, exist_ok=True)
    timestamp_slug = datetime.utcnow().strftime("%Y%m%d_%H%M%S")
    backup_filename = f"telemetry_snapshot_{timestamp_slug}.db"
    backup_path = os.path.join(DB_BACKUP_DIR, backup_filename)

    print(f"[*] Compiling snapshot of live tracking records... [{timestamp_slug} UTC]")
    
    try:
        shutil.copy2(DB_SOURCE, backup_path)
        shutil.copy2(DB_SOURCE, os.path.join(DB_BACKUP_DIR, "telemetry_evergreen.db"))
        print(f"[+] Isolated binary snapshot saved at: {backup_path}")
        
        # Log backup event straight to production table structures instead of old mock method
        bunq_db.insert_invoice(
            date=datetime.utcnow().strftime("%Y-%m-%d"),
            isbn="SYSTEM_BACKUP",
            description=f"Snapshot compiled: {backup_filename}",
            status="AUTOMATED_SYNC",
            gateway="Git Subprocess Loop",
            net=0.00,
            vat=0.00,
            gross=0.00,
            channel="SYSTEM_LEADER",
            entity="Git Automation Node"
        )
        
    except Exception as e:
        print(f"[-] Failure isolating SQLite data state: {e}")
        return

    print("[*] Launching Git subprocess tracking loops inside Termux...")
    try:
        subprocess.run(["git", "add", "-f", DB_BACKUP_DIR], check=True)
        subprocess.run(["git", "add", "-f", "git_sync_ledger.py"], check=True)
        
        commit_message = f"sync telemetric database ledger snapshot - {timestamp_slug} UTC"
        subprocess.run(["git", "commit", "-m", commit_message], check=True)
        
        print("[*] Pushing binary state layers upstream to repository...")
        subprocess.run(["git", "push"], check=True)
        print("[+] Repository pipeline synchronized completely!")
        
    except subprocess.CalledProcessError as git_err:
        print(f"[-] Subprocess tracking loop rejected the commit tree sequence: {git_err}")

if __name__ == "__main__":
    execute_secure_ledger_push()
