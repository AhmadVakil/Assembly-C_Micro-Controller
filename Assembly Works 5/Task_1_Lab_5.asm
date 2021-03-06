;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   1DT301, Computer Technology I
;   Date: 2017-11-12
;   Author:
;   Ahmadreza Vakilalroayayi
;
;   Lab number:         5
;   Title:              JHD202 and displaying text from serial port. Writing char into display
;
;   Hardware:           STK600, CPU ATmega2560
;
;   Function:			Working on display JHD202 and serial port to show the character.
;
;   Input ports:        N/A
;
;   Output ports:       
;
;   Subroutines:        N/A
;
;   Included files:     m2560def.inc
;
;   Other information:  N/A
;
;   Changes in program: 
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"

.def tmp=r16
.def Data=r17
.def RS=r18
.equ FourBits=0b00000010	
.equ DisplayClear=0b00000001		
.equ Display=0b00001111				
.cseg
.org 0x0000							
jmp reset
.org 0x0072


reset:
ldi tmp,HIGH(RAMEND)		
out SPH,tmp					
ldi tmp,LOW(RAMEND)			
out SPL,tmp					
ser tmp						
out DDRE,tmp				
clr tmp;r16=0
out PORTE,tmp

Initialize_Display:
rcall power_up_wait			
ldi Data,FourBits			
rcall write_nibble			
rcall short_wait			
ldi Data,Display			
rcall write_cmd				
rcall short_wait			
rcall clr_disp
ldi Data,0b00100101
rcall write_char

loop:nop
rjmp loop	
			
clr_disp:
ldi Data,DisplayClear	
rcall write_cmd			
rcall long_wait			
ret

write_char:
ldi RS,0b00100000
rjmp write

write_cmd:
clr RS

write:
mov tmp,Data				
andi Data,0b11110000		
swap Data					
or Data,RS					
rcall write_nibble			
mov Data,tmp				
andi Data,0b00001111		
or Data,RS					

write_nibble:
rcall switch_output			
nop							
sbi PORTE,5					;enabling high for display JHD202A
nop
nop
cbi PORTE,5					;enabling low for display JHD202A
nop
nop
ret

; Waitings
short_wait:
clr zh
ldi zl,30
rjmp wait_loop

long_wait:
ldi zh,HIGH(1000)	
ldi zl,LOW(1000)
rjmp wait_loop

dbnc_wait:
ldi zh,HIGH(4600)	
ldi zl,LOW(4600)
rjmp wait_loop

power_up_wait:
ldi zh,HIGH(9000)	
ldi zl,LOW(9000)

wait_loop:
sbiw z,1
brne wait_loop
ret


;Configuring JHD202A
switch_output:
push tmp
clr tmp
sbrc Data,0				;D4=1?
ori tmp,0b00000100			;Set pin2
sbrc Data,1				;D5=1?
ori tmp,0b00001000			;Set pin3
sbrc Data,2				;D6=1?
ori tmp,0b00000001			;Set pin0
sbrc Data,3				;D7=1?
ori tmp,0b00000010			;Set pin1
sbrc Data,4				;E=1?
ori tmp,0b00100000			;Set pin5
sbrc Data,5				;RS=1?
ori tmp,0b10000000			;Set pin7
out porte,tmp
pop tmp

ret