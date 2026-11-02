#!/usr/bin/env python3
"""make_main.py - write MAIN.XIMG, a 1200x630 preview card of the KDP profile.

usage: python3 make_main.py [MAIN.XIMG]       needs Pillow (Termux: pkg install python-pillow)
XIMG: "XIMG", 1, 1, width u32 LE, height u32 LE, zlib(RGBA bytes) - same as OMQpreview.ximg.
"""
import struct
import sys
import zlib

from PIL import Image, ImageDraw, ImageFont

path = sys.argv[1] if len(sys.argv) > 1 else "MAIN.XIMG"
ID = "KDPMember:KL5UQ4f48673352"
BG, TITLE, TEXT, DIM = (0x14, 0x18, 0x20, 255), (0x38, 0xBD, 0xF8, 255), (0x86, 0xEF, 0xAC, 255), (0x7D, 0x87, 0x99, 255)

# draw small with the built-in bitmap font, then scale 4x so the pixels stay crisp
small = Image.new("RGBA", (300, 158), BG)
d = ImageDraw.Draw(small)
d.fontmode = "1"
f = ImageFont.load_default()
d.text((14, 12), "KDP FORUM PROFILE", font=f, fill=TITLE)
d.line((14, 26, 286, 26), fill=DIM)
rows = [("Nickname", ID), ("Code", ID[len("KDPMember:"):]), ("Role", "Member"), ("Points", "1")]
for i, (k, v) in enumerate(rows):
    d.text((14, 40 + i * 18), "%-9s: %s" % (k, v), font=f, fill=TEXT)
d.text((14, 140), "oeneye XIMG 1200x630 RGBA", font=f, fill=DIM)
img = small.resize((1200, 632), Image.NEAREST).crop((0, 0, 1200, 630))

raw = img.tobytes()
data = b"XIMG" + bytes([1, 1]) + struct.pack("<II", 1200, 630) + zlib.compress(raw, 9)
open(path, "wb").write(data)
print("wrote %s: 1200x630, %d bytes" % (path, len(data)))
