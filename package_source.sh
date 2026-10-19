#!/usr/bin/env bash
# ==============================================================================
# Script Name: package_source.sh
# Description: Compresses core script pipelines and document assets into a
#              standardized distribution archive layout.
# ==============================================================================

RELEASE_DIR="MOSFETQexchange/output"
ARCHIVE_NAME="MOSFETQ_Release_v1.0.tar.gz"

print_banner() {
    echo "================================================================"
    echo "     MOSFETQ BACKUP CONSOLE — AUTOMATED ARTIFACT DISTRIBUTION    "
    echo "================================================================"
}

print_banner

# 1. Verification Step
if [ ! -d "$RELEASE_DIR" ]; then
    echo "[-] Packaging fault: Target asset directory $RELEASE_DIR not found."
    exit 1
fi

echo "[*] Serializing workspace blueprints and binary database tracking models..."

# 2. Compile compressed archive including code framework elements
tar -czf "$RELEASE_DIR/$ARCHIVE_NAME" \
    --exclude="backups" \
    --exclude="logs" \
    bunq_db.py \
    oeneye_virtual_lab.py \
    sync_and_register.py \
    set_customer_data.py \
    export_invoices.py \
    calculate_vat.py \
    generate_report_chart.py \
    check_db_integrity.py \
    build_manuscript.py \
    verify_git_history.py \
    git_sync_ledger.py \
    MOSFETQexchange/output/telemetry.db \
    MOSFETQexchange/output/MOSFETQ_Master_Manuscript.pdf

if [ $? -eq 0 ]; then
    echo "[+] Archive assembled successfully: $RELEASE_DIR/$ARCHIVE_NAME"
    echo "[*] Distribution payload weight: $(du -sh "$RELEASE_DIR/$ARCHIVE_NAME" | cut -f1)"
else
    echo "[-] Critical error encountered during archival serialization step."
fi
echo "================================================================"
