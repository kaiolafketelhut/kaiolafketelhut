#!/usr/bin/env python3
"""main_cpu.py - read MAIN.BDF, check it, and solve the one-rod model on the CPU.

usage: python3 main_cpu.py [MAIN.BDF]
Handles only what MAIN.BDF uses: free-format GRID, CROD, PROD, MAT1, FORCE.
Result: u = F*L / (A*E)   (axial elongation of the rod)
"""
import math
import sys

path = sys.argv[1] if len(sys.argv) > 1 else "MAIN.BDF"
lines = [l.rstrip("\n") for l in open(path)]

# 1. the profile lines live in $ comments
for l in lines:
    if l.startswith("$ ") and " : " in l:
        print(l[2:])

# 2. structure check
text = "\n".join(lines)
for word in ("CEND", "BEGIN BULK", "ENDDATA"):
    if word not in text:
        sys.exit("BDF check failed: missing " + word)
cards = {}
for l in lines[lines.index("BEGIN BULK") + 1:]:
    if l.startswith("$") or not l.strip() or l.strip() == "ENDDATA":
        continue
    f = [x.strip() for x in l.split(",")]
    cards.setdefault(f[0], []).append(f[1:])


def num(s):
    return float(s) if s else 0.0


grids = {int(c[0]): [num(x) for x in c[2:5]] for c in cards["GRID"]}
rod = cards["CROD"][0]
pid, g1, g2 = int(rod[1]), int(rod[2]), int(rod[3])
for g in (g1, g2):
    if g not in grids:
        sys.exit("BDF check failed: CROD uses missing GRID %d" % g)
area = next(num(c[2]) for c in cards["PROD"] if int(c[0]) == pid)
mid = next(int(c[1]) for c in cards["PROD"] if int(c[0]) == pid)
young = next(num(c[1]) for c in cards["MAT1"] if int(c[0]) == mid)
length = math.dist(grids[g1], grids[g2])
force = next(num(c[3]) for c in cards["FORCE"] if int(c[1]) == g2)

u = force * length / (area * young)
print("BDF check: OK (%d GRID, %d CROD, %d PROD, %d MAT1)"
      % (len(cards["GRID"]), len(cards["CROD"]), len(cards["PROD"]), len(cards["MAT1"])))
print("rod      : L=%g  A=%g  E=%g  F=%g" % (length, area, young, force))
print("CPU      : u(grid %d) = %.6E" % (g2, u))
