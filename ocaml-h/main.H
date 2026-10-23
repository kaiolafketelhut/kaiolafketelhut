/* main.H - program entry in OCaml style, built on ocaml.h */
#ifndef MAIN_H
#define MAIN_H
#include "ocaml.h"

OCAML_OPTION(int);
OCAML_LIST(int)

#define MAIN int main(void)

static int  sq(int x)         { return x * x; }
static bool odd(int x)        { return x % 2 != 0; }
static int  add(int a, int b) { return a + b; }
static void show(int x)       { printf("%d ", x); }

MAIN {
  int a[] = {1,2,3,4,5,6,7};
  let l = int_of_array(a, 7);
  let o = int_filter(odd, l);
  let s = int_map(sq, o);
  int_iter(show, s); puts("");
  printf("sum = %d\n", int_fold_left(add, 0, s));
  TRY {
    Not_found();
  } WITH {
    printf("caught: %s\n", ocaml__msg);
  } END_TRY
  int_free(l); int_free(o); int_free(s);
  return 0;
}
#endif
