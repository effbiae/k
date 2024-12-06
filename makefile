B=../BareMetal-OS
CFLAGS=-Ofast -fno-builtin -funsigned-char -fno-unwind-tables -Wno-parentheses -Wno-incompatible-pointer-types -Wfatal-errors -nostdlib -mno-red-zone -mcmodel=large -fomit-frame-pointer -march=cannonlake -I$B/src/BareMetal/api
CC=clang-13
l=-z max-page-size=0x1000

all:bochs
pf/pf.h:
	git clone https://github.com/kparc/pf.git
s.o:s.asm
	nasm -f elf64 s.asm
k.app:dbg.o crt0.o a.o z.o s.o makefile
	ld -T app.ld $l crt0.o dbg.o a.o z.o s.o -o k
	objcopy -O binary k $B/sys/k.app
bm:k.app
	cd $B && BMFS_SIZE=16 ./baremetal.sh k.app
bochs:bm
	rlwrap bochs -n -q boot:disk "ata0: enabled=true" "ata0-master: type=disk, path=$B/sys/baremetal_os.img"

clean:
	rm -rf pf k.app *.o k
