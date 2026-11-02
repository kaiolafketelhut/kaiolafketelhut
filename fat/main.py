#!/usr/bin/env python3
"""main.py - KDP profile on a tiny FAT12 image (pure Python, no mtools needed).

usage: python3 main.py [image] [sectors]    default: kdp.img, 32 sectors = 16 KiB
Layout: boot | FAT1 | FAT2 | root dir (16 entries) | data (cluster 2 = first data sector)
"""
import struct
import sys

PREFIX = "KDPMember:"
ME = {"id": "KDPMember:KL5UQ4f48673352", "role": "Member", "points": 1}
SECTOR = 512


def short_code(i):
    return i[len(PREFIX):] if i.startswith(PREFIX) else i


def profile_text():
    lines = [
        "=== KDP Forum Profile ===",
        "Nickname : " + ME["id"],
        "Code     : " + short_code(ME["id"]),
        "Role     : " + ME["role"],
        "Points   : %d" % ME["points"],
    ]
    return ("\r\n".join(lines) + "\r\n").encode("ascii")


def build_image(sectors, name=b"KDP     ", ext=b"TXT"):
    fat_sectors, root_entries, reserved = 1, 16, 1
    root_sectors = root_entries * 32 // SECTOR
    data_start = reserved + 2 * fat_sectors + root_sectors
    clusters = sectors - data_start
    if clusters < 2 or clusters >= 4085:
        raise SystemExit("sectors must give 2..4084 clusters (FAT12)")
    if (clusters + 2) * 3 // 2 > fat_sectors * SECTOR:
        raise SystemExit("FAT too small for this size")

    img = bytearray(sectors * SECTOR)

    # boot sector (BPB)
    boot = bytearray(SECTOR)
    boot[0:3] = b"\xEB\x3C\x90"
    boot[3:11] = b"KDPFAT12"
    struct.pack_into("<HBHBHHBHHHII", boot, 11,
                     SECTOR, 1, reserved, 2, root_entries, sectors,
                     0xF8, fat_sectors, 32, 2, 0, 0)
    struct.pack_into("<BBBI11s8s", boot, 36, 0x80, 0, 0x29, 0x4B445046,
                     b"KDPFAT     ", b"FAT12   ")
    boot[510:512] = b"\x55\xAA"
    img[0:SECTOR] = boot

    # file data in cluster 2 (profile is < 512 bytes)
    data = profile_text()
    assert len(data) <= SECTOR
    img[data_start * SECTOR:data_start * SECTOR + len(data)] = data

    # FAT: media, end-of-chain markers, cluster 2 = end of file
    fat = bytearray(fat_sectors * SECTOR)
    # entries 0,1,2 = 0xFF8, 0xFFF, 0xFFF packed as 12-bit values
    fat[0:5] = bytes([0xF8, 0xFF, 0xFF, 0xFF, 0x0F])
    for k in range(2):
        off = (reserved + k * fat_sectors) * SECTOR
        img[off:off + len(fat)] = fat

    # root directory: volume label + file entry
    root = (reserved + 2 * fat_sectors) * SECTOR
    entry = bytearray(32)
    entry[0:11] = b"KDPFAT     "
    entry[11] = 0x08                # volume label
    img[root:root + 32] = entry
    entry = bytearray(32)
    entry[0:8], entry[8:11] = name, ext
    entry[11] = 0x20                # archive
    struct.pack_into("<H", entry, 26, 2)       # first cluster
    struct.pack_into("<I", entry, 28, len(data))
    img[root + 32:root + 64] = entry
    return bytes(img)


def read_root(img):
    """Return {NAME.EXT: bytes} for the files in the root directory."""
    (bps, spc, rsv, nfat, nroot, tot, _m, fsz) = struct.unpack_from("<HBHBHHBH", img, 11)
    root = (rsv + nfat * fsz) * bps
    dstart = rsv + nfat * fsz + nroot * 32 // bps
    files = {}
    for k in range(nroot):
        e = img[root + k * 32:root + k * 32 + 32]
        if e[0] in (0, 0xE5) or e[11] & 0x08:
            continue
        nm = e[0:8].decode().rstrip() + "." + e[8:11].decode().rstrip()
        cl, size = struct.unpack_from("<H", e, 26)[0], struct.unpack_from("<I", e, 28)[0]
        off = (dstart + (cl - 2) * spc) * bps
        files[nm] = img[off:off + size]
    return files


def main():
    path = sys.argv[1] if len(sys.argv) > 1 else "kdp.img"
    sectors = int(sys.argv[2]) if len(sys.argv) > 2 else 32
    img = build_image(sectors)
    with open(path, "wb") as f:
        f.write(img)
    print("--- %s (%d KiB, FAT12) ---" % (path, len(img) // 1024))
    files = read_root(open(path, "rb").read())
    for nm, d in files.items():
        print("%-12s %6d bytes" % (nm, len(d)))
    print("--- KDP.TXT ---")
    print(files["KDP.TXT"].decode("ascii").replace("\r\n", "\n"), end="")


if __name__ == "__main__":
    main()
