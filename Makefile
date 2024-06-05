# $@ -> target file
# $< -> first dependency
# $^ -> all dependencies

default: run

#--------------------------
bin/kernel.bin: bin/kent.o bin/kernel.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --entry main --oformat binary

bin/kent.o: src/bootloader/kent.asm
	nasm $< -f elf -o $@

bin/kernel.o: src/kernel/kernel.c
	gcc -fno-pie -m32 -ffreestanding -c $< -o $@

#--------------------------
bin/boot.bin:
	$(MAKE) -C src/bootloader

bin/os.bin: bin/boot.bin bin/kernel.bin
	cat $^ > $@

#--------------------------
run: bin/os.bin bin/boot.bin
	qemu-system-x86_64 $<

clean:
	$(RM) bin/*.bin bin/*.o bin/*.dis
