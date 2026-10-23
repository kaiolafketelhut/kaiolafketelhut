#!/data/data/com.termux/files/usr/bin/bash
set -e
# BuildXimg.sh - Oeneye Ada .ximg (A+B+C)
# A = src/*.adb/.ads  text/x-ada
# B = obj/*.ali + bin  compiled GNAT
# C = assets/ + fedora iso

APP=${1:-oeneye-ada}
SRC_DIR=${2:-.}
OUT="${APP}.ximg"
WORK=".ximg-build-${APP}"

echo "[*] Building ${OUT} (A+B+C)"

rm -rf "$WORK"
mkdir -p "$WORK/src" "$WORK/obj" "$WORK/assets" "$WORK/bin"

# A - Ada sources
echo "[A] Collecting Ada sources text/x-ada"
find "$SRC_DIR" -maxdepth 2 -type f \( -name "*.adb" -o -name "*.ads" -o -name "*.ada" \) -exec cp -v {} "$WORK/src/" \; || true
ls -1 "$WORK/src/" | head

# B - Build with GNAT
echo "[B] Compiling Ada"
if command -v gprbuild >/dev/null 2>&1 && [ -f "${SRC_DIR}/${APP}.gpr" ]; then
  gprbuild -P "${SRC_DIR}/${APP}.gpr" --build-dir="$WORK/obj" || true
elif command -v gnatmake >/dev/null 2>&1; then
  # find main
  MAIN=$(ls "$SRC_DIR"/main.adb "$SRC_DIR"/*_main.adb 2>/dev/null | head -1)
  if [ -n "$MAIN" ]; then
    gnatmake -D "$WORK/obj" -o "$WORK/bin/${APP}" "$MAIN" || true
  fi
else
  echo "[!] gnat not found, will pack sources only (install: pkg install gnat)"
fi
cp -v "$WORK"/obj/*.ali "$WORK/obj/" 2>/dev/null || true
cp -v "$WORK"/obj/*.o "$WORK/obj/" 2>/dev/null || true

# C - Assets (your Fedora ISO + images)
echo "[C] Adding assets"
[ -f ~/storage/downloads/oeneye-fedora.iso ] && cp -v ~/storage/downloads/oeneye-fedora.iso "$WORK/assets/" || true
find "$SRC_DIR" -maxdepth 1 -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.pdf" \) -exec cp -v {} "$WORK/assets/" \; 2>/dev/null || true

# MIME manifest
cat > "$WORK/MIME.manifest" <<EOF
# Oeneye XIMG manifest
# MIME: application/vnd.oeneye.ximg+ada
# Contains:
#  src/* -> text/x-ada
#  obj/* -> application/x-gnat-ali
#  assets/* -> application/x-iso9660-image
#  bin/* -> application/x-executable
type=application/vnd.oeneye.ximg+ada
version=1.0
created=$(date -u +%Y-%m-%dT%H:%M:%SZ)
app=${APP}
EOF

# Pack
echo "[*] Packing ${OUT}"
tar -cf "${OUT}.tar" -C "$WORK" .
# Add XIMG magic header (4 bytes at 0)
printf "XIMG" | dd of="${OUT}.tar" bs=1 seek=0 conv=notrunc status=none
mv "${OUT}.tar" "$OUT"

# Checksums
sha256sum "$OUT" | tee "${OUT}.sha256"
ls -lh "$OUT"
file "$OUT"
echo "[*] MIME: application/vnd.oeneye.ximg+ada / application/x-ximg+ada"
echo "[*] Done: $OUT"
# cleanup
rm -rf "$WORK"
