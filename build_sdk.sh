#!/usr/bin/env bash
echo "[*] Compiling SDK.c with clang..."
clang SDK.c -o sdk_test
if [ $? -eq 0 ]; then
    echo "[+] Build complete. Running verification test:"
    ./sdk_test
else
    echo "[-] Error: Compilation failed."
fi
