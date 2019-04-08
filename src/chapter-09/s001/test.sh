gcc -o exam.o -c exam.c
ld -o exam -Ttext 0x00 -e main exam.o
objdump -D exam.o > exam_objdump.txt
objcopy -R .note -R .comment -S -O binary exam exam.bin

nm --line-numbers exam | sort > exam_nm.txt
ndisasm -b 32 exam.bin > exam_disasm.txt

