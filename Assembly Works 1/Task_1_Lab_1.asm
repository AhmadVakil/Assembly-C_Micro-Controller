;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-09-15
; Author:
; Ahmadreza Vakilalroayayi
; 
;
; Lab number: 1 
; Task Number: 1
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
; Other information: This program will light up the LED number 2, First I have decided to use PORTB as an output (I used 1 to enable the specified pin) and then I used out and 0(Which means ON for the LEDs) for LED2 to turn it on.
;
; Changes in program: (Description and date)
;
; Task 1:
;	Write a program in Assembly language to light LED 2.
;	You can use any of the four ports, but start with PORTB.
;	The program should be very short! How many instructions is minimum number?
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

ldi r16,0b00000100   ; Load the binary number into r16 (Register). Note: we can use hexa decimal(Example: 0xff) AND/OR binary which I already used and decimal
out DDRB, r16 		 ; We have loaded the number into r16 in previous line but now we need to send it to PORTB which will use PORTB as an output

ldi r16, 0b11111011  ; So, now as you see, I used zero which means ON(From right to left as the 0 indicates the LED position also) Note:Now we use LED, but the out put can be anything not just LED)
out PORTB, r16	     ; We have settled everythings, so in this line we just send all we have settled(From r16) into the PORTB

nop
