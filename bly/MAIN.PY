#!/usr/bin/env python3
"""MAIN.PY - read main.bly (XML, SI units) and solve the ideal transformer.

usage: python3 MAIN.PY [main.bly]      (same output as: xsltproc main.xsl main.bly)
Checks every unit attribute against the SI unit this script expects.
"""
import math
import os
import sys
import xml.etree.ElementTree as ET

EXPECT = {
    "primary_turns": "1", "secondary_turns": "1", "core_relative_permeability": "1",
    "leakage_inductance": "H", "saturation_flux": "T", "core_area": "m2",
    "frequency": "Hz", "primary_voltage": "V", "load_power": "W",
}

here = os.path.dirname(os.path.abspath(__file__))
path = sys.argv[1] if len(sys.argv) > 1 else os.path.join(here, "main.bly")
root = ET.parse(path).getroot()

p = root.find("profile")
print("=== KDP Forum Profile ===")
print("Nickname : " + p.findtext("nickname"))
print("Code     : " + p.findtext("code"))
print("Role     : " + p.findtext("role"))
print("Points   : " + p.findtext("points"))

for t in root.findall("trafo"):
    v = {}
    for tag, unit in EXPECT.items():
        el = t.find(tag)
        if el is None:
            sys.exit("trafo %s: missing <%s>" % (t.get("id"), tag))
        if el.get("unit") != unit:
            sys.exit("trafo %s: <%s> must be in unit %r, found %r"
                     % (t.get("id"), tag, unit, el.get("unit")))
        v[tag] = float(el.text)
    a = v["primary_turns"] / v["secondary_turns"]
    vs = v["primary_voltage"] / a
    bpk = v["primary_voltage"] / (4.44 * v["frequency"] * v["primary_turns"] * v["core_area"])
    xlk = 2 * math.pi * v["frequency"] * v["leakage_inductance"]
    bsat = v["saturation_flux"]
    print()
    print("--- trafo %s (SI units) ---" % t.get("id"))
    print("turns ratio a = Np/Ns : %.4f (1)" % a)
    print("secondary voltage Vs  : %.4f V" % vs)
    print("primary current Ip    : %.4f A" % (v["load_power"] / v["primary_voltage"]))
    print("secondary current Is  : %.4f A" % (v["load_power"] / vs))
    print("leakage reactance Xlk : %.6f ohm" % xlk)
    print("peak core flux Bpk    : %.4f T (limit %g T)" % (bpk, bsat))
    print("saturation margin     : %.4f T - %s"
          % (bsat - bpk, "OK" if bpk < bsat else "SATURATED"))
