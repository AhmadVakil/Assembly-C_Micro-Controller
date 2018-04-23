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
#define BAUD 2400
#define UBRR_VAL 47
#define N 50


void uart_intitial(void);		// Calling the function to initialize
void uart_display(unsigned char data);	// passing data parameter
void view(char* inputData,int size);	

int main(void){
uart_intitial();										// Calling the function to initialize
tmp="\rAO0001I like this science       It is awesome";	// we should consider the char length when we want to view chars
view(tmp,48);				
tmp="\rBO0001Printed!";		
view(tmp,17);				// chars and lengths are passed through this function
tmp="\rZD001";				// Image frame address is Z
view (tmp,6);
return 0;
}

void uart_intitial(void){
UBRR1L=UBRRVAL;
UCSR1B=(1<<TXEN1)|(1<<RXEN1);

}
void uart_display(unsigned char data){
while(!(UCSR1A & (1<<UDRE1)));
UDR1=data;
}

void view(char* inputData,int size){		// looping through all chars 
int i;
int sumOfAll;
sumOfAll=0;
for(i=0;i<size;i++){
sumOfAll=sumOfAll+inputData[i];		// SumOfAll inputData
}

sumOfAll=sumOfAll%256;

char mainData[N];

sprintf(mainData,"%s%02X\n",inputData,sumOfAll);

for(i=0;i<size+3;i++)
{
uart_display(mainData[i]);
}
}