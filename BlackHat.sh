#!/usr/bin/env bash
# BlackHat.sh - build the oeneye Red Hat-style (Fedora base) ISO
# Runs as root inside a Fedora container (see build-oeneye-redhat.yml)
set -euo pipefail
REL="${RELEASEVER:-44}"
OUT="${OUT:-$PWD/out}"
mkdir -p "$OUT" work && cd work
dnf install -y lorax lorax-lmc-novirt pykickstart git anaconda-tui xorriso
dnf install -y spin-kickstarts fedora-kickstarts --setopt=install_weak_deps=True || (dnf install -y git dnf install -y fedora-kickstartsdnf install -y fedora-kickstarts git clone https://pagure.io/fedora-kickstarts.git /usr/share/spin-kickstarts)
(cd /usr/share/spin-kickstarts && ksflatten -c oeneye-fedora.ks -o "$OLDPWD/flat.ks")
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
rm -rf "$OUT/lmc"
livemedia-creator --make-iso --no-virt --ks flat.ks \
  --project oeneye --releasever "$REL" --volid oeneye \
  --iso-name oeneye-redhat.iso --resultdir "$OUT/lmc"
