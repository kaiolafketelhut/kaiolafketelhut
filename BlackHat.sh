#!/usr/bin/env bash
set -ex
REL="44"
WORKDIR="$(pwd)"
OUT="$WORKDIR/out"
mkdir -p "$OUT"
rm -rf "$OUT/lmc"

dnf install -y lorax lorax-lmc-novirt pykickstart git anaconda-tui xorriso glibc-langpack-en

rm -rf /usr/share/spin-kickstarts /tmp/fedora-kickstarts
git clone https://pagure.io/fedora-kickstarts.git /tmp/fedora-kickstarts

# Fedora moved ks files to fedora/ subdir in 2024+
find /tmp/fedora-kickstarts -name "fedora-live-xfce.ks" | head

KS_SRC=$(find /tmp/fedora-kickstarts -name "fedora-live-xfce.ks" | head -n1)
KS_DIR=$(dirname "$KS_SRC")
echo "KS_DIR=$KS_DIR KS_SRC=$KS_SRC"
ls -lh "$KS_DIR/fedora-live-"*.ks | head -n 20

mkdir -p /usr/share/spin-kickstarts
cp -r "$KS_DIR"/* /usr/share/spin-kickstarts/ || cp -r /tmp/fedora-kickstarts/* /usr/share/spin-kickstarts/

ls /usr/share/spin-kickstarts/fedora-live-xfce.ks

cp -v "$WORKDIR/oeneye-fedora.ks" /usr/share/spin-kickstarts/oeneye-tmp.ks
cd /usr/share/spin-kickstarts
cat oeneye-tmp.ks

ksflatten -c oeneye-tmp.ks -o "$WORKDIR/flat.ks"
echo "FLAT OK" && wc -l "$WORKDIR/flat.ks"

rm -rf "$OUT/lmc"
livemedia-creator --make-iso --no-virt --ks "$WORKDIR/flat.ks" --project oeneye --releasever "$REL" --volid oeneye --iso-name oeneye-redhat.iso --resultdir "$OUT/lmc"
cp "$OUT"/lmc/*.iso "$OUT"/ || true
ls -lh "$OUT"/*.iso
