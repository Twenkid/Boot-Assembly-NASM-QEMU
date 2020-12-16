;-----------
; Boot sector
; Current "player" of this code - Todor Arnaudov, Tosh/Twenkid/Razumir
; Extended the basic example from:
; kupala: https://youtu.be/GOmPPmINoUs , 7.09.2011 ã.
; Thanks also to Linux 0.01, OSDev.org, ... Ralf Brown interrupt's list HTML version, 
; http://www.moon-soft.com/program/FORMAT/other/VGA.htm 
; IBM-PC ... Peter Norton ...
; etc. :)
; 18-5-2016 -- OK, QEMU! So far the best one for quick exploration and experimentation (.bin files), no bloated settings list.
;------------
section .text
org 0x00

;mov ax, 9ch							; B8 9C 00
;mov ss, ax		;set stack segment  ; 8E D0
;mov sp, 32000d	;set stack pointer	; BC 00 10
;mov ax, 7c0h 	;?sets the AL? (AH is rewritten); no  ; B8 C0 07

xor ax, ax							;
mov ss, ax		;set stack segment  ; 8E D0
mov ds, ax
mov sp, 32000d	;set stack pointer	; BC 00 10
mov ax, 7c0h 	;?sets the AL? (AH is rewritten); no  ; B8 C0 07


; cli  -- int off - for switching modes!  --> sti

;mov	ax,cs
;mov	ds,ax
;mov	es,ax
;mov ss,ax
;mov	sp, 2048
	
push ax
push ax
push ax

mov ah,0
mov al,0h
int 10h ;$B800  ... 40x25?

;10h = g 80x25 8x14 640x350 4 2 a000 64k ega
;00= t 40x25 9x16 16 8 b800 vga

 
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
		
end_pr:		
        mov ah, 0eh
		add al, 100
		int 10h
		int 10h
		int 10h
		int 10h
		
		;mov ax,0xb000
		mov ax, 0xB800 ; 0xA000
		mov es, ax		
		mov di, 0
		;mov al, 67		;write directly in VGA memory, text mode, monochrome?
		mov dx, 0x0906
						
_put:	;mov ax, 13h ; //AH = 0, set mode, al = 13h, mode
        ;int 10h
		;mov ax, 0xA000
		
		;mov [es:di], dl	 ;write all - hope something to appear
		mov [es:di], dx  ;write all - hope something to appear
_cyc2:		
		;inc dh	;dh - the color and background
		inc dl
		add di,2
		cmp di, 16384
		je _nextseg
		jmp _put
		;je _nextseg		
		;jmp _put
_nextseg: mov ax, 0x0e43		
		int 10h
		int 10h
		int 10h

        ;mov ax, es
		;add ax, 4096		
		;mov es, ax
		;jmp _put  ;endless cycle ... no...				         
		
		;je _reverse
		;mov al,32
		;mov ah,9
		;int 10h  ;space
_reverse: 		nop        
        ;mov bx,0 
		;cmp cx,0
		;je _endreverse
		;pop ax	;reverse, pop-out
		;mov ah,09h		
		;xor ah, ah
		;int 10h
		;dec cx	
        ;jmp _reverse		
_endreverse: nop		
						
;end_pr:	;ret  ;not in function

;_printtext:
_over: ;mov ah, 09h ;final PPPP   ;don't use in VGA $B800
       ;mov al, 80
	   ;int 10h
	   ;int 10h
	   ;int 10h
	   ;int 10h
	   nop
;jmp $			;	E9 FD FF  ?
;-----------------
_str1: db '\nVsedurzhitel...', 13, 10, 0 ; '$' ; $?
times 510-($-$$) db 0	;$ should be current address, $$ - first address
dw 0xAA55	;mark in the end of the boot sector


; 48, 57	
;8E D0 BC 00 10 B8 C0 07 B4 0E B0 66 CD 10 E9 FD FF

;13h Write String 	