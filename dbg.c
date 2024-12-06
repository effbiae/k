#include"pf/pf.h"
#include<libBareMetal.c>
void printLINE(int x){pf("LINE %d\n",x);}
ssize_t write (int f, const void *s, size_t n) __wur
{return b_output(s,n),n;}
