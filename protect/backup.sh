#!/bin/sh
# backup.sh - dated tar.gz + sha256 of a directory, keep the newest N, mark read-only
# usage: sh backup.sh DIR [dest] [keep]      default dest: ~/backups-kdp, keep 5
#        sh backup.sh verify [dest]          re-check every checksum in dest
if [ "$1" = verify ]; then
  cd "${2:-$HOME/backups-kdp}" || exit 2
  for s in *.sha256; do sha256sum -c "$s"; done
  exit
fi
SRC=$(cd "${1:?usage: backup.sh DIR [dest] [keep]}" && pwd)
DEST=${2:-$HOME/backups-kdp}
KEEP=${3:-5}
mkdir -p "$DEST"
name="$(basename "$SRC")-$(date +%Y%m%d-%H%M%S).tar.gz"
tar --exclude='.git' -czf "$DEST/$name" -C "$(dirname "$SRC")" "$(basename "$SRC")" || exit 1
(cd "$DEST" && sha256sum "$name" > "$name.sha256")
chmod a-w "$DEST/$name" "$DEST/$name.sha256"
echo "wrote $DEST/$name ($(wc -c < "$DEST/$name") bytes)"
ls -1t "$DEST"/*.tar.gz | tail -n +$((KEEP + 1)) | while read -r old; do
  chmod u+w "$old" "$old.sha256"; rm -f "$old" "$old.sha256"; echo "pruned $old"
done
