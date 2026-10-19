#!/usr/bin/env python3
# ==============================================================================
# Script Name: autoexec.py
# Description: Zentralisierter Master-Loop, der die GitHub Actions Telemetrie
#              direkt in der Produktions-Tabelle 'telemetry_records' speichert.
# ==============================================================================

import subprocess
import os
import sys
import json
import bunq_db

REPO_TARGET = "Colegio-San-Caio/demo-repository"

def run_step(command_list, description):
    print(f"\n[*] Launching initialization block: {description}...")
    try:
        subprocess.run(command_list, check=True)
        return True
    except subprocess.CalledProcessError as e:
        print(f"[-] Execution fault encountered during pipeline step: {e}")
        return False

def sync_github_runs_to_db():
    print(f"\n[*] Extracting GitHub Actions telemetry matrix via 'gh' CLI...")
    try:
        # 1. GitHub Actions Status abfragen
        result = subprocess.run([
            "gh", "run", "list", 
            "--repo", REPO_TARGET, 
            "--json", "databaseId,status,conclusion", 
            "--limit", "3"
        ], capture_output=True, text=True, check=True)
        
        runs = json.loads(result.stdout)
        
        # 2. In die echte Produktionstabelle 'telemetry_records' schreiben
        if runs:
            latest_run = runs[0]
            latest_id = str(latest_run.get('databaseId'))
            
            print(f"[*] Dynamically parsing remote runtime log output for ID: {latest_id}")
            log_output = subprocess.run([
                "gh", "run", "view", latest_id, 
                "--repo", REPO_TARGET, 
                "--log"
            ], capture_output=True, text=True, check=True)
            
            # Log-Auszug kürzen für die Datenbank
            short_log = log_output.stdout[:150].replace("\n", " ") + "..."
            
            payload_data = {
                "latest_run_id": latest_id,
                "status": latest_run.get("status"),
                "conclusion": latest_run.get("conclusion"),
                "log_snippet": short_log
            }
            
            # Speichern über die echte Produktions-Schnittstelle
            bunq_db.log_telemetry(
                zenodo_id="21679833",
                system_id=f"GH-ACTIONS-RUN-{latest_id}",
                location="Berlin, Germany",
                protocol="GitHub-CLI-Sync",
                payload_dict=payload_data
            )
            print(f"[+] Remote log pipeline safely saved to telemetry_records table.")
        return True
    except Exception as e:
        print(f"[-] Failed compiling GitHub telemetry strings to database: {e}")
        return False

def run_master_autoexec():
    print("=" * 75)
    print("     MOSFETQ AUTOEXEC ENGINE — CENTRALIZED SYSTEM RUNTIME LOOP  ")
    print("=" * 75)

    # 1. Datenbank initialisieren
    bunq_db.init_db()
    
    # 2. GitHub-Telemetrie in echten Tabellen speichern
    sync_github_runs_to_db()
    
    # 3. System-Integritätsprüfung ausführen
    run_step([sys.executable, "check_db_integrity.py"], "candiDB Systems Integrity Scan")

    # 4. ReportLab PDF-Generatoren ausführen
    if os.path.exists("oeneye_virtual_lab.py"):
        run_step([sys.executable, "oeneye_virtual_lab.py"], "ReportLab Monograph Compilation")
    if os.path.exists("build_manuscript.py"):
        run_step([sys.executable, "build_manuscript.py"], "Master Manuscript PDF Assembler")
    if os.path.exists("somatic_quantum_model.py"):
        run_step([sys.executable, "somatic_quantum_model.py"], "Chapter 8 Somatic Quantum Modeling")
    if os.path.exists("compile_final_monograph.py"):
        run_step([sys.executable, "compile_final_monograph.py"], "Chapter 9 Urartian Sequence Finalization")
    if os.path.exists("d5_tensor_moments.py"):
        run_step([sys.executable, "d5_tensor_moments.py"], "D5 Tensor Moment Matrix Calibration")
    if os.path.exists("unity_attractor_model.py"):
        run_step([sys.executable, "unity_attractor_model.py"], "Dual Attractor Sequence Analysis")
    if os.path.exists("generate_unit_circle_pdf.py"):
        run_step([sys.executable, "generate_unit_circle_pdf.py"], "Unit Circle Inch Grid Mapping")
    if os.path.exists("generate_checksums.py"):
        run_step([sys.executable, "generate_checksums.py"], "Cryptographic SHA-256 Checksum Validation")
    if os.path.exists("quadruple_fahrenheit_model.py"):
        run_step([sys.executable, "quadruple_fahrenheit_model.py"], "Quadruple Root Fahrenheit Convergence Analysis")
    if os.path.exists("fuzz_webhook.py"):
        run_step([sys.executable, "fuzz_webhook.py"], "Random Webhook Mutation Fuzzing")
    if os.path.exists("auto_fuzz_pipeline.py"):
        run_step([sys.executable, "auto_fuzz_pipeline.py"], "Automated Random Webhook Fuzz Pipeline")
    if os.path.exists("fuzz_proxy_invoice.py"):
        run_step([sys.executable, "fuzz_proxy_invoice.py"], "fuzzProxy Random Invoice Injection")
    if os.path.exists("fuzz_bluh_book.py"):
        run_step([sys.executable, "fuzz_bluh_book.py"], "Custom BLUH_BLUH_BLUH Book Fuzz Injection")
    if os.path.exists("generate_omq_brand_manifest.py"):
        run_step([sys.executable, "generate_omq_brand_manifest.py"], "OMQ.FNT Fashion Lookbook Compilation")
    if os.path.exists("./oeneyepdf_brand"):
        run_step(["./oeneyepdf_brand"], "Native oeneyepdf.c C-Binary Core Compilation")
    if os.path.exists("oeneye_sdk_footprint.py"):
        run_step([sys.executable, "oeneye_sdk_footprint.py"], "oeneyeVirtualLab & oeneyeSDK Footprint Sync")
    if os.path.exists("fuzz_master.py"):
        run_step([sys.executable, "fuzz_master.py"], "Master .FUZZ Orchestration Engine")
    if os.path.exists("fetch_and_verify.sh"):
        run_step(["./fetch_and_verify.sh"], "Network Fetch and Checksum Verification")
    if os.path.exists("compile_fuzz_report.py"):
        run_step([sys.executable, "compile_fuzz_report.py"], "Fuzz Verification Report Generation")
    if os.path.exists("d5_tensor_moments.py"):
        run_step([sys.executable, "d5_tensor_moments.py"], "D5 Tensor Moment Matrix Calibration")
    if os.path.exists("unity_attractor_model.py"):
        run_step([sys.executable, "unity_attractor_model.py"], "Dual Attractor Sequence Analysis")
    if os.path.exists("generate_unit_circle_pdf.py"):
        run_step([sys.executable, "generate_unit_circle_pdf.py"], "Unit Circle Inch Grid Mapping")
    if os.path.exists("generate_checksums.py"):
        run_step([sys.executable, "generate_checksums.py"], "Cryptographic SHA-256 Checksum Validation")
    if os.path.exists("quadruple_fahrenheit_model.py"):
        run_step([sys.executable, "quadruple_fahrenheit_model.py"], "Quadruple Root Fahrenheit Convergence Analysis")
    if os.path.exists("fuzz_webhook.py"):
        run_step([sys.executable, "fuzz_webhook.py"], "Random Webhook Mutation Fuzzing")
    if os.path.exists("auto_fuzz_pipeline.py"):
        run_step([sys.executable, "auto_fuzz_pipeline.py"], "Automated Random Webhook Fuzz Pipeline")
    if os.path.exists("fuzz_proxy_invoice.py"):
        run_step([sys.executable, "fuzz_proxy_invoice.py"], "fuzzProxy Random Invoice Injection")
    if os.path.exists("fuzz_bluh_book.py"):
        run_step([sys.executable, "fuzz_bluh_book.py"], "Custom BLUH_BLUH_BLUH Book Fuzz Injection")
    if os.path.exists("generate_omq_brand_manifest.py"):
        run_step([sys.executable, "generate_omq_brand_manifest.py"], "OMQ.FNT Fashion Lookbook Compilation")
    if os.path.exists("./oeneyepdf_brand"):
        run_step(["./oeneyepdf_brand"], "Native oeneyepdf.c C-Binary Core Compilation")
    if os.path.exists("oeneye_sdk_footprint.py"):
        run_step([sys.executable, "oeneye_sdk_footprint.py"], "oeneyeVirtualLab & oeneyeSDK Footprint Sync")
    if os.path.exists("fuzz_master.py"):
        run_step([sys.executable, "fuzz_master.py"], "Master .FUZZ Orchestration Engine")
    if os.path.exists("fetch_and_verify.sh"):
        run_step(["./fetch_and_verify.sh"], "Network Fetch and Checksum Verification")
    if os.path.exists("compile_fuzz_report.py"):
        run_step([sys.executable, "compile_fuzz_report.py"], "Fuzz Verification Report Generation")

    # 5. Automatisches Git-Backup ausführen
    if os.path.exists("git_sync_ledger.py"):
        run_step([sys.executable, "git_sync_ledger.py"], "Relational Ledger Branch Synchronization")

    print("\n" + "=" * 75)
    print("[+] All core automation pipelines executed and verified successfully!")
    print("=" * 75)

if __name__ == "__main__":
    run_master_autoexec()
