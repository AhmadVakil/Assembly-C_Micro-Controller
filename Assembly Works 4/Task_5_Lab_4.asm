;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   1DT301, Computer Technology I
;   Date: 2017-11-05
;   Author:
;   Ahmadreza Vakilalroayayi
;
;   Lab number:         4
;   Title:              Timer and USART
;
;   Hardware:           STK600, CPU ATmega2560
;
;   Function:           Now we should use interrupts in last task.
;
;   Input ports:        RS232
;
;   Output ports:       PORTB, RS232
;
;   Subroutines:        
;
;   Included files:     m2560def.inc
;
;   Other information:  
;
;   Changes in program: 
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"

.def temp = r16
.def ledLights = r17
.def reverser = r18
.def bitReceivedChecker = r19     ; Flag to check if data is received
.equ bitPerSeconds = 12		
.equ yes = 0b00000001
.equ no = 0b00000000
.cseg

.org 0x00
rjmp reset

.org URXC1addr 
rjmp receiveChecker

.org UDRE1addr
rjmp emptyChecker

.org 0x72

reset:
;Stack Pointer
ldi temp, LOW(RAMEND)
out SPL, temp
ldi temp, HIGH(RAMEND)
out SPH, temp

ser temp
out DDRB, temp

ldi temp, bitPerSeconds		;Serial communication setup
sts UBRR1L, temp			;setting bps rate

ldi temp, (1<<RXEN1) | (1<<TXEN1) | (1<<RXCIE1) | (1<<UDRIE1)
sts UCSR1B, temp			; UART flag is enabled

sei
clr ledLights

main_loop:					; Waits for interrupts and showing lights to PORTB
	rcall showLights		; reverse the value and show it on PORTB
	rjmp main_loop

showLights:					
	mov reverser, ledLights
	com reverser
	out PORTB, reverser
	ret

receiveChecker:				; If data is recieved by UART 0 show it on ledLights
	lds ledLights, UDR1		; ledLights value is changed
    ldi bitReceivedChecker, yes

    reti




emptyChecker: 
    cpi bitReceivedChecker, no		; If bitReceivedChecker is equal to 0 then send to the receiver
    breq isEmpty

	sts UDR1, ledLights		
	ldi bitReceivedChecker, no
        
    isEmpty:
        reti
