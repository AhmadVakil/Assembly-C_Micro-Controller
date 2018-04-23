;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;	1DT301, Computer Technology I
;	Date: 2017-10-12
;	Author:
;	Ahmadreza Vakilalroayayi
;
;	Lab number: 3
;	Title: Interrupts
;
;	Hardware: STK600, CPU ATmega2560
;
;	Function: 	Using interrupts to simulates the rear lights and brakes on car
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
.equ brakeBits = 2				
.equ resetToRight = 0b00001000	
.equ resetToLeft = 0b00010000	
.cseg

; initialize start
.org 0b00000000
rjmp start

;interrupt for Switch0
.org int0addr
rjmp goRight

;interrupt for Switch1
.org int1addr
rjmp goLeft

.org int2addr
rjmp brakeInterrupt
.org 0x72

start:
; Initialize stack pointer
ldi r16, HIGH(RAMEND) 
out SPH, r16
ldi r16, LOW(RAMEND) 
out SPL, r16


ldi mainValue, 0b11111111
out DDRB, mainValue						;PORTB as output


ldi mainValue, 0b00000000
out DDRD, mainValue						;PORTD as input

clr ledValue							;Clear register

;SW0,SW1,SW2 interrupts
ldi mainValue, (7<<int0)
out EIMSK, mainValue


; set interrupt control 
ldi mainValue, (1<<ISC00) | (1<<ISC10) | (1<<ISC20)
sts EICRA, mainValue
sei

callingLoop:
ldi ledBits, 0b11000011				; Leds lights sets to 0b11000011 at the begining
sbrc ledValue, brakeBits
rcall brake

sbrc ledValue, turnLeft
rcall leftLight
sbrc ledValue, turnRight
rcall rightLight

rcall showLights
rcall ledDelay
rjmp callingLoop

leftLight:
cbr ledBits, 0b11110000
or ledBits, tmpValue
clc									;clear carry flag
lsl tmpValue
brcc stopLeft						; Branch if carry flag is empty and call stopLeft
									
ldi tmpValue, resetToLeft			; If branch was not empty, load resetToLeft into tmpValue to light the leds

stopLeft:
ret

rightLight:
cbr ledBits, 0b00001111
or ledBits, tmpValue				; Perform OR on ledBits and tmpValue
lsr tmpValue						; Shift right
cpi tmpValue, 0b00000001			; Compare tmpValue with 0b00000001
brge stopRight						; If greater branch and go to stopRight

ldi tmpValue, resetToRight			;If not greater then load resetToRight into tmpValue

stopRight:
ret

brake:
ser ledstate						; Set register for brake bits
ret

showLights:
mov reverseValue, ledBits    
com reverseValue					; Reverse the reverseValue to show the lights
out PORTB, reverseValue				; Show it on PORTB
ret


ledDelay:							; 500ms delay
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

pressDelay:							; 100ms delay
	ldi  r30, 130
    ldi  r29, 222
L2: dec  r29
    brne L2
    dec  r30
    brne L2
    nop
ret

goRight:
rcall pressDelay					; Calling a short delay for switch press down and up

sbrc ledValue, turnLeft
reti

cbr ledValue, 0b10000000
ldi changeValue, 0b00000001
eor ledValue, changeValue				
ldi tmpValue, resetToRight			; Change to starting point of right lights (0b00001000)
	
reti

goLeft:
rcall pressDelay					; Calling a short delay for switch press down and up
sbrc ledValue, turnRight
reti
cbr ledValue, 0b00000001
ldi changeValue, 0b10000000
eor ledValue, changeValue			; Perform OR between ledValue and changeValue
ldi tmpValue, resetToLeft			; Change to starting point of right lights (0b00010000)
reti

brakeInterrupt:
rcall pressDelay					; Delay for Switch press
		
ldi changeValue, 0b00000100		
eor ledValue, changeValue			; Perform OR between ledValue and changeValue
reti