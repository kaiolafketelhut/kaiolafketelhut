/* test.c - load MAIN.DLL at run time and print the profile (Windows).
   build: x86_64-w64-mingw32-gcc -o test.exe test.c   (run next to MAIN.DLL, e.g. under Wine) */
#include <windows.h>
#include <stdio.h>

int main(void)
{
    HMODULE h = LoadLibraryA("MAIN.DLL");
    if (!h) { puts("cannot load MAIN.DLL"); return 1; }
    int (*get)(char *, int) = (int (*)(char *, int))GetProcAddress(h, "KdpGetProfile");
    if (!get) { puts("KdpGetProfile not exported"); return 1; }
    char buf[256];
    get(buf, sizeof buf);
    fputs(buf, stdout);
    FreeLibrary(h);
    return 0;
}
