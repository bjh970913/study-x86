OBJECTS = exam.o exam.run

.SUFFIXES : .asm .o
.SUFFIXES : .c .o

.asm.o :
	nasm -o $@ $^
.c.o:
	gcc -c $^ -o $@

TARGET = ${BUILD_RESULT}
$(TARGET) : $(OBJECTS)
	rm $@; cat $^ >> $@

clean :
	rm -rf $(OBJECTS)
