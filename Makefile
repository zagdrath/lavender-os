ARCH_DIR=kernel/arch/i386
KERNEL_DIR=kernel
LIBC_DIR=libc

ARCH_FILES=\
$(ARCH_DIR)/boot.s \
$(ARCH_DIR)/crti.s \
$(ARCH_DIR)/crtn.s \

KERNEL_FILES=\
$(KERNEL_DIR)/drivers/tty.c \
$(KERNEL_DIR)/include/tty.h \
$(KERNEL_DIR)/include/vga.h \
$(KERNEL_DIR)/kernel.c \
$(LIBC_DIR)/include/sys/cdefs.h \
$(LIBC_DIR)/include/stdio.h \
$(LIBC_DIR)/include/stdlib.h \
$(LIBC_DIR)/include/string.h \
$(LIBC_DIR)/stdio/printf.c \
$(LIBC_DIR)/stdio/putchar.c \
$(LIBC_DIR)/stdio/puts.c \
$(LIBC_DIR)/stdlib/abort.c \
$(LIBC_DIR)/string/memcmp.c \
$(LIBC_DIR)/string/memcpy.c \
$(LIBC_DIR)/string/memmove.c \
$(LIBC_DIR)/string/memset.c \
$(LIBC_DIR)/string/strlen.c \

all: kernel iso

kernel:
	mkdir build
	i686-elf-as $(ARCH_FILES) -o build/kernel/boot.o
	i686-elf-gcc $(KERNEL_FILES) -o build/kernel.o -std=gnu99 -ffreestanding -O2 -nostdlib -Wall -Wextra -r
	i686-elf-gcc -T kernel/arch/i386/linker.ld -o build/lavender.bin -ffreestanding -O2 -nostdlib build/boot.o build/kernel.o -lgcc

iso:
	mkdir -p build/boot
	mkdir -p build/boot/grub
	mv build/lavender.bin build/boot/lavender.bin
	cat > grub.cfg << EOF
	menuentry "Lavender" {
		multiboot /boot/lavender.bin
	}
	EOF
	mv grub.cfg build/boot/grub/grub.cfg
	grub-mkrescue -o build/boot/lavender.iso build
clean:
	rm -rf build/