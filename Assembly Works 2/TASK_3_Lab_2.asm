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
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"


; Initialize SP, Stack Pointer
ldi r20, HIGH(RAMEND) ; R20 = high part of RAMEND address
out SPH,R20 ; SPH = high part of RAMEND address
ldi R20, low(RAMEND) ; R20 = low part of RAMEND address
out SPL,R20 ; SPL = low part of RAMEND address


ldi r16,0b11111111 ; ALL pins will be available to use as output
out DDRB, r16 

ldi r16,0b00000000; A is input
out DDRA, r16

ldi r22, 0b00000000 ;changes

change_counter:
in r16, PINA		; read from port a
cpi r16, 0b11111101 ; count changes from SW1
breq count_positive
rjmp change_counter

count_positive:
inc r22

count_negative:
com r22
out PORTB, r22
com r22
in r16, PINA
cpi r16, 0b11111101
breq count_negative
inc r22
com r22
out PORTB, r22
com r22

rjmp change_counter










