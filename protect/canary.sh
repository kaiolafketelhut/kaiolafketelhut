#!/bin/sh
# canary.sh - hash baseline + change check; alerts when many files change at once
# usage: sh canary.sh init DIR
#        sh canary.sh check DIR [limit]     (default limit 5 changed/missing files)
# Set CANARY_HOOK=/path/to/script to run it on alert (gets the change list as $1).
MODE=$1
DIR=${2:-.}
LIMIT=${3:-5}
STORE=${CANARY_DIR:-$HOME/.canary}
mkdir -p "$STORE"
MAN="$STORE/$(printf '%s' "$(cd "$DIR" && pwd)" | tr '/' '_').sha256"
NOW=${TMPDIR:-/tmp}/canary.$$

scan() { (cd "$DIR" && find . -type f ! -path './.git/*' -print0 | sort -z | xargs -0 sha256sum); }

case $MODE in
  init)
    scan > "$MAN"
    echo "baseline: $(wc -l < "$MAN") files -> $MAN"
    ;;
  check)
    [ -f "$MAN" ] || { echo "no baseline, run: sh canary.sh init $DIR"; exit 2; }
    scan > "$NOW"
    awk 'NR==FNR { old[substr($0,67)] = $1; next }
         { f = substr($0,67); seen[f] = 1
           if (!(f in old)) print "NEW      " f
           else if (old[f] != $1) print "CHANGED  " f }
         END { for (f in old) if (!(f in seen)) print "MISSING  " f }' "$MAN" "$NOW" | sort > "$NOW.diff"
    rm -f "$NOW"
    bad=$(grep -cE '^(CHANGED|MISSING)' "$NOW.diff")
    new=$(grep -c '^NEW' "$NOW.diff")
    cat "$NOW.diff"
    echo "changed/missing: $bad   new: $new   limit: $LIMIT"
    if [ "$bad" -ge "$LIMIT" ]; then
      echo "ALERT: $bad files changed or vanished - possible ransomware or mass edit"
      [ -n "$CANARY_HOOK" ] && [ -x "$CANARY_HOOK" ] && "$CANARY_HOOK" "$NOW.diff"
      rm -f "$NOW.diff"
      exit 1
    fi
    rm -f "$NOW.diff"
    ;;
  *) echo "usage: sh canary.sh init DIR | check DIR [limit]"; exit 2 ;;
esac
