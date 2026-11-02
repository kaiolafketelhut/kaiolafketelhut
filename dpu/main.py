#!/usr/bin/env python3
"""main.py - KDP profile as a self-describing binary record (DPU-style, with CRC).

usage: python3 main.py              write main.bin + main.BIN next to this script, then read them
       python3 main.py read FILE... read and verify record files
Record: magic(4) version(u16) flags(u16) length(u32) payload(length) crc32(u32)
  main.bin = little-endian, magic "KDPU"
  main.BIN = big-endian (network order), magic "UPDK" (the magic reversed)
Note: main.bin and main.BIN differ only in case - they collide on FAT, NTFS and
default macOS volumes. On Android/Linux file systems both can exist.
"""
import os
import struct
import sys
import zlib

ID = "KDPMember:KL5UQ4f48673352"
PAYLOAD = (
    "=== KDP Forum Profile ===\n"
    "Nickname : %s\n"
    "Code     : %s\n"
    "Role     : Member\n"
    "Points   : 1\n" % (ID, ID[len("KDPMember:"):])
).encode("ascii")


def pack(big):
    e = ">" if big else "<"
    magic = b"UPDK" if big else b"KDPU"
    head = magic + struct.pack(e + "HHI", 1, 1 if big else 0, len(PAYLOAD))
    return head + PAYLOAD + struct.pack(e + "I", zlib.crc32(PAYLOAD) & 0xFFFFFFFF)


def unpack(data):
    magic = data[:4]
    if magic == b"KDPU":
        e = "<"
    elif magic == b"UPDK":
        e = ">"
    else:
        raise ValueError("bad magic %r" % magic)
    ver, flags, n = struct.unpack_from(e + "HHI", data, 4)
    payload = data[12:12 + n]
    (crc,) = struct.unpack_from(e + "I", data, 12 + n)
    ok = crc == zlib.crc32(payload) & 0xFFFFFFFF
    return ("big" if e == ">" else "little"), ver, flags, payload, ok


def show(path):
    order, ver, flags, payload, ok = unpack(open(path, "rb").read())
    print("--- %s: %s-endian, version %d, flags %d, %d bytes, crc %s ---"
          % (path, order, ver, flags, len(payload), "OK" if ok else "BAD"))
    print(payload.decode("ascii"), end="")
    return ok


def main():
    if len(sys.argv) > 1 and sys.argv[1] == "read":
        return 0 if all([show(p) for p in sys.argv[2:]]) else 1
    here = os.path.dirname(os.path.abspath(__file__))
    paths = []
    for name, big in (("main.bin", False), ("main.BIN", True)):
        p = os.path.join(here, name)
        open(p, "wb").write(pack(big))
        paths.append(p)
    return 0 if all([show(p) for p in paths]) else 1


if __name__ == "__main__":
    sys.exit(main())
