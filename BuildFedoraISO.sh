#!/usr/bin/env bash
# Runs inside a fedora container: bakes a kickstart into the Fedora Server netinst ISO
set -euo pipefail
: "${HASH:?OENEYE_ROOT_HASH secret missing}"
dnf install -y lorax xorriso isomd5sum curl
BASE="https://dl.fedoraproject.org/pub/fedora/linux/releases/${FEDORA:-44}/Server/x86_64/iso"
NAME=$(curl -fsSL "$BASE/" | grep -o 'Fedora-Server-netinst-x86_64-[^"<]*\.iso' | head -n1)
[ -n "$NAME" ] || { echo "no netinst ISO found at $BASE"; exit 1; }
curl -fL -o in.iso "$BASE/$NAME"
cp "/w/${KS:-oeneye-fedora.ks}" ks.cfg
sed -i "s|\$6\$REPLACE|$HASH|" ks.cfg
mkksiso --ks ks.cfg in.iso /out/oeneye-fedora.iso
