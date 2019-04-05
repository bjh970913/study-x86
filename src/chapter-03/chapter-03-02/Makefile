OBJECTS = 0.boot-refac.o 1.kernel-refac.o


.SUFFIXES : .asm .o
.asm.o :
    nasm -o $@ $^
TARGET = ${BUILD_RESULT}
$(TARGET) : $(OBJECTS)
    rm $@; cat $^ >> $@

clean :
    rm -rf $(OBJECTS)
