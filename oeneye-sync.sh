#!/usr/bin/env bash
set -eo pipefail

REMOTE_BASE="https://raw.githubusercontent.com/kaiolafketelhut/kaiolafketelhut/main"
TARGET_ARTIFACT="fat77.img"
MANIFEST="SHA256SUMS_v2"

echo "Fetching latest artifact manifest ($MANIFEST)..."
curl -sSL "$REMOTE_BASE/$MANIFEST" -o REMOTE_MANIFEST
tr -d '\r' < REMOTE_MANIFEST > MANIFEST_CLEAN

echo "Downloading latest verified artifact ($TARGET_ARTIFACT)..."
curl -sSL "$REMOTE_BASE/$TARGET_ARTIFACT" -o "$TARGET_ARTIFACT"

echo "--- MANIFEST CONTENTS ---"
cat MANIFEST_CLEAN
echo "-------------------------"

echo "Extracting verification entry for $TARGET_ARTIFACT..."
grep "$TARGET_ARTIFACT" MANIFEST_CLEAN > .verify.sum

echo "--- VERIFY FILE ---"
cat .verify.sum
echo "-------------------"

echo "Verifying checksum..."
if sha256sum --check .verify.sum; then
    echo "Checksum verified successfully for $TARGET_ARTIFACT!"
    rm -f .verify.sum REMOTE_MANIFEST MANIFEST_CLEAN
else
    echo "ERROR: Checksum mismatch! Verification failed for security."
    rm -f .verify.sum REMOTE_MANIFEST MANIFEST_CLEAN
    exit 1
fi
