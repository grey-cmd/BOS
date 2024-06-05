disk_load:
	pusha
	push dx

	mov ah, 0x02	; read mode
	mov al, dh	; read from dh number of sectors
	mov cl, 0x02	; start from sec2 (sec1 is the bootloader)
	mov ch, 0x00	; cylinder 0
	mov dh, 0x00	; head 0
	; dl		- drive number is set as input to disk_load
	; es:bh	- offset buffer pointer is set as input as well

	int 0x13
	jc disk_err

	pop dx		; get back # of sectors to read
	cmp al, dh
	jne sect_err

	popa
	ret

disk_err:
	jmp disk_loop

sect_err:
	jmp disk_loop

disk_loop:
	jmp $
