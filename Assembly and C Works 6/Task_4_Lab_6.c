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
#define characterSelect '*' 
#define newLineCharacter '-' 
#define maxLine 2 
#define numbers "12"
#define maxCharOnLine 24
#define rate 25
void urat_Display(char);
void init(void);
void urat_initial(void);
void viewData(void);
int startsFrom = 0;
char selectedLine = 0;
char totalLine[8][maxCharOnLine] = { "", "", "", "", "", "", "", "" };

int main(void) 
{
init();
char Data ="";
while (1) {
while ( !(UCSR1A & (1<<RXC1)) ){
	Data = UDR1;
}			
 
	if (Data == characterSelect){
		selectedLine = 1;
	}	
		else if (Data == newLineCharacter){
			startsFrom++;
			if (startsFrom >= maxLine){
				startsFrom = 0;
		}				
		else 
		startsFrom = -1;
	}				
	else {
		char* row = totalLine[startsFrom]; 
		sprintf(row, "%s%c", row, Data);
	}
viewData(); 
}	
	return 0;
}

void init(void) 
{
	urat_initial();
	viewData(); 
}

void urat_initial(void)
{
	UBRR1L = rate;
	UCSR1B = ((1 << RXEN1) | (1 << TXEN1)); 
}

void viewData()
{
	int currentRow = startsFrom;
	if (currentRow < 1){
		currentRow++;
	}	
	char firstAllocated[48] = "";
	char selectedRow = selectedLine ? '_' : (startsFrom + '1');
	sprintf(firstAllocated, "Enter input: (Line %c)   %s", selectedRow, totalLine[currentRow-1]);
	char secondAllocated[48] = " ";
	if (totalLine[currentRow][0]) 
		for (int i = 0; i < 48; i++) 
			secondAllocated[i] = totalLine[currentRow][i];

	sumOfLengths = (sizeof("O0001")/sizeof(char))+(sizeof(firstAllocated)/sizeof(char))+4;
	Allocated_Memory = malloc(sumOfLengths*sizeof(char));
	sprintf(Allocated_Memory, "\r%c%s%s", 'A', "O0001", firstAllocated);
	sumOfAll = 0;
	for (int i = 0; (Allocated_Memory[i] != 0); i++)
		sumOfAll += Allocated_Memory[i];
		
	sumOfAll = sumOfAll%256;
	sprintf(Allocated_Memory, "%s%02X\n", Allocated_Memory, sumOfAll);
	for (int i = 0; Allocated_Memory[i]; i++)
		urat_Display(Allocated_Memory[i]);

	free(Allocated_Memory);
	sumOfLengths = (sizeof("O0001")/sizeof(char))+(sizeof(firstAllocated)/sizeof(char))+4;
	Allocated_Memory = malloc(sumOfLengths*sizeof(char));
	sprintf(Allocated_Memory, "\r%c%s%s", 'B', "O0001", secondAllocated);
	sumOfAll = 0;
	for (int i = 0; (Allocated_Memory[i] != 0); i++)
		sumOfAll += Allocated_Memory[i];
		
	sumOfAll = sumOfAll%256;
	sprintf(Allocated_Memory, "%s%02X\n", Allocated_Memory, sumOfAll);
	for (int i = 0; Allocated_Memory[i]; i++)
		urat_Display(Allocated_Memory[i]);

	free(Allocated_Memory);
	sumOfLengths = (sizeof("D001")/sizeof(char))+(sizeof("")/sizeof(char))+4;
	Allocated_Memory = malloc(sumOfLengths*sizeof(char));
	sprintf(Allocated_Memory, "\r%c%s%s", 'Z', "D001", 0);
	sumOfAll = 0;
	for (int i = 0; (Allocated_Memory[i] != 0); i++)
		sumOfAll += Allocated_Memory[i];
		
	sumOfAll = sumOfAll%256;
	sprintf(Allocated_Memory, "%s%02X\n", Allocated_Memory, sumOfAll);
	for (int i = 0; Allocated_Memory[i]; i++)
		urat_Display(Allocated_Memory[i]);

	free(Allocated_Memory);
}

void urat_Display(char character)
{
	while ( !(UCSR1A & (1<<UDRE1)) ) ; 
	UDR1 = character;
}