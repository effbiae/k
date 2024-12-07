#include"pf/pf.h"
#include<libBareMetal.c>
ssize_t write (int __fd, const void *__buf, size_t __n) __wur
{
  b_output(__buf,__n);
}
void debug(int line){pf("DBG %d\n",line);}
