//;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
//;   1DT301, Computer Technology I
//;   Date: 2017-11-19
//;   Author:
//;   Ahmadreza Vakilalroayayi
//;
//;   Lab number:         6
//;   Title:              Cybertech display and displaying text from serial port. 
//;
//;   Hardware:           STK600, CPU ATmega2560
//;
//;   Function:			  Working on Cybertech display and serial port to show the characters.
//;
//;   Input ports:        N/A
//;
//;   Output ports:       
//;
//;   Subroutines:        N/A
//;
//;   Included files:     m2560def.inc
//;
//;   Other information:  N/A
//;
//;   Changes in program: 
//;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#include <avr/io.h>
#include <stdio.h>
#include <stdlib.h>
#define BAUD 2400
#define UBRR_VAL 47
void uart_initial(void);		// Calling the function to initialize
void uart_display(unsigned char data); // passing data parameter 

int main(void){
uart_initial();
char* tmp = "\rAO0001A";	 // Characters segments to printout A
int sumOfAll=0;				 // sumOfAll is declared, 0 should be set to be able to calculate the sum. 
int i;						 // i is declared, value will be set in the loops.

for (i=0;i<8;i++){			// Looping through characters to calculate the sum of all chars
sumOfAll=sumOfAll+tmp[i];	// calculating sumOfAll from tmp chars
}

sumOfAll = sumOfAll % 256;
char outPut[10];

sprintf(outPut,"%s%02X\n",tmp,sumOfAll); // Sends formatted output

for(i=0;i<11;i++){		// Looping through outPut to send it to display
uart_display(outPut[i]);
}

tmp ="\rZD0013C\n"; 
for(i=0;i<9;i++)
{
uart_display(tmp[i]); // passing tmp[i] values
}
return 0;
}

void uart_initial(void){
UBRR1L= UBRR_VAL;
UCSR1B = ( 1<<TXEN1 ) | ( 1<<RXEN1 );
}

void uart_display(unsigned char data){
while (!( UCSR1A & (1<<UDRE1)));
UDR1 = data;
}