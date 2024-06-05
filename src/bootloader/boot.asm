[bits 16]
[org 0x7c00]

KERNEL_ADDRESS equ 0x1000

mov [BOOT_DRIVE], dl		; BIOS stores boot drive in 'dl, store it for later

; setup stack
mov bp, 0x9000
mov sp, bp

call load_kernel
call switch_32b

jmp $

%include "disk.asm"
%include "gldt.asm"
%include "s32b.asm"

[bits 16]
load_kernel:
	mov dl, [BOOT_DRIVE]	; disk to read from
	mov dh, 2				; # of sectors to read
	mov bx, KERNEL_ADDRESS	; destination to place read data
	call disk_load
	ret

[bits 32]
begin_32b:
	call KERNEL_ADDRESS		; give control to the kernel
	jmp $

BOOT_DRIVE db 0

times 510 - ($-$$) db 0
dw 0xaa55
