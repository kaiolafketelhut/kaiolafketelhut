#!/usr/bin/env bash
# ==============================================================================
# Script Name: view_loop.sh
# Description: Continuous monitor and view loop for generated MOSFETQexchange PDFs.
# ==============================================================================

OUTPUT_DIR="./MOSFETQexchange/output"
echo "[*] Starting PDF view loop. Press Ctrl+C to exit."

while true; do
    if [ -d "$OUTPUT_DIR" ]; then
        for PDF in "$OUTPUT_DIR"/*.pdf; do
            [ -f "$PDF" ] || continue
            if command -v termux-open &> /dev/null; then
                termux-open "$PDF"
                echo "[+] Opened via termux-open: $PDF"
            elif command -v oeneyeViewer &> /dev/null; then
                oeneyeViewer "$PDF" &
                echo "[+] Opened via oeneyeViewer: $PDF"
            fi
            break
        done
    fi
    sleep 5
done
