; main.asm - KDP profile, Z80 CP/M .COM (zmac / sjasmplus syntax)
BDOS    equ 5
        org 100h
        ld  de, hdr
        call puts
        ld  de, l_nick
        call puts
        ld  de, pre
        call puts
        ld  de, code
        call puts
        ld  de, l_code
        call puts
        ld  de, code            ; short code = the part after the prefix
        call puts
        ld  de, l_role
        call puts
        ld  de, l_pts
        call puts
        rst 0

puts:   ld  c, 9                ; BDOS print $-terminated string
        call BDOS
        ret

hdr:    db "=== KDP Forum Profile ===", 13, 10, '$'
l_nick: db "Nickname : $"
pre:    db "KDPMember:$"
code:   db "KL5UQ4f48673352", 13, 10, '$'
l_code: db "Code     : $"
l_role: db "Role     : Member", 13, 10, '$'
l_pts:  db "Points   : 1", 13, 10, '$'
