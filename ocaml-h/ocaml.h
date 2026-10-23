/* ocaml.h - OCaml-style helpers for C (gnu11, clang/gcc). Single header. */
#ifndef OCAML_H
#define OCAML_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <setjmp.h>

#define let __auto_type

/* ---- option: OCAML_OPTION(int); Some(int,3); None(int); OPT_DEFAULT(o,0) ---- */
#define OCAML_OPTION(T) typedef struct { bool some; T v; } option_##T
#define Some(T,x) ((option_##T){ .some = true, .v = (x) })
#define None(T)   ((option_##T){ .some = false })
#define IS_SOME(o) ((o).some)
#define OPT_DEFAULT(o,d) ((o).some ? (o).v : (d))

/* ---- immutable list: OCAML_LIST(int) -> int_list, int_cons, int_map ... ---- */
#define OCAML_LIST(T) \
typedef struct T##_node { T hd; struct T##_node *tl; } *T##_list; \
static inline __attribute__((unused)) T##_list T##_cons(T h, T##_list t){ T##_list n = malloc(sizeof *n); n->hd = h; n->tl = t; return n; } \
static inline __attribute__((unused)) void T##_free(T##_list l){ while (l) { T##_list n = l->tl; free(l); l = n; } } \
static inline __attribute__((unused)) int T##_length(T##_list l){ int n = 0; for (; l; l = l->tl) n++; return n; } \
static inline __attribute__((unused)) T##_list T##_rev(T##_list l){ T##_list r = 0; for (; l; l = l->tl) r = T##_cons(l->hd, r); return r; } \
static inline __attribute__((unused)) T##_list T##_map(T (*f)(T), T##_list l){ T##_list r = 0, o; for (; l; l = l->tl) r = T##_cons(f(l->hd), r); o = T##_rev(r); T##_free(r); return o; } \
static inline __attribute__((unused)) T##_list T##_filter(bool (*p)(T), T##_list l){ T##_list r = 0, o; for (; l; l = l->tl) if (p(l->hd)) r = T##_cons(l->hd, r); o = T##_rev(r); T##_free(r); return o; } \
static inline __attribute__((unused)) T T##_fold_left(T (*f)(T, T), T acc, T##_list l){ for (; l; l = l->tl) acc = f(acc, l->hd); return acc; } \
static inline __attribute__((unused)) void T##_iter(void (*f)(T), T##_list l){ for (; l; l = l->tl) f(l->hd); } \
static inline __attribute__((unused)) T##_list T##_of_array(const T *a, int n){ T##_list r = 0; while (n-- > 0) r = T##_cons(a[n], r); return r; }

/* ---- exceptions: TRY { ... } WITH { ... } END_TRY ----
   Don't return/break out of a TRY body; mark locals changed inside it volatile. */
#define OCAML_MAXDEPTH 64
static jmp_buf ocaml__jb[OCAML_MAXDEPTH];
static int ocaml__depth = -1;
static int ocaml__exn = 0;
static const char *ocaml__msg = "";
#define TRY if (!setjmp(ocaml__jb[++ocaml__depth])) {
#define WITH ocaml__depth--; } else { ocaml__depth--;
#define END_TRY }
#define RAISE(code,msg) do { \
  if (ocaml__depth < 0) { fprintf(stderr, "Fatal error: exception %d: %s\n", (code), (msg)); exit(2); } \
  ocaml__exn = (code); ocaml__msg = (msg); longjmp(ocaml__jb[ocaml__depth], 1); } while (0)
#define failwith(msg)         RAISE(1, msg)
#define Not_found()           RAISE(2, "Not_found")
#define invalid_arg(msg)      RAISE(3, msg)

/* ---- small stdlib ---- */
#define PIPE2(x,f,g)   g(f(x))
#define PIPE3(x,f,g,h) h(g(f(x)))
static inline __attribute__((unused)) void print_endline(const char *s){ puts(s); }
static inline __attribute__((unused)) void print_int(int n){ printf("%d", n); }
static inline __attribute__((unused)) char *string_of_int(int n){ char *s = malloc(24); snprintf(s, 24, "%d", n); return s; }
static inline __attribute__((unused)) char *ocaml_concat(const char *a, const char *b){ size_t la = strlen(a); char *s = malloc(la + strlen(b) + 1); memcpy(s, a, la); strcpy(s + la, b); return s; }
#endif
