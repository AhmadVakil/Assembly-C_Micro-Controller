;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;	1DT301, Computer Technology I
;	Date: 2017-10-05
;	Author:
;	Ahmadreza Vakilalroayayi
;
;	Lab number: 3
;	Title: Interrupts 
;
;	Hardware: STK600, CPU ATmega2560
;
;	Function: Using interrupts to Switch between ringcounter and johnson counter
;
;	Input ports: PORTD
;
;	Output ports: PORTB
;
;	Subroutines: If applicable.
;   Included files: m2560def.inc
;
;	Other information:
;
;	Changes in program: (Description and date)
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

.equ ringCounter	= 0b00000000			
.equ johnsonCounter = 0b11111111	
.def currentRing = r16
.def ledsStatus = r17
.def stop = r18								

.org 0x00
jmp reset
.org 0x02
jmp interrupt					; Interrupt 
.org 0x72

reset:
; Initialize stack pointer
ldi r16, low(RAMEND)
out SPL, r16
ldi r16, high(RAMEND)
out SPH, r16

ldi r16, 0b00000000				; PORTA as input
out DDRD, r16

ldi r16, 0b11111111				; PORTB as output
out DDRB, r16

ldi r16, 0b00000001				; Enable INT0
out EIMSK, r16

ldi r16, 0b00000010				
sts EICRA, r16					; Store to data space
sei								 

ldi currentRing, ringCounter			; Starting with ringCounter and load it as currentRing

main:
cpi currentRing, ringCounter			; compare currentRing with ringCounter
brne johnson							; If not equal switch to johnson

ring:	
rcall ringStart					
rjmp reverse

johnson:								; Johnson ring
rcall johnsonStart				

reverse:
com ledsStatus					; Reverse bits
out PORTB, ledsStatus
com ledsStatus					; reverse again

rcall delay						; Delay routin 
rjmp main

johnsonStart:
cpi r22, 0b00000000
breq increment					; if all on then increment the leds
								
decrement:
rcall goRight					
cpi ledsStatus, 0b00000000		
brne return						
ldi r22, 0b00000000				
jmp return

increment:
rcall goLeft					
cpi ledsStatus, 0b11111111		
brne return						
ldi r22, 0b11111111				

return:							
ret

; Going to left 
goLeft:
lsl ledsStatus					; Shift left
inc ledsStatus					
ret								; Subroutine return

; Going to right
goRight:
dec ledsStatus
lsr ledsStatus
ret

; Ring counter starts here
ringStart:						
cpi ledsStatus,0b00000000		; Check leds 			
breq incrementLeds				; If all leds are 0 go to incrementLeds
ldi r19, 0b00000000
lsl ledsStatus					
adc ledsStatus, r19				; Add r19 to ledStatus with carry	
ret								; Subroutine return
	
incrementLeds:
inc ledsStatus					
ret

delay:
ldi r19, 0b00000010					
ldi r20, 0b00000010						
ldi r21, 0b00000010						

delayEnd:
cpi stop, 0b11111111			; Ending delay if bits are 0b11111111
breq stopDelay

dec r19
brne delayEnd

dec r20
brne delayEnd

dec r21
brne delayEnd
nop

stopDelay:
ldi stop, 0b00000000            ; Now change the bits to 0b00000000
ret

interrupt:
com currentRing					; Reverse current ring
ldi stop, 0b11111111
ldi ledsStatus, 0b00000000
reti							; Return the interrupt