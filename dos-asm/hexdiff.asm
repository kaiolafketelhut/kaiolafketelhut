; hexdiff.asm - hex diff of two files, DOS .COM (NASM)
; build: nasm -f bin hexdiff.asm -o HEXDIFF.COM
; usage: HEXDIFF file1 file2
; prints "OOOOOOOO AA BB" (offset, byte 1, byte 2, hex) for each differing byte
        bits    16
        org     100h

start:
        mov     si, 81h                 ; command tail in the PSP
        call    skipsp
        mov     al, [si]
        cmp     al, 13
        je      usage
        or      al, al
        jz      usage
        mov     [name1], si
        call    endtok
        call    skipsp
        mov     al, [si]
        cmp     al, 13
        je      usage
        or      al, al
        jz      usage
        mov     [name2], si
        call    endtok

        mov     dx, [name1]
        mov     ax, 3D00h               ; AH=3Dh open, AL=0 read-only
        int     21h
        jc      err_open
        mov     [h1], ax
        mov     dx, [name2]
        mov     ax, 3D00h
        int     21h
        jc      err_open
        mov     [h2], ax

next:
        mov     bx, [h1]
        mov     cx, 1
        mov     dx, buf1
        mov     ah, 3Fh                 ; AH=3Fh read one byte
        int     21h
        jc      err_read
        mov     [n1], ax
        mov     bx, [h2]
        mov     cx, 1
        mov     dx, buf2
        mov     ah, 3Fh
        int     21h
        jc      err_read
        mov     [n2], ax

        mov     ax, [n1]
        or      ax, [n2]
        jz      done                    ; both at end of file
        cmp     word [n1], 0
        je      lenmis
        cmp     word [n2], 0
        je      lenmis
        mov     al, [buf1]
        cmp     al, [buf2]
        je      same

        inc     word [diffs]
        call    poff
        mov     dl, ' '
        call    putc
        mov     al, [buf1]
        call    pbyte
        mov     dl, ' '
        call    putc
        mov     al, [buf2]
        call    pbyte
        call    crlf
same:
        add     word [off_lo], 1
        adc     word [off_hi], 0
        jmp     next

lenmis:
        mov     dx, m_len
        mov     ah, 9
        int     21h
        call    poff
        call    crlf
        inc     word [diffs]

done:
        mov     bx, [h1]
        mov     ah, 3Eh                 ; AH=3Eh close
        int     21h
        mov     bx, [h2]
        mov     ah, 3Eh
        int     21h
        mov     dx, m_diffs
        mov     ah, 9
        int     21h
        mov     ax, [diffs]
        call    pword
        call    crlf
        mov     al, 0
        cmp     word [diffs], 0
        je      .ok
        mov     al, 1
.ok:    mov     ah, 4Ch
        int     21h

usage:
        mov     dx, m_usage
        mov     ah, 9
        int     21h
        mov     ax, 4C02h
        int     21h
err_open:
        mov     dx, m_open
        mov     ah, 9
        int     21h
        mov     ax, 4C03h
        int     21h
err_read:
        mov     dx, m_read
        mov     ah, 9
        int     21h
        mov     ax, 4C04h
        int     21h

; --- helpers ---
skipsp: cmp     byte [si], ' '
        jne     .r
        inc     si
        jmp     skipsp
.r:     ret

endtok: mov     al, [si]                ; end the token at SI with a 0
        cmp     al, ' '
        je      .nul
        cmp     al, 13
        je      .nul
        or      al, al
        jz      .ret
        inc     si
        jmp     endtok
.nul:   mov     byte [si], 0
        cmp     al, ' '
        jne     .ret
        inc     si
.ret:   ret

putc:   mov     ah, 2
        int     21h
        ret

crlf:   mov     dl, 13
        call    putc
        mov     dl, 10
        call    putc
        ret

pbyte:  push    ax                      ; print AL as 2 hex digits
        shr     al, 4
        call    pnib
        pop     ax
        and     al, 0Fh
pnib:   add     al, '0'
        cmp     al, '9'
        jbe     .p
        add     al, 7
.p:     mov     dl, al
        mov     ah, 2
        int     21h
        ret

pword:  push    ax                      ; print AX as 4 hex digits
        mov     al, ah
        call    pbyte
        pop     ax
        call    pbyte
        ret

poff:   mov     ax, [off_hi]            ; print 32-bit offset as 8 hex digits
        call    pword
        mov     ax, [off_lo]
        call    pword
        ret

name1   dw      0
name2   dw      0
h1      dw      0
h2      dw      0
n1      dw      0
n2      dw      0
off_lo  dw      0
off_hi  dw      0
diffs   dw      0
buf1    db      0
buf2    db      0
m_usage db      'usage: HEXDIFF file1 file2', 13, 10, '$'
m_open  db      'cannot open file', 13, 10, '$'
m_read  db      'read error', 13, 10, '$'
m_len   db      'length differs at ', '$'
m_diffs db      'DIFFS: $'
