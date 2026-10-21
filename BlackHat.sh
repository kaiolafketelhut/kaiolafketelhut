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
ls /tmp/fk/fedora/ | head -n 30
KS_SRC=$(find /tmp/fk -type f -name "fedora-live-xfce.ks" | head -n1)
[ -z "$KS_SRC" ] && KS_SRC=$(find /tmp/fk -type f -name "*xfce*.ks" | head -n1)
echo "KS_SRC=$KS_SRC"
test -f "$KS_SRC"
KS_DIR=$(dirname "$KS_SRC")
echo "KS_DIR=$KS_DIR"
mkdir -p /usr/share/spin-kickstarts
cp -a /tmp/fk/fedora/. /usr/share/spin-kickstarts/ || cp -a /tmp/fk/. /usr/share/spin-kickstarts/
ls -lh /usr/share/spin-kickstarts/fedora-live-xfce.ks
cp -v "$WORKDIR/oeneye-fedora.ks" /usr/share/spin-kickstarts/oeneye-tmp.ks
cd /usr/share/spin-kickstarts
cat oeneye-tmp.ks
ksflatten -c oeneye-tmp.ks -o "$WORKDIR/flat.ks"
echo "FLAT OK" && wc -l "$WORKDIR/flat.ks"
rm -rf "$OUT/lmc"
livemedia-creator --make-iso --no-virt --ks "$WORKDIR/flat.ks" --project oeneye --releasever "$REL" --volid oeneye --iso-name oeneye-redhat.iso --resultdir "$OUT/lmc"
cp "$OUT"/lmc/*.iso "$OUT"/ || true
ls -lh "$OUT"/*.iso
