OBJ		= objects
BIN		= binary

all: Image

.PHONY: clean run-qemu
clean:
	rm -f $(OBJ)\*.o
	rm -f $(BIN)\bootsect

run-qemu: $(BIN)\bootsect
	qemu-system-i386 -boot a -fda $(BIN)\bootsect

$(BIN)\bootsect: $(OBJ)\bootsect.o ld-bootsect.ld
	ld -T ld-bootsect.ld $(OBJ)\bootsect.o -o $(BIN)\bootsect
	objcopy -O binary -j .text $(BIN)\bootsect

$(OBJ)\bootsect.o: bootsect.S
	as --32 bootsect.S -o $(OBJ)\bootsect.o
