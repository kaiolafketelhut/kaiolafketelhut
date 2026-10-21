#!/usr/bin/env bash
set -euo pipefail
REL="${1:-44}"
OUT="$PWD/out"
mkdir -p "$OUT"
rm -rf "$OUT/lmc"

# 1. install tools - f44 names
dnf install -y lorax lorax-lmc-novirt pykickstart git anaconda-tui xorriso

# try packages, if not found clone
if ! dnf install -y spin-kickstarts --setopt=install_weak_deps=True; then
  dnf install -y git
  rm -rf /usr/share/spin-kickstarts
  git clone https://pagure.io/fedora-kickstarts.git /usr/share/spin-kickstarts
fi

# 2. flatten your OWN ks
cd /usr/share/spin-kickstarts
ksflatten -c oeneye-fedora.ks -o "$OLDPWD/flat.ks" || ksflatten -c fedora-live-xfce.ks -o "$OLDPWD/flat.ks"

# 3. add oeneye branding
cat >> flat.ks <<'POST'
%post
cat > /etc/os-release <<'OS'
NAME="oeneye"
ID=oeneye
ID_LIKE="fedora rhel"
VERSION="1.05 rc"
VERSION_ID="1.05-rc"
PRETTY_NAME="oeneye 1.05 rc (Fedora base)"
OS
%end
POST

# 4. build
rm -rf "$OUT/lmc"
livemedia-creator --make-iso --no-virt --ks flat.ks \
  --project oeneye --releasever "$REL" --volid oeneye \
  --iso-name oeneye-redhat.iso --resultdir "$OUT/lmc"

cp "$OUT"/lmc/*.iso "$OUT"/ || true
ls -lh "$OUT"/*.iso
