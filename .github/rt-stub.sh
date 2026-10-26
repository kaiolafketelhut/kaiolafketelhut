set -e
TC=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin
echo 'int shm_open(const char*n,int f,unsigned m){return -1;} int shm_unlink(const char*n){return -1;}' > $HOME/shm.c
$TC/aarch64-linux-android30-clang -c $HOME/shm.c -o $HOME/shm.o
$TC/llvm-ar rcs $HOME/sysroot/lib/librt.a $HOME/shm.o
printf 'int shm_open(const char *, int, unsigned int);\nint shm_unlink(const char *);\n' > $HOME/shm-stub.h
