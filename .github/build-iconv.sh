set -e
TC=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin
curl -L https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz | tar xz
cd libiconv-1.17
./configure --host=aarch64-linux-android --prefix=$HOME/sysroot --enable-static --disable-shared CC=$TC/aarch64-linux-android28-clang AR=$TC/llvm-ar RANLIB=$TC/llvm-ranlib
make -j4
make install
