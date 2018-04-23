;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   1DT301, Computer Technology I
;   Date: 2017-10-30
;   Author:
;   Ahmadreza Vakilalroayayi
;
;   Lab number:         4
;   Title:              Timer and USART
;
;   Hardware:           STK600, CPU ATmega2560
;
;   Function:           Converting the input value from serial port and out put it to PORTB as ASCII code and also pulse it back to the reciever, I used putty to enter chars
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
.equ bitPerSeconds = 12 	
.org 0
rjmp reset

.org 0x72
reset:
;Initial Stack Pointer 
ldi temp, LOW(RAMEND)
out SPL, temp
ldi temp, HIGH(RAMEND)
out SPH, temp

ser temp
out DDRB, temp


ldi temp, bitPerSeconds					;Sereial communication setup
sts UBRR1L, temp						;bps setup


ldi temp, (1<<TXEN1) | (1<<RXEN1)		;To be able to get the data I have enabled the UART flag
sts UCSR1B, temp			

clr ledLights
rcall showLights

main_loop:								;Here I check to see if data is transmitting or not.
lds temp, UCSR1A
sbrs temp, RXC1			
rjmp main_loop		
		
lds ledLights, UDR1						;ledLights will show the value
	
rcall showLights
	
	ldi  r31, 6
	ldi  r30, 19
	ldi  r29, 174
L1: dec  r29
	brne L1
	dec  r30
	brne L1
	dec  r31
	brne L1
	rjmp PC+1


pulser:	
lds temp, UCSR1A
sbrs temp, UDRE1					;If is not set then go back to pulser
rjmp pulser		
sts UDR1, ledLights					; Otherwise send
		
rjmp main_loop

showLights:							; com ledLights and Showing on PORTB 
mov reverser, ledLights
com reverser
out PORTB, reverser
ret