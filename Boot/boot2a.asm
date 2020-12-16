;-----------
; Boot sector
; Extended the basic example from:
; kupala: https://youtu.be/GOmPPmINoUs , 7.09.2011 ã.
; Thanks also to Linux 0.01
;------------
section .text
org 0x00

mov ax, 9ch							; B8 9C 00
mov ss, ax		;set stack segment  ; 8E D0
mov sp, 4096d	;set stack pointer	; BC 00 10
mov ax, 7c0h 	;?sets the AL? (AH is rewritten); no  ; B8 C0 07
;--------------
mov ah, 0eh		;					B4 0E
mov al, 66h	;					B0 66
int 10h			;BIOS call to print a character	;	CD 10
;jmp $			;	E9 FD FF  ?
;-----------------
times 510-($-$$) db 0	;$ should be current address, $$ - first address
dw 0xAA55	;mark in the end of the boot sector

	
;8E D0 BC 00 10 B8 C0 07 B4 0E B0 66 CD 10 E9 FD FF
