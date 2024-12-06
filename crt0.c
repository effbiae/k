int main(int,char**);
void _start(){
 asm volatile ("subq $8,%%rsp"::);
 char*v[2]={"k",0};
 main(1,v);
 asm volatile ("addq $8,%%rsp"::);
}
