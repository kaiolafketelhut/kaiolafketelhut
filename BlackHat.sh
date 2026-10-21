#!/usr/bin/env bash
set -ex
REL="44"
WORKDIR="$(pwd)"
OUT="$WORKDIR/out"
mkdir -p "$OUT"
rm -rf "$OUT/lmc"

# INSTALL FIRST - fixes git: command not found + No such file spin-kickstarts
dnf install -y lorax lorax-lmc-novirt pykickstart git anaconda-tui xorriso glibc-langpack-en spin-kickstarts

echo "=== SPIN KICKSTARTS ==="
ls -lh /usr/share/spin-kickstarts/
ls /usr/share/spin-kickstarts/fedora-live-xfce.ks

KS_DIR="/usr/share/spin-kickstarts"
cp -v "$WORKDIR/oeneye-fedora.ks" "$KS_DIR/oeneye-tmp.ks"
cd "$KS_DIR"
cat oeneye-tmp.ks

ksflatten -c oeneye-tmp.ks -o "$WORKDIR/flat.ks"
echo "FLAT OK" && wc -l "$WORKDIR/flat.ks"

rm -rf "$OUT/lmc"
livemedia-creator --make-iso --no-virt --ks "$WORKDIR/flat.ks" --project oeneye --releasever "$REL" --volid oeneye --iso-name oeneye-redhat.iso --resultdir "$OUT/lmc"
cp "$OUT"/lmc/*.iso "$OUT"/ || true
ls -lh "$OUT"/*.iso
