# porting k to BareMetal-OS

## tldr
 - an app built and installed with `baremetal.sh k.app` isn't loaded properly.
 - the first 4096 bytes are ok, but different after that

## to reproduce
```
git clone https://github.com/effbiae/k.git
```
then edit the first line of the `makefile` to set your path to BareMetal-OS.

`make bochs` will build k as an app and make an image with `baremetal.sh k.app` 
and start bochs. you need bochs configured with avx512 support (see below).

when bochs starts, choose menu item 6 to start the simulation. 
at the bochs prompt, set a breakpoint at the start of 
`k.app` with `b 0x400000`

continue execution with `c`.  note execution breaks at the start of `k.app`

dump bochs memory with `writemem "bochs.mem" 0x400000 45792`. note that `bochs.mem` differs from `k.app` from address `0x1000` onwards

## to see execution go wrong...
set a breakpoint in the `_start` function of `k.app` with `b 0x40002d`

continue execution with `c`

note that execution stops at the start of `k.app` with the instruction `sub rsp,byte +0x18` this can be verified by disassembling the `k.app` with `ndisasm -b64 k.app`

continue execution with `c`

note that bochs breaks at `0x40002d` at instruction `call rax` with `rax=ffff8000_000086e0`. looking at the disassembly of `k.app`, the instruction at `0x86e0` is `push r15` but when i step bochs into the call, the instruction is 
```
0) [0x0000004086e0] 0008:ffff8000000086e0 (unk. ctxt): mov ecx, edx              ; 63ca
```
which is not consistent with the `k.app` image

## what i did

first, i replaced `syscall` with `call b_k` and put `b_k` in `s.asm`

i pulled `_start` out and put it in `crt0.c`

i got the source for bochs 2.8 and configured for debugging avx512 as
```
$ ./configure --enable-smp --enable-cpu-level=6 --enable-all-optimizations --enable-x86-64 --enable-pci --enable-usb --enable-vmx --enable-debugger --enable-disasm --enable-debugger-gui --enable-logging --enable-fpu --enable-3dnow --enable-sb16=dummy --enable-cdrom --enable-x86-debugger --enable-iodebug --disable-plugins --disable-docbook --with-x --with-x11 --with-term --enable-avx --enable-evex
```

### notes
```
b 0x1e0170 write a ret to ProgramLocation
b 0x1e01fe there is a single program
b 0x1e0230 call [b_storage_read]
b 0x1e0237 call [ProgramLocation]
b 0x1e0fa0 [ProgramLocation]
b 0x4086e0 main
```
