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
;   Function:           Converting the input value from serial port and out put it to PORTB as ASCII code, I used putty to enter chars
;
;   Input ports:        RS232
;
;   Output ports:       PORTB
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
.equ bitPerSeconds = 12 	; Setting the bps value

;Initial Stack Pointer
ldi temp, LOW(RAMEND)
out SPL, temp
ldi temp, HIGH(RAMEND)
out SPH, temp

ser temp
out DDRB, temp

ldi temp, bitPerSeconds		;Sereial communication setup
sts UBRR1L, temp			;bps setup

ldi temp, (1<<RXEN1)		; To be able to get the data I have enabled the UART flag
sts UCSR1B, temp			

clr ledLights
rcall showLights

main_loop:					; Here I check all the time to see if any data is transmitting or not.
lds temp, UCSR1A
sbrs temp, RXC1		    
rjmp main_loop		
		
lds ledLights, UDR1			; ledLights will show the value

end:
rcall showLights
rjmp main_loop

showLights:
mov reverser, ledLights
com reverser
out PORTB, reverser
ret