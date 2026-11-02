#!/usr/bin/env python3
"""main.py - write main.PDF with the KDP profile (pure Python, no libraries).

usage: python3 main.py [output.pdf]      default: main.PDF
"""
import sys

ID = "KDPMember:KL5UQ4f48673352"
LINES = [
    "=== KDP Forum Profile ===",
    "Nickname : " + ID,
    "Code     : " + ID[len("KDPMember:"):],
    "Role     : Member",
    "Points   : 1",
    "",
    "MIME     : application/pdf",
]


def esc(s):
    return s.replace("\\", "\\\\").replace("(", "\\(").replace(")", "\\)")


def build(lines):
    text = "BT /F1 12 Tf 72 720 Td 18 TL\n"
    text += "".join("(%s) Tj T*\n" % esc(l) for l in lines) + "ET\n"
    objs = [
        "<< /Type /Catalog /Pages 2 0 R >>",
        "<< /Type /Pages /Kids [3 0 R] /Count 1 >>",
        "<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] "
        "/Resources << /Font << /F1 4 0 R >> >> /Contents 5 0 R >>",
        "<< /Type /Font /Subtype /Type1 /BaseFont /Courier >>",
        "<< /Length %d >>\nstream\n%sendstream" % (len(text.encode("latin-1")), text),
        "<< /Title (KDP profile) /Author (Kai Ketelhut) >>",
    ]
    out = bytearray(b"%PDF-1.4\n")
    offsets = []
    for i, body in enumerate(objs, 1):
        offsets.append(len(out))
        out += ("%d 0 obj\n%s\nendobj\n" % (i, body)).encode("latin-1")
    xref = len(out)
    out += ("xref\n0 %d\n0000000000 65535 f \n" % (len(objs) + 1)).encode()
    for o in offsets:
        out += ("%010d 00000 n \n" % o).encode()
    out += ("trailer\n<< /Size %d /Root 1 0 R /Info 6 0 R >>\nstartxref\n%d\n%%%%EOF\n"
            % (len(objs) + 1, xref)).encode()
    return bytes(out)


if __name__ == "__main__":
    path = sys.argv[1] if len(sys.argv) > 1 else "main.PDF"
    data = build(LINES)
    open(path, "wb").write(data)
    print("wrote %s (%d bytes)" % (path, len(data)))
