/* qxd.c - tiny QxD interpreter: qxd file.iQxD */
#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define MAXE 256
#define LEN  256

static char dn[MAXE][LEN], df[MAXE][LEN], dv[MAXE][LEN];
static int nent;

static char *trim(char *s)
{
    char *e;
    while (isspace((unsigned char)*s)) s++;
    e = s + strlen(s);
    while (e > s && isspace((unsigned char)e[-1])) *--e = '\0';
    return s;
}

static void store(const char *n, const char *f, const char *v)
{
    if (nent >= MAXE) return;
    snprintf(dn[nent], LEN, "%s", n);
    snprintf(df[nent], LEN, "%s", f);
    snprintf(dv[nent], LEN, "%s", v);
    nent++;
}

/* Node[NAME].Field[.sub] -> value */
static void lookup(const char *ref, char *out)
{
    char n[LEN], tmp[LEN], *p, *a;
    const char *close;
    size_t l;
    int i;

    out[0] = '\0';
    if (strncmp(ref, "Node[", 5) != 0) return;
    close = strstr(ref, "].");
    if (!close) return;
    snprintf(n, LEN, "%.*s", (int)(close - (ref + 5)), ref + 5);

    for (i = 0; i < nent; i++) {
        if (strcmp(dn[i], n) == 0 && strcmp(df[i], close + 2) == 0) {
            snprintf(tmp, LEN, "%s", dv[i]);
            p = tmp;
            while ((a = strstr(p, " -> ")) != NULL) p = a + 4;
            l = strlen(p);
            if (l && p[0] == '"') { p++; l--; }
            if (l && p[l - 1] == '"') l--;
            snprintf(out, LEN, "%.*s", (int)l, p);
            return;
        }
    }
}

/* print "text" Node[X].Field */
static void run_print(char *rest)
{
    char val[LEN], *q, *ref;
    val[0] = '\0';
    if (rest[0] == '"' && (q = strchr(rest + 1, '"')) != NULL) {
        *q = '\0';
        ref = trim(q + 1);
        if (*ref) lookup(ref, val);
        printf("%s%s\n", rest + 1, val);
        return;
    }
    lookup(rest, val);
    printf("%s\n", val);
}

int main(int argc, char **argv)
{
    FILE *fp;
    char buf[1024], node[LEN] = "";
    int inmain = 0;

    if (argc < 2) { fprintf(stderr, "usage: qxd file.iQxD\n"); return 1; }
    fp = fopen(argv[1], "r");
    if (!fp) { perror(argv[1]); return 1; }

    while (fgets(buf, sizeof buf, fp)) {
        char *line = trim(buf), *c, *field, *value, *p, *pair, *save;
        size_t n = strlen(line), vlen;

        if (!*line || strncmp(line, "//", 2) == 0) continue;
        if (strncmp(line, "Node[", 5) == 0 && n > 2 && strcmp(line + n - 2, " {") == 0) {
            c = strchr(line, ']');
            if (c) snprintf(node, LEN, "%.*s", (int)(c - (line + 5)), line + 5);
            continue;
        }
        if (strcmp(line, "main {") == 0) { inmain = 1; continue; }
        if (strcmp(line, "}") == 0) { node[0] = '\0'; inmain = 0; continue; }
        if (inmain) {
            if (strncmp(line, "print ", 6) == 0) run_print(line + 6);
            continue;
        }
        if (!node[0]) continue;

        c = strchr(line, ':');
        if (!c) continue;
        *c = '\0';
        field = trim(line);
        value = trim(c + 1);
        store(node, field, value);

        /* { key: val, key: val } also stores Field.key */
        vlen = strlen(value);
        if (vlen > 1 && value[0] == '{' && value[vlen - 1] == '}' && strchr(value, ':')) {
            value[vlen - 1] = '\0';
            p = value + 1;
            for (pair = strtok_r(p, ",", &save); pair; pair = strtok_r(NULL, ",", &save)) {
                char key[LEN], *c2 = strchr(pair, ':');
                if (!c2) continue;
                *c2 = '\0';
                snprintf(key, LEN, "%s.%s", field, trim(pair));
                store(node, key, trim(c2 + 1));
            }
        }
    }
    fclose(fp);
    return 0;
}
