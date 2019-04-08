#!/usr/bin/env bash

nasm -f elf  -o exam2_asm.o exam2.asm
gcc -o exam2.o -m32 -c exam2.c -g
gcc -o exam2 -g -m32 exam2.o exam2_asm.o 

./exam2
