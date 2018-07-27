all: ${BUILD_RESULT}

${BUILD_RESULT}: 0.boot.img 1.boot.img
	echo $^
	cat $^  >> ${BUILD_RESULT}

0.boot.img: 0.boot.asm
	nasm -o $@ $^

1.boot.img: 1.boot.asm
	nasm -o $@ $^

clean: all
	rm -rf *.img
