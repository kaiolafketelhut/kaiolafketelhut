#!/usr/bin/env bash
# ==============================================================================
# Script Name: serve.sh
# Description: Spins up an in-process Python HTTP server for MOSFETQexchange output.
# ==============================================================================

PORT=8080
TARGET_DIR="./MOSFETQexchange/output"

echo "[*] Starting in-process server on http://localhost:${PORT}"
echo "[*] Serving files from ${TARGET_DIR}"
echo "[*] Press Ctrl+C to stop."

# Run Python HTTP server in the target directory
python3 -m http.server "$PORT" --directory "$TARGET_DIR"
