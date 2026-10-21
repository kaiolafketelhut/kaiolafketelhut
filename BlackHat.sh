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

echo "=== LS /tmp/fk ==="
ls -la /tmp/fk
echo "=== ALL KS FILES ==="
find /tmp/fk -maxdepth 3 -type f -name "*.ks" | sort | head -n 100
echo "=== GREP XFCE ==="
find /tmp/fk -type f -name "*xfce*" | sort

mkdir -p /usr/share/spin-kickstarts
cp -a /tmp/fk/. /usr/share/spin-kickstarts/ 2>/dev/null || true
# also copy if there's subdirs
ls /usr/share/spin-kickstarts/*.ks | head -n 50

# check if xfce exists, fallback to base+workstation
if [ ! -f /usr/share/spin-kickstarts/fedora-live-xfce.ks ]; then
  echo "WARNING: fedora-live-xfce.ks not found, listing alternatives"
  ls /usr/share/spin-kickstarts/fedora-live*.ks
  # create a shim xfce file that includes base if missing
  if [ ! -f /usr/share/spin-kickstarts/fedora-live-xfce.ks ]; then
    cat > /usr/share/spin-kickstarts/fedora-live-xfce.ks <<'SHIM'
%include fedora-live-base.ks
%packages
@xfce-desktop
%end
SHIM
  fi
fi

cp -v "$WORKDIR/oeneye-fedora.ks" /usr/share/spin-kickstarts/oeneye-tmp.ks
cd /usr/share/spin-kickstarts
cat oeneye-tmp.ks

echo "=== KSFLATTEN ==="
ksflatten --config oeneye-tmp.ks -o "$WORKDIR/flat.ks" 2>&1 | tee /tmp/ks.log
echo "FLAT OK"
wc -l "$WORKDIR/flat.ks"
head -n 100 "$WORKDIR/flat.ks"

rm -rf "$OUT/lmc"
livemedia-creator --make-iso --no-virt --ks "$WORKDIR/flat.ks" --project oeneye --releasever "$REL" --volid oeneye --iso-name oeneye-redhat.iso --resultdir "$OUT/lmc" 2>&1 | tee /tmp/lmc.log
cp "$OUT"/lmc/*.iso "$OUT"/ || true
ls -lh "$OUT"/*.iso
