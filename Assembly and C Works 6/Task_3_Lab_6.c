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
#include <util/delay.h>
#define F_CPU 1843200UL
#define BAUD_RATE 25 
char* major = "Computer Science";
char* name = "Ahmadreza";
void uart_Display(char);
void init(void);
void uart_intitial(void);


int main(void) {
	init();		
	int sumOfLengths = (sizeof("O0001")/sizeof(char))+(sizeof("Linnaeus University          Year 2017")/sizeof(char))+4; // Sum of lengths 
	char* Allocated_Memory = malloc(buffer_size*sizeof(char));		// Allocated memory size
	sprintf(Allocated_Memory, "\r%c%s%s", 'A', "O0001", "Linnaeus University          Year 2017");
	unsigned int sumOfAll = 0;
	for (int i = 0; (Allocated_Memory[i] != 0); i++)	// looping through memory
		sumOfAll += Allocated_Memory[i];
		
	sumOfAll = sumOfAll%256;
	sprintf(Allocated_Memory, "%s%02X\n", Allocated_Memory, sumOfAll);
	for (int i = 0; Allocated_Memory[i]; i++)
		uart_Display(Allocated_Memory[i]);

	free(Allocated_Memory); // free the memory
	//****************************************************************************************
	sumOfLengths = (sizeof("O0001")/sizeof(char))+(sizeof("")/sizeof(char))+4;
	Allocated_Memory = malloc(sumOfLengths*sizeof(char));
	sprintf(Allocated_Memory, "\r%c%s%s", 'B', "O0001", ""); // Command(O0001) and memory
	sumOfAll = 0;
	for (int i = 0; (Allocated_Memory[i] != 0); i++)
		sumOfAll += Allocated_Memory[i];
		
	sumOfAll = sumOfAll%256;
	sprintf(Allocated_Memory, "%s%02X\n", Allocated_Memory, sumOfAll);
	for (int i = 0; Allocated_Memory[i]; i++)
		uart_Display(Allocated_Memory[i]);

	free(Allocated_Memory);
	//*****************************************************************************************
	sumOfLengths = (sizeof("D001")/sizeof(char))+(sizeof("")/sizeof(char))+4;
	Allocated_Memory = malloc(sumOfLengths*sizeof(char));
	sprintf(Allocated_Memory, "\r%c%s%s", 'Z', "D001", 0);
	sumOfAll = 0;
	for (int i = 0; (Allocated_Memory[i] != 0); i++)
		sumOfAll += Allocated_Memory[i];
		
	sumOfAll = sumOfAll%256;
	sprintf(Allocated_Memory, "%s%02X\n", Allocated_Memory, sumOfAll);
	for (int i = 0; Allocated_Memory[i]; i++)
		uart_Display(Allocated_Memory[i]);

	free(Allocated_Memory);
	_delay_ms(1000); // delay
	//**********************************************************************************************************
	
	while (1) {	
	// Printing next strings ***********************************************************************************
	sumOfLengths = (sizeof("O0001")/sizeof(char))+(sizeof(major)/sizeof(char))+4;
	Allocated_Memory = malloc(sumOfLengths*sizeof(char));
	sprintf(Allocated_Memory, "\r%c%s%s", 'B', "O0001", major);
	sumOfAll = 0;
	for (int i = 0; (Allocated_Memory[i] != 0); i++)
		sumOfAll += Allocated_Memory[i];
		
	sumOfAll = sumOfAll%256;
	sprintf(Allocated_Memory, "%s%02X\n", Allocated_Memory, sumOfAll);
	for (int i = 0; Allocated_Memory[i]; i++)
		uart_Display(Allocated_Memory[i]);

	free(Allocated_Memory);
	
	//**********************************************************************************************************
	sumOfLengths = (sizeof("D001")/sizeof(char))+(sizeof("")/sizeof(char))+4;
	Allocated_Memory = malloc(sumOfLengths*sizeof(char));
	sprintf(Allocated_Memory, "\r%c%s%s", 'Z', "D001", 0);
	sumOfAll = 0;
	for (int i = 0; (Allocated_Memory[i] != 0); i++)
		sumOfAll += Allocated_Memory[i];
		
	sumOfAll = sumOfAll%256;
	sprintf(Allocated_Memory, "%s%02X\n", Allocated_Memory, sumOfAll);
	for (int i = 0; Allocated_Memory[i]; i++)
		uart_Display(Allocated_Memory[i]);

	free(Allocated_Memory);
	_delay_ms(1000);
	//***********************************************************************************************************
	
	// Printing next strings *********************************************************************************** 
	sumOfLengths = (sizeof("O0001")/sizeof(char))+(sizeof(name)/sizeof(char))+4;
	Allocated_Memory = malloc(sumOfLengths*sizeof(char));
	sprintf(Allocated_Memory, "\r%c%s%s", 'B', "O0001", name);
	sumOfAll = 0;
	for (int i = 0; (Allocated_Memory[i] != 0); i++)
		sumOfAll += Allocated_Memory[i];
		
	sumOfAll = sumOfAll%256;
	sprintf(Allocated_Memory, "%s%02X\n", Allocated_Memory, sumOfAll);
	for (int i = 0; Allocated_Memory[i]; i++)
		uart_Display(Allocated_Memory[i]);

	free(Allocated_Memory);
	//**********************************************************************************************************
	sumOfLengths = (sizeof("D001")/sizeof(char))+(sizeof("")/sizeof(char))+4;
	Allocated_Memory = malloc(sumOfLengths*sizeof(char));
	sprintf(Allocated_Memory, "\r%c%s%s", 'Z', "D001", 0);
	sumOfAll = 0;
	for (int i = 0; (Allocated_Memory[i] != 0); i++)
		sumOfAll += Allocated_Memory[i];
		
	sumOfAll = sumOfAll%256;
	sprintf(Allocated_Memory, "%s%02X\n", Allocated_Memory, sumOfAll);
	for (int i = 0; Allocated_Memory[i]; i++)
		uart_Display(Allocated_Memory[i]);

	free(Allocated_Memory);
	_delay_ms(1000);
	//***********************************************************************************************************
	}	
	return 0;
}

void init(void) {
	uart_intitial();
}


void uart_intitial(void)
{
	UBRR1L = BAUD_RATE;
	UCSR1B = ((1 << RXEN1) | (1 << TXEN1)); 
}


void uart_Display(char character)
{
	while ( !(UCSR1A & (1<<UDRE1)) ) ; 
	UDR1 = character;
}
