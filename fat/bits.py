#!/usr/bin/env python3
"""bits.py - read a FAT table with any entry width (bit length).

usage: python3 bits.py [image] [width ...]     default: root.img, widths 7 12 16
Entries are packed LSB-first, exactly like FAT12 (so width 12 matches real FAT12).
"""
import os
import sys

default = os.path.join(os.environ.get("TMPDIR", "/tmp"), "root.img")
path = sys.argv[1] if len(sys.argv) > 1 else default
widths = [int(a) for a in sys.argv[2:]] or [7, 12, 16]

d = open(path, "rb").read()
fat = d[512:1024]                       # FAT1 = sector 1 (one 512-byte sector)
stream = int.from_bytes(fat, "little")
print("FAT bytes :", fat[:8].hex(" "), "...")
print("FAT bits  :", len(fat) * 8)

for n in widths:
    mask = (1 << n) - 1
    print("\n== %d-bit entries ==" % n)
    print("entries in this FAT sector :", len(fat) * 8 // n)
    print("value range                : 0..%d (roughly %d usable clusters)" % (mask, mask - 11))
    for i in range(6):
        lo, hi = i * n, i * n + n - 1
        v = (stream >> lo) & mask
        shared = "  <- shares a byte with a neighbour" if lo % 8 or (hi + 1) % 8 else ""
        print("entry %d: bits %3d..%3d (bytes %d..%d) = 0x%0*X%s"
              % (i, lo, hi, lo // 8, hi // 8, (n + 3) // 4, v, shared))
