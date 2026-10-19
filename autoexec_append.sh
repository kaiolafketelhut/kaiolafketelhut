#!/usr/bin/env bash
set -e
TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
EPOCH=$(date +%s)
mkdir -p articles
mkdir -p.chat
echo "$TS | $EPOCH" >>.chat/history.log
echo "$EPOCH" >.chat/last_chat_epoch
N=$(ls articles/ | wc -l | tr -d ' ')
FILE="articles/Julia_Menge_eigenOENEYE_$(printf "%03d" $((N+1)))_xTitin_${EPOCH}.md"
echo "# xTitin $TS" > "$FILE"
echo "auto $FILE"
./static_own_index.sh 2>/dev/null || true
