[bits 16]

switch_32b:
	cli					; disable interrupts
	lgdt [gdt_descriptor]	; load gdt
	mov eax, cr0
	or eax, 0x1			; enable protected mode
	mov cr0, eax
	jmp CODE_SEG:init_32b	; far jump

[bits 32]
init_32b:
	mov ax, DATA_SEG		; update segment registers
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000		; setup stack
	mov esp, ebp

	call begin_32b			; move back to boot.asm
