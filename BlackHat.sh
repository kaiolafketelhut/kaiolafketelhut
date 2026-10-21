#!/usr/bin/env bash
set -e
REL="${1:-44}"
WORKDIR="$(pwd)"
OUT="$WORKDIR/out"
mkdir -p "$OUT"
rm -rf "$OUT/lmc"

echo "=== install tools ==="
dnf install -y lorax lorax-lmc-novirt pykickstart git anaconda-tui xorriso

if ! dnf install -y spin-kickstarts --setopt=install_weak_deps=True 2>&1; then
  rm -rf /usr/share/spin-kickstarts
  git clone https://pagure.io/fedora-kickstarts.git /usr/share/spin-kickstarts
fi

echo "=== locate kickstart ==="
ls -l "$WORKDIR"/*.ks /usr/share/spin-kickstarts/*.ks | head -n 30
# your file - pick first .ks in repo or fallback
KSFILE=$(ls "$WORKDIR"/oeneye*.ks "$WORKDIR"/*.ks 2>/dev/null | head -n1 || echo "/usr/share/spin-kickstarts/fedora-live-xfce.ks")
echo "Using KSFILE=$KSFILE"
cp -v "$KSFILE" /usr/share/spin-kickstarts/oeneye-tmp.ks

cd /usr/share/spin-kickstarts
ksflatten -c oeneye-tmp.ks -o "$WORKDIR/flat.ks"

cat >> "$WORKDIR/flat.ks" <<'POST'
%post
cat > /etc/os-release <<'OS'
NAME="oeneye"
ID=oeneye
ID_LIKE="fedora rhel"
VERSION="1.05 rc"
VERSION_ID="1.05-rc"
PRETTY_NAME="oeneye 1.05 rc (Fedora base) MOSFETQ infinity-eye"
OS
%end
POST

echo "=== build ISO ==="
rm -rf "$OUT/lmc"
livemedia-creator --make-iso --no-virt --ks "$WORKDIR/flat.ks" \
  --project oeneye --releasever "$REL" --volid oeneye \
  --iso-name oeneye-redhat.iso --resultdir "$OUT/lmc"

cp "$OUT"/lmc/*.iso "$OUT"/ || true
ls -lh "$OUT"/*.iso
