;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2017-09-29
; Author:
; Ahmadreza Vakilalroayayi
; 
;
; Lab number: 2
; Title: Using specified delay in TASK5 from previous LAB
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Description can be found in the report.
;
; Input ports: No input port
;
; Output ports: PORTB (LEDs)
;
; Subroutines: Delay subroutines and ring_counter subroutine
; Included files: m2560def.inc
;
; Other information: This program will increase and decrease the delay with changing the timer number.
;
; Changes in program: (Description and date)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"

.equ timer = 500						; Can be changed to have different delays
.def lightValue = r16
; Initialize SP, Stack Pointer
ldi r16, high(RAMEND)					; R16 = high part of RAMEND address
out SPH, r16							; SPH = high part of RAMEND address
ldi r16, low(RAMEND)					; R16 = low part of RAMEND address
out SPL, r16							; SPL = low part of RAMEND address

ldi r16, 0xFF							; Set PORTB as output
out DDRB, r16	

ldi lightValue, 0x01					; load 0x01 into lightValue(r16)
rjmp ring_counter

;One milisecond delay
delay:
	push r16			
	push r17

	L0:
	ldi r16, low(500)
	ldi r17, high(500)

	L1:
	dec r16
	nop
	brne L1				
	dec r17
	nop
	brne L1

	sbiw r25:r24, 1			; Subtract 1 from these register pairs
	brne L0					; If not equal go to L0 until it reach the time
	pop r17					; pop the r17 value from the stack
	pop r16					; pop the r16 value from the stack

ret

ring_counter:

	com lightValue			; Reverse the lightValue
	out PORTB, lightValue	; Show the value of lightValue on PORTB
	com lightValue			; Reverse lightValue again to work on it
	ldi r24, low(timer)		; timer is already sets to 500ms above 
	ldi r25, high(timer)
	rcall delay				; Call the delay subroutine
	ldi r17, 0
	lsl lightValue			; Shift the lightValue to left
	adc lightValue, r17		; add r17 to lightValue	with carry

rjmp ring_counter		