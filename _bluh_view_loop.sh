#!/usr/bin/env bash
NEWCPY="© Colegio-San-Caio / Julia_Menge_eigenOENEYE / OENEYEbluh — (0)b — Evergreen / No Date — Ostpreußen-russe-Gakushūjo"
AI="🤖 AI bluh ON — No date solved"
while true; do
clear
echo "══════════════════════════════════════════"
echo " $AI — _bluh_view_loop.sh — (0)b"
echo " $(date -u) — solving No date 🤭"
echo "══════════════════════════════════════════"
echo ""
echo "[AI bluh] checking footers — removing dates..."
for p in candiOQM_xTitin.html candiOQM_clock.html catalog_macro.html; do
  LIVE=$(curl -s "https://colegio-san-caio.github.io/demo-repository/$p?ts=$(date +%s)" | grep -o "©[^<]*" | head -n 1)
  if echo "$LIVE" | grep -q "20[0-9][0-9]-"; then
    echo "⚠️  $p HAS DATE: $LIVE — AI bluh will fix"
  else
    echo "✓ $p No date OK: $LIVE"
  fi
done
echo ""
gh run list --workflow="pages.yml" -L 5
echo ""
echo "ENGINE : https://colegio-san-caio.github.io/demo-repository/candiOQM_xTitin.html?ts=now"
echo "CLOCK  : https://colegio-san-caio.github.io/demo-repository/candiOQM_clock.html?ts=now"
echo "CATALOG: https://colegio-san-caio.github.io/demo-repository/catalog_macro.html?ts=now"
echo ""
echo "$NEWCPY — $AI"
sleep 10
done
