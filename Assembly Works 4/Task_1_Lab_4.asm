;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   1DT301, Computer Technology I
;   Date: 2017-10-29
;   Author:
;   Ahmadreza Vakilalroayayi
;
;   Lab number:         4
;   Title:              Timer and USART
;
;   Hardware:           STK600, CPU ATmega2560
;
;   Function:			1 Hz square wave to turn on and off LED0 each 1/2 second.   
;
;   Input ports:        N/A
;
;   Output ports:       PORTB, PINB0
;
;   Subroutines:        N/A
;
;   Included files:     m2560def.inc
;
;   Other information:  N/A
;
;   Changes in program: 
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

.def temp = r16
.def ledLights = r17
.def counter = r18
.equ comparable = 2
.equ foreScale = 0x05				
.equ timer = 6			 
.CSEG
.org 0
rjmp reset

.org ovf0addr					;interrupt vector
rjmp interrupt

.org 0x72

reset:
ldi temp, LOW(RAMEND)
out SPL, temp
ldi temp, HIGH(RAMEND)
out SPH, temp

ldi temp, 0x01
out DDRB, temp

ldi temp, foreScale				;set forescale
out TCCR0B, temp

ldi temp, (1<<TOIE0)			;enabling flag
sts TIMSK0, temp

ldi temp, timer					;Timer value
out TCNT0, temp

sei
clr ledLights

main_loop:
out PORTB, ledLights
rjmp main_loop

interrupt:
in temp, SREG					;Status goes to stack 
push temp
	
ldi temp, timer					;set timer value
out TCNT0, temp
	
inc counter
	
cpi counter, comparable 		;if it is equal to 2 then go to switch_Leds
breq switch_Leds			  
	
rjmp end
	
switch_Leds:
com ledLights 					; Switch LED0
clr counter						; Counter == 0
		
end:
pop temp
out SREG, temp
reti
