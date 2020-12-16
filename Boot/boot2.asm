section .text
org 0x00

mov ax, 9ch	
mov ss, ax	;set stack segment
mov sp, 4096d	;set stack pointer
mov ax, 7c0h 	;?sets the AL? (AH is rewritten); no

mov ah, 0eh
mov al, 66h
int 10h			;BIOS call to print a character
jmp $

section .data

times 510-($-$$) db 0	;$ should be current address, $$ - first address
dw 0xAA55	;mark in the end of the boot sector

times 1476500 db 0 ;$fill a floppy size


