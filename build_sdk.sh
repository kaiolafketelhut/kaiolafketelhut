#!/usr/bin/env bash

# Default compilation architecture mode
ARCH_FLAG="-DTARGET_ARCH_16"

if [ "$1" == "--x64" ]; then
    echo "[*] Configuring build parameters for x64 architecture..."
    ARCH_FLAG="-DTARGET_ARCH_X64"
else
    echo "[*] Configuring build parameters for 16-Bit architecture..."
fi

echo "[*] Compiling SDK.c with clang..."
clang $ARCH_FLAG SDK.c -o sdk_test

if [ $? -eq 0 ]; then
    echo "[+] Build complete. Running verification test:"
    ./sdk_test
else
    echo "[-] Error: Compilation failed."
fi
