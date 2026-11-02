/* main.c - KDP profile as a DLL (Windows) / shared library (Linux).
   Windows build: x86_64-w64-mingw32-gcc -shared -O2 -o MAIN.DLL main.c
   Linux test   : gcc -shared -fPIC -O2 -o main.so main.c
   Exports: KdpGetProfile(buf, size) -> bytes written (the profile text),
            KdpGetPoints() -> 1,  KdpShortCode() -> pointer to the code string */
#include <stdio.h>
#include <string.h>

#ifdef _WIN32
#  define KDP_API __declspec(dllexport)
#else
#  define KDP_API __attribute__((visibility("default")))
#endif

static const char ID[]   = "KDPMember:KL5UQ4f48673352";
static const char ROLE[] = "Member";

KDP_API const char *KdpShortCode(void)
{
    static const char prefix[] = "KDPMember:";
    return strncmp(ID, prefix, sizeof prefix - 1) == 0 ? ID + sizeof prefix - 1 : ID;
}

KDP_API int KdpGetPoints(void) { return 1; }

KDP_API int KdpGetProfile(char *buf, int size)
{
    if (!buf || size <= 0) return -1;
    return snprintf(buf, (size_t)size,
                    "=== KDP Forum Profile ===\n"
                    "Nickname : %s\nCode     : %s\nRole     : %s\nPoints   : %d\n",
                    ID, KdpShortCode(), ROLE, KdpGetPoints());
}
