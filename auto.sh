#!/usr/bin/env bash
set -e
mkdir -p articles
mkdir -p "./.chat"
TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
EPOCH=$(date +%s)
echo "$TS" >> "./.chat/history.log"
N=$(ls articles/ | wc -l | tr -d ' ')
F="articles/Julia_Menge_eigenOENEYE_$(printf "%03d" $((N+1)))_xTitin_${EPOCH}.md"
echo "# xTitin $TS" > "$F"
echo "[auto] created $F"
# rebuild original
./static_own_index.sh 2>/dev/null || (mkdir -p.; echo "static missing")
git add -A
git commit -m "ABCD one auto $TS" || true
git push
gh workflow run pages.yml
sleep 5
gh run list --workflow="pages.yml" -L 3
gh run view $(gh run list --workflow="pages.yml" -L 1 --json databaseId -q '.[0].databaseId') 2>&1 | tail -n 30
./static_own_index.sh
