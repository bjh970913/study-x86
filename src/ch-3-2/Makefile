all: ${BUILD_RESULT}

${BUILD_RESULT}: 0.boot.img 1.kernal.img
	cat $^  >> ${BUILD_RESULT}

0.boot.img: 0.boot-refac.asm
	nasm -o $@ $^

1.kernal.img: 1.kernel-refac.asm
	nasm -o $@ $^

clean: all
	rm -rf *.img
