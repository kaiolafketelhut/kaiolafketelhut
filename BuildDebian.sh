#!/usr/bin/env bash
# Runs inside a debian:trixie container
set -euo pipefail
apt-get update && apt-get install -y live-build
mkdir /live && cd /live
lb config --distribution trixie \
  --archive-areas "main contrib non-free-firmware" \
  --binary-images iso-hybrid \
  --iso-application oeneye --iso-volume oeneye
mkdir -p config/package-lists config/includes.chroot/etc
printf '%s\n' task-xfce-desktop live-task-standard > config/package-lists/base.list.chroot
printf 'NAME="oeneye"\nID=oeneye\nID_LIKE=debian\nVERSION="1.05 rc"\nVERSION_ID="1.05-rc"\nPRETTY_NAME="oeneye 1.05 rc (Debian base)"\n' > config/includes.chroot/etc/os-release
lb build
cp /live/*.iso /out/
