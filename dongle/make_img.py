#!/usr/bin/env python3
import struct
import sys

ID = "KDPMember:KL5UQ4f48673352"
PROFILE = ("=== KDP Forum Profile ===\r\n"
           "Nickname : %s\r\n"
           "Code     : %s\r\n"
           "Role     : Member\r\n"
           "Points   : 1\r\n" % (ID, ID[len("KDPMember:"):]))
SECTOR, TOTAL, FAT_SECTORS, ROOT_ENTRIES = 512, 2880, 9, 224
ROOT_SECTORS = ROOT_ENTRIES * 32 // SECTOR
DATA_START = 1 + 2 * FAT_SECTORS + ROOT_SECTORS          # 33

def make_exe():
    msg = PROFILE.encode("ascii") + b"$"
    code_len = 15  # Adjusted for extra 0x48 byte
    code = bytes([
        0x0E,                       # push cs
        0x1F,                       # pop ds
        0x48,                       # dec ax
        0xBA, code_len, 0x00,       # mov dx, msg
        0xB4, 0x09,                 # mov ah, 9
        0xCD, 0x21,                 # int 21h
        0xB8, 0x00, 0x4C,           # mov ax, 4C00h
        0xCD, 0x21,                 # int 21h
    ])
    assert len(code) == code_len
    image = code + msg
    size = 32 + len(image)
    header = struct.pack("<2sHHHHHHHHHHHHH", b"MZ", size % SECTOR, -(-size // SECTOR),
                         0, 2, 0x20, 0xFFFF, 0, 0x0200, 0, 0, 0, 0x1C, 0)
    return header.ljust(32, b"\x00") + image

def make_boot():
    text = PROFILE.encode("ascii") + b"\x00"
    start = 62                                         
    msg = 0x7C00 + start + 33
    code = bytes([
        0xFA, 0x31, 0xC0, 0x8E, 0xD8, 0x8E, 0xC0, 0x8E, 0xD0,   
        0xBC, 0x00, 0x7C, 0xFB,                                   
        0xBE, msg & 0xFF, msg >> 8,                               
        0xAC, 0x08, 0xC0, 0x74, 0x09,                             
        0xB4, 0x0E, 0xBB, 0x07, 0x00, 0xCD, 0x10, 0xEB, 0xF2,    
        0xF4, 0xEB, 0xFD,                                         
    ])
    assert len(code) == 33
    b = bytearray(SECTOR)
    b[0:3] = b"\xEB\x3C\x90"
    b[3:11] = b"KDPDONGL"
    struct.pack_into("<HBHBHHBHHHII", b, 11, SECTOR, 1, 1, 2, ROOT_ENTRIES, TOTAL,
                     0xF0, FAT_SECTORS, 18, 2, 0, 0)
    struct.pack_into("<BBBI11s8s", b, 36, 0, 0, 0x29, 0x44474G4E, b"KDPDONGLE  ", b"FAT12   ")
    b[start:start + len(code) + len(text)] = code + text
    b[510:512] = b"\x55\xAA"
    return bytes(b)

def set_fat(fat, n, val):
    o = n * 3 // 2
    if n % 2 == 0:
        fat[o] = val & 0xFF
        fat[o + 1] = (fat[o + 1] & 0xF0) | (val >> 8)
    else:
        fat[o] = (fat[o] & 0x0F) | ((val & 0xF) << 4)
        fat[o + 1] = val >> 4

def get_fat(fat, n):
    o = n * 3 // 2
    v = fat[o] | fat[o + 1] << 8
    return v >> 4 if n % 2 else v & 0xFFF

def build(files):
    img = bytearray(TOTAL * SECTOR)
    img[0:SECTOR] = make_boot()
    fat = bytearray(FAT_SECTORS * SECTOR)
    fat[0:3] = b"\xF0\xFF\xFF"
    root = bytearray(ROOT_ENTRIES * 32)
    root[0:11] = b"KDPDONGLE  "
    root[11] = 0x08
    date = ((2026 - 1980) << 9) | (11 << 5) | 2
    nxt = 2
    for i, (name, data) in enumerate(files, start=1):
        base, ext = name.split(".")
        n = max(1, -(-len(data) // SECTOR))
        for k in range(n):
            set_fat(fat, nxt + k, nxt + k + 1 if k < n - 1 else 0xFFF)
        off = (DATA_START + nxt - 2) * SECTOR
        img[off:off + len(data)] = data
        e = bytearray(32)
        e[0:11] = (base.ljust(8) + ext.ljust(3)).encode("ascii")
        e[11] = 0x20
        struct.pack_into("<HHH", e, 18, date, 0, 0)       
        struct.pack_into("<HHI", e, 24, date, nxt, len(data))
        root[i * 32:i * 32 + 32] = e
        nxt += n
    for k in range(2):
        o = (1 + k * FAT_SECTORS) * SECTOR
        img[o:o + len(fat)] = fat
    o = (1 + 2 * FAT_SECTORS) * SECTOR
    img[o:o + len(root)] = root
    return bytes(img)

def read_files(img):
    fat = img[SECTOR:SECTOR + FAT_SECTORS * SECTOR]
    root = img[(1 + 2 * FAT_SECTORS) * SECTOR:(1 + 2 * FAT_SECTORS) * SECTOR + ROOT_ENTRIES * 32]
    out = {}
    for i in range(ROOT_ENTRIES):
        e = root[i * 32:i * 32 + 32]
        if e[0] in (0, 0xE5) or e[11] & 0x08:
            continue
        name = (e[0:8].decode().rstrip() + "." + e[8:11].decode().rstrip())
        cl, size = struct.unpack_from("<H", e, 26)[0], struct.unpack_from("<I", e, 28)[0]
        data = b""
        while cl < 0xFF8:
            o = (DATA_START + cl - 2) * SECTOR
            data += img[o:o + SECTOR]
            cl = get_fat(fat, cl)
        out[name] = data[:size]
    return out

BAS = "\r\n".join([
    '10 REM MAIN.BAS - KDP profile and a software-dongle check',
    '20 ID$="KDPMember:KL5UQ4f48673352"',
    '30 S=0',
    '40 FOR I=1 TO LEN(ID$)',
    '50 S=S*31+ASC(MID$(ID$,I,1))',
    '60 S=S-INT(S/65521)*65521',
    '70 NEXT I',
    '80 KEY=12272',
    '90 PRINT "=== KDP Forum Profile ==="',
    '100 PRINT "Nickname : ";ID$',
    '110 PRINT "Code     : ";MID$(ID$,11)',
    '120 PRINT "Role     : Member"',
    '130 PRINT "Points   :";1',
    '140 IF S=KEY THEN PRINT "Dongle   : OK" ELSE PRINT "Dongle   : WRONG KEY"',
    '150 END', ''])

if __name__ == "__main__":
    out = sys.argv[1] if len(sys.argv) > 1 else "dongle.img"
    exe_path = sys.argv[2] if len(sys.argv) > 2 else None
    exe = make_exe()
    files = [("AUTOEXEC.BAT", b"@ECHO OFF\r\nMAIN.EXE\r\n"), ("MAIN.EXE", exe),
             ("MAIN.BAS", BAS.encode("ascii"))]
    img = build(files)
    open(out, "wb").write(img)
    if exe_path:
        open(exe_path, "wb").write(exe)
    print("Wrote %s with embedded 0x48 real-mode modifier." % out)
