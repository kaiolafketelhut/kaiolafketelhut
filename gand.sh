#!/usr/bin/env bash
set -e
echo "[CANDI OQM] gand.sh building..."

# 1. road mapping macro
mkdir -p gand
cat > gand/fprint.mod <<'MOD'
oeneye-pkg active
MOD

# 2. touch candiOQM + open graph
touch candiOQM.txt
echo "# CANDI OQM - $(date -u +%Y%m%d%H%M)" > candiOQM.txt

# 3. open graph meta
cat > meta_share.html <<'HTML'
<meta property="og:type" content="website" />
<meta property="og:title" content="CANDI OQM - Colegio San Caio" />
<meta property="og:url" content="https://colegio-san-caio.github.io/demo-repository/candiOQM.txt" />
<meta property="og:image" content="https://colegio-san-caio.github.io/demo-repository/preview.png" />
<link rel="up" href="https://colegio-san-caio.github.io/demo-repository/" />
HTML

# 4. pixel road macros
cat > road_mapping_macros.h <<'H'
#define RD_TILE_PX 32
#define RD_SNAP_PX(v) (floor((v) / RD_TILE_PX) * RD_TILE_PX)
#define RD_SNAP_PX_F(v) (round((v) * 16) / 16)
H

echo "gand.sh executed successfully - $(cat candiOQM.txt)"
ls -l candiOQM.txt road_mapping_macros.h meta_share.html
