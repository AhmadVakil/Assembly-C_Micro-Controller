;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-09-15
; Author:
; Ahmadreza Vakilalroayayi
; 
;
; Lab number: 1
; Task Number: 2
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
; Other information: Refer to PDF file included in main zip folder to read about my experiment, but I have also explained here to have more clear. 
;
; Changes in program: (Description and date)
;
; Task 2:
; 	Write a program in Assembly language to read the switches and light the corresponding LED.
; 	Example: When you press SW5, LED5 so should light.
; 	Make an initialization part of the program and after that an infinite loop.
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

ldi r16,0b11111111  ; ALL pins will be available to use as output
out DDRB, r16 

ldi r16, 0b00000000 ; DDRA is input
out DDRA, r16

my_loop:            ; This is a subroutine
in r17, PINA  		; Get the data from PINA (Switches) and keep it into r17
out PORTB, r17	    ; PORTB is connected to LEDS and is output
rJmp my_loop 	    ; Go back to the my_loop subroutine 

nop                 ; Do nothing
