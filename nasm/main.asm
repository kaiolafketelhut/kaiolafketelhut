; main.asm - KDP profile, x86-64 Linux, NASM
; build: nasm -f elf64 main.asm -o main.o && x86_64-linux-gnu-ld main.o -o kdp
global _start

%macro out 2
        mov     eax, 1          ; sys_write
        mov     edi, 1          ; stdout
        mov     rsi, %1
        mov     edx, %2
        syscall
%endmacro

section .data
hdr:    db "=== KDP Forum Profile ===", 10
hdr_n   equ $-hdr
nick:   db "Nickname : "
nick_n  equ $-nick
id:     db "KDPMember:KL5UQ4f48673352", 10
id_n    equ $-id
code:   db "Code     : "
code_n  equ $-code
role:   db "Role     : Member", 10
role_n  equ $-role
pts:    db "Points   : 1", 10
pts_n   equ $-pts

section .text
_start:
        out     hdr, hdr_n
        out     nick, nick_n
        out     id, id_n
        out     code, code_n
        out     id+10, id_n-10  ; short code = id after the 10-char prefix
        out     role, role_n
        out     pts, pts_n
        mov     eax, 60         ; sys_exit
        xor     edi, edi
        syscall
