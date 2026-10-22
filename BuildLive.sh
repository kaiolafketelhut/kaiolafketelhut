#!/usr/bin/env bash
set -euo pipefail
apt-get update && apt-get install -y live-build debootstrap cpio gzip
mkdir -p /live && cd /live
lb config --distribution trixie --archive-areas "main contrib non-free-firmware" --binary-images iso-hybrid --iso-application oeneye --iso-publisher oeneye --iso-volume oeneye
mkdir -p config/package-lists config/includes.chroot/etc
printf '%s\n' task-lxqt-desktop live-task-standard calamares calamares-settings-debian > config/package-lists/oeneye.list.chroot
printf 'NAME="oeneye"\nID=oeneye\nID_LIKE=debian\nVERSION="0.1"\nPRETTY_NAME="oeneye"\n' > config/includes.chroot/etc/os-release
mkdir -p config/packages.chroot && cp /w/oeneye-cuda_0.1_all.deb config/packages.chroot/ || true
lb build
cp /live/*.iso /out/
