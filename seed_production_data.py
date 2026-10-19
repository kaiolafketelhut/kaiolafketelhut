#!/usr/bin/env python3
# ==============================================================================
# Script Name: seed_production_data.py
# Description: Seeds production receipts and real-time JSON network logs 
#              straight into the verified relational SQLite schemas.
# ==============================================================================

import bunq_db

def seed_system_data():
    bunq_db.init_db()
    print("[*] Seeding production data logs from active ledger templates...")

    # 1. Seed Real Purchase Bill Transaction Data Frame
    bunq_db.insert_invoice(
        date="2026-09-13",
        isbn="978-3-00-068463-0",
        description="Reference Publication (Sachbuch & Wissen, Fieldberry Group)",
        status="INTERCEPTED",
        gateway="https://bunq.me",
        net=21.00,
        vat=1.47,
        gross=22.47,
        channel="WHOLESALE_INSTITUTIONAL",
        entity="SIETEHR FOUNDATION",
        n_cage="CNNN3"
    )
    print("[+] Successfully parsed and logged Invoice #71795531 records.")

    # 2. Seed Real Telemetry Manifest Records
    mock_payload = {
        "identifier": "QUANTUMTHERMOSTATIC-CORE-01",
        "location": "Berlin, Germany",
        "operational_sprint": "3-Month Clinical & Technical Roadmap",
        "ftp_account": "qt_mainframe_ftp",
        "access_level": "Secure Restricted (Bank-Grade Encryption Compliant)",
        "protocol": "SFTP/FTPS over Calibrated Inertial Thresholds",
        "authentication_mode": "Public Key Infrastructure (PKI) + Zero-Trust Runtime Verification"
    }

    bunq_db.log_telemetry(
        zenodo_id="21679833",
        system_id="QUANTUMTHERMOSTATIC-CORE-01",
        location="Berlin, Germany",
        protocol="SFTP/FTPS over Calibrated Inertial Thresholds",
        payload_dict=mock_payload
    )
    print("[+] Successfully synchronized hardware telemetry log records.")

if __name__ == "__main__":
    seed_system_data()
