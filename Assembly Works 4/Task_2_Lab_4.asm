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
;   Function:           Pulse width modulator applied on task one can change the duty cycle by pressing switches
;
;   Input ports:        PINC0 , PINC1 , PORTC 
;
;   Output ports:       PORTB , PINB0
;
;   Subroutines:        
;
;   Included files:     m2560def.inc
;
;   Other information:  N/A
;
;   Changes in program: 
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"

.def temp = r16
.def ledLights = r17				; Output value to leds
.def reverser = r18	 
.def counter = r19       
.def cycles = r20
.equ timeCounter = 206             
.equ off = 0b00000000
.equ on = 0b00000001
.equ lowCycleValue = 0
.equ highCycleValue = 20
.cseg

.org 0					; Begin the function
rjmp reset

.org OVF0ADDR			; Over timer value
rjmp timer_interrupt

.org INT0ADDR			; SW0 interrupt
rjmp interrupt0

.org INT1ADDR			; SW1 interrupt
rjmp interrupt1

.org 0x72

;Initialize stack pointer
reset:
ldi temp, LOW(RAMEND)
out SPL, temp
ldi temp, HIGH(RAMEND)
out SPH, temp

ldi temp, 0x01
out DDRB, temp

; Set prescale to 1024
ldi temp, 0x05
out TCCR0B, temp

 
ldi temp, (1<<TOIE0)						; Interrupt for timer end
sts TIMSK0, temp


ldi temp, timeCounter						; Set value for timeCounter
out TCNT0, temp


ldi temp, (3 << INT0)						; Interrupts SW0 , SW1
out EIMSK, temp


ldi temp, (3 << ISC00) | (3 << ISC10)		; When switch released
sts EICRA, temp

sei
clr ledLights
ldi cycles, 9

main_loop:
rcall showLights
rjmp main_loop

showLights:
mov reverser, ledLights
com reverser
out PORTB, reverser
ret
	
timer_interrupt:
	
in temp, SREG						; Status should goes to stack
push temp
	
	
ldi temp, timeCounter				; Reset timer
out TCNT0, temp

cpi counter, highCycleValue
brlo cycleChecker

ldi counter, lowCycleValue

cycleChecker:
cp counter, cycles				 ; if counter is lower than cycles
brlo turnONleds						 ; if yes LED on
rjmp turnOFFleds					 ; Otherwise LED off
	
turnONleds:
ldi ledLights, on
rjmp timerEnd

turnOFFleds:
ldi ledLights, off
		
timerEnd:
inc counter
pop temp
out SREG, temp
reti

interrupt0:
lds temp, PORTD
	
	sw0_loop:
    ldi  r31, 130
    ldi  r30, 222
L1: dec  r30
    brne L1
    dec  r31
    brne L1
    nop

	lds r29, PORTD
	cp temp, r29
	brne sw0_loop

    cpi cycles, highCycleValue		 ; is cycles equal to 20?
    breq switchZeroEnd				 ; If yes end 

inc cycles							 ; Other wise increse it

switchZeroEnd:
ldi temp, 0x00
sts EIFR, temp
reti

interrupt1:
lds temp, PORTD
	
	sw1_loop:
    ldi  r31, 130
    ldi  r30, 222
L2: dec  r30
    brne L2
    dec  r31
    brne L2
    nop

	lds r29, PORTD
	cp temp, r29
	brne sw1_loop

cpi cycles, lowCycleValue			; is cycles equal to 0?
breq switchZeroEnd					; If yes end 

dec cycles							; Otherwise decrement the value

switchOneEnd:
ldi temp, 0x00
sts EIFR, temp
reti
