#!/usr/bin/env python3
"""main.py - VM.ximg: a tiny program stored in the pixels of an XIMG, plus its interpreter.

usage: python3 main.py make [VM.ximg]     write the image
       python3 main.py run  [VM.ximg]     decode it and run the program
XIMG: "XIMG", 1, 1, width u32 LE, height u32 LE, zlib(RGBA bytes).
The RGBA byte stream is the program: "KVM1", then ops, padded with zeros:
  0x01 <len> <ascii bytes>   print the text and a newline
  0x00                       halt
"""
import struct
import sys
import zlib

LINES = [
    "=== KDP Forum Profile ===",
    "Nickname : KDPMember:KL5UQ4f48673352",
    "Code     : KL5UQ4f48673352",
    "Role     : Member",
    "Points   : 1",
]
W = 16


def program():
    code = b"KVM1"
    for line in LINES:
        b = line.encode("ascii")
        code += bytes([1, len(b)]) + b
    return code + b"\x00"


def make(path):
    code = program()
    row = W * 4
    h = -(-len(code) // row)
    raw = code.ljust(row * h, b"\x00")
    data = b"XIMG" + bytes([1, 1]) + struct.pack("<II", W, h) + zlib.compress(raw, 9)
    open(path, "wb").write(data)
    print("wrote %s: %dx%d pixels, %d bytes, program %d bytes" % (path, W, h, len(data), len(code)))


def run(path):
    d = open(path, "rb").read()
    if d[:4] != b"XIMG":
        sys.exit("not an XIMG")
    w, h = struct.unpack("<II", d[6:14])
    raw = zlib.decompress(d[14:])
    if len(raw) != w * h * 4 or raw[:4] != b"KVM1":
        sys.exit("no KVM1 program in this image")
    pc = 4
    while pc < len(raw):
        op = raw[pc]
        if op == 0:
            return
        if op == 1:
            n = raw[pc + 1]
            print(raw[pc + 2:pc + 2 + n].decode("ascii"))
            pc += 2 + n
        else:
            sys.exit("bad opcode 0x%02X at %d" % (op, pc))


if __name__ == "__main__":
    mode = sys.argv[1] if len(sys.argv) > 1 else "run"
    target = sys.argv[2] if len(sys.argv) > 2 else "VM.ximg"
    make(target) if mode == "make" else run(target)
