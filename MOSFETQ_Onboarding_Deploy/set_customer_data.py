#!/usr/bin/env python3
# ==============================================================================
# Script Name: set_customer_data.py
# Description: Interactive provisioning utility allowing readers to register
#              their own ISBN and bunq settlement references into the DB.
# ==============================================================================

import os
import shutil
import bunq_db

TEMPLATE_PATH = "template.pdf"
OUTPUT_DIR = "MOSFETQexchange/output"

def run_customer_provisioning():
    # Ensure database tables exist
    bunq_db.init_db()
    
    print("=" * 60)
    print("  OENEYE-NN INTERACTIVE BOOK & PAYMENT LINK PROVISIONER")
    print("=" * 60)
    
    # 1. Capture user telemetry configurations
    user_isbn = input("[?] Enter your publication ISBN (e.g., 9783000684630): ").strip()
    user_pay_link = input("[?] Enter your payment link (e.g., https://bunq.me): ").strip()
    
    if not user_isbn or not user_pay_link:
        print("[-] Execution halted: Input fields cannot be left blank.")
        return

    # 2. Save variables straight to your SQL configuration tables
    bunq_db.save_config("isbn", user_isbn)
    bunq_db.save_config("settlement_reference", user_pay_link)
    bunq_db.log_event("CUSTOMER_PROVISION", f"Registered ISBN: {user_isbn} | Link: {user_pay_link}")
    
    print("[+] Configuration parameters successfully synced to relational tables.")

    # 3. Handle fulfillment document generation
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    custom_pdf_name = f"fulfillment_ISBN_{user_isbn}.pdf"
    output_pdf_path = os.path.join(OUTPUT_DIR, custom_pdf_name)

    # Check if a base template PDF exists in the working directory
    if os.path.exists(TEMPLATE_PATH):
        shutil.copy(TEMPLATE_PATH, output_pdf_path)
        print(f"[+] Custom tracking document generated: {output_pdf_path}")
    else:
        # Fallback: Create a structural tracking asset file if template.pdf is not present yet
        with open(output_pdf_path, "w") as dummy_pdf:
            dummy_pdf.write(f"%PDF-1.4 Mock Framework - ISBN: {user_isbn} | Target: {user_pay_link}\n")
        print(f"[*] Base template.pdf not found. Generated empty asset wireframe at: {output_pdf_path}")

    print("=" * 60)
    print("[+] Pipeline initialization sequence complete!")

if __name__ == "__main__":
    run_customer_provisioning()
