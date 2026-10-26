set -e
TC=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin
curl -L https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.17.tar.gz | tar xz
cd libiconv-1.17
./configure --host=aarch64-linux-android --prefix=$HOME/sysroot --enable-static --disable-shared CC=$TC/aarch64-linux-android30-clang AR=$TC/llvm-ar RANLIB=$TC/llvm-ranlib
make -j4
make install
mkdir -p $HOME/sysroot/lib/pkgconfig
printf 'prefix=%s\nlibdir=${prefix}/lib\nincludedir=${prefix}/include\nName: iconv\nDescription: GNU libiconv\nVersion: 1.17\nLibs: -L${libdir} -liconv\nCflags: -I${includedir}\n' "$HOME/sysroot" > $HOME/sysroot/lib/pkgconfig/iconv.pc
