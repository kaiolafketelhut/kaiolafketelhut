#!/usr/bin/env bash
set -ex
REL="44"
WORKDIR="$(pwd)"
OUT="$WORKDIR/out"
mkdir -p "$OUT" && rm -rf "$OUT/lmc"

dnf install -y lorax lorax-lmc-novirt pykickstart git anaconda-tui xorriso glibc-langpack-en wget curl

rm -rf /tmp/kickstarts
mkdir -p /usr/share/spin-kickstarts /tmp/kickstarts
cd /usr/share/spin-kickstarts

# Download directly via raw - pagure + github mirror
BASE_URLS=(
  "https://pagure.io/fedora-kickstarts/raw/f44/f"
  "https://pagure.io/fedora-kickstarts/raw/main/f"
  "https://pagure.io/fedora-kickstarts/raw/rawhide/f"
  "https://raw.githubusercontent.com/fedoraproject/fedora-kickstarts/f44"
  "https://raw.githubusercontent.com/fedoraproject/fedora-kickstarts/main"
)

FILES=(
  fedora-live-base.ks
  fedora-live-xfce.ks
  fedora-live-common.ks
  fedora-repo.ks
  fedora-repo-not-rawhide.ks
  fedora-repo-rawhide.ks
  fedora-common.ks
  fedora-common-ostree.ks
  fedora-xfce-common.ks
  fedora-xfce-packages.ks
)

for f in "${FILES[@]}"; do
  if [ -f "$f" ]; then continue; fi
  for base in "${BASE_URLS[@]}"; do
    echo "TRY $base/$f"
    if curl -L --fail -s "$base/$f" -o "$f.tmp" 2>&1 | head; then
      if grep -q "%packages\|%include\|repo" "$f.tmp" 2>/dev/null; then
        mv "$f.tmp" "$f"
        echo "GOT $f from $base"
        break
      fi
    fi
    rm -f "$f.tmp"
  done
done

# if pagure blocked, create minimal working base so ksflatten succeeds
if [ ! -f fedora-repo-not-rawhide.ks ]; then
cat > fedora-repo-not-rawhide.ks <<'REPO'
repo --name=fedora --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=fedora-44&arch=$basearch
repo --name=updates --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=updates-released-f44&arch=$basearch
REPO
fi
if [ ! -f fedora-repo.ks ]; then
cat > fedora-repo.ks <<'REPO2'
%include fedora-repo-not-rawhide.ks
REPO2
fi
if [ ! -f fedora-common.ks ]; then echo "%packages" > fedora-common.ks; echo "%end" >> fedora-common.ks; fi
if [ ! -f fedora-live-common.ks ]; then echo "%include fedora-common.ks" > fedora-live-common.ks; fi
if [ ! -f fedora-live-base.ks ]; then
cat > fedora-live-base.ks <<'BASE'
%include fedora-repo.ks
%include fedora-common.ks
%packages
@core
kernel
dracut-live
livesys-scripts
%end
BASE
fi
if [ ! -f fedora-live-xfce.ks ]; then
cat > fedora-live-xfce.ks <<'XFCE'
%include fedora-live-base.ks
%packages
@xfce-desktop
%end
XFCE
fi

ls -lh
cat fedora-live-base.ks
cat fedora-live-xfce.ks

cp -v "$WORKDIR/oeneye-fedora.ks" oeneye-tmp.ks
echo "=== OUR KS ==="
cat oeneye-tmp.ks

ksflatten --config oeneye-tmp.ks -o "$WORKDIR/flat.ks"
echo "FLAT OK"
head -n 100 "$WORKDIR/flat.ks"

rm -rf "$OUT/lmc"
livemedia-creator --make-iso --no-virt --ks "$WORKDIR/flat.ks" --project oeneye --releasever "$REL" --volid oeneye --iso-name oeneye-redhat.iso --resultdir "$OUT/lmc"
ls -lh "$OUT/lmc/" 
cp "$OUT/lmc/"*.iso "$OUT"/ || true
ls -lh "$OUT"/*.iso
