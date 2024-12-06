#porting k to BareMetal-OS

`git clone` and edit the `makefile` to set your path to BareMetal-OS.

`make bochs` will build k as an app and make an image with `baremetal.sh k.app` 
and start bochs

to see the instruction it errors on, set a breakpoint in bochs with `b 0x000000407c49`
and this is the erroring point:
```
(0) Breakpoint 1, 0xffff800000007c49 in ?? ()
Next at t=21248957
(0) [0x000000407c49] 0008:ffff800000007c49 (unk. ctxt): vpxorq zmm1, zmm0, zmmword ptr ds:[rdi] ; 62f1fd48ef0f
```


##what i did

first, i replaced `syscall` with `call b_k` and put `b_k` in s.asm

i pulled `_start` out and put it in `crt0.c`

i got the source for bochs 2.8 and configured for debugging avx512 as
```
$ ./configure \
--enable-smp \
--enable-cpu-level=6 \
--enable-all-optimizations \
--enable-x86-64 \
--enable-pci \
--enable-usb \
--enable-vmx \
--enable-debugger \
--enable-disasm \
--enable-debugger-gui \
--enable-logging \
--enable-fpu \
--enable-3dnow \
--enable-sb16=dummy \
--enable-cdrom \
--enable-x86-debugger \
--enable-iodebug \
--disable-plugins \
--disable-docbook \
--with-x \
--with-x11 \
--with-term \
--enable-avx \
--enable-evex 
```
