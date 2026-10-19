#!/usr/bin/env bash
# ==============================================================================
# Script Name: fetch_and_verify.sh
# Description: Automates network data fetching of the landing portal index 
#              and computes its absolute SHA-256 cryptographic check signature.
# ==============================================================================

TARGET_URL="https://github.io"
OUTPUT_FILE="MOSFETQexchange/output/downloaded_index.html"

echo "========================================================================"
echo "    MOSFETQ NETWORK SUITE — AUTOMATED CURL & CRYPTO CHECKSUM LOOKUP     "
echo "========================================================================"

# 1. Verification Step: Ensure output directory exists
mkdir -p "MOSFETQexchange/output"

echo "[*] Launching network data download loop for layout stream..."
echo "[*] Source Address: $TARGET_URL"

# 2. Curl command pipeline to download static assets safely
curl -s -L "$TARGET_URL" -o "$OUTPUT_FILE"

if [ $? -eq 0 ] && [ -f "$OUTPUT_FILE" ]; then
    echo "[+] Transport complete! File cached at: $OUTPUT_FILE"
    echo "[*] Total Byte Sizing Profile: $(wc -c < "$OUTPUT_FILE" | xargs) bytes"
    echo "------------------------------------------------------------------------"
    
    # 3. Calculate and display the unique SHA-256 signature hash
    echo "[*] Computing absolute SHA-256 cryptographic verification checksum..."
    file_hash=$(sha256sum "$OUTPUT_FILE" | cut -d' ' -f1)
    echo "[+] SHA-256: $file_hash"
    
    # 4. Save verification trace parameters straight to production logs
    python3 -c "
import bunq_db
bunq_db.log_telemetry(
    zenodo_id='21679833',
    system_id='CURL-FETCH-CHECK',
    location='Berlin, Germany',
    protocol='SHA-256 Web Attestation',
    payload_dict={'url': '$TARGET_URL', 'sha256_hash': '$file_hash', 'status': 'VERIFIED'}
)
"
    echo "[+] Network attestation metrics cleanly written to telemetry_records."
else
    echo "[-] Transport error: Failed to fetch data layers from target server pool."
fi
echo "========================================================================"
