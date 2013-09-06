#include <mega8.h>
#include <alcd.h>
#include <delay.h>
#include <stdio.h>
#include <eering.c>

#define RES PORTC.4
#define CLK PORTC.5
#define ZASH PORTC.3
#define DATA PORTC.2
#define LED PORTC.1
#define DERE PORTD.2 // 0 - прием 1 - передача
#define Hi(Int) (int)Int>>8
#define Low(Int) (char)(Int)

#define AdrUBRRL 0x10
#define AdrUCSRC 0x11
#define AdrRLP 0x12
#define AdrModbus 0x13


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

typedef struct{                    //структура главноего меню
    unsigned char *NAME;           // - название пункта главного меню
    char Num;                      // - количество подпунктов данного пункта меню
    char fl;                       // - начальный код подменю 
    char now;                      // - показывает текущую сохраненную настройку
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
        CLK=0;
        TempReg=TeReg&(1<<i);
        if(TempReg) DATA=1;
        else DATA=0;
        CLK=1;
        i++;
    }
}

void Load_Reg()
{
char TempReg;
TempReg=Hi(Reg);
Transf_Reg(TempReg);
TempReg=Low(Reg);
Transf_Reg(TempReg);
ZASH=1;
ZASH=0;
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
    EEPROM_write(AdrUBRRL,UBRRL);
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
        
            
                case 110:{ModbusAdress=TempAdr-1;MenuPrint(X1,punkt,0);EEPROM_write(AdrModbus,ModbusAdress);break;}
                case 210:{menu_g[1].now=1;MenuPrint(X3,punkt,1);UBRRL=0x67;EEPROM_write(AdrUBRRL,UBRRL);break;}
                case 220:{menu_g[1].now=2;MenuPrint(X4,punkt,1);UBRRL=0x33;EEPROM_write(AdrUBRRL,UBRRL);break;}
                case 230:{menu_g[1].now=3;MenuPrint(X5,punkt,1);UBRRL=0x19;EEPROM_write(AdrUBRRL,UBRRL);break;}
                case 240:{menu_g[1].now=4;MenuPrint(X6,punkt,1);UBRRL=0x0C;EEPROM_write(AdrUBRRL,UBRRL);break;}
                case 250:{menu_g[1].now=5;MenuPrint(X7,punkt,1);UBRRL=0x06;EEPROM_write(AdrUBRRL,UBRRL);break;}    
                case 310:{menu_g[2].now=1;MenuPrint(X9,punkt,2);E_UCSRC|=0x30;UCSRC=E_UCSRC;EEPROM_write(AdrUCSRC,E_UCSRC);break;}
                case 320:{menu_g[2].now=2;MenuPrint(X10,punkt,2);E_UCSRC&=~0x30;E_UCSRC|=0x20;UCSRC=E_UCSRC;EEPROM_write(AdrUCSRC,E_UCSRC);break;}
                case 330:{menu_g[2].now=3;MenuPrint(X11,punkt,2);E_UCSRC&=~0x30;UCSRC=E_UCSRC;EEPROM_write(AdrUCSRC,E_UCSRC);break;}
                case 410:{menu_g[3].now=1;MenuPrint(X13,punkt,3);E_UCSRC&=~0x08;UCSRC=E_UCSRC;EEPROM_write(AdrUCSRC,E_UCSRC);break;}
                case 420:{menu_g[3].now=2;MenuPrint(X14,punkt,3);E_UCSRC|=0x08;UCSRC=E_UCSRC;EEPROM_write(AdrUCSRC,E_UCSRC);break;}
                case 510:{menu_g[4].now=1;MenuPrint(X16,punkt,4);E_RLP=0x54;EEPROM_write(AdrRLP,E_RLP);break;}
                case 520:{menu_g[4].now=2;MenuPrint(X17,punkt,4);E_RLP=0x00;EEPROM_write(AdrRLP,E_RLP);break;}    
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void init()
{
E_UCSRC=EEPROM_read(AdrUCSRC);
E_UCSRC|=0x86;
E_UBRRL=EEPROM_read(AdrUBRRL);
E_RLP=EEPROM_read(AdrRLP);
ModbusAdress=EEPROM_read(AdrModbus);
TempAdr=ModbusAdress;
UCSRA=0x00;
UCSRB=0x08;
UCSRC=E_UCSRC;
    UCSRC=0x86;
UBRRH=0x00;
UBRRL=E_UBRRL;
    UBRRL=0x0C;
printf("%x ",E_UCSRC);                                             ////
switch(E_UBRRL)
{
    case 0x67:{menu_g[1].now=1;break;} // 1200
    case 0x33:{menu_g[1].now=2;break;} // 2400
    case 0x19:{menu_g[1].now=3;break;} // 4800
    case 0x0C:{menu_g[1].now=4;break;} // 9600
    case 0x06:{menu_g[1].now=5;break;} // 19200
}

switch(E_UCSRC&0x08)
{
    case 0:{menu_g[3].now=1;break;} // 1 - SB
    case 0x08:{menu_g[3].now=2;break;} // 2 - SB
    
}
switch(E_UCSRC&0x30)
{
    case 0:{menu_g[2].now=3;break;}   // No
    case 20:{menu_g[2].now=2;break;}  // Even
    case 30:{menu_g[2].now=1;break;}  // Odd
}

if(E_RLP==0x54)  //0x54 - yes  0x00 -No
{
    EERing_find(&E_Reg);
    Reg=EERing_read(E_Reg);
    Load_Reg();
    menu_g[4].now=1;
}
else 
{
    Reg=0x00;
    RES=0;
    ZASH=1;
    ZASH=0;
    RES=1;
    
    EERing_write(&E_Reg,Reg);
    menu_g[4].now=2;
}
lcd_init(16);
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void main(void)
{
DDRD&=~0b01101000;
PORTD|=0b01101000;
DDRC=0x7E;
RES=1;
DERE=0;

init();

LED=1;
delay_ms(1000);
LED=0;


lcd_puts(menu_g[0].NAME);
Menu=10;
while (1)
    {
    
       if (!PIND.6)     // Select - button 
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
        
        
        if (!PIND.3)    // Back - button
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
        
        
        if (!PIND.5)    // Next - button
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
