10 REM KDP profile in classic BASIC
20 ID$ = "KDPMember:KL5UQ4f48673352"
30 ROLE$ = "Member"
40 POINTS = 1
50 P$ = "KDPMember:"
60 REM The short code after the "KDPMember:" prefix
70 IF LEFT$(ID$, LEN(P$)) = P$ THEN CODE$ = MID$(ID$, LEN(P$) + 1) ELSE CODE$ = ID$
80 PRINT "=== KDP Forum Profile ==="
90 PRINT "Nickname : "; ID$
100 PRINT "Code     : "; CODE$
110 PRINT "Role     : "; ROLE$
120 PRINT "Points   :"; POINTS
130 END
