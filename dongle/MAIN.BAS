10 REM MAIN.BAS - KDP profile and a software-dongle check
20 ID$="KDPMember:KL5UQ4f48673352"
30 S=0
40 FOR I=1 TO LEN(ID$)
50 S=S*31+ASC(MID$(ID$,I,1))
60 S=S-INT(S/65521)*65521
70 NEXT I
80 KEY=12272
90 PRINT "=== KDP Forum Profile ==="
100 PRINT "Nickname : ";ID$
110 PRINT "Code     : ";MID$(ID$,11)
120 PRINT "Role     : Member"
130 PRINT "Points   :";1
140 IF S=KEY THEN PRINT "Dongle   : OK, key ";MID$(STR$(S),2) ELSE PRINT "Dongle   : WRONG KEY ";MID$(STR$(S),2)
150 END
