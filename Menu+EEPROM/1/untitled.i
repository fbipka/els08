
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrw ICR1=0x26;   
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

void _lcd_write_data(unsigned char data);

unsigned char lcd_read_byte(unsigned char addr);

void lcd_write_byte(unsigned char addr, unsigned char data);

void lcd_gotoxy(unsigned char x, unsigned char y);

void lcd_clear(void);
void lcd_putchar(char c);

void lcd_puts(char *str);

void lcd_putsf(char flash *str);

void lcd_putse(char eeprom *str);

void lcd_init(unsigned char lcd_columns);

#pragma library alcd.lib

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

typedef char *va_list;

#pragma used+

char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);
int printf(char flash *fmtstr,...);
int sprintf(char *str, char flash *fmtstr,...);
int vprintf(char flash * fmtstr, va_list argptr);
int vsprintf(char *str, char flash * fmtstr, va_list argptr);

char *gets(char *str,unsigned int len);
int snprintf(char *str, unsigned int size, char flash *fmtstr,...);
int vsnprintf(char *str, unsigned int size, char flash * fmtstr, va_list argptr);

int scanf(char flash *fmtstr,...);
int sscanf(char *str, char flash *fmtstr,...);

#pragma used-

#pragma library stdio.lib

#pragma used+

typedef struct EEPROMRing
{
char StBuf_Start;         
char DtBuf_Start;         
char Buf_Size;            
char SAdress;             
} EE_Ring; 

void EEPROM_write(short uiAddress, unsigned char ucData);
unsigned char EEPROM_read(short uiAddress);
void EERing_write(EE_Ring *Temp, unsigned char EData);
unsigned char EERing_read(EE_Ring Temp);
void EERing_find(EE_Ring *Temp);

void EEPROM_write(short uiAddress, unsigned char ucData)
{
while(EECR & (1<<1       ));
EEAR = uiAddress;
EEDR = ucData;
EECR |= (1<<2       );
EECR |= (1<<1       );
}

unsigned char EEPROM_read(short uiAddress)
{
while(EECR & (1<<1       ));
EEAR = uiAddress;
EECR |= (1<<0       );
return EEDR;
}

unsigned char EERing_read(EE_Ring Temp)
{
char TData;
if(Temp.SAdress==Temp.StBuf_Start) Temp.SAdress=((Temp.SAdress+Temp.Buf_Size-1)&0x0F)|Temp.DtBuf_Start;
else Temp.SAdress=(Temp.SAdress&0x0F|Temp.DtBuf_Start)-1;     
TData=EEPROM_read(Temp.SAdress);
return TData;
}

void EERing_write(EE_Ring *Temp, unsigned char EData)
{
char TDataAdr;
TDataAdr=Temp->SAdress&0x0F|Temp->DtBuf_Start;                                        
if(EData!=EEPROM_read(TDataAdr)) EEPROM_write(TDataAdr, EData);      
if(Temp->SAdress+1==Temp->StBuf_Start+Temp->Buf_Size)                                
{
Temp->SAdress=Temp->StBuf_Start;                                                 
EEPROM_write(Temp->SAdress, EEPROM_read(Temp->StBuf_Start+Temp->Buf_Size-1)+1); 
} 
else 
{                                                                   
Temp->SAdress++;                                                      
EEPROM_write(Temp->SAdress, EEPROM_read(Temp->SAdress-1)+1);                
}

}

void EERing_find(EE_Ring *Temp)       
{
Temp->SAdress=Temp->StBuf_Start;
while(Temp->SAdress+1<Temp->StBuf_Start+Temp->Buf_Size)
{
if(EEPROM_read(Temp->SAdress)==EEPROM_read(Temp->SAdress+1)-1)         
Temp->SAdress++;                                            
else break;                                                     
}

}

#pragma used-

unsigned char X1[]={"Modbus Adress"};
unsigned char X2[]={"USART Speed"};
unsigned char X3[]={"1200"};
unsigned char X4[]={"2400"};
unsigned char X5[]={"4800"};
unsigned char X6[]={"9600"};
unsigned char X7[]={"19200"};
unsigned char X8[]={"Parity"};
unsigned char X9[]={"Odd"};
unsigned char X10[]={"Even"};
unsigned char X11[]={"No"};
unsigned char X12[]={"Stop Bits"};
unsigned char X13[]={"1"};
unsigned char X14[]={"2"};
unsigned char X15[]={"Restore"};
unsigned char X16[]={"Yes"};
unsigned char X17[]={"No"};

typedef struct{                    
unsigned char *NAME;           
char Num;                      
char fl;                       
char now;                      
}StructMenu;

static StructMenu menu_g[]={       
{X1,1,11,1},                         
{X2,5,21,1},                         
{X8,3,31,1},                         
{X12,2,41,1},
{X15,2,51,1}
};

static EE_Ring E_Reg={0x20,0x30,8,0};

short Menu=0,Reg;
char flag=0,m1=0,ModbusAdress,TempAdr;
char E_UBRRL,E_UCSRC,E_RLP;

void Transf_Reg(char TeReg)
{
char i,TempReg;
i=0;
while(i<8)
{
PORTC.5=0;
TempReg=TeReg&(1<<i);
if(TempReg) PORTC.2=1;
else PORTC.2=0;
PORTC.5=1;
i++;
}
}

void Load_Reg()
{
char TempReg;
TempReg=(int)Reg>>8;
Transf_Reg(TempReg);
TempReg=(char)(Reg);
Transf_Reg(TempReg);
PORTC.3=1;
PORTC.3=0;
}

void PrintNumber(char x)
{
char TempP[3]="",Tem,i=0,Tem2=100;
while(i<3)
{
Tem=x/Tem2;
TempP[i]=0x30+Tem;
x=x%Tem2;
i++;
Tem2/=10;
}
lcd_gotoxy(0,1);
lcd_puts(TempP);
}

void MenuPrint(unsigned char X[], short kod,char y)
{
char tmp;
printf("asd");
lcd_puts(menu_g[y].NAME);
lcd_gotoxy(0,1);
if(kod!=110) lcd_puts(X);
else PrintNumber(ModbusAdress);
tmp=kod%10;
if(tmp==menu_g[y].now) lcd_puts(" <");

if (kod>100)
{
lcd_gotoxy(12,1);
lcd_puts("Ok");
Menu/=10;
EEPROM_write(0x10,UBRRL);
}

}

void FuncMenu(short punkt)
{
lcd_clear();
switch(punkt)
{
case 10:{lcd_puts(menu_g[0].NAME);TempAdr=ModbusAdress;break;}
case 11:
{
lcd_puts(menu_g[0].NAME);
PrintNumber(TempAdr);
TempAdr++;
if(TempAdr>255) TempAdr=0;
break;
}
case 20:{lcd_puts(menu_g[1].NAME);break;}
case 21:{MenuPrint(X3,punkt,1);break;}
case 22:{MenuPrint(X4,punkt,1);break;}
case 23:{MenuPrint(X5,punkt,1);break;}
case 24:{MenuPrint(X6,punkt,1);break;}
case 25:{MenuPrint(X7,punkt,1);break;}    
case 30:{lcd_puts(menu_g[2].NAME);break;}
case 31:{MenuPrint(X9,punkt,2);break;}
case 32:{MenuPrint(X10,punkt,2);break;}
case 33:{MenuPrint(X11,punkt,2);break;}
case 40:{lcd_puts(menu_g[3].NAME);break;}
case 41:{MenuPrint(X13,punkt,3);break;}
case 42:{MenuPrint(X14,punkt,3);break;}
case 50:{lcd_puts(menu_g[4].NAME);break;}
case 51:{MenuPrint(X16,punkt,4);break;}
case 52:{MenuPrint(X17,punkt,4);break;}

case 110:{ModbusAdress=TempAdr-1;MenuPrint(X1,punkt,0);EEPROM_write(0x13,ModbusAdress);break;}
case 210:{menu_g[1].now=1;MenuPrint(X3,punkt,1);UBRRL=0x67;EEPROM_write(0x10,UBRRL);break;}
case 220:{menu_g[1].now=2;MenuPrint(X4,punkt,1);UBRRL=0x33;EEPROM_write(0x10,UBRRL);break;}
case 230:{menu_g[1].now=3;MenuPrint(X5,punkt,1);UBRRL=0x19;EEPROM_write(0x10,UBRRL);break;}
case 240:{menu_g[1].now=4;MenuPrint(X6,punkt,1);UBRRL=0x0C;EEPROM_write(0x10,UBRRL);break;}
case 250:{menu_g[1].now=5;MenuPrint(X7,punkt,1);UBRRL=0x06;EEPROM_write(0x10,UBRRL);break;}    
case 310:{menu_g[2].now=1;MenuPrint(X9,punkt,2);E_UCSRC|=0x30;UCSRC=E_UCSRC;EEPROM_write(0x11,E_UCSRC);break;}
case 320:{menu_g[2].now=2;MenuPrint(X10,punkt,2);E_UCSRC&=~0x30;E_UCSRC|=0x20;UCSRC=E_UCSRC;EEPROM_write(0x11,E_UCSRC);break;}
case 330:{menu_g[2].now=3;MenuPrint(X11,punkt,2);E_UCSRC&=~0x30;UCSRC=E_UCSRC;EEPROM_write(0x11,E_UCSRC);break;}
case 410:{menu_g[3].now=1;MenuPrint(X13,punkt,3);E_UCSRC&=~0x08;UCSRC=E_UCSRC;EEPROM_write(0x11,E_UCSRC);break;}
case 420:{menu_g[3].now=2;MenuPrint(X14,punkt,3);E_UCSRC|=0x08;UCSRC=E_UCSRC;EEPROM_write(0x11,E_UCSRC);break;}
case 510:{menu_g[4].now=1;MenuPrint(X16,punkt,4);E_RLP=0x54;EEPROM_write(0x12,E_RLP);break;}
case 520:{menu_g[4].now=2;MenuPrint(X17,punkt,4);E_RLP=0x00;EEPROM_write(0x12,E_RLP);break;}    
}
}

void init()
{
E_UCSRC=EEPROM_read(0x11);
E_UCSRC|=0x86;
E_UBRRL=EEPROM_read(0x10);
E_RLP=EEPROM_read(0x12);
ModbusAdress=EEPROM_read(0x13);
TempAdr=ModbusAdress;
UCSRA=0x00;
UCSRB=0x08;
UCSRC=E_UCSRC;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=E_UBRRL;
UBRRL=0x0C;
printf("%x ",E_UCSRC);                                             
switch(E_UBRRL)
{
case 0x67:{menu_g[1].now=1;break;} 
case 0x33:{menu_g[1].now=2;break;} 
case 0x19:{menu_g[1].now=3;break;} 
case 0x0C:{menu_g[1].now=4;break;} 
case 0x06:{menu_g[1].now=5;break;} 
}

switch(E_UCSRC&0x08)
{
case 0:{menu_g[3].now=1;break;} 
case 0x08:{menu_g[3].now=2;break;} 

}
switch(E_UCSRC&0x30)
{
case 0:{menu_g[2].now=3;break;}   
case 20:{menu_g[2].now=2;break;}  
case 30:{menu_g[2].now=1;break;}  
}

if(E_RLP==0x54)  
{
EERing_find(&E_Reg);
Reg=EERing_read(E_Reg);
Load_Reg();
menu_g[4].now=1;
}
else 
{
Reg=0x00;
PORTC.4=0;
PORTC.3=1;
PORTC.3=0;
PORTC.4=1;

EERing_write(&E_Reg,Reg);
menu_g[4].now=2;
}
lcd_init(16);
}

void main(void)
{
DDRD&=~0b01101000;
PORTD|=0b01101000;
DDRC=0x7E;
PORTC.4=1;
PORTD.2 =0;

init();

PORTC.1=1;
delay_ms(1000);
PORTC.1=0;

lcd_puts(menu_g[0].NAME);
Menu=10;
while (1)
{

if (!PIND.6)     
{
delay_ms(20);
if(!PIND.6) 
{
while(!PIND.6);
if(!flag)
{
Menu++;
flag=1;
}
else
{
flag=2;
Menu*=10;
}            
FuncMenu(Menu);
}
}  

if (!PIND.3)    
{
delay_ms(20);
if(!PIND.3) 
{
while(!PIND.3);
Menu=10;
m1=0;
flag=0;      
FuncMenu(Menu);

}    
}  

if (!PIND.5)    
{
delay_ms(20);
if(!PIND.5) 
{
while(!PIND.5);
if(!flag)
{
Menu+=10;
m1++;
if(Menu>50) {Menu=10;m1=0;}
}   
else 
{
Menu++;
if((menu_g[m1].Num+menu_g[m1].fl)==Menu) Menu=menu_g[m1].fl;
}    
FuncMenu(Menu);

}    
}  

}   

}
