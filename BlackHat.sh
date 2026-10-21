#!/usr/bin/env bash
set -ex
REL="44"
WORKDIR="$(pwd)"
OUT="$WORKDIR/out"
mkdir -p "$OUT"
rm -rf "$OUT/lmc"

dnf install -y lorax lorax-lmc-novirt pykickstart git anaconda-tui xorriso glibc-langpack-en spin-kickstarts || true

echo "=== FIND KS FILES ==="
ls -R /usr/share/spin-kickstarts | head -n 100
find /usr/share -name "fedora-live-xfce.ks" 2>/dev/null
find . -name "*.ks" -maxdepth 3 2>/dev/null || true

# use system spin-kickstarts if present, else cloned one
KS_DIR="/usr/share/spin-kickstarts"
if [ ! -f "$KS_DIR/fedora-live-xfce.ks" ]; then
  KS_DIR="/usr/share/spin-kickstarts/fedora"
  if [ ! -f "$KS_DIR/fedora-live-xfce.ks" ]; then
    # clone to /tmp and locate
    rm -rf /tmp/fedora-kickstarts
    git clone https://pagure.io/fedora-kickstarts.git /tmp/fedora-kickstarts
    find /tmp/fedora-kickstarts -name "fedora-live-xfce.ks" -exec ls -l {} \;
    KS_DIR=$(dirname $(find /tmp/fedora-kickstarts -name "fedora-live-xfce.ks" | head -n1))
  fi
fi

echo "Using KS_DIR=$KS_DIR"
cp -v "$WORKDIR/oeneye-fedora.ks" "$KS_DIR/oeneye-tmp.ks"
cd "$KS_DIR"
cat oeneye-tmp.ks

ksflatten -c oeneye-tmp.ks -o "$WORKDIR/flat.ks"
echo "FLAT OK" && wc -l "$WORKDIR/flat.ks"

rm -rf "$OUT/lmc"
livemedia-creator --make-iso --no-virt --ks "$WORKDIR/flat.ks" --project oeneye --releasever "$REL" --volid oeneye --iso-name oeneye-redhat.iso --resultdir "$OUT/lmc"
cp "$OUT"/lmc/*.iso "$OUT"/ || true
ls -lh "$OUT"/*.iso
