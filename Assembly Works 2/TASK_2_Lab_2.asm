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
; Function: Working with possibilities to creat a dice game. The LEDs will be turned on which means the number of dice will shown by LEDs. There are 6 possiblities.
; Please refer to Laboration file in moodle to see how dice number should be converted into STK600 LEDs.
; Input ports: SW1 will be used which is
; connected to PORTA.
;
; Output ports: Description can be found in the report.
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

dice:
;out PORTB, r16
ldi r17,6 ; This is here for LEDs lights
in r16, PINA
cpi r16, 0b11111101 ; if PINA value is equal to SW1 
breq generate_number ; if yes then go to generate_number subroutine
rjmp dice ; otherwise jump to dice

generate_number:
in r16, PINA
cpi r16, 0b11111101
brne show_my_chance

dec r17
brne generate_number

ldi r17, 6
rjmp generate_number


show_my_chance:
cpi r17, 1
breq change1

cpi r17, 2
breq change2

cpi r17, 3
breq change3

cpi r17, 4
breq change4

cpi r17, 5
breq change5

cpi r17, 6
breq change6

change1:
ldi r17, 0b11101111
out PORTB, r17
call delay
rjmp dice

change2:
ldi r17, 0b01111101
out PORTB, r17
call delay
rjmp dice

change3:
ldi r17, 0b01101101
out PORTB, r17
call delay
rjmp dice

change4:
ldi r17, 0b00111001
out PORTB, r17
call delay
rjmp dice

change5:
ldi r17, 0b00101001
out PORTB, r17
call delay
rjmp dice

change6:
ldi r17, 0b00010001
out PORTB, r17
call delay
rjmp dice

rjmp generate_number

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








