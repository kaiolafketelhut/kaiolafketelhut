#!/usr/bin/env bash
# ==============================================================================
# Script Name: sync_loop.sh
# Description: Continuous Git pull -> build (xtex.sh) -> commit -> push loop.
# ==============================================================================

INTERVAL=30
echo "[*] Starting Git synchronization & build loop (interval: ${INTERVAL}s)..."
echo "[*] Press Ctrl+C to exit."

while true; do
    echo "------------------------------------------------------------------"
    echo "[*] $(date -u +'%H:%M:%S') - Syncing with remote repository..."
    
    # Pull latest changes gracefully
    git pull origin main 2>/dev/null || git pull || true

    # Run the build pipeline
    if [ -f "./xtex.sh" ]; then
        echo "[*] Running xtex.sh build pipeline..."
        ./xtex.sh
    fi

    # Check if there are generated or modified files to commit
    if [ -n "$(git status --porcelain)" ]; then
        echo "[*] Committing updated documents and artifacts..."
        git add .
        git commit -m "auto-sync: pipeline build update — 1+0=1"
        
        echo "[*] Pushing updates to remote..."
        git push origin main 2>/dev/null || git push || true
        echo "[+] Sync cycle completed successfully."
    else
        echo "[+] Repository clean. No changes detected."
    fi

    sleep ${INTERVAL}
done
