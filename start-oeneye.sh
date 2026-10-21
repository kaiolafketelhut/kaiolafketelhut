#!/bin/bash
termux-wake-lock
pg_ctl -D $PREFIX/var/lib/postgresql status || pg_ctl -D $PREFIX/var/lib/postgresql -l $PREFIX/var/lib/postgresql/logfile start
# mongo in nohup (survives proot-distro login exit)
pgrep -f "mongod.*27017" >/dev/null || nohup proot-distro login ubuntu -- bash -c "mongod --dbpath /data/db --bind_ip 0.0.0.0 --port 27017 --wiredTigerCacheSizeGB 0.25 --logpath /tmp/mongod.log --logappend" > /tmp/mongo-nohup.log 2>&1 &
sleep 2
python ~/kai/mirror.py
