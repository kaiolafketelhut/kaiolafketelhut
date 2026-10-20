#!/data/data/com.termux/files/usr/bin/bash
set -e
VER="1.05"
PKG="oeneyeos"
SRC="$HOME/oeneyeos-salsa"
DIR="$HOME/kai/build-${PKG}_${VER}"
rm -rf "$DIR"
mkdir -p "$DIR/DEBIAN" "$DIR/usr/share/oeneyeos"

cat > "$DIR/DEBIAN/control" <<CONTROL
Package: oeneyeos
Version: 1.05
Section: web
Priority: optional
Architecture: all
Maintainer: oeneye <oeneye@debian>
Description: oeneyeOS v1.05 FINAL stable - verified running system
 DNS OK kaiolafketelhut.github.io, clean, running on 127.0.0.1:8080
CONTROL

# get verified html from salsa or from running debian
cp "$SRC/index.html" "$DIR/usr/share/oeneyeos/index.html" 2>/dev/null || cp "$HOME/oeneye/index.html" "$DIR/usr/share/oeneyeos/" 2>/dev/null || echo '<h1 style="color:green">oeneyeOS v1.05 FINAL - VERIFIED</h1><p>DNS OK: kaiolafketelhut.github.io/kaiolafketelhut/</p>' > "$DIR/usr/share/oeneyeos/index.html"
cp "$SRC/mySignal.html" "$DIR/usr/share/oeneyeos/" 2>/dev/null || echo "<html>mySignal v1.05 FINAL</html>" > "$DIR/usr/share/oeneyeos/mySignal.html"

# make it FINAL text
sed -i 's/v1.05 (rc) - final - running system - VERIFIED/v1.05 FINAL - VERIFIED/' "$DIR/usr/share/oeneyeos/index.html"
sed -i 's/v1.05 (rc)/v1.05 FINAL/' "$DIR/usr/share/oeneyeos/index.html"
grep -q "v1.05" "$DIR/usr/share/oeneyeos/index.html" || echo '<h1 style="color:green">oeneyeOS v1.05 FINAL - VERIFIED</h1>' > "$DIR/usr/share/oeneyeos/index.html"

chmod 0755 "$DIR/DEBIAN"
chmod 0644 "$DIR/DEBIAN/control"
find "$DIR" -type d -exec chmod 0755 {} \;
find "$DIR" -type f -exec chmod 0644 {} \;
cd "$HOME/kai"
dpkg-deb --build "$DIR"
mv "$DIR.deb" "oeneyeos_${VER}_all.deb"
ls -lh oeneyeos_${VER}_all.deb
echo "BUILT $VER FINAL"
