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
;	Function: 	Using interrupts to simulates the rear lights on car
;
;	Input ports: PORTD
;
;	Output ports: PORTB
;
;	Subroutines: If applicable.
;	Included files: m2560def.inc
;
;	Other information:
;	
;	Changes in program: (Description and date)
;		
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"

.def mainValue = r16
.def ledBits = r17						
.def ledValue = r18						
.def tmpValue = r19						
.def reverseValue = r20					
.def changeValue = r21					
.equ turnRight = 0						
.equ turnLeft = 7						
.equ resetToRight = 0b00001000			
.equ resetToLeft = 0b00010000			
.cseg

.org 0b00000000							;initialize start
rjmp start

.org int0addr							;interrupt for Switch0
rjmp goRight


.org int1addr							;interrupt for Switch1
rjmp goLeft
.org 0x72

start:
; initialize Stack Pointer
ldi r16, HIGH(RAMEND)	
out SPH, r16
ldi r16, LOW(RAMEND) 
out SPL, r16

ldi mainValue, 0b11111111
out DDRB, mainValue			   			;PORTB as output

ldi mainValue, 0b00000000
out DDRD, mainValue						;PORTD as input

clr ledValue							; Clear register


ldi mainValue, (3<<int0)				;SW0 and SW1 interrupts
out EIMSK, mainValue
	

ldi mainValue, (1<<ISC00)|(1<<ISC10)	; set interrupt control
sts EICRA, mainValue
sei

callingLoop:
clr ledBits

sbrs ledValue, turnLeft				; Skip if bits are set
sbr ledBits, 0b11000000				; Load 0b11000000 into register

sbrs ledValue, turnRight			;Skip if bits set
sbr ledBits, 0b00000011				; Load 0b00000011 into register

sbrc ledValue, turnLeft				; Skip if bits are cleared
rcall leftLight

sbrc ledValue, turnRight			; Skip if bits are cleared
rcall rightLight

rcall showLights
rcall ledDelay
rjmp callingLoop


leftLight:
cbr ledBits, 0b11110000
or ledBits, tmpValue
clc									
lsl tmpValue
brcc stopLeft						
ldi tmpValue, resetToLeft		

stopLeft:
ret

rightLight:
cbr ledBits, 0b00001111
or ledBits, tmpValue
lsr tmpValue
cpi tmpValue, 1
brge stopRight						

ldi tmpValue, resetToRight	

stopRight:
ret

showLights:
mov reverseValue, ledBits
com reverseValue
out PORTB, reverseValue
ret									;Return the interrupt


ledDelay:							; 500 ms delay 
	ldi  r31, 3
	ldi  r30, 138
	ldi  r29, 86
L1: dec  r29
	brne L1
	dec  r30
	brne L1
	dec  r31
	brne L1
	rjmp PC+1
ret


pressDelay:							; 100 ms delay  
	ldi  r30, 130
	ldi  r29, 222
L2: dec  r29
	brne L2
	dec  r30
	brne L2
	nop
ret
	
goRight:
rcall pressDelay					 ; Calling a short delay for switch press down and up

sbrc ledValue, turnLeft
reti

cbr ledValue, 0b10000000
ldi changeValue, 0b00000001
eor ledValue, changeValue			;turnRight bit toogle
ldi tmpValue, resetToRight			;tmpValue = starting bit string
reti

goLeft:
rcall pressDelay

sbrc ledValue, turnRight
reti

cbr ledValue, 0b00000001
ldi changeValue, 0b10000000
eor ledValue, changeValue		
ldi tmpValue, resetToLeft		
reti