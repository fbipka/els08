#pragma used+

typedef struct EEPROMRing
{
  char StBuf_Start;         //Status Buffer Start Adress
  char DtBuf_Start;         //Data Buffer Start Adress
  char Buf_Size;            //Buffer Size
  char SAdress;             //Текущее значение адреса статус буфера
} EE_Ring; 
 
 void EEPROM_write(short uiAddress, unsigned char ucData);
 unsigned char EEPROM_read(short uiAddress);
 void EERing_write(EE_Ring *Temp, unsigned char EData);
 unsigned char EERing_read(EE_Ring Temp);
 void EERing_find(EE_Ring *Temp);
 
 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

void EEPROM_write(short uiAddress, unsigned char ucData)
{
	while(EECR & (1<<EEWE));//ждем установки бита EEWE
	EEAR = uiAddress;//устанавливаем адрес
	EEDR = ucData;//записываем байт данных
	EECR |= (1<<EEMWE);//устанавливаем EEMWE
	EECR |= (1<<EEWE);//устанавливаем EEWE
}

unsigned char EEPROM_read(short uiAddress)
{
	while(EECR & (1<<EEWE));//ждем установки EEWE
	EEAR = uiAddress;//устанавливаем адрес чтения
	EECR |= (1<<EERE);//разрешаем чтение
	return EEDR;//возвращаем прочитанный байт из функции
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

unsigned char EERing_read(EE_Ring Temp)
{
	char TData;
    if(Temp.SAdress==Temp.StBuf_Start) Temp.SAdress=((Temp.SAdress+Temp.Buf_Size-1)&0x0F)|Temp.DtBuf_Start;
    else Temp.SAdress=(Temp.SAdress&0x0F|Temp.DtBuf_Start)-1;     // Получаем адрес ячейки с данными, зависящий от адреса ячейки статуса
	TData=EEPROM_read(Temp.SAdress);
	return TData;
}

void EERing_write(EE_Ring *Temp, unsigned char EData)
{
	char TDataAdr;
	TDataAdr=Temp->SAdress&0x0F|Temp->DtBuf_Start;                                        // Получаем адрес ячейки с данными, зависящий от адреса ячейки статуса
	if(EData!=EEPROM_read(TDataAdr)) EEPROM_write(TDataAdr, EData);      
	if(Temp->SAdress+1==Temp->StBuf_Start+Temp->Buf_Size)                                //Если достигли конечного адреса буфера статуса
	{
		Temp->SAdress=Temp->StBuf_Start;                                                 //Переходим в начало буфера
		EEPROM_write(Temp->SAdress, EEPROM_read(Temp->StBuf_Start+Temp->Buf_Size-1)+1); //Наращиваем значение буфера статуса
	} 
	else 
	{                                                                   //если еще не конец буфера
		Temp->SAdress++;                                                      //наращиваем адрес ячейки буфера                                                      
		EEPROM_write(Temp->SAdress, EEPROM_read(Temp->SAdress-1)+1);                //записываем по нему значение буфера статуса +1
	}

	 //возвращаем обновленный адрес последней записи в буфер
}


void EERing_find(EE_Ring *Temp)       //Поиск адреса последней записи
{
    Temp->SAdress=Temp->StBuf_Start;
	while(Temp->SAdress+1<Temp->StBuf_Start+Temp->Buf_Size)
    {
        if(EEPROM_read(Temp->SAdress)==EEPROM_read(Temp->SAdress+1)-1)         //Сравниваем значение по текущему и следующему адресу
             Temp->SAdress++;                                            //Если разница равна 1, то идем дальше наращивая адрес
        else break;                                                     //Если разница не равна 1, значит текущий адрес и есть последний 
    }
	
}
 
#pragma used-