#!/usr/bin/env bash
set -ex
REL="44"
WORKDIR="$(pwd)"
OUT="$WORKDIR/out"
mkdir -p "$OUT"
rm -rf "$OUT/lmc"
dnf install -y lorax lorax-lmc-novirt pykickstart git anaconda-tui xorriso glibc-langpack-en wget

rm -rf /tmp/kickstarts /usr/share/spin-kickstarts
mkdir -p /usr/share/spin-kickstarts

# METHOD 3: download latest fedora-kickstarts rpm from koji directly
dnf install -y fedora-kickstarts || \
dnf install -y https://kojipkgs.fedoraproject.org/packages/fedora-kickstarts/0.1.0/1.fc44/noarch/fedora-kickstarts-0.1.0-1.fc44.noarch.rpm || true

# Try github official mirror that actually exists: pagure fork on github
for URL in \
  https://github.com/fedoraproject/fedora-kickstarts.git \
  https://github.com/fedoraproject/kickstarts.git \
  https://pagure.io/fedora-kickstarts.git \
  https://src.fedoraproject.org/rpms/fedora-kickstarts.git; do
  rm -rf /tmp/kickstarts
  echo "=== TRY $URL ==="
  if git clone --depth 1 "$URL" /tmp/kickstarts 2>&1 | head -n 20; then
    ls /tmp/kickstarts/ | head -n 30
    find /tmp/kickstarts -maxdepth 2 -name "fedora-live-base.ks" | head
    if find /tmp/kickstarts -name "fedora-live-base.ks" | grep -q .; then
      echo "FOUND KS IN $URL"
      find /tmp/kickstarts -name "*.ks" -exec cp -n {} /usr/share/spin-kickstarts/ \; 2>/dev/null || true
      cp -a /tmp/kickstarts/*.ks /usr/share/spin-kickstarts/ 2>/dev/null || true
      break
    fi
  fi
done

ls -lh /usr/share/spin-kickstarts/ | head -n 100
ls /usr/share/spin-kickstarts/fedora-live*.ks 2>&1 | head

# final shim if still missing
if [ ! -f /usr/share/spin-kickstarts/fedora-live-base.ks ]; then
  echo "CREATING SHIM BASE - upstream empty"
  cat > /usr/share/spin-kickstarts/fedora-live-base.ks <<'BASE'
%include fedora-repo.ks
%include fedora-common.ks
%packages
@core
kernel
dracut-live
%end
BASE
  cat > /usr/share/spin-kickstarts/fedora-common.ks <<'COMMON'
%packages
glibc
%end
COMMON
  cat > /usr/share/spin-kickstarts/fedora-repo.ks <<'REPO'
repo --name=fedora --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=fedora-44&arch=$basearch
repo --name=updates --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=updates-released-f44&arch=$basearch
REPO
fi

if [ ! -f /usr/share/spin-kickstarts/fedora-live-xfce.ks ]; then
  cat > /usr/share/spin-kickstarts/fedora-live-xfce.ks <<'XFCE'
%include fedora-live-base.ks
%packages
@xfce-desktop
%end
XFCE
fi

cp -v "$WORKDIR/oeneye-fedora.ks" /usr/share/spin-kickstarts/oeneye-tmp.ks
cd /usr/share/spin-kickstarts
ksflatten --config oeneye-tmp.ks -o "$WORKDIR/flat.ks"
echo "FLAT OK"
rm -rf "$OUT/lmc"
livemedia-creator --make-iso --no-virt --ks "$WORKDIR/flat.ks" --project oeneye --releasever "$REL" --volid oeneye --iso-name oeneye-redhat.iso --resultdir "$OUT/lmc"
ls -lh "$OUT"/lmc/
cp "$OUT"/lmc/*.iso "$OUT"/ || true
ls -lh "$OUT"/*.iso
