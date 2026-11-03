#!/usr/bin/env bash
ARCH_FLAG="-DTARGET_ARCH_16"
if [ "$1" == "--x64" ]; then
    echo "[*] OMQ Font Engine: Activating 64-bit Core Typographic Engine..."
    ARCH_FLAG="-DTARGET_ARCH_X64"
fi
clang $ARCH_FLAG SDK.c -o sdk_test
if [ $? -eq 0 ]; then
    echo "[+] Subsystem compiled successfully. Executing verification trace:"
    ./sdk_test
fi
