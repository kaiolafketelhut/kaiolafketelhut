#!/usr/bin/env python3
"""entropy.py - flag files that look random (a sign of encryption).

usage: python3 entropy.py [dir] [threshold]     default: . 7.5
Plain text and code sit around 4-5.5 bits/byte; encrypted data is near 8.
Compressed formats (png, zip, deb...) are also near 8 and are listed apart.
"""
import math
import os
import sys

top = sys.argv[1] if len(sys.argv) > 1 else "."
limit = float(sys.argv[2]) if len(sys.argv) > 2 else 7.5
PACKED = {".png", ".jpg", ".jpeg", ".gif", ".webp", ".zip", ".gz", ".xz", ".bz2",
          ".7z", ".deb", ".iso", ".img", ".bin", ".ximg", ".mat", ".pdf", ".wasm",
          ".apk", ".aab", ".jar", ".tgz", ".qcow2"}


def entropy(data):
    counts = [0] * 256
    for b in data:
        counts[b] += 1
    n = len(data)
    return -sum(c / n * math.log2(c / n) for c in counts if c)


odd, packed, scanned = [], [], 0
for root, dirs, files in os.walk(top):
    dirs[:] = [d for d in dirs if d != ".git"]
    for name in files:
        path = os.path.join(root, name)
        try:
            with open(path, "rb") as f:
                data = f.read(1 << 20)          # first 1 MiB is enough to judge
        except OSError:
            continue
        if len(data) < 256:
            continue                            # too small to judge
        scanned += 1
        e = entropy(data)
        if e >= limit:
            ext = os.path.splitext(name)[1].lower()
            (packed if ext in PACKED or name.lower() in {"bzimage", "vmlinuz", "initrd"} else odd).append((e, path))

print("scanned %d files (threshold %.1f bits/byte)" % (scanned, limit))
print("\nSUSPICIOUS - high entropy but not a packed type: %d" % len(odd))
for e, p in sorted(odd, reverse=True):
    print("  %.3f  %s" % (e, p))
print("\nexpected - packed/compressed types: %d" % len(packed))
for e, p in sorted(packed, reverse=True)[:10]:
    print("  %.3f  %s" % (e, p))
if len(packed) > 10:
    print("  ... and %d more" % (len(packed) - 10))
sys.exit(1 if odd else 0)
