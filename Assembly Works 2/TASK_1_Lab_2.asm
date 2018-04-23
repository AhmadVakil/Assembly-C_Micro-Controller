;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2016-09-29
; Author:
; Ahmadreza Vakilalroayayi
; 
;
; Lab number: 2
; Title: How to use the PORTs. Digital input/output. Subroutine call.
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Switch between ring counter and johnson counter with SW0. 
;
; Input ports: When SW0 is pressed the subroutines will be changed(SW0==PORTA)
;
; Output ports: PORTB
;
; Subroutines: If applicable.
; Included files: m2560def.inc
;
; Other information: 
;
; Changes in program: (Description and date)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"


; Initialize SP, Stack Pointer
ldi r20, HIGH(RAMEND) ; R20 = high part of RAMEND address
out SPH,R20 ; SPH = high part of RAMEND address
ldi R20, low(RAMEND) ; R20 = low part of RAMEND address
out SPL,R20 ; SPL = low part of RAMEND address


ldi r16,0b11111111 ; ALL pins will be available to use as output
out DDRB, r16 

ldi r21,0b00000000; A is input
out DDRA, r21


johnson_loop:

in r21,PINA			; Get the value from PINA and register it on r21
cpi r21,0b11111110	; if Switch one pressed go to Ring_Counter
breq ring_counter

out PORTB, r16 ; Show the value of r16 on PORTB
call delay	; Call the delay subroutine 

com r16	; Reverse r16
lsl r16	; Shift r16 to left
inc r16 ; increase r16
com r16 ; Reverse r16 again

cpi r16,0x00	; compare if all LEDs are ON
brne johnson_loop ; If all LEDs are on then go back to johnson_loop  

cpi r16,0x00	; compare r16 with 0  
breq off_all_leds	; If all ON then ==> off_all_leds one by one and go backward


off_all_leds:
ldi r16,0b00000000 
out PORTB,r16

; Going backward in johnson counter
backward_loop:
in r21,PINA	
cpi r21,0b11111110
breq ring_counter

out PORTB, r16
call delay

com r16
dec r16
lsr r16
com r16

cpi r16,0xFF
breq johnson_loop

cpi r16,0x00
brne backward_loop

; Delay subroutine
delay:
	push r18
	push r19
	push r20

	ldi  r18, 3
    ldi  r19, 138
    ldi  r20, 86

L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
    rjmp PC+1

pop r20
pop r19
pop r18
ret



ring_counter:
ring_loop:

in r22,PINA
cpi r22,0b11111110
breq change_to_johnson
out PORTB, r16
call delay

lsl r16
inc r16

cpi r16,0xFF
brne ring_loop

end:
ldi r16,0b11111110
rjmp ring_loop

rjmp ring_counter

change_to_johnson:
ldi r16,0b11111111
rjmp johnson_loop

change_to_ring:
ldi r16,0b11111110; A is input
rjmp ring_counter












