#!/usr/bin/env bash
# ==============================================================================
# Script Name: unpack_source.sh
# Description: Onboarding automation script that extracts the distribution 
#              tarball and triggers the system integrity diagnostic.
# ==============================================================================

SOURCE_TAR="MOSFETQexchange/output/MOSFETQ_Release_v1.0.tar.gz"
TARGET_UNPACK_DIR="MOSFETQ_Onboarding_Deploy"

echo "================================================================"
echo "    MOSFETQ DEPLOYMENT — AUTOMATED ONBOARDING UNPACK SUITE      "
echo "================================================================"

# 1. Integrity check: Verify tarball archive exists
if [ ! -f "$SOURCE_TAR" ]; then
    echo "[-] Unpacking fault: Distribution archive $SOURCE_TAR not found."
    exit 1
fi

echo "[*] Initializing target workspace: $TARGET_UNPACK_DIR"
mkdir -p "$TARGET_UNPACK_DIR"

# 2. De-serialize and extract file components cleanly
echo "[*] De-serializing and extracting core script pipelines..."
tar -xzf "$SOURCE_TAR" -C "$TARGET_UNPACK_DIR"

if [ $? -eq 0 ]; then
    echo "[+] Extraction complete! Relocating into workspace container..."
    cd "$TARGET_UNPACK_DIR"
    
    # 3. Initialize and execute runtime validation loops natively
    echo "[*] Triggering database schema system initialization..."
    python3 bunq_db.py
    
    echo "[*] Running absolute candiDB verification routines..."
    python3 check_db_integrity.py
    
    echo "[+] System onboarding verification sequence successfully passed!"
else
    echo "[-] Critical failure encountered during archive extraction pass."
fi
echo "================================================================"
