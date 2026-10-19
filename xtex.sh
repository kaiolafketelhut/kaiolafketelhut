#!/usr/bin/env bash
set -e
mkdir -p MOSFETQexchange/output MOSFETQexchange/spool/fax MOSFETQexchange/spool/vnc
export FAX_NAME="oeneye.c + oeneyepdf.c"
export PDF="./MOSFETQexchange/output/jc_sigma.pdf"
echo "FAX by $FAX_NAME"
python3 oeneyepdf.c
ls -lh MOSFETQexchange/output/
