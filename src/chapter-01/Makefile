OBJECTS = 0.boot.o 1.boot.o


.SUFFIXES : .asm .o
.asm.o :
	nasm -o $@ $^
TARGET = ${BUILD_RESULT}
$(TARGET) : $(OBJECTS)
	rm $@; cat $^ >> $@

clean :
	rm -rf $(OBJECTS)
