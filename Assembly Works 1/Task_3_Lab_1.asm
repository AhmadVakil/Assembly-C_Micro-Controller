;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-09-15
; Author:
; Ahmadreza Vakilalroayayi
; 
; Lab number: 1
; Task Number: 3
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
; Other information: CPI helped to solve this problem
;
; Changes in program: (Description and date)
; Task 3:
;	Write a program in Assembly language to read the switches and light LED0 when you
;	press SW5.
;	For all other switches there should be no activity
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

ldi r16,0b11111111 		; ALL pins will be available to use as output
out DDRB, r16 

ldi r16,0b00000000 		; DDRA is input 
out DDRA, r16			; I used r16 again, so new value will clear the last value in register. Except using stack and stack pointer. I mean POP PUSH but here is as simple as it.

my_loop:
in r17, PINA 			; Get the data from PINA a(Switches) and send it into r17
cpi r17,0b00100000		; Is that binary number equal to r17? CPI(Compare with immediate) mean exactly like this question.
brne my_loop			; If it's ne(NOT EQUAL) go back to my_loop, ***OTHERWISE CONTINUE TO NEXT LINE WHICH MEANS THEY ARE EQUAL! 
ldi r16,0b11111110 		; So if it was equal it will be here to turn on the LED 0
;out DDRA, r16 			; OOPS!!: This line seems like not necessery, but don't consider it as a mistake. I will fix it when I go to lab	
out PORTB, r16			; Turn the LED on and go to next line which jumps to the loop again. We want this program to listen to our input all the time and that's why we used loop
rJmp my_loop
