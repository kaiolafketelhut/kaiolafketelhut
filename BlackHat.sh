#!/usr/bin/env bash
set -ex
REL="44"
WORKDIR="$(pwd)"
OUT="$WORKDIR/out"
mkdir -p "$OUT"
rm -rf "$OUT/lmc"
dnf install -y lorax lorax-lmc-novirt pykickstart git anaconda-tui xorriso glibc-langpack-en

rm -rf /tmp/fedora-kickstarts /usr/share/spin-kickstarts
git clone https://pagure.io/fedora-kickstarts.git /tmp/fedora-kickstarts
ls /tmp/fedora-kickstarts/

# NEW LOCATION in F44: fedora/ subdir
find /tmp/fedora-kickstarts -type f -name "*.ks" | grep live | head -n 20

KS_SRC=$(find /tmp/fedora-kickstarts -type f -name "fedora-live-xfce.ks" | head -n1)
if [ -z "$KS_SRC" ]; then
  KS_SRC=$(find /tmp/fedora-kickstarts -type f -name "*xfce*.ks" | head -n1)
fi
echo "KS_SRC=$KS_SRC"
test -n "$KS_SRC" || (echo "ERROR: no xfce ks found" && exit 2)
KS_DIR=$(dirname "$KS_SRC")
echo "KS_DIR=$KS_DIR"

mkdir -p /usr/share/spin-kickstarts
cp -rv /tmp/fedora-kickstarts/* /usr/share/spin-kickstarts/ 2>&1 | head -n 50
ls -lh /usr/share/spin-kickstarts/fedora/ 2>&1 | head
ls -lh /usr/share/spin-kickstarts/fedora-live-xfce.ks || ls -lh /tmp/fedora-kickstarts/fedora/fedora-live-xfce.ks

cp -v "$WORKDIR/oeneye-fedora.ks" /usr/share/spin-kickstarts/oeneye-tmp.ks
cd /usr/share/spin-kickstarts
ksflatten -c oeneye-tmp.ks -o "$WORKDIR/flat.ks" || ksflatten -c /tmp/fedora-kickstarts/fedora/fedora-live-xfce.ks -o "$WORKDIR/flat.ks" --test || (cat oeneye-tmp.ks && exit 2)
echo "FLAT OK" && wc -l "$WORKDIR/flat.ks"
rm -rf "$OUT/lmc"
livemedia-creator --make-iso --no-virt --ks "$WORKDIR/flat.ks" --project oeneye --releasever "$REL" --volid oeneye --iso-name oeneye-redhat.iso --resultdir "$OUT/lmc"
cp "$OUT"/lmc/*.iso "$OUT"/ || true
ls -lh "$OUT"/*.iso
