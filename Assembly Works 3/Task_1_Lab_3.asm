;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-10-05
; Author:
; Ahmadreza Vakilalroayayi
; 
; Lab number: 3
; Title: How to use interrupts.
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Turn LED ON or OFF when the interrupt switch 0 is pressed;
; Input ports:  PORTD
;
; Output ports: PORTB
;
; Subroutines: If applicable.
; Included files: m2560def.inc
;
; Other information: 
;
; Changes in program: (Description and date)
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

.org 0x00
rjmp start
.org INT0addr				
rjmp ledRoutine
.org 0x72

start :
;Initialize SP, Stack Pointer
ldi r20, HIGH ( RAMEND )	; R20 = high part of RAMEND address
out SPH, R20				; SPH = high part of RAMEND address
ldi R20, low ( RAMEND )		; R20 = low part of RAMEND address
out SPL, R20
.def leds = R18

ldi r16, 0x0b11111111				;Set data direction registers.
out DDRB, r16				;Set B port as output ports
out PORTB, r16
mov leds, r16
ldi r16, 0x0b00000000				;Set data direction registers.
out DDRD, r16				;Set PORTD as input

ldi r16 , 0 b00000010		;Respond to Switch
sts EICRA, r16				;External Interrupt Control Register A(EICRA) for ISC00 

ldi r16, 0b00000001
out EIMSK, r16

sei							;Global Interrupt Enable
ldi r19,0

stop: nop					;This is main subroutin which should not do anything
rjmp stop

ledRoutine:
COM leds					;Invert all bits 
out PORTB , leds			;Show bits on PORTB
reti						;Interrupt Return