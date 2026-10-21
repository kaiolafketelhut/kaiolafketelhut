#!/usr/bin/env bash
set -e
REL="${1:-44}"
WORKDIR="$(pwd)"
OUT="$WORKDIR/out"
mkdir -p "$OUT"
rm -rf "$OUT/lmc"

echo "=== install host tools ==="
dnf install -y lorax lorax-lmc-novirt pykickstart git anaconda-tui xorriso

if ! dnf install -y spin-kickstarts --setopt=install_weak_deps=True 2>&1; then
  echo "spin-kickstarts not in repo, cloning"
  rm -rf /usr/share/spin-kickstarts
  git clone https://pagure.io/fedora-kickstarts.git /usr/share/spin-kickstarts
fi

echo "=== flatten ==="
# your ks is in repo root, not in /usr/share/spin-kickstarts
if [ -f "$WORKDIR/oeneye-fedora.ks" ]; then
  KSFROM="$WORKDIR/oeneye-fedora.ks"
else
  KSFROM="/usr/share/spin-kickstarts/fedora-live-xfce.ks"
fi

cd /usr/share/spin-kickstarts
ksflatten -c "$KSFROM" -o "$WORKDIR/flat.ks"

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
