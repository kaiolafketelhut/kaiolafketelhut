#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
URL="https://colegio-san-caio.github.io/demo-repository/index.html"
FILE="/sdcard/Download/index.html"

echo "Calculating hashes..."
LOCAL=$(sha256sum "$FILE" | awk '{print $1}')
REMOTE=$(curl -sL --fail "${URL}?ts=$(date +%s)" | sha256sum | awk '{print $1}')

echo "Local : $LOCAL"
echo "Remote: $REMOTE"
echo

if [[ "$LOCAL" == "$REMOTE" ]]; then
  echo "✓ DEPLOYMENT VERIFIED"
else
  echo "x HASH MISMATCH - live site different from local"
fi
