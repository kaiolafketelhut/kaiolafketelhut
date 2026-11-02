#!/usr/bin/env python3
"""main.py - write the KDP profile as main.md, MAIN.csv, MAIN.TOML and main.ZIP, then check them.

usage: python3 main.py       (files are written next to this script)
"""
import csv
import os
import zipfile

ID = "KDPMember:KL5UQ4f48673352"
CODE = ID[len("KDPMember:"):]
ROLE, POINTS = "Member", 1
here = os.path.dirname(os.path.abspath(__file__))


def path(name):
    return os.path.join(here, name)


with open(path("main.md"), "w", newline="\n") as f:
    f.write("# KDP Forum Profile\n\n"
            "| Field | Value |\n|---|---|\n"
            "| Nickname | `%s` |\n| Code | `%s` |\n| Role | %s |\n| Points | %d |\n"
            % (ID, CODE, ROLE, POINTS))

with open(path("MAIN.csv"), "w", newline="") as f:
    w = csv.writer(f)
    w.writerow(["nickname", "code", "role", "points"])
    w.writerow([ID, CODE, ROLE, POINTS])

with open(path("MAIN.TOML"), "w", newline="\n") as f:
    f.write('# MAIN.TOML - KDP profile\n[profile]\nnickname = "%s"\ncode = "%s"\n'
            'role = "%s"\npoints = %d\n' % (ID, CODE, ROLE, POINTS))

with zipfile.ZipFile(path("main.ZIP"), "w", zipfile.ZIP_DEFLATED) as z:
    for name in ("main.md", "MAIN.csv", "MAIN.TOML"):
        z.write(path(name), name)

# --- check everything and print the profile from each file ---
print("=== KDP Forum Profile ===")
with open(path("MAIN.csv"), newline="") as f:
    row = list(csv.DictReader(f))[0]
print("csv  : %s | %s | %s | %s" % (row["nickname"], row["code"], row["role"], row["points"]))
try:
    import tomllib
    with open(path("MAIN.TOML"), "rb") as f:
        t = tomllib.load(f)["profile"]
    print("toml : %s | %s | %s | %s" % (t["nickname"], t["code"], t["role"], t["points"]))
except ImportError:
    print("toml : written (tomllib needs Python 3.11+ to check it)")
with zipfile.ZipFile(path("main.ZIP")) as z:
    print("zip  : %s (testzip: %s)" % (", ".join(z.namelist()), z.testzip() or "OK"))
print("md   : %d bytes" % os.path.getsize(path("main.md")))
