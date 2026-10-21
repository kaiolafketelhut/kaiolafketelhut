#!/usr/bin/env bash
# Runs inside debian:trixie. FLAVOR=lxqt (Debian base) or lubuntu (Ubuntu noble base)
set -euo pipefail
apt-get update && apt-get install -y live-build debootstrap ubuntu-keyring debian-archive-keyring
mkdir /live && cd /live
if [ "${FLAVOR:-lxqt}" = lubuntu ]; then
  lb config --mode ubuntu --distribution noble \
    --archive-areas "main restricted universe multiverse" \
    --debootstrap-options "--keyring=/usr/share/keyrings/ubuntu-archive-keyring.gpg" \
    --binary-images iso-hybrid --iso-application oeneye --iso-volume oeneye
  PKGS="lubuntu-desktop"; LIKE=ubuntu; NAME="Lubuntu base"
else
  lb config --distribution trixie \
    --archive-areas "main contrib non-free-firmware" \
    --binary-images iso-hybrid --iso-application oeneye --iso-volume oeneye
  PKGS="task-lxqt-desktop live-task-standard"; LIKE=debian; NAME="Debian LXQt"
fi
mkdir -p config/package-lists config/includes.chroot/etc
printf '%s\n' $PKGS > config/package-lists/base.list.chroot
printf 'NAME="oeneye"\nID=oeneye\nID_LIKE=%s\nVERSION="1.05 rc"\nVERSION_ID="1.05-rc"\nPRETTY_NAME="oeneye 1.05 rc (%s)"\n' "$LIKE" "$NAME" > config/includes.chroot/etc/os-release
lb build
cp /live/*.iso /out/
