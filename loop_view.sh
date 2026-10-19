#!/usr/bin/env bash
set -e
while true; do
  clear
  echo "=== $(date -u) ==="
  gh run list --workflow="pages.yml" -L 5
  echo ""
  echo "-- in_progress --"
  gh run list --workflow="pages.yml" --status in_progress -L 3
  echo ""
  echo "-- queued --"
  gh run list --workflow="pages.yml" --status queued -L 3
  ID=$(gh run list --workflow="pages.yml" -L 1 --json databaseId -q '.[0].databaseId' 2>/dev/null || echo "")
  if [ -n "$ID" ]; then
    echo ""
    echo ">> gh run view $ID"
    gh run view $ID 2>&1 | tail -n 40
  fi
  sleep 3
done
