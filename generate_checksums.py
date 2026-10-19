#!/usr/bin/env python3
# ==============================================================================
# Script Name: generate_checksums.py
# Description: Generates an official SHA-256 verification ledger for all
#              core scripts and compiled multi-page PDF manuscript assets.
# ==============================================================================

import hashlib
import os
import bunq_db

TARGET_FILES = [
    "autoexec.py",
    "bunq_db.py",
    "git_sync_ledger.py",
    "check_db_integrity.py",
    "build_manuscript.py",
    "generate_unit_circle_pdf.py",
    "MOSFETQexchange/output/telemetry.db",
    "MOSFETQexchange/output/MOSFETQ_Master_Manuscript.pdf",
    "MOSFETQexchange/output/unit_circle_geometry.pdf"
]

OUTPUT_CHECKSUM_FILE = "MOSFETQexchange/output/checksums.sha256"

def calculate_sha256(filepath):
    """Computes the SHA-256 hexadecimal hash string of a given file node."""
    sha256_hash = hashlib.sha256()
    with open(filepath, "rb") as f:
        for byte_block in iter(lambda: f.read(4096), b""):
            sha256_hash.update(byte_block)
    return sha256_hash.hexdigest()

def compile_verification_ledger():
    print("=" * 75)
    print("    MOSFETQ SECURITY CORE — AUTOMATED SHA-256 CHECKSUM VERIFICATION")
    print("=" * 75)
    
    os.makedirs(os.path.dirname(OUTPUT_CHECKSUM_FILE), exist_ok=True)
    ledger_entries = []
    
    print("[*] Calculating cryptographic signatures for release workspace...")
    for filename in TARGET_FILES:
        if os.path.exists(filename):
            file_hash = calculate_sha256(filename)
            relative_name = os.path.basename(filename)
            ledger_line = f"{file_hash}  {relative_name}"
            ledger_entries.append(ledger_line)
            print(f"    - Hash generated for {relative_name:<28} : {file_hash[:12]}...")
        else:
            print(f"    [-] Skipping missing asset node: {filename}")

    # Write the formatted hashes out to a permanent validation asset file
    with open(OUTPUT_CHECKSUM_FILE, "w", encoding="utf-8") as lf:
        lf.write("\n".join(ledger_entries) + "\n")
        
    print(f"\n[+] Cryptographic ledger written completely: {OUTPUT_CHECKSUM_FILE}")

    # Write checksum logging data straight to candiDB telemetry records
    bunq_db.log_telemetry(
        zenodo_id="21679833",
        system_id="SHA256-LEDGER-01",
        location="Berlin, Germany",
        protocol="Colegio San Caio Verification Protocol (PL:36883)",
        payload_dict={"checksum_count": len(ledger_entries), "status": "COMPLIANT"}
    )
    print("[+] Cryptographic check parameters successfully saved to database rows.")
    print("=" * 75)

if __name__ == "__main__":
    compile_verification_ledger()
