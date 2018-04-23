;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-09-15
; Author:
; Ahmadreza Vakilalroayayi
; 
;
; Lab number: 1
; Task Number: 6
;
; Title: How to use the PORTs. Digital input/output. Subroutine call.
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Describe the function of the program, so that you can understand it,
; even if you're viewing this in a year from now!
;
; Input ports: Describe the function of used ports, for example on-board switches
; connected to PORTA.
;
; Output ports: Describe the function of used ports, for example on-board LEDs
; connected to PORTB.
;
; Subroutines: If applicable.
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: (Description and date)
;
;	Task 6:
;		Write a program in Assembly language that creates a Johnson Counter in an infinite loop.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

; In this program we need to turn on all lights one by one going left, and we need to turned them off vice versa. lsl and lsr can be used to shift the value. 

; Initialize SP, Stack Pointer
ldi r20, HIGH(RAMEND)		; R20 = high part of RAMEND address
out SPH,R20 				; SPH = high part of RAMEND address
ldi R20, low(RAMEND) 		; R20 = low part of RAMEND address
out SPL,R20 				; SPL = low part of RAMEND address


ldi r16,0b11111111 			; ALL pins will be available to use as output
out DDRB, r16 

johnson_loop:				
out PORTB, r16				; PORTB is connected to LEDs 	
call delay
com r16						; Reversing the r16
lsl r16						; Shift the value of r16 to left
inc r16						; increment the value 
com r16						; Again reverse the value (if it's 0 will be 1 and vice versa)
cpi r16,0x00				; Are we reached the end? Or all LEDs are ON? then we need to go backward!
brne johnson_loop			; If it's not, jump to the loop again until all the LEDs turned ON

cpi r16,0x00
breq off_all_leds			; If all LEDs are on then we need to turn them off and start over, so we go to the subroutine below

off_all_leds:
ldi r16,0b00000000			; Turn the last LEDs on together with other LEDs and we are getting ready to go backward	
out PORTB,r16				

backward_loop:
out PORTB, r16
call delay

com r16						; in backward_loop we do the same as above but in vice versa
dec r16						; We should decrement instead of increment
lsr r16						; We should shift righ(Going back) instead of going left
com r16						; reversing the value
cpi r16,0xFF				; Comparing to see if all the lamps are off
breq johnson_loop			; Are they off now? If yes, go back to the start of the program and repeat this routine

cpi r16,0x00				; Otherwise we still need to repeat this routine to turn off all the LEDs and make them ready to start the program from the johnson_loop subroutine
brne backward_loop

delay:						; This is my delay between each shift
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
