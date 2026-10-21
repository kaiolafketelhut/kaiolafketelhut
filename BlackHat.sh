#!/usr/bin/env bash
set -exo pipefail
REL="44"
OUT="$(pwd)/out"
mkdir -p "$OUT" && rm -rf "$OUT/lmc"
dnf install -y lorax lorax-lmc-novirt pykickstart anaconda-tui xorriso isomd5sum curl

cat > /tmp/oeneye-standalone.ks <<'KS'
url --url=https://dl.fedoraproject.org/pub/fedora/linux/releases/44/Everything/x86_64/os/
repo --name=fedora --baseurl=https://dl.fedoraproject.org/pub/fedora/linux/releases/44/Everything/x86_64/os/
repo --name=updates --baseurl=https://dl.fedoraproject.org/pub/fedora/linux/updates/44/Everything/x86_64/
lang en_US.UTF-8
keyboard us
timezone UTC
rootpw --lock
user --name=oeneye --groups=wheel --password=oeneye
part / --size=10000 --fstype=ext4
bootloader --location=mbr
network --bootproto=dhcp
services --enabled=NetworkManager
%packages
@core
@xfce-desktop
kernel
dracut-live
livesys-scripts
grub2-pc
grub2-pc-modules
grub2-efi-x64
grub2-efi-x64-cdboot
shim-x64
syslinux
%end
%post
echo 'oeneye 1.05 rc' > /etc/oeneye-release
%end
KS

ksflatten --config /tmp/oeneye-standalone.ks -o flat.ks
livemedia-creator --make-iso --no-virt --ks flat.ks --project oeneye --releasever "$REL" --volid oeneye --iso-name oeneye-redhat.iso --resultdir "$OUT/lmc" --nomacboot 2>&1 | tee /tmp/lmc.log
ls -lh "$OUT/lmc/"
echo "=== RESULTS ==="
ls -lh "$OUT/lmc/" || true
ls -lh out/ || true
find . -maxdepth 3 -name "*.iso" -exec cp -v {} out/ \; 2>/dev/null || true
