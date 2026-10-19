#!/usr/bin/env bash
# status_check.sh — audit for MOSFETQexchange / oeneyeFAX — auto FAX by {NAME}
NAME="${FAX_NAME:-oeneye.c + oeneyepdf.c}"
FAX_LINE="FAX by $NAME — set by oeneye.c + oeneyepdf.c — FAX by oeneyeFAX — PL:36883"

echo "===================================================================="
echo " MOSFETQexchange & oeneyeFAX Pipeline Audit Status"
echo "===================================================================="
echo "[*] Timestamp: $(date -u +'%Y-%m-%d %H:%M:%S UTC')"
echo "[*] $FAX_LINE"
echo ""

echo "--- 1. Output Files (verify %PDF + author) ---"
if [ -d "MOSFETQexchange/output" ]; then
    ls -lh MOSFETQexchange/output/
    for PDF in MOSFETQexchange/output/*.pdf; do
      [ -f "$PDF" ] || continue
      if head -c4 "$PDF" | grep -q "%PDF"; then
        echo "  [OK] $PDF is PDF — $(stat -c%s "$PDF") bytes"
        # check author set by oeneyepdf.c
        strings "$PDF" | grep -E "/Author|oeneye" | head -n2
      else
        echo "  [FAIL] $PDF NOT a PDF — needs rebuild via oeneyepdf.c"
      fi
    done
else
    echo "[!] MOSFETQexchange/output missing."
fi

echo ""
echo "--- 2. Spool Queue ---"
if [ -d "MOSFETQexchange/spool/fax" ]; then
    ls -lh MOSFETQexchange/spool/fax/
    cat MOSFETQexchange/spool/fax/*.fax 2>/dev/null | head
else
    echo "[!] Spool missing — mkdir -p MOSFETQexchange/spool/fax"
fi

echo ""
echo "--- 3. IMC Sources ---"
find . -maxdepth 3 -type f \( -name "*.IMC" -o -name "*.imc" \) -ls 2>/dev/null || echo "No *.IMC found"

echo ""
echo "--- 4. Main PDFs ---"
ls -lh ./sigma_0b_jc.pdf ./jc_sigma.pdf 2>/dev/null || echo "sigma_0b_jc.pdf not in root"

echo ""
echo "--- 5. Git Working Tree ---"
git status -s
echo ""
git log --oneline -3

echo "===================================================================="
echo " Framework Identity: 1 + 0 = 1 | PL:36883 | $FAX_LINE"
echo "===================================================================="
