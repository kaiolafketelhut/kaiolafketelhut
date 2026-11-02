#!/usr/bin/env python3
"""make_bin.py - write main.bin, a 512-byte BIOS boot sector that prints the KDP profile.

usage: python3 make_bin.py [main.bin]
No assembler needed: the 16-bit x86 code is spelled out byte by byte below.
Boot test: qemu-system-x86_64 -drive format=raw,file=main.bin -display curses
"""
import sys

TEXT = ("=== KDP Forum Profile ===\r\n"
        "Nickname : KDPMember:KL5UQ4f48673352\r\n"
        "Code     : KL5UQ4f48673352\r\n"
        "Role     : Member\r\n"
        "Points   : 1\r\n").encode("ascii") + b"\x00"

MSG = 33                      # offset of the text; the code below is exactly 33 bytes
code = bytes([
    0xFA,                     #  0 cli
    0x31, 0xC0,               #  1 xor ax, ax
    0x8E, 0xD8,               #  3 mov ds, ax
    0x8E, 0xC0,               #  5 mov es, ax
    0x8E, 0xD0,               #  7 mov ss, ax
    0xBC, 0x00, 0x7C,         #  9 mov sp, 0x7C00
    0xFB,                     # 12 sti
    0xBE, (0x7C00 + MSG) & 0xFF, (0x7C00 + MSG) >> 8,   # 13 mov si, msg
    0xAC,                     # 16 next: lodsb
    0x08, 0xC0,               # 17 or al, al
    0x74, 0x09,               # 19 jz halt
    0xB4, 0x0E,               # 21 mov ah, 0x0E   (BIOS teletype)
    0xBB, 0x07, 0x00,         # 23 mov bx, 7
    0xCD, 0x10,               # 26 int 0x10
    0xEB, 0xF2,               # 28 jmp next
    0xF4,                     # 30 halt: hlt
    0xEB, 0xFD,               # 31 jmp halt
])
assert len(code) == MSG, len(code)
sector = (code + TEXT).ljust(510, b"\x00") + b"\x55\xAA"
assert len(sector) == 512

path = sys.argv[1] if len(sys.argv) > 1 else "main.bin"
open(path, "wb").write(sector)
print("wrote %s: %d bytes, code %d + text %d, signature 55 AA" % (path, len(sector), len(code), len(TEXT)))
