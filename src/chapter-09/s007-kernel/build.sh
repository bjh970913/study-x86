#!/usr/bin/env bash

export LDFLAGS=-lssp_nonshared

nasm -f bin -o boot.bin boot.asm
nasm -f bin -o setup.bin setup.asm -l list_setup.txt
nasm -f coff -o interrupt_asm.o interrupt.asm

GCC="gcc -fno-stack-protector -Wall -fPIE -m32 -c"
LD="ld -m elf_i386"

${GCC} -o kernel.o kernel.c
${GCC} -o interrupt.o interrupt.c
${GCC} -o process.o process.c

nasm -f coff -o floppy_asm.o floppy.asm

${GCC} -o floppy.o floppy.c


${LD} -o kernel -Ttext 0xc0000000 -e start_kernel \
    kernel.o interrupt_asm.o interrupt.o process.o floppy_asm.o floppy.o

objcopy -R .note -R .comment -S -O binary kernel kernel.bin

${GCC} -o print_string.o print_string.c

${GCC} -o user_program1.o user_program1.c
${GCC} -o user_program2.o user_program2.c
${GCC} -o user_program3.o user_program3.c
${GCC} -o user_program4.o user_program4.c

${LD} -o user_program1 -Ttext 0x080001000 -e main user_program1.o print_string.o
${LD} -o user_program2 -Ttext 0x080002000 -e main user_program2.o print_string.o
${LD} -o user_program3 -Ttext 0x080003000 -e main user_program3.o print_string.o
${LD} -o user_program4 -Ttext 0x080004000 -e main user_program4.o print_string.o

objcopy -R .note -R .comment -S -O binary user_program1 user_program1.bin
objcopy -R .note -R .comment -S -O binary user_program2 user_program2.bin
objcopy -R .note -R .comment -S -O binary user_program3 user_program3.bin
objcopy -R .note -R .comment -S -O binary user_program4 user_program4.bin

cat boot.bin \
    setup.bin \
    kernel.bin \
    user_program1.bin \
    user_program2.bin \
    user_program3.bin \
    user_program4.bin > ./image.img
