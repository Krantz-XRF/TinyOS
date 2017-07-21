all: Image

.PHONY: clean run-qemu
clean:
	rm -f *.o

run-qemu: bootsect
	qemu-system-i386 -boot a -fda bootsect

bootsect: bootsect.o ld-bootsect.ld
	ld -T ld-bootsect.ld bootsect.o -o bootsect
	objcopy -O binary -j .text bootsect

bootsect.o: bootsect.S
	as --32 bootsect.S -o bootsect.o
