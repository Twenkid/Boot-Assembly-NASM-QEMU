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
mov al, 63h
int 10h
mov cx, 19h
mov dx, 1675h
add cx,dx
mov al, cl
int 10h
mov al, ch
int 10h
mov cx,255d
mov al,0h
_cyc:
    int 10h
	dec cx
	cmp cx,0
	inc al
	je _end
	jmp _cyc
	
    call _print	 	
    mov dx, _str1
	 mov ah,13h
	 int 10h	;print string
_conventional_RAM:     
     int 12h		;to ax
	 mov bx, ax
	 ;push 1
	 call _print; text ;code		
     call _over
;function

_print: cmp bx,0  ;in bx
		je end_pr
		mov al,bh
		cmp al,10
		jb _print010		
		add al,65
_digit: int 10h		
	    shr bx,4
		jmp _print
end_pr:	ret

;_printtext:
_end: nop
;jmp $			;	E9 FD FF  ?
;-----------------
times 510-($-$$) db 0	;$ should be current address, $$ - first address
dw 0xAA55	;mark in the end of the boot sector
_str1: db '\nVsedurzhitel...', 13, 10, '$' ; $?


; 48, 57	
;8E D0 BC 00 10 B8 C0 07 B4 0E B0 66 CD 10 E9 FD FF

;13h Write String 	