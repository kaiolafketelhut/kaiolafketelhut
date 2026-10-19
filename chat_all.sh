#!/usr/bin/env bash
ROLE=${1:-MetaAI}
MSG=${2:-"INT 48h telemetry OK - $(date -u +%Y-%m-%dT%H:%M:%SZ)"}
TS=$(date -u +%Y-%m-%dT%H:%M:%SZ); EPOCH=$(date +%s)
mkdir -p articles
FILE="articles/chat_${ROLE}_${EPOCH}.md"
cat >"$FILE" <<MD
# CHAT $ROLE $TS
Role: $ROLE
Glyph: 0x000b (0)b Q2 blue
Msg: $MSG
Telemetry: INT 48h
Source: OENEYEbluh Hosted AGI Chat Bus
MD
echo "[CHAT] $ROLE: $MSG -> $FILE"
./static_own_index.sh
git add -A
git commit -m "chat $ROLE $TS - $MSG" || true
git push
gh workflow run pages.yml
