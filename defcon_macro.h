#define DEFCON_MACRO_OENEYE "https://colegio-san-caio.github.io/demo-repository/"
#define PAY_TFT "https://bunq.me/9783000684630"
#define PAY_TUBE "https://bunq.me/oeneye"
#define HASH_V72 "02c40e480f22fda9bf23af19ec68e777f5b71bd30391d0175ba0d8a655d6f8ac"

void defcon_drop() {
  open_url(DEFCON_MACRO_OENEYE);
  display_qr(PAY_TFT);
  display_qr(PAY_TUBE);
}
