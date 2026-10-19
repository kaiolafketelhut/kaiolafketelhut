#!/bin/bash
nasm -f bin stage2.asm -o stage2.bin
cat boot.bin stage2.bin > oeneyeOS.img
truncate -s 1474560 oeneyeOS.img
dd if=/dev/zero of=data.img bs=512 count=5760
dd if=stage2.bin of=data.img bs=512 seek=1 conv=notrunc
ls -lh
