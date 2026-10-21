#!/usr/bin/env bash
set -ex
REL="44"
WORKDIR="$(pwd)"
OUT="$WORKDIR/out"
mkdir -p "$OUT"
rm -rf "$OUT/lmc"
dnf install -y lorax lorax-lmc-novirt pykickstart git anaconda-tui xorriso glibc-langpack-en

rm -rf /tmp/fk /usr/share/spin-kickstarts
git clone https://pagure.io/fedora-kickstarts.git /tmp/fk
KS_SRC=$(find /tmp/fk -type f -name "fedora-live-xfce.ks" | head -n1)
echo "KS_SRC=$KS_SRC"
KS_DIR=$(dirname "$KS_SRC")
mkdir -p /usr/share/spin-kickstarts
cp -a "$KS_DIR"/. /usr/share/spin-kickstarts/
cp -a /tmp/fk/common/. /usr/share/spin-kickstarts/ 2>/dev/null || true
ls /usr/share/spin-kickstarts/ | head -n 60

# Fix oeneye ks to use absolute includes that exist
cat "$WORKDIR/oeneye-fedora.ks" > /tmp/check.ks
echo "--- oeneye-fedora.ks ---"
cat /tmp/check.ks
echo "--- END ---"

cp -v "$WORKDIR/oeneye-fedora.ks" /usr/share/spin-kickstarts/oeneye-tmp.ks
cd /usr/share/spin-kickstarts

# Try flatten with include-path
ksflatten --config oeneye-tmp.ks --include-path /usr/share/spin-kickstarts -o "$WORKDIR/flat.ks" 2>&1 | tee /tmp/ks.log || \
ksflatten -c oeneye-tmp.ks -o "$WORKDIR/flat.ks" 2>&1 | tee /tmp/ks.log

echo "FLAT OK" && head -n 200 "$WORKDIR/flat.ks"
echo "--- tail flat ---"
tail -n 100 "$WORKDIR/flat.ks"

rm -rf "$OUT/lmc"
livemedia-creator --make-iso --no-virt --ks "$WORKDIR/flat.ks" --project oeneye --releasever "$REL" --volid oeneye --iso-name oeneye-redhat.iso --resultdir "$OUT/lmc" 2>&1 | tee /tmp/lmc.log

cp "$OUT"/lmc/*.iso "$OUT"/ || true
ls -lh "$OUT"/*.iso
