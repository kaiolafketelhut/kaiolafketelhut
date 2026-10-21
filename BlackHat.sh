#!/usr/bin/env bash
set -ex
REL="44"
WORKDIR="$(pwd)"
OUT="$WORKDIR/out"
mkdir -p "$OUT"
rm -rf "$OUT/lmc"

# install everything including kickstarts RPM, not pagure
dnf install -y lorax lorax-lmc-novirt pykickstart git anaconda-tui xorriso glibc-langpack-en spin-kickstarts

echo "=== LS spin-kickstarts ==="
ls -lh /usr/share/spin-kickstarts/ | head -n 100
ls /usr/share/spin-kickstarts/fedora-live*.ks

# use installed kickstarts
KS_DIR="/usr/share/spin-kickstarts"
cp -v "$WORKDIR/oeneye-fedora.ks" "$KS_DIR/oeneye-tmp.ks"
cat "$KS_DIR/oeneye-tmp.ks"
cd "$KS_DIR"

echo "=== KSFLATTEN ==="
ksflatten --config oeneye-tmp.ks -o "$WORKDIR/flat.ks" 2>&1 | tee /tmp/ks.log
echo "FLAT OK"
wc -l "$WORKDIR/flat.ks"
head -n 80 "$WORKDIR/flat.ks"

rm -rf "$OUT/lmc"
livemedia-creator --make-iso --no-virt --ks "$WORKDIR/flat.ks" --project oeneye --releasever "$REL" --volid oeneye --iso-name oeneye-redhat.iso --resultdir "$OUT/lmc" 2>&1 | tee /tmp/lmc.log
cp "$OUT"/lmc/*.iso "$OUT"/ || true
ls -lh "$OUT"/*.iso
