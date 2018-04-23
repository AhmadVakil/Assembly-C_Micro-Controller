;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-09-15
; Author:
; Ahmadreza Vakilalroayayi
; 
;
; Lab number: 1
; Task Number: 5
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
;	Task 5:
;		Write a program in Assembly language that creates a Ring Counter. The values should be
;		displayed with the LEDs. Use shift instructions, LSL or LSR.
;		Make a delay of approximately 0.5 sec in between each count. Write the delay as a
;		subroutine. For using the subroutine, you must initialize the Stack Pointer, SP. Include the
;		following instructions in beginning of your program:
; 
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

; Initialize SP, Stack Pointer
ldi r20, HIGH(RAMEND) 		; R20 = high part of RAMEND address
out SPH,R20 				; SPH = high part of RAMEND address
ldi R20, low(RAMEND) 		; R20 = low part of RAMEND address
out SPL,R20 				; SPL = low part of RAMEND address


ldi r16,0b11111111 			; ALL pins will be available to use as output
out DDRB, r16 


ldi r16,0b11111110			; A is input

ldi r17,0000000010
ldi r18,0b00000001


loop:

out PORTB, r16				; Turn on LED depending on r16 value, value will be changed during the subroutine
call delay					; Go to delay for 0.5 second, without delay you will not be able to see the LEDs blinks. If I need to use the simulator I have to disable it!
lsl r16						; Shif the value of r16 to the left
inc r16						; increase the value,Example: shifting to left from 1 will be 2 and the second LED will light up! Here is the problem we have to increment the value in order to keep to previous value as well to move to next LED.
cpi r16,0xFF				; Are all the LEDs off? Or are they all 1?
brne loop  					; If it's not equal to 1 go back to loop, AND if it's equal keep continue

end:
ldi r16,0b11111110			; Turn the first LED ON
rjmp loop					; Go back to the begining of loop 

delay:						; Just push and pop for delay, I used the link in lecture slides to calculate the delay and to produce the code
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
