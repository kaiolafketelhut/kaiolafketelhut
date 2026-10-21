#!/bin/bash
# oeneye co-container stack: termuxDB + Fedora app
set -e
echo "[1/3] Starting termuxDB..."
pg_ctl -D $PREFIX/var/lib/postgresql -l $PREFIX/var/lib/postgresql/logfile start || true
pg_isready -h 127.0.0.1
psql termuxDB -c "SELECT 'termuxDB UP: ' || count(*) || ' rows' FROM test;" -t

echo "[2/3] Fedora co-container..."
proot-distro login fedora -- bash -c "echo Fedora: \$(cat /etc/fedora-release)"

echo "[3/3] Testing co-container link..."
PGPASSWORD=oeneye psql -h 127.0.0.1 -U oeneye -d termuxDB -c "SELECT * FROM test;" -h 127.0.0.1 -U oeneye

echo "✅ oeneye co-containers READY"
echo "DB: termuxDB on 127.0.0.1:5432"
echo "APP: proot-distro login fedora"
