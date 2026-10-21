# oeneye Fedora 41+ - fixed auth removed
lang en_US.UTF-8
keyboard us
timezone Europe/Berlin --utc
rootpw --iscrypted $6$REPLACE
selinux --enforcing
firewall --enabled --service=ssh
bootloader --location=mbr
clearpart --all --initlabel
autopart
%packages
gcc-gnat
gnat-gps
gprbuild
libgnat-devel
binutils
@xfce-desktop
neovim
git
python3
%end
%post
echo "oeneye installed"
%end
%post
cat > /usr/local/bin/BuildXimg.sh <<'EOB'
#!/bin/bash
set -e
APP=${1:-oeneye-ada}; SRC=${2:-/home/oeneye}; OUT="${APP}.ximg"; WORK="/tmp/.ximg-build-${APP}"
rm -rf "$WORK"; mkdir -p "$WORK/src" "$WORK/obj" "$WORK/assets" "$WORK/bin"
find "$SRC" -maxdepth 2 -type f \( -name "*.adb" -o -name "*.ads" \) -exec cp {} "$WORK/src/" \; 2>/dev/null || true
MAIN=$(ls "$SRC"/main.adb 2>/dev/null | head -1); [ -n "$MAIN" ] && gnatmake -D "$WORK/obj" -o "$WORK/bin/${APP}" "$MAIN" || true
tar -cf "${OUT}.tar" -C "$WORK" .; printf "XIMG" | dd of="${OUT}.tar" bs=1 seek=0 conv=notrunc status=none 2>/dev/null; mv "${OUT}.tar" "/home/oeneye/${OUT}"; sha256sum "/home/oeneye/${OUT}" > "/home/oeneye/${OUT}.sha256"; rm -rf "$WORK"
EOB
chmod +x /usr/local/bin/BuildXimg.sh
mkdir -p /usr/share/mime/packages
cat > /usr/share/mime/packages/oeneye-ximg.xml <<'XML'
<?xml version="1.0"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  <mime-type type="application/vnd.oeneye.ximg+ada"><comment>Oeneye Ada Image</comment><glob pattern="*.ximg"/><magic priority="50"><match type="string" value="XIMG" offset="0"/></match></mime-type>
  <mime-type type="text/x-ada"><comment>Ada source</comment><glob pattern="*.adb"/><glob pattern="*.ads"/></mime-type>
</mime-info>
XML
update-mime-database /usr/share/mime
echo "application/vnd.oeneye.ximg+ada ximg" >> /etc/mime.types
%end
