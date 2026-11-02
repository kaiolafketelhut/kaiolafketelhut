// main.s - KDP profile in AArch64 assembly (calls libc printf)
// build: clang -o kdp_asm main.s

        .section .rodata
id:         .asciz "KDPMember:KL5UQ4f48673352"
role:       .asciz "Member"
hdr:        .asciz "=== KDP Forum Profile ==="
fmt_nick:   .asciz "Nickname : %s\n"
fmt_code:   .asciz "Code     : %s\n"
fmt_role:   .asciz "Role     : %s\n"
fmt_pts:    .asciz "Points   : %d\n"

        .text
        .globl  main
main:
        stp     x29, x30, [sp, #-16]!
        mov     x29, sp

        adrp    x0, hdr
        add     x0, x0, :lo12:hdr
        bl      puts

        adrp    x0, fmt_nick
        add     x0, x0, :lo12:fmt_nick
        adrp    x1, id
        add     x1, x1, :lo12:id
        bl      printf

        // short code = id + 10 (skips the 10 characters of "KDPMember:")
        adrp    x0, fmt_code
        add     x0, x0, :lo12:fmt_code
        adrp    x1, id
        add     x1, x1, :lo12:id
        add     x1, x1, #10
        bl      printf

        adrp    x0, fmt_role
        add     x0, x0, :lo12:fmt_role
        adrp    x1, role
        add     x1, x1, :lo12:role
        bl      printf

        adrp    x0, fmt_pts
        add     x0, x0, :lo12:fmt_pts
        mov     w1, #1
        bl      printf

        mov     w0, #0
        ldp     x29, x30, [sp], #16
        ret
