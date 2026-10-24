#!/bin/sh
# usage: sh store.sh NAME FILE...  ->  docs/NAME/<timestamp>/FILE  and  docs/NAME/latest/FILE
N=$1; shift
T=$(date -u +%Y%m%d-%H%M%S)
D=docs/$N/$T
mkdir -p "$D" "docs/$N/latest"
for f in "$@"; do cp "$f" "$D/"; cp "$f" "docs/$N/latest/"; done
sh docs/make-index.sh
echo "stored in $D"
