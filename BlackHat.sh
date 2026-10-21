#!/usr/bin/env bash
set -ex
REL="44"
WORKDIR="$(pwd)"
OUT="$WORKDIR/out"
mkdir -p "$OUT"
rm -rf "$OUT/lmc"

dnf install -y lorax lorax-lmc-novirt pykickstart git anaconda-tui xorriso glibc-langpack-en

# TRY ALL POSSIBLE KICKSTART SOURCES
rm -rf /tmp/fk /tmp/kickstarts /usr/share/spin-kickstarts
mkdir -p /usr/share/spin-kickstarts

# 1) try new rpm name
dnf install -y fedora-kickstarts || true
if ls /usr/share/spin-kickstarts/*.ks 2>/dev/null; then
  echo "GOT RPM"
else
  # 2) try git from src.fedoraproject and github mirrors
  for URL in \
    https://github.com/fedoraproject/fedora-kickstarts.git \
    https://src.fedoraproject.org/rpms/fedora-kickstarts.git \
    https://pagure.io/fedora-kickstarts.git; do
    echo "Trying $URL"
    rm -rf /tmp/kickstarts
    if git clone --depth 1 --branch f44 "$URL" /tmp/kickstarts 2>/dev/null || \
       git clone --depth 1 --branch main "$URL" /tmp/kickstarts 2>/dev/null || \
       git clone --depth 1 "$URL" /tmp/kickstarts; then
      find /tmp/kickstarts -maxdepth 3 -name "*.ks" | head -n 20
      if [ -f /tmp/kickstarts/fedora-live-base.ks ]; then
        cp -a /tmp/kickstarts/*.ks /usr/share/spin-kickstarts/
        cp -a /tmp/kickstarts/common/*.ks /usr/share/spin-kickstarts/ 2>/dev/null || true
        break
      fi
      # src.fedoraproject rpm repo has files inside - look deeper
      if [ -d /tmp/kickstarts ]; then
        find /tmp/kickstarts -name "fedora-live-base.ks" -exec cp -a {} /usr/share/spin-kickstarts/ \; 2>/dev/null || true
        find /tmp/kickstarts -name "*.ks" -exec cp -a {} /usr/share/spin-kickstarts/ \; 2>/dev/null || true
      fi
      ls /usr/share/spin-kickstarts/*.ks 2>/dev/null && break
    fi
  done
fi

echo "=== FINAL LS ==="
ls -lh /usr/share/spin-kickstarts/ | head -n 100
ls /usr/share/spin-kickstarts/fedora-live*.ks || echo "NO LIVE KS"

# If still no xfce, create minimal shim so build doesn't die
if [ ! -f /usr/share/spin-kickstarts/fedora-live-xfce.ks ]; then
  cat > /usr/share/spin-kickstarts/fedora-live-xfce.ks <<'SHIM'
%include fedora-live-base.ks
%packages
@xfce-desktop
%end
SHIM
fi

cp -v "$WORKDIR/oeneye-fedora.ks" /usr/share/spin-kickstarts/oeneye-tmp.ks
cd /usr/share/spin-kickstarts
cat oeneye-tmp.ks

echo "=== KSFLATTEN ==="
ksflatten --config oeneye-tmp.ks -o "$WORKDIR/flat.ks"
echo "FLAT OK"
wc -l "$WORKDIR/flat.ks"

rm -rf "$OUT/lmc"
livemedia-creator --make-iso --no-virt --ks "$WORKDIR/flat.ks" --project oeneye --releasever "$REL" --volid oeneye --iso-name oeneye-redhat.iso --resultdir "$OUT/lmc"
cp "$OUT"/lmc/*.iso "$OUT"/ || true
ls -lh "$OUT"/*.iso
