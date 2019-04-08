OBJECTS = boot_paging.o setup.o kernel_paging.o user_program1.o user_program2.o user_program3.o user_program4.o user_program5.o

.SUFFIXES : .asm .o
.asm.o :
	nasm -o $@ $^
TARGET = ${BUILD_RESULT}
$(TARGET) : $(OBJECTS)
	rm $@; cat $^ >> $@

clean :
	rm -rf $(OBJECTS)
