#!/usr/bin/env bash
# Runs inside debian:trixie. Debian + LXQt live ISO with Calamares installer.
set -euo pipefail
apt-get update && apt-get install -y live-build debootstrap debian-archive-keyring
mkdir /live && cd /live
lb config --distribution trixie \
  --archive-areas "main contrib non-free-firmware" \
  --binary-images iso-hybrid --iso-application oeneye --iso-volume oeneye
mkdir -p config/package-lists config/includes.chroot/etc
printf '%s\n' task-lxqt-desktop live-task-standard calamares calamares-settings-debian > config/package-lists/base.list.chroot
printf 'NAME="oeneye"\nID=oeneye\nID_LIKE=debian\nVERSION="1.05 rc"\nVERSION_ID="1.05-rc"\nPRETTY_NAME="oeneye 1.05 rc (Debian LXQt)"\n' > config/includes.chroot/etc/os-release
lb build
cp /live/*.iso /out/
