#!/usr/bin/env python3
import os
FAX="FAX by oeneye.c + oeneyepdf.c - PL:36883 - 1+0=1"
os.makedirs("MOSFETQexchange/spool/vnc",exist_ok=True)
for i in range(3): open(f"MOSFETQexchange/spool/vnc/frame_{i:06d}.IMC","w").write(f"{FAX}\nframe={i} g=0\n")
print(FAX)
