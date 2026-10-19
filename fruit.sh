#!/usr/bin/env bash
set -e
echo "=== $(date -u +%Y-%m-%dT%H:%M:%SZ) - $(ls articles/ | wc -l) articles ==="
./static_own_index.sh 2>/dev/null || echo "static_own_index.sh missing, skipping"
./autoexec_append.sh 2>/dev/null || echo "autoexec_append.sh missing, creating one"
if [! -f autoexec_append.sh ]; then
  printf '#!/usr/bin/env bash\nmkdir -p articles\nN=$(ls articles/|wc -l)\nEPOCH=$(date +%%s)\nFILE="articles/Julia_Menge_eigenOENEYE_$(printf "%%03d" $((N+1)))_xTitin_${EPOCH}.md"\necho "# xTitin $EPOCH" > "$FILE"\necho "appended $FILE"\n' > autoexec_append.sh
  chmod +x autoexec_append.sh
 ./autoexec_append.sh
fi
git add -A
git commit -m "loop $(date -u +%Y-%m-%dT%H:%M:%SZ) - $(ls articles/ | wc -l) articles" || true
git push
# FIXED gh run view loop
gh workflow run pages.yml 2>/dev/null || true
sleep 3
ID=$(gh run list --workflow="pages.yml" -L 1 --json databaseId -q '.[0].databaseId' 2>/dev/null || echo "")
echo "Triggered run $ID - view:"
gh run view $ID 2>/dev/null || gh run list --workflow="pages.yml" -L 3
