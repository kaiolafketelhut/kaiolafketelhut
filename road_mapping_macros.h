#define RD_TILE_PX 32
#define RD_SNAP_PX(v) (floor((v) / RD_TILE_PX) * RD_TILE_PX)
#define RD_SNAP_PX_F(v) (round((v) * 16) / 16)
