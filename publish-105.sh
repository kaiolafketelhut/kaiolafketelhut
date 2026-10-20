#!/data/data/com.termux/files/usr/bin/bash
set -e
cd ~/kai
DEB=oeneyeos_1.05_all.deb
[ -f "$DEB" ] || { echo "missing $DEB"; exit 1; }

SHA=$(sha256sum "$DEB" | cut -d' ' -f1)
echo "$SHA  $DEB" | tee docs/$DEB.sha256

# bump version in the pages
for f in docs/index.html docs/floppy.html; do
  [ -f "$f" ] && sed -i 's/1\.04/1.05/g' "$f"
done

git add -A
git commit -m "oeneyeos 1.05 final" || true
git tag -f v1.05
git push -f origin main
git push -f salsa main
git push -f origin v1.05
git push -f salsa v1.05
echo "DONE. SHA-256: $SHA"
