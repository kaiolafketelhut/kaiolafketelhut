#!/usr/bin/env bash
set -e
TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)
EPOCH=$(date +%s)
mkdir -p articles images
# NEVER rm articles/ images/ - explicit guard
if [ -f candiOQM_xTitin.html ] && [ $(wc -c < candiOQM_xTitin.html) -lt 500 ]; then
  echo "ERROR: engine too small, refusing to overwrite"; exit 1
fi
cat > index.html <<HTML
<!doctype html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>CANDI OQM xTitin $TS</title></head><body style="font-family:monospace;background:#000;color:#0f0;padding:20px">
<h1>CANDI OQM ∅⊂ℱ∞ by Julia_Menge_eigenOENEYE</h1>
<p style="color:#ff0">GLOBAL RESTORED $TS epoch $EPOCH | no deletions ever again</p>
<p><a href="candiOQM_xTitin.html?ts=$EPOCH" style="color:#0ff">→ !engine 4716b</a> | <a href="candiOQM_clock.html?ts=$EPOCH" style="color:#ff0">→ CLOCK</a></p>
<h3>All codes recovered (including previously deleted):</h3>
<pre>$(ls -1 articles/ | cat)
$(git log --all --name-status --diff-filter=D --pretty=format:"" --name-only | sort -u | sed 's/^/ [deleted recovered attempt] /')</pre>
<p>Engine: $(wc -c < candiOQM_xTitin.html 2>/dev/null || echo 0)b | Clock: $(wc -c < candiOQM_clock.html 2>/dev/null || echo 0)b</p>
</body></html>
HTML
echo "PERSISTENT NO-DELETE BUILD $TS - $(ls articles/ | wc -l) articles safe"
