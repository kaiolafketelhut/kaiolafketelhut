; main.asm - KDP profile, 16-bit DOS .COM, NASM
; build: nasm -f bin main.asm -o kdp.com
%macro puts 1
        mov     dx, %1
        mov     ah, 9           ; DOS print $-terminated string
        int     21h
%endmacro

        org     100h
        puts    hdr
        puts    l_nick
        puts    pre
        puts    code
        puts    l_code
        puts    code            ; short code = the part after the prefix
        puts    l_role
        puts    l_pts
        mov     ax, 4C00h       ; exit
        int     21h

hdr:    db "=== KDP Forum Profile ===", 13, 10, "$"
l_nick: db "Nickname : $"
pre:    db "KDPMember:$"
code:   db "KL5UQ4f48673352", 13, 10, "$"
l_code: db "Code     : $"
l_role: db "Role     : Member", 13, 10, "$"
l_pts:  db "Points   : 1", 13, 10, "$"
