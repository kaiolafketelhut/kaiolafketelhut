#!/usr/bin/env bash
set -ex
REL="44"
WORKDIR="$(pwd)"
OUT="$WORKDIR/out"
mkdir -p "$OUT" && rm -rf "$OUT/lmc"

dnf install -y lorax lorax-lmc-novirt pykickstart git anaconda-tui xorriso isomd5sum

# Fully standalone KS - NO %include at all, no external dependency
cat > /tmp/oeneye-standalone.ks <<'KS'
url --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=fedora-44&arch=$basearch
repo --name=fedora --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=fedora-44&arch=$basearch
repo --name=updates --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=updates-released-f44&arch=$basearch

lang en_US.UTF-8
keyboard us
timezone UTC
auth --enableshadow --passalgo=sha512
selinux --enforcing
firewall --enabled
xconfig --startxonboot
services --enabled=NetworkManager --disabled=network,sshd

part / --size=8000 --fstype=ext4
bootloader --location=mbr --append="rhgb quiet"
network --bootproto=dhcp
rootpw --lock
user --name=oeneye --groups=wheel --password=oeneye

%packages
@core
@xfce-desktop
@standard
@hardware-support
kernel
dracut-live
livesys-scripts
lorax-templates-generic
fedora-release
neovim
git
%end

%post
echo 'NAME="oeneye"' > /etc/os-release
echo 'ID=oeneye' >> /etc/os-release
echo 'VERSION="1.05 rc"' >> /etc/os-release
echo 'PRETTY_NAME="oeneye 1.05 rc MOSFETQ infinity-eye"' >> /etc/os-release
echo 'ID_LIKE="fedora rhel"' >> /etc/os-release
# make live user auto login xfce
systemctl enable lightdm 2>/dev/null || systemctl enable gdm 2>/dev/null || true
%end
KS

echo "=== KSFLATTEN ==="
ksflatten --config /tmp/oeneye-standalone.ks -o "$WORKDIR/flat.ks"
echo "FLAT OK"
head -n 40 "$WORKDIR/flat.ks"

echo "=== LIVEMEDIA ==="
rm -rf "$OUT/lmc"
livemedia-creator --make-iso --no-virt --ks "$WORKDIR/flat.ks" --project oeneye --releasever "$REL" --volid oeneye --iso-name oeneye-redhat.iso --resultdir "$OUT/lmc" 2>&1 | tee /tmp/lmc.log
ls -lh "$OUT/lmc/"
cp "$OUT/lmc/"*.iso "$OUT"/ || true
ls -lh "$OUT"/*.iso
