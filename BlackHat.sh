#!/usr/bin/env bash
set -ex
REL="44"
WORKDIR="$(pwd)"
OUT="$WORKDIR/out"
mkdir -p "$OUT" && rm -rf "$OUT/lmc"

dnf install -y lorax lorax-lmc-novirt pykickstart git anaconda-tui xorriso glibc-langpack-en wget curl isomd5sum

rm -rf /tmp/kickstarts
mkdir -p /usr/share/spin-kickstarts /tmp/kickstarts
cd /usr/share/spin-kickstarts

# clean old shims
rm -f fedora-live*.ks fedora-common.ks fedora-repo*.ks

# download real files from pagure raw
curl -L --fail -s https://pagure.io/fedora-kickstarts/raw/f44/f/fedora-live-base.ks -o fedora-live-base.ks || true
curl -L --fail -s https://pagure.io/fedora-kickstarts/raw/f44/f/fedora-live-xfce.ks -o fedora-live-xfce.ks || true
curl -L --fail -s https://pagure.io/fedora-kickstarts/raw/f44/f/fedora-common.ks -o fedora-common.ks || true
curl -L --fail -s https://pagure.io/fedora-kickstarts/raw/f44/f/fedora-live-common.ks -o fedora-live-common.ks || true
curl -L --fail -s https://pagure.io/fedora-kickstarts/raw/f44/f/fedora-repo-not-rawhide.ks -o fedora-repo-not-rawhide.ks || true
curl -L --fail -s https://pagure.io/fedora-kickstarts/raw/f44/f/fedora-repo.ks -o fedora-repo.ks || true

ls -lh

# ensure repo files exist
if [ ! -s fedora-repo-not-rawhide.ks ]; then
cat > fedora-repo-not-rawhide.ks <<'REPO'
url --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=fedora-44&arch=$basearch
repo --name=fedora --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=fedora-44&arch=$basearch
repo --name=updates --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=updates-released-f44&arch=$basearch
REPO
fi

if [ ! -s fedora-live-base.ks ]; then
cat > fedora-live-base.ks <<'BASE'
%include fedora-repo-not-rawhide.ks
%include fedora-common.ks
%packages
@core
kernel
dracut-live
livesys-scripts
%end
BASE
fi

if [ ! -s fedora-live-xfce.ks ]; then
cat > fedora-live-xfce.ks <<'XFCE'
%include fedora-live-base.ks
%packages
@xfce-desktop
%end
XFCE
fi

# OUR KICKSTART - with URL already!
cat > oeneye-tmp.ks <<'KS'
url --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=fedora-44&arch=$basearch
%include fedora-live-xfce.ks
%packages
@xfce-desktop
neovim
git
%end
%post
echo 'NAME="oeneye"' > /etc/os-release
echo 'ID=oeneye' >> /etc/os-release
echo 'PRETTY_NAME="oeneye 1.05 rc MOSFETQ infinity-eye"' >> /etc/os-release
%end
KS

cat oeneye-tmp.ks
echo "=== KSFLATTEN ==="
ksflatten --config oeneye-tmp.ks -o "$WORKDIR/flat.ks"
echo "FLAT OK"

# FIX DUPLICATE REPO - keep only first url and unique repos
awk '!seen[$0]++' "$WORKDIR/flat.ks" > "$WORKDIR/flat2.ks"
mv "$WORKDIR/flat2.ks" "$WORKDIR/flat.ks"

# ensure url is first line
if ! head -n1 "$WORKDIR/flat.ks" | grep -q "^url"; then
  # add url if missing
  sed -i '1i url --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=fedora-44&arch=$basearch' "$WORKDIR/flat.ks"
fi

head -n 30 "$WORKDIR/flat.ks"

echo "=== LIVEMEDIA ==="
rm -rf "$OUT/lmc"
livemedia-creator --make-iso --no-virt --ks "$WORKDIR/flat.ks" --project oeneye --releasever "$REL" --volid oeneye --iso-name oeneye-redhat.iso --resultdir "$OUT/lmc" 2>&1 | tee /tmp/lmc.log
ls -lh "$OUT/lmc/" 
cp "$OUT/lmc/"*.iso "$OUT"/ || true
ls -lh "$OUT"/*.iso
