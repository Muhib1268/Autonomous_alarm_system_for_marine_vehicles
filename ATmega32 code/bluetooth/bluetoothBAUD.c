#include <mega32.h>

// Alphanumeric LCD functions
#include <alcd.h>
#include <delay.h>
#include <string.h>
#include <stdlib.h>
    
#define bt_vcc PORTB.5
#define bt_en PORTB.6
#define bt_state PORTB.7
// Declare your global variables here

unsigned char at[6], at_rmaad[12], at_bind_A[26], at_bind_B[26], at_init[11], at_inq[10], at_link_A[26], at_link_B[26], dicson[7];
unsigned char at_state[12], recData[32];        //To declare 8bit character variable
char i=0, b=0;    //To declare single bit

// Standard Input/Output functions
#include <stdio.h>


void usart_transmit(unsigned char ch )
{
    while ( !( UCSRA & (1<<UDRE)) );
    UDR = ch;
}

interrupt [USART_RXC] void myInterrupt(void)
{
    recData[i] = getchar();     //Get Character from UDR  
    
    i++;
    if(i>=32)
    {
//        lcd_clear();
//        lcd_gotoxy(0,0);
//        lcd_puts(recData);
//        lcd_gotoxy(0,1);
//        lcd_puts("Sth Received");            
        //delay_ms(2000);
//        b=1;
        i=0;
    }
}

void main(void)
{
int j=0;
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (1<<DDB6) | (1<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);


// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 38400
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x19;


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
strcpy(at, "AT\r\n");
strcpy(at_rmaad, "AT+RMAAD\r\n");

strcpy(at_bind_A, "AT+BIND=98D3,A1,F5B548\r\n");
strcpy(at_bind_B, "AT+BIND=98D3,21,F73B81\r\n");

strcpy(at_init, "AT+INIT\r\n");
strcpy(at_inq, "AT+INQ\r\n");

strcpy(at_link_A, "AT+LINK=98D3,A1,F5B548\r\n");
strcpy(at_link_B, "AT+LINK=98D3,21,F73B81\r\n");

strcpy(dicson, "AT+DISC\r\n");
strcpy(at_state, "AT+STATE\r\n");

PORTB.5=1; 
// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here

            //UCSRB=(0<<RXCIE)|(0<<RXEN);  
            PORTB.6=0;
            PORTB.5=0;
            delay_ms(200);
            

            PORTB.6=1;
            delay_ms(100);   
            PORTB.5=1;
            
            for (j=0; j<strlen(at); j++)
            {
                usart_transmit(at[j]); 
            } 
            delay_ms(100);
            
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts(recData); 
            delay_ms(5000);
                    
            for (j=0; j<strlen(at_rmaad); j++)
            {
                usart_transmit(at_rmaad[j]); 
            }
            delay_ms(100);
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts(recData);  
            delay_ms(5000);
                                            
            for (j=0; j<strlen(at_bind_B); j++)
            {
                usart_transmit(at_bind_B[j]); 
            }
            delay_ms(100);
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts(recData); 
            delay_ms(5000); 
            
            for (j=0; j<strlen(at_init); j++)
            {
                usart_transmit(at_init[j]); 
            }
            delay_ms(100);
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts(recData);   
            delay_ms(5000); 
            
            for (j=0; j<strlen(at_inq); j++)
            {
                usart_transmit(at_inq[j]); 
            }
            delay_ms(100);
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts(recData);  
            delay_ms(5000);  
                      
            for (j=0; j<strlen(at_link_B); j++)
            {
                usart_transmit(at_link_B[j]); 
            }
            delay_ms(100);
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts(recData);  
            delay_ms(5000); 
            
            PORTB.6=0;  
            PORTB.5=0;   
            
            delay_ms(200);  
            PORTB.5=1;
            while(PINB.7==0)
            {
                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_puts("No B.tooth Con.");
                delay_ms(3);
            }
            
            lcd_clear();
            lcd_gotoxy(0,0);
            lcd_puts("B.tooth Connected");
            delay_ms(10000);
      }
}
