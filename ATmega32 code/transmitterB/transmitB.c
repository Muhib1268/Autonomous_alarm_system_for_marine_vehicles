#include <mega32.h>

// Alphanumeric LCD functions
#include <alcd.h>
#include <delay.h>
#include <string.h>
#include <stdlib.h>

#define AD_DATA_PIN = PIND.5; // Pin mapping of microcontroller
#define AD_SCK_PIN = PIND.4; // Pin mapping of microcontroller

// Declare your global variables here

char mychar, loadData[5];        //To declare 8bit character variable

// Standard Input/Output functions
#include <stdio.h>


void usart_transmit(unsigned char ch )
{
    while ( !( UCSRA & (1<<UDRE)) );
    UDR = ch;
}

interrupt [USART_RXC] void myInterrupt(void)
{
    int j=0;
    //recData[i] = getchar();     //Get Character from UDR
    mychar=getchar();
    if(mychar=='V')
    {
        lcd_clear();
        lcd_gotoxy(0, 0);
        lcd_puts("Transmitting"); 
                
        for (j=0; j<strlen(loadData); j++)
        {
            usart_transmit(loadData[j]); 
        }
        usart_transmit('M');         
    }   
}

unsigned long ReadCount()
{
	unsigned long Count;
	unsigned char i;
	PORTD.4=0;                   //AD_SCK_PIN
	Count=0;
	while(PIND.5);             //AD_DATA_PIN
	for (i=0;i<24;i++)
	{
		PORTD.4=1;                  //AD_SCK_PIN
		Count=Count<<1;
		PORTD.4=0;                  //AD_SCK_PIN
		if(PIND.5) Count++;          //AD_DATA_PIN
	}
	
	Count=Count^0x800000; 
    for(i=0;i<2; i++)
    {
        PORTD.4=1;                        //AD_SCK_PIN  
        PORTD.4=0;                        //AD_SCK_PIN  
    }      
     
	return(Count);
}

void main(void)
{
// Declare your local variables here
char disp[16], loadTemp[4];
unsigned long data=0;
int w, finalWeight;

// Input/Output Ports initialization
DDRA=0xFF;
DDRD.4=1;

MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=0xFF;  //(0<<ISC2);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: Off
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x19;



#asm ("sei");
// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTA Bit 0
// RD - PORTA Bit 1
// EN - PORTA Bit 2
// D4 - PORTA Bit 4
// D5 - PORTA Bit 5
// D6 - PORTA Bit 6
// D7 - PORTA Bit 7
// Characters/line: 16
lcd_init(16);


while (1)
      {
            data=ReadCount(); 
            w=data/32;    
            finalWeight=-1040;
            finalWeight+= w;
            itoa(finalWeight, disp);     
            
            if(finalWeight/3<1000)
            {
                itoa(0,loadData);
                itoa(finalWeight/3,loadTemp);
                strcat(loadData, loadTemp);
            }
            else{ 
                itoa(finalWeight/3,loadData);
            }
             
            lcd_clear();     
            lcd_gotoxy(0,0);
            lcd_puts(disp);
            lcd_gotoxy(0,1);
            lcd_puts(loadData);
            delay_ms(1000);           
      }
}
