#!/bin/bash
# oeneyeOS Auto-Response Handler (AH) - Safe Parser & Hexdiff Support
# Usage: ./ah_engine.sh <trigger> [-httpx <url>] [-auto _auto] [-auto-hexdiff -X]

INPUT_TRIGGER="$1"
shift
RULE_DIR="suomidb/rules"

mkdir -p "$RULE_DIR"

echo "[*] Processing trigger: '$INPUT_TRIGGER'"

TARGET_URL=""
AUTO_MODE=0
HEXDIFF_MODE=0

# Parse remaining arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -httpx) TARGET_URL="$2"; shift ;;
        -auto) [ "$2" = "_auto" ] && AUTO_MODE=1; shift ;;
        -auto-hexdiff) [ "$2" = "-X" ] && HEXDIFF_MODE=1; shift ;;
    esac
    shift
done

if [ "$HEXDIFF_MODE" -eq 1 ]; then
    echo "[*] Auto-hexdiff mode activated (-X): generating binary diff signature..."
    echo "--- Hexdiff Payload Signature ---"
    printf "TARGET: %s\n" "${TARGET_URL:-local_stream}"
    hexdump -C <<< "$INPUT_TRIGGER" 2>/dev/null || od -A x -t x1 -c <<< "$INPUT_TRIGGER"
    echo "---------------------------------"
    exit 0
fi

if [ -n "$TARGET_URL" ]; then
    echo "[*] Querying target via HTTPS: $TARGET_URL"
    FETCHED_CONTENT=$(curl -sL "$TARGET_URL")
    if [ $? -eq 0 ]; then
        echo "[+] Successfully fetched content."
        echo "--- Content Preview ---"
        echo "$FETCHED_CONTENT" | head -n 8
        echo "-----------------------"
    else
        echo "[-] Failed to retrieve content from $TARGET_URL"
    fi
    exit 0
fi

# Safe rule lookup using grep/cut instead of source
RESPONDED=0
for rule in "$RULE_DIR"/*.cfg; do
    if [ -f "$rule" ]; then
        RULE_TRIGGER=$(grep '^TRIGGER=' "$rule" | cut -d'=' -f2-)
        if [ "$INPUT_TRIGGER" = "$RULE_TRIGGER" ]; then
            RULE_RESPONSE=$(grep '^RESPONSE=' "$rule" | cut -d'=' -f2-)
            echo "[+] Match found! Auto-response: $RULE_RESPONSE"
            RESPONDED=1
            break
        fi
    fi
done

if [ "$RESPONDED" -eq 0 ]; then
    echo "[-] No matching rule found for '$INPUT_TRIGGER'."
fi
