;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   1DT301, Computer Technology I
;   Date: 2017-11-15
;   Author:
;   Ahmadreza Vakilalroayayi
;
;   Lab number:         5
;   Title:              JHD202 and displaying text from serial port. Serial communication and display
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
.def data = r17
.def RS = r18
.def counter = r19
.equ FourBits = 0b00000010
.equ displayClear = 0b00000001
.equ Display = 0b00001111           
.equ RS_ON = 0b00100000
.equ lcd = PORTE                 
.equ lcdData = DDRE                
.equ rate = 12               
.equ scl = 0x05                    
.equ exLine = 0b00100011
.equ addr_loc = 0x0200
.cseg
.org 0x00
jmp reset

.org 0x72

reset:
; Initial stack pointer
ldi tmp, HIGH(RAMEND)
out SPH, tmp
ldi tmp, LOW(RAMEND)
out SPL, tmp
ser tmp
out lcdData, tmp
rcall initial_display

ldi tmp, rate
sts UBRR1L, tmp                    

ldi tmp, (1<<RXEN1)
sts UCSR1B, tmp                    
    
sei
    
clr counter
ldi XH, HIGH(addr_loc)
ldi XL, LOW(addr_loc)
rcall input

main_loop:
ldi XH, HIGH(addr_loc)
ldi XL, LOW(addr_loc)
ldi YH, HIGH(addr_loc)
ldi YL, LOW(addr_loc)
clr counter

allLines:
inc counter
rcall write_main					
rcall delay_5sec					
rcall write_new_lines				
cpi counter, 4
brlo allLines					
	
rjmp main_loop						
										

initial_display:
rcall power_up_wait                 
ldi data, FourBits                  
rcall write_nibble
rcall short_wait
ldi data, Display
rcall write_cmd
rcall short_wait

clear_display:
ldi data, displayClear
rcall write_cmd
rcall long_wait
ret

write_char:
ldi RS, RS_ON
rjmp write

write_cmd:
clr RS

write:
mov tmp, data
andi data, 0b11110000              
swap data
or data, RS                         
rcall write_nibble                  
mov data, tmp
andi data, 0b00001111             
or data, RS

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

switch_output:
push tmp
clr tmp

sbrc data, 0                        
ori tmp, 0b00000100           
sbrc data, 1                       
ori tmp, 0b00001000          
sbrc data, 2                        
ori tmp, 0b00000001           
sbrc data, 3                        
ori tmp, 0b00000010           
sbrc data, 4                        
ori tmp, 0b00100000           
sbrc data, 5                      
ori tmp, 0b10000000          

out lcd, tmp
pop tmp
ret

input:
lds tmp, UCSR1A
sbrs tmp, RXC1			
rjmp input		
		
lds data, UDR1			

cpi data, exLine
brne store_char

inc counter

cpi counter, 4
brge read_lines_end

store_char:
st X+, data

rjmp input

read_lines_end:
ldi data, exLine
st X+, data
ret

write_main:
ld data, X+
cpi data, exLine
breq write_lines_end
rcall write_char
rcall long_wait
rjmp write_main

write_lines_end:	
ret

write_new_lines:
push counter
rcall clear_display
ldi counter, 40

write_new_line:
ldi data, 0b00100000
rcall write_char
rcall short_wait
dec counter
cpi counter, 1
brge write_new_line
rcall write_second_line
ldi data, 0b00000010
rcall write_cmd
rcall long_wait
pop counter
ret

write_second_line:
ld data, Y+
cpi data, exLine
breq write_second_line_end
rcall write_char
rcall long_wait
rjmp write_second_line

write_second_line_end:	
ret

delay_5sec:
push r18
push r19
push r20
ldi  r18, 26
ldi  r19, 94
ldi  r20, 111
L1: dec  r20
brne L1
dec  r19
brne L1
dec  r18
brne L1
nop

pop r20
pop r19
pop r18
ret