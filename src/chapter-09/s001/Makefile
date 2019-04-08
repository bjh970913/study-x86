OBJECTS = exam_C1.o

.SUFFIXES : .asm .o
.asm.o :
    nasm -o $@ $^
TARGET = ${BUILD_RESULT}
$(TARGET) : $(OBJECTS)
    rm $@; cat $^ >> $@

clean :
    rm -rf $(OBJECTS)
