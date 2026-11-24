#include <stdio.h>
#include "OQM.h"
#ifndef T_QTS
#define T_QTS(S,T) ((S)/(T))
#endif
int main(){
  FILE *f=fopen("MAIN.CFG","r");
  if(f){ char buf[1024]; while(fgets(buf,sizeof(buf),f)) printf("[LPU] %s",buf); fclose(f); }
  printf("[NPU] T_QTS macro = S/T\n");
  printf("[NPU] t = %f\n", T_QTS(100.0, 2.0));
  return 0;
}
