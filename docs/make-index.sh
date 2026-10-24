#!/bin/sh
cd "$(dirname "$0")/.." || exit 1
{ echo '['; first=1
find docs -type f ! -name index.json | sort | while read -r f; do
  s=$(wc -c < "$f")
  if [ $first = 1 ]; then first=0; else echo ','; fi
  printf '{"path":"%s","bytes":%s}' "$f" "$s"
done; echo; echo ']'; } > docs/index.json
