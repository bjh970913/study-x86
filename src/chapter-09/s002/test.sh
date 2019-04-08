#!/usr/bin/env bash

gcc -m32 -o exam.o -c exam.c -mpreferred-stack-boundary=2
ld -m elf_i386 -o exam -Ttext 0x00 -e main exam.o
objdump -D exam.o > exam_objdump.txt
objcopy -R .note -R .comment -S -O binary exam exam.bin

nm --line-numbers exam | sort > exam_nm.txt
ndisasm -b 32 exam.bin > exam_disasm.txt
