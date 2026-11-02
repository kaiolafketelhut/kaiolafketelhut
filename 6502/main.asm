; main.asm - KDP profile, 6502 (C64 PRG), 64tass
; build: 64tass -C -a main.asm -o kdp.prg
        * = $0801
        .word (+), 10           ; BASIC stub: 10 SYS 2061
        .byte $9e
        .text "2061"
        .byte 0
+       .word 0

start   ldx #0
loop    lda msg,x
        beq done
        jsr $ffd2               ; CHROUT
        inx
        bne loop
done    rts

msg     .text "=== KDP Forum Profile ===", 13
        .text "Nickname : KDPMember:KL5UQ4f48673352", 13
        .text "Code     : KL5UQ4f48673352", 13
        .text "Role     : Member", 13
        .text "Points   : 1", 13
        .byte 0
