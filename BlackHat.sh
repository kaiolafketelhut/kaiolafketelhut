#!/usr/bin/env bash
set -ex
REL="44"
WORKDIR="$(pwd)"
OUT="$WORKDIR/out"
mkdir -p "$OUT" && rm -rf "$OUT/lmc"
dnf install -y lorax lorax-lmc-novirt pykickstart anaconda-tui xorriso isomd5sum curl

# STANDALONE KS - uses dl.fedoraproject.org directly, not mirrorlist
cat > /tmp/oeneye-standalone.ks <<'KS'
url --url=https://dl.fedoraproject.org/pub/fedora/linux/releases/44/Everything/aarch64/os/
repo --name=fedora --baseurl=https://dl.fedoraproject.org/pub/fedora/linux/releases/44/Everything/aarch64/os/
repo --name=updates --baseurl=https://dl.fedoraproject.org/pub/fedora/linux/updates/44/Everything/aarch64/
lang en_US.UTF-8
keyboard us
timezone UTC
auth --enableshadow --passalgo=sha512
selinux --disabled
firewall --disabled
xconfig --startxonboot
services --enabled=NetworkManager
part / --size=10000 --fstype=ext4
bootloader --location=mbr
network --bootproto=dhcp
rootpw --lock
user --name=oeneye --groups=wheel --password=oeneye
%packages
@core
@xfce-desktop
kernel
dracut-live
livesys-scripts
%end
%post
echo 'oeneye 1.05 rc' > /etc/oeneye-release
%end
KS

ksflatten --config /tmp/oeneye-standalone.ks -o "$WORKDIR/flat.ks"
echo FLAT OK

rm -rf "$OUT/lmc"
livemedia-creator --make-iso --no-virt --ks "$WORKDIR/flat.ks" --project oeneye --releasever "$REL" --volid oeneye --iso-name oeneye-redhat.iso --resultdir "$OUT/lmc" --nomacboot 2>&1 | tee /tmp/lmc.log
ls -lh "$OUT/lmc/"
cp "$OUT/lmc/"*.iso "$OUT"/ || true
