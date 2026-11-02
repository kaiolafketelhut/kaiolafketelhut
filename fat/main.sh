#!/bin/sh
# main.sh - KDP profile on a FAT12 image
# usage: sh main.sh [image] [size-in-KiB]   (default: kdp.img, 64)
set -e
IMG=${1:-kdp.img}
SIZE=${2:-64}

rm -f "$IMG"
mkfs.fat -C -F 12 -n KDPFAT "$IMG" "$SIZE" > /dev/null

# DOS-style CRLF text file stored in the root directory
printf '%s\r\n' \
    '=== KDP Forum Profile ===' \
    'Nickname : KDPMember:KL5UQ4f48673352' \
    'Code     : KL5UQ4f48673352' \
    'Role     : Member' \
    'Points   : 1' \
  | mcopy -i "$IMG" - ::KDP.TXT

echo "--- $IMG ($SIZE KiB, FAT12) ---"
mdir -i "$IMG" ::
echo "--- KDP.TXT ---"
mtype -t -i "$IMG" ::KDP.TXT
