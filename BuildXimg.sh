#!/data/data/com.termux/files/usr/bin/bash
set -e
APP=${1:-oeneye-ada}
SRC_DIR=${2:-.}
OUT="${APP}.ximg"
WORK=".ximg-build-${APP}"
echo "[*] Building ${OUT} (A+B+C) MIME: application/vnd.oeneye.ximg+ada"
rm -rf "$WORK"; mkdir -p "$WORK/src" "$WORK/obj" "$WORK/assets" "$WORK/bin"
find "$SRC_DIR" -maxdepth 2 -type f \( -name "*.adb" -o -name "*.ads" -o -name "*.ada" \) -exec cp -v {} "$WORK/src/" \; 2>/dev/null || true
if command -v gnatmake >/dev/null 2>&1; then
  MAIN=$(ls "$SRC_DIR"/main.adb "$SRC_DIR"/*_main.adb 2>/dev/null | head -1)
  [ -n "$MAIN" ] && gnatmake -D "$WORK/obj" -o "$WORK/bin/${APP}" "$MAIN" || echo "[B] build failed, packing sources only"
fi
cat > "$WORK/MIME.manifest" <<MAN
type=application/vnd.oeneye.ximg+ada
fallback=application/x-ximg+ada
contains: src=text/x-ada obj=application/x-gnat-ali assets=application/x-iso9660-image
app=${APP}
created=$(date -u +%Y-%m-%dT%H:%M:%SZ)
MAN
tar -cf "${OUT}.tar" -C "$WORK" .
printf "XIMG" | dd of="${OUT}.tar" bs=1 seek=0 conv=notrunc status=none 2>/dev/null
mv "${OUT}.tar" "$OUT"
sha256sum "$OUT" | tee "${OUT}.sha256"
ls -lh "$OUT"; file "$OUT"
rm -rf "$WORK"
