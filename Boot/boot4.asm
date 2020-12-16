;-----------
; Boot sector
; Extended the basic example from:
; kupala: https://youtu.be/GOmPPmINoUs , 7.09.2011 ã.
; Thanks also to Linux 0.01
;------------
section .text
org 0x00

;mov ax, 9ch							; B8 9C 00
;mov ss, ax		;set stack segment  ; 8E D0
;mov sp, 32000d	;set stack pointer	; BC 00 10
;mov ax, 7c0h 	;?sets the AL? (AH is rewritten); no  ; B8 C0 07

mov ax, 0x9C							;
mov ss, ax		;set stack segment  ; 8E D0
mov sp, 32000d	;set stack pointer	; BC 00 10
mov ax, 7c0h 	;?sets the AL? (AH is rewritten); no  ; B8 C0 07

mov	ax,cs
mov	ds,ax
mov	es,ax
mov ss,ax
mov	sp, 2048
	
push ax
push ax
push ax

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
_end:		
    ; mov dx, _str1
	 ;mov ah,13h
	 ;int 10h	;print string	 
;_conventional_RAM:     
 ;    int 12h		;to ax
	; mov bx, ax
	 ;;;push 1
	; call _print; text ;code		
    ; jmp _over
;function

       xor cx,cx
       mov bx, 0xfda8
_print: cmp bx,0  ;in bx
		je end_pr
		inc cx	;digit
		;mov al, bl
		mov al,bl
		and al, 0x0f ;only lower 4-bits!!!
		cmp al,10
		jb _digit		
		add al,7	;65, 66, 67 ... a, b, c  ...65 = A ... - 48 - 17 ... but - 10 ...
_digit: add al,48    ;48,49,50,... 0,1,2,...		
        int 10h		
		;and ax, 0x000f
        push ax
	    shr bx,4
		jmp _print		
		
		mov al,32
		mov ah,9
		int 10h  ;space
_reverse: 		nop        
        mov bx,0 
		cmp cx,0
		je _endreverse
		pop ax	;reverse, pop-out
		mov ah,09h		
		xor ah, ah
		int 10h
		dec cx	
        jmp _reverse		
_endreverse: nop		
						
end_pr:	;ret  ;not in function

;_printtext:
_over: mov al, 80
	   int 10h
	   int 10h
	   int 10h
	   int 10h
	   nop
;jmp $			;	E9 FD FF  ?
;-----------------
_str1: db '\nVsedurzhitel...', 13, 10, 0 ; '$' ; $?
times 510-($-$$) db 0	;$ should be current address, $$ - first address
dw 0xAA55	;mark in the end of the boot sector


; 48, 57	
;8E D0 BC 00 10 B8 C0 07 B4 0E B0 66 CD 10 E9 FD FF

;13h Write String 	