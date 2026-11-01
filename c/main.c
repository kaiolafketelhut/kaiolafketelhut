#include <stdio.h>
#include <string.h>

typedef struct {
    const char *member_id;
    const char *role;
    int points;
} KdpMember;

/* The short code after the "KDPMember:" prefix */
static const char *short_code(const KdpMember *m)
{
    const char *prefix = "KDPMember:";
    size_t n = strlen(prefix);
    return strncmp(m->member_id, prefix, n) == 0 ? m->member_id + n : m->member_id;
}

int main(void)
{
    KdpMember me = { "KDPMember:KL5UQ4f48673352", "Member", 1 };

    puts("=== KDP Forum Profile ===");
    printf("Nickname : %s\n", me.member_id);
    printf("Code     : %s\n", short_code(&me));
    printf("Role     : %s\n", me.role);
    printf("Points   : %d\n", me.points);
    return 0;
}
