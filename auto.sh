#!/bin/bash
cp INDEX.HTML index.html
git add INDEX.HTML index.html
git commit -m "auto: INDEX.HTML -> index.html BLUH.XKTS $(date -u +%Y-%m-%dT%H:%MZ)"
git push origin main
git push origin main:gh-pages --force-with-lease
git push origin main:bluh --force-with-lease
echo "live at https://kaiolafketelhut.github.io/kaiolafketelhut/"
