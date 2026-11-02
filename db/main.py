#!/usr/bin/env python3
"""main.py - build main.sqlite from main.sql and print the profile (stdlib sqlite3).

usage: python3 main.py [database]      default: main.sqlite next to this script
"""
import os
import sqlite3
import sys

here = os.path.dirname(os.path.abspath(__file__))
db = sys.argv[1] if len(sys.argv) > 1 else os.path.join(here, "main.sqlite")
if os.path.exists(db):
    os.remove(db)
con = sqlite3.connect(db)
con.executescript(open(os.path.join(here, "main.sql")).read())
con.commit()
nick, code, role, points = con.execute(
    "SELECT nickname, code, role, points FROM profile").fetchone()
print("=== KDP Forum Profile ===")
print("Nickname : " + nick)
print("Code     : " + code)
print("Role     : " + role)
print("Points   : %d" % points)
print("(%s, %d bytes)" % (db, os.path.getsize(db)))
con.close()
