;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   1DT301, Computer Technology I
;   Date: 2017-11-12
;   Author:
;   Ahmadreza Vakilalroayayi
;
;   Lab number:         5
;   Title:              JHD202 and displaying text from serial port. BINGO machine
;
;   Hardware:           STK600, CPU ATmega2560
;
;   Function:			Working on display JHD202 and serial port to show the character.
;
;   Input ports:        N/A
;
;   Output ports:       
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
.def tmp = r16
.def Data = r17
.def RS = r18
.def number = r19
.def numTwo = r20
.def numThree = r21
.equ exPort = PORTD
.equ exData = DDRD
.equ Display = 0b00001111
.equ high_Chance = 75
.equ low_Chance = 1
.equ FourBits = 0b00000010
.equ DisplayClear = 0b00000001
.equ ON = 0b00100000
.equ lcd = PORTE                   ; lcd PORT

.equ lcdData = DDRE                ; lcd Data
.equ lcdOut = 0b00110000 
             
.cseg
.org 0x00
jmp reset
.org int0addr
jmp sw0
.org 0x72

reset:
; Initialize stack pointer
ldi tmp, HIGH(RAMEND)
out SPH, tmp
ldi tmp, LOW(RAMEND)
out SPL, tmp
    
; LCD port
ser tmp
out lcdData, tmp
clr tmp
out exData, tmp 
	 
rcall init_display
ldi tmp, (1<<int0)
out EIMSK, tmp
    
ldi tmp, (3<<ISC00)
sts EICRA, tmp
        
sei
    
rjmp newBingo

Bingo:
cpi number, high_Chance
brge newBingo
inc number
rjmp Bingo

newBingo:
ldi number, low_Chance
rjmp Bingo

init_display:
rcall power_up_wait                 
ldi Data, FourBits                  
rcall write_nibble
rcall short_wait
ldi Data, Display
rcall write_cmd
rcall short_wait

clear_display:
ldi Data, DisplayClear
rcall write_cmd
rcall long_wait
ret

write_char:
ldi RS, ON
rjmp write

write_cmd:
clr RS

write:
mov tmp, Data
andi Data, 0b11110000              ; Clear lower nibble
swap Data
or Data, RS                         ; Add RS to command to write
rcall write_nibble                  ; send high nibble
mov Data, tmp
andi Data, 0b00001111              ; Clear high nibble
or Data, RS

write_nibble:
rcall switch_output
nop
sbi lcd, 5
nop
nop
cbi lcd, 5
nop
nop
ret

short_wait: 
clr ZH
ldi ZL, 30
rjmp wait_loop
long_wait:  
ldi ZH, HIGH(1000)
ldi ZH, LOW(1000)
rjmp wait_loop
dbnc_wait:  
ldi ZH, HIGH(4600)
ldi ZL, LOW(4600)
rjmp wait_loop
power_up_wait:
ldi ZH, HIGH(9000)
ldi ZL, LOW(9000)

wait_loop:  
sbiw Z, 1
brne wait_loop
ret

; Setting up output for LCD JHD202C
switch_output:
push tmp
clr tmp
sbrc Data, 0                  ;D4 ?
ori tmp, 0b00000100           ;set PIN3
sbrc Data, 1                  ;D5 ?
ori tmp, 0b00001000           ;set PIN4
sbrc Data, 2                  ;D6 ?
ori tmp, 0b00000001           ;set PIN0
sbrc Data, 3                  ;D7 ?
ori tmp, 0b00000010           ;set PIN1
sbrc Data, 4                  ;E ?
ori tmp, 0b00100000           ;set PIN5
sbrc Data, 5                  ;RS ?
ori tmp, 0b10000000           ;set PIN7

out lcd, tmp
pop tmp
ret

sw0:
in tmp, SREG
push tmp
mov numThree, number
lds tmp, PORTD
    
sw0_loop:
ldi  r31, 130
ldi  r30, 222
L1: dec  r30
brne L1
dec  r31
brne L1
nop

lds r29, PORTD
cp tmp, r29
brne sw0_loop
ldi numTwo, 0

checkNum:
cpi numThree, 10
brge changeNum
rcall clear_display
mov Data, numTwo
ori Data, lcdOut
rcall write_char
rcall long_wait
mov Data, numThree
ori Data, lcdOut
rcall write_char
pop tmp
out SREG, tmp
reti

changeNum:
subi numThree, 10
inc numTwo
rjmp checkNum