#pragma used+

typedef struct EEPROMRing
{
  char StBuf_Start;         //Status Buffer Start Adress
  char DtBuf_Start;         //Data Buffer Start Adress
  char Buf_Size;            //Buffer Size
  char SAdress;             //������� �������� ������ ������ ������
} EE_Ring; 
 
 void EEPROM_write(short uiAddress, unsigned char ucData);
 unsigned char EEPROM_read(short uiAddress);
 void EERing_write(EE_Ring *Temp, unsigned char EData);
 unsigned char EERing_read(EE_Ring Temp);
 void EERing_find(EE_Ring *Temp);
 
 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

void EEPROM_write(short uiAddress, unsigned char ucData)
{
	while(EECR & (1<<EEWE));//���� ��������� ���� EEWE
	EEAR = uiAddress;//������������� �����
	EEDR = ucData;//���������� ���� ������
	EECR |= (1<<EEMWE);//������������� EEMWE
	EECR |= (1<<EEWE);//������������� EEWE
}

unsigned char EEPROM_read(short uiAddress)
{
	while(EECR & (1<<EEWE));//���� ��������� EEWE
	EEAR = uiAddress;//������������� ����� ������
	EECR |= (1<<EERE);//��������� ������
	return EEDR;//���������� ����������� ���� �� �������
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

unsigned char EERing_read(EE_Ring Temp)
{
	char TData;
    if(Temp.SAdress==Temp.StBuf_Start) Temp.SAdress=((Temp.SAdress+Temp.Buf_Size-1)&0x0F)|Temp.DtBuf_Start;
    else Temp.SAdress=(Temp.SAdress&0x0F|Temp.DtBuf_Start)-1;     // �������� ����� ������ � �������, ��������� �� ������ ������ �������
	TData=EEPROM_read(Temp.SAdress);
	return TData;
}

void EERing_write(EE_Ring *Temp, unsigned char EData)
{
	char TDataAdr;
	TDataAdr=Temp->SAdress&0x0F|Temp->DtBuf_Start;                                        // �������� ����� ������ � �������, ��������� �� ������ ������ �������
	if(EData!=EEPROM_read(TDataAdr)) EEPROM_write(TDataAdr, EData);      
	if(Temp->SAdress+1==Temp->StBuf_Start+Temp->Buf_Size)                                //���� �������� ��������� ������ ������ �������
	{
		Temp->SAdress=Temp->StBuf_Start;                                                 //��������� � ������ ������
		EEPROM_write(Temp->SAdress, EEPROM_read(Temp->StBuf_Start+Temp->Buf_Size-1)+1); //���������� �������� ������ �������
	} 
	else 
	{                                                                   //���� ��� �� ����� ������
		Temp->SAdress++;                                                      //���������� ����� ������ ������                                                      
		EEPROM_write(Temp->SAdress, EEPROM_read(Temp->SAdress-1)+1);                //���������� �� ���� �������� ������ ������� +1
	}

	 //���������� ����������� ����� ��������� ������ � �����
}


void EERing_find(EE_Ring *Temp)       //����� ������ ��������� ������
{
    Temp->SAdress=Temp->StBuf_Start;
	while(Temp->SAdress+1<Temp->StBuf_Start+Temp->Buf_Size)
    {
        if(EEPROM_read(Temp->SAdress)==EEPROM_read(Temp->SAdress+1)-1)         //���������� �������� �� �������� � ���������� ������
             Temp->SAdress++;                                            //���� ������� ����� 1, �� ���� ������ ��������� �����
        else break;                                                     //���� ������� �� ����� 1, ������ ������� ����� � ���� ��������� 
    }
	
}
 
#pragma used-