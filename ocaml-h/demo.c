#include "ocaml.h"
OCAML_OPTION(int);
OCAML_LIST(int)
static int dbl(int x){ return x * 2; }
static bool even(int x){ return x % 2 == 0; }
static int add(int a, int b){ return a + b; }
static option_int first_even(int_list l){
  for (; l; l = l->tl) if (even(l->hd)) return Some(int, l->hd);
  return None(int);
}
int main(void){
  int arr[] = {1,2,3,4,5};
  let l = int_of_array(arr, 5);
  let d = int_map(dbl, l);
  printf("sum of doubled = %d\n", int_fold_left(add, 0, d));
  let ev = int_filter(even, l);
  printf("evens = %d items\n", int_length(ev));
  option_int o = first_even(l);
  printf("first even = %d\n", OPT_DEFAULT(o, -1));
  TRY {
    if (int_length(l) > 3) failwith("list too long");
  } WITH {
    printf("caught: %s\n", ocaml__msg);
  } END_TRY
  print_endline("done");
  return 0;
}
