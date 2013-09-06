
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 2,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : No
;'char' is unsigned       : Yes
;8 bit enums              : No
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _Menu=R4
	.DEF _Reg=R6
	.DEF _flag=R9
	.DEF _m1=R8
	.DEF _ModbusAdress=R11
	.DEF _TempAdr=R10
	.DEF _E_UBRRL=R13
	.DEF _E_UCSRC=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x13:
	.DB  0x4D,0x6F,0x64,0x62,0x75,0x73,0x20,0x41
	.DB  0x64,0x72,0x65,0x73,0x73
_0x14:
	.DB  0x55,0x53,0x41,0x52,0x54,0x20,0x53,0x70
	.DB  0x65,0x65,0x64
_0x15:
	.DB  0x31,0x32,0x30,0x30
_0x16:
	.DB  0x32,0x34,0x30,0x30
_0x17:
	.DB  0x34,0x38,0x30,0x30
_0x18:
	.DB  0x39,0x36,0x30,0x30
_0x19:
	.DB  0x31,0x39,0x32,0x30,0x30
_0x1A:
	.DB  0x50,0x61,0x72,0x69,0x74,0x79
_0x1B:
	.DB  0x4F,0x64,0x64
_0x1C:
	.DB  0x45,0x76,0x65,0x6E
_0x1D:
	.DB  0x4E,0x6F
_0x1E:
	.DB  0x53,0x74,0x6F,0x70,0x20,0x42,0x69,0x74
	.DB  0x73
_0x1F:
	.DB  0x31
_0x20:
	.DB  0x32
_0x21:
	.DB  0x52,0x65,0x73,0x74,0x6F,0x72,0x65
_0x22:
	.DB  0x59,0x65,0x73
_0x23:
	.DB  0x4E,0x6F
_0x24:
	.DB  LOW(_X1),HIGH(_X1),0x1,0xB,0x1,LOW(_X2),HIGH(_X2),0x5
	.DB  0x15,0x1,LOW(_X8),HIGH(_X8),0x3,0x1F,0x1,LOW(_X12)
	.DB  HIGH(_X12),0x2,0x29,0x1,LOW(_X15),HIGH(_X15),0x2,0x33
	.DB  0x1
_0x25:
	.DB  0x20,0x30,0x8
_0xA9:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0
_0x0:
	.DB  0x61,0x73,0x64,0x0,0x20,0x3C,0x0,0x4F
	.DB  0x6B,0x0,0x25,0x78,0x20,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x0D
	.DW  _X1
	.DW  _0x13*2

	.DW  0x0B
	.DW  _X2
	.DW  _0x14*2

	.DW  0x04
	.DW  _X3
	.DW  _0x15*2

	.DW  0x04
	.DW  _X4
	.DW  _0x16*2

	.DW  0x04
	.DW  _X5
	.DW  _0x17*2

	.DW  0x04
	.DW  _X6
	.DW  _0x18*2

	.DW  0x05
	.DW  _X7
	.DW  _0x19*2

	.DW  0x06
	.DW  _X8
	.DW  _0x1A*2

	.DW  0x03
	.DW  _X9
	.DW  _0x1B*2

	.DW  0x04
	.DW  _X10
	.DW  _0x1C*2

	.DW  0x02
	.DW  _X11
	.DW  _0x1D*2

	.DW  0x09
	.DW  _X12
	.DW  _0x1E*2

	.DW  0x01
	.DW  _X13
	.DW  _0x1F*2

	.DW  0x01
	.DW  _X14
	.DW  _0x20*2

	.DW  0x07
	.DW  _X15
	.DW  _0x21*2

	.DW  0x03
	.DW  _X16
	.DW  _0x22*2

	.DW  0x02
	.DW  _X17
	.DW  _0x23*2

	.DW  0x19
	.DW  _menu_g_G000
	.DW  _0x24*2

	.DW  0x03
	.DW  _E_Reg_G000
	.DW  _0x25*2

	.DW  0x03
	.DW  _0x3D
	.DW  _0x0*2+4

	.DW  0x03
	.DW  _0x3D+3
	.DW  _0x0*2+7

	.DW  0x06
	.DW  0x04
	.DW  _0xA9*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega8.h>
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
;#include <alcd.h>
;#include <delay.h>
;#include <stdio.h>
;#include <eering.c>
;#pragma used+
;
;typedef struct EEPROMRing
;{
;  char StBuf_Start;         //Status Buffer Start Adress
;  char DtBuf_Start;         //Data Buffer Start Adress
;  char Buf_Size;            //Buffer Size
;  char SAdress;             //Текущее значение адреса статус буфера
;} EE_Ring;
;
; void EEPROM_write(short uiAddress, unsigned char ucData);
; unsigned char EEPROM_read(short uiAddress);
; void EERing_write(EE_Ring *Temp, unsigned char EData);
; unsigned char EERing_read(EE_Ring Temp);
; void EERing_find(EE_Ring *Temp);
;
;
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;
;void EEPROM_write(short uiAddress, unsigned char ucData)
; 0000 0005 {

	.CSEG
_EEPROM_write:
;	while(EECR & (1<<EEWE));//ждем установки бита EEWE
;	uiAddress -> Y+1
;	ucData -> Y+0
_0x3:
	SBIC 0x1C,1
	RJMP _0x3
;	EEAR = uiAddress;//устанавливаем адрес
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	OUT  0x1E+1,R31
	OUT  0x1E,R30
;	EEDR = ucData;//записываем байт данных
	LD   R30,Y
	OUT  0x1D,R30
;	EECR |= (1<<EEMWE);//устанавливаем EEMWE
	SBI  0x1C,2
;	EECR |= (1<<EEWE);//устанавливаем EEWE
	SBI  0x1C,1
;}
	RJMP _0x2080001
;
;unsigned char EEPROM_read(short uiAddress)
;{
_EEPROM_read:
;	while(EECR & (1<<EEWE));//ждем установки EEWE
;	uiAddress -> Y+0
_0x6:
	SBIC 0x1C,1
	RJMP _0x6
;	EEAR = uiAddress;//устанавливаем адрес чтения
	LD   R30,Y
	LDD  R31,Y+1
	OUT  0x1E+1,R31
	OUT  0x1E,R30
;	EECR |= (1<<EERE);//разрешаем чтение
	SBI  0x1C,0
;	return EEDR;//возвращаем прочитанный байт из функции
	IN   R30,0x1D
	RJMP _0x2080003
;}
;
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;
;unsigned char EERing_read(EE_Ring Temp)
;{
_EERing_read:
;	char TData;
;    if(Temp.SAdress==Temp.StBuf_Start) Temp.SAdress=((Temp.SAdress+Temp.Buf_Size-1)&0x0F)|Temp.DtBuf_Start;
	ST   -Y,R17
;	Temp -> Y+1
;	TData -> R17
	LDD  R30,Y+1
	LDD  R26,Y+4
	CP   R30,R26
	BRNE _0x9
	LDD  R30,Y+3
	ADD  R26,R30
	SUBI R26,LOW(1)
	LDI  R30,LOW(15)
	AND  R30,R26
	LDD  R26,Y+2
	OR   R30,R26
	RJMP _0xA0
;    else Temp.SAdress=(Temp.SAdress&0x0F|Temp.DtBuf_Start)-1;     // Получаем адрес ячейки с данными, зависящий от адреса ячейки статуса
_0x9:
	LDD  R30,Y+4
	ANDI R30,LOW(0xF)
	LDD  R26,Y+2
	OR   R30,R26
	SUBI R30,LOW(1)
_0xA0:
	STD  Y+4,R30
;	TData=EEPROM_read(Temp.SAdress);
	RCALL SUBOPT_0x0
	MOV  R17,R30
;	return TData;
	MOV  R30,R17
	LDD  R17,Y+0
	ADIW R28,5
	RET
;}
;
;void EERing_write(EE_Ring *Temp, unsigned char EData)
;{
_EERing_write:
;	char TDataAdr;
;	TDataAdr=Temp->SAdress&0x0F|Temp->DtBuf_Start;                                        // Получаем адрес ячейки с данными, зависящий от адреса ячейки статуса
	ST   -Y,R17
;	*Temp -> Y+2
;	EData -> Y+1
;	TDataAdr -> R17
	RCALL SUBOPT_0x1
	LDD  R26,Z+3
	LDI  R30,LOW(15)
	AND  R30,R26
	MOV  R0,R30
	RCALL SUBOPT_0x2
	ADIW R26,1
	LD   R30,X
	OR   R30,R0
	MOV  R17,R30
;	if(EData!=EEPROM_read(TDataAdr)) EEPROM_write(TDataAdr, EData);
	MOV  R30,R17
	RCALL SUBOPT_0x0
	LDD  R26,Y+1
	CP   R30,R26
	BREQ _0xB
	MOV  R30,R17
	RCALL SUBOPT_0x3
	LDD  R30,Y+3
	ST   -Y,R30
	RCALL _EEPROM_write
;	if(Temp->SAdress+1==Temp->StBuf_Start+Temp->Buf_Size)                                //Если достигли конечного адреса буфера статуса
_0xB:
	RCALL SUBOPT_0x4
	SUBI R30,-LOW(1)
	MOV  R1,R30
	RCALL SUBOPT_0x2
	LD   R0,X
	RCALL SUBOPT_0x2
	ADIW R26,2
	LD   R30,X
	ADD  R30,R0
	CP   R30,R1
	BRNE _0xC
;	{
;		Temp->SAdress=Temp->StBuf_Start;                                                 //Переходим в начало буфера
	RCALL SUBOPT_0x2
	LD   R30,X
	__PUTB1SNS 2,3
;		EEPROM_write(Temp->SAdress, EEPROM_read(Temp->StBuf_Start+Temp->Buf_Size-1)+1); //Наращиваем значение буфера статуса
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x3
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R0,X
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADIW R26,2
	LD   R30,X
	MOV  R26,R0
	ADD  R26,R30
	RJMP _0xA1
;	}
;	else
_0xC:
;	{                                                                   //если еще не конец буфера
;		Temp->SAdress++;                                                      //наращиваем адрес ячейки буфера
	RCALL SUBOPT_0x4
	SUBI R30,-LOW(1)
	ST   X,R30
;		EEPROM_write(Temp->SAdress, EEPROM_read(Temp->SAdress-1)+1);                //записываем по нему значение буфера статуса +1
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x3
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDD  R26,Z+3
_0xA1:
	LDI  R30,LOW(1)
	RCALL __SWAPB12
	SUB  R30,R26
	RCALL SUBOPT_0x0
	SUBI R30,-LOW(1)
	ST   -Y,R30
	RCALL _EEPROM_write
;	}
;
;	 //возвращаем обновленный адрес последней записи в буфер
;}
	LDD  R17,Y+0
	ADIW R28,4
	RET
;
;
;void EERing_find(EE_Ring *Temp)       //Поиск адреса последней записи
;{
_EERing_find:
;    Temp->SAdress=Temp->StBuf_Start;
;	*Temp -> Y+0
	RCALL SUBOPT_0x5
	LD   R30,X
	__PUTB1SNS 0,3
;	while(Temp->SAdress+1<Temp->StBuf_Start+Temp->Buf_Size)
_0xE:
	RCALL SUBOPT_0x6
	SUBI R30,-LOW(1)
	MOV  R1,R30
	RCALL SUBOPT_0x5
	LD   R0,X
	RCALL SUBOPT_0x5
	ADIW R26,2
	LD   R30,X
	ADD  R30,R0
	CP   R1,R30
	BRSH _0x10
;    {
;        if(EEPROM_read(Temp->SAdress)==EEPROM_read(Temp->SAdress+1)-1)         //Сравниваем значение по текущему и следующему адресу
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x0
	PUSH R30
	RCALL SUBOPT_0x6
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x0
	SUBI R30,LOW(1)
	POP  R26
	CP   R30,R26
	BRNE _0x11
;             Temp->SAdress++;                                            //Если разница равна 1, то идем дальше наращивая адрес
	RCALL SUBOPT_0x6
	SUBI R30,-LOW(1)
	ST   X,R30
;        else break;                                                     //Если разница не равна 1, значит текущий адрес и есть последний
	RJMP _0x12
_0x11:
	RJMP _0x10
;    }
_0x12:
	RJMP _0xE
_0x10:
;
;}
	RJMP _0x2080003
;
;#pragma used-
;
;#define RES PORTC.4
;#define CLK PORTC.5
;#define ZASH PORTC.3
;#define DATA PORTC.2
;#define LED PORTC.1
;#define DERE PORTD.2 // 0 - прием 1 - передача
;#define Hi(Int) (int)Int>>8
;#define Low(Int) (char)(Int)
;
;#define AdrUBRRL 0x10
;#define AdrUCSRC 0x11
;#define AdrRLP 0x12
;#define AdrModbus 0x13
;
;
;unsigned char X1[]={"Modbus Adress"};

	.DSEG
;unsigned char X2[]={"USART Speed"};
;unsigned char X3[]={"1200"};
;unsigned char X4[]={"2400"};
;unsigned char X5[]={"4800"};
;unsigned char X6[]={"9600"};
;unsigned char X7[]={"19200"};
;unsigned char X8[]={"Parity"};
;unsigned char X9[]={"Odd"};
;unsigned char X10[]={"Even"};
;unsigned char X11[]={"No"};
;unsigned char X12[]={"Stop Bits"};
;unsigned char X13[]={"1"};
;unsigned char X14[]={"2"};
;unsigned char X15[]={"Restore"};
;unsigned char X16[]={"Yes"};
;unsigned char X17[]={"No"};
;
;typedef struct{                    //структура главноего меню
;    unsigned char *NAME;           // - название пункта главного меню
;    char Num;                      // - количество подпунктов данного пункта меню
;    char fl;                       // - начальный код подменю
;    char now;                      // - показывает текущую сохраненную настройку
;}StructMenu;
;
;static StructMenu menu_g[]={
;{X1,1,11,1},
;{X2,5,21,1},
;{X8,3,31,1},
;{X12,2,41,1},
;{X15,2,51,1}
;};
;
;static EE_Ring E_Reg={0x20,0x30,8,0};
;
;short Menu=0,Reg;
;char flag=0,m1=0,ModbusAdress,TempAdr;
;char E_UBRRL,E_UCSRC,E_RLP;
;
;void Transf_Reg(char TeReg)
; 0000 003E {

	.CSEG
_Transf_Reg:
; 0000 003F     char i,TempReg;
; 0000 0040     i=0;
	RCALL __SAVELOCR2
;	TeReg -> Y+2
;	i -> R17
;	TempReg -> R16
	LDI  R17,LOW(0)
; 0000 0041     while(i<8)
_0x26:
	CPI  R17,8
	BRSH _0x28
; 0000 0042     {
; 0000 0043         CLK=0;
	CBI  0x15,5
; 0000 0044         TempReg=TeReg&(1<<i);
	MOV  R30,R17
	LDI  R26,LOW(1)
	RCALL __LSLB12
	LDD  R26,Y+2
	AND  R30,R26
	MOV  R16,R30
; 0000 0045         if(TempReg) DATA=1;
	CPI  R16,0
	BREQ _0x2B
	SBI  0x15,2
; 0000 0046         else DATA=0;
	RJMP _0x2E
_0x2B:
	CBI  0x15,2
; 0000 0047         CLK=1;
_0x2E:
	SBI  0x15,5
; 0000 0048         i++;
	SUBI R17,-1
; 0000 0049     }
	RJMP _0x26
_0x28:
; 0000 004A }
	RCALL __LOADLOCR2
	RJMP _0x2080001
;
;void Load_Reg()
; 0000 004D {
_Load_Reg:
; 0000 004E char TempReg;
; 0000 004F TempReg=Hi(Reg);
	ST   -Y,R17
;	TempReg -> R17
	MOVW R30,R6
	RCALL __ASRW8
	MOV  R17,R30
; 0000 0050 Transf_Reg(TempReg);
	ST   -Y,R17
	RCALL _Transf_Reg
; 0000 0051 TempReg=Low(Reg);
	MOV  R17,R6
; 0000 0052 Transf_Reg(TempReg);
	ST   -Y,R17
	RCALL _Transf_Reg
; 0000 0053 ZASH=1;
	SBI  0x15,3
; 0000 0054 ZASH=0;
	CBI  0x15,3
; 0000 0055 }
	LD   R17,Y+
	RET
;
;void PrintNumber(char x)
; 0000 0058 {
_PrintNumber:
; 0000 0059 char TempP[3]="",Tem,i=0,Tem2=100;
; 0000 005A while(i<3)
	SBIW R28,3
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	RCALL __SAVELOCR4
;	x -> Y+7
;	TempP -> Y+4
;	Tem -> R17
;	i -> R16
;	Tem2 -> R19
	LDI  R16,0
	LDI  R19,100
_0x37:
	CPI  R16,3
	BRSH _0x39
; 0000 005B {
; 0000 005C Tem=x/Tem2;
	MOV  R30,R19
	LDD  R26,Y+7
	RCALL __DIVB21U
	MOV  R17,R30
; 0000 005D TempP[i]=0x30+Tem;
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,4
	ADD  R26,R30
	ADC  R27,R31
	MOV  R30,R17
	SUBI R30,-LOW(48)
	ST   X,R30
; 0000 005E x=x%Tem2;
	MOV  R30,R19
	LDD  R26,Y+7
	RCALL __MODB21U
	STD  Y+7,R30
; 0000 005F i++;
	SUBI R16,-1
; 0000 0060 Tem2/=10;
	MOV  R26,R19
	LDI  R30,LOW(10)
	RCALL __DIVB21U
	MOV  R19,R30
; 0000 0061 }
	RJMP _0x37
_0x39:
; 0000 0062 lcd_gotoxy(0,1);
	RCALL SUBOPT_0x7
; 0000 0063 lcd_puts(TempP);
	MOVW R30,R28
	ADIW R30,4
	RCALL SUBOPT_0x8
	RCALL _lcd_puts
; 0000 0064 }
	RCALL __LOADLOCR4
	ADIW R28,8
	RET
;
;void MenuPrint(unsigned char X[], short kod,char y)
; 0000 0067 {
_MenuPrint:
; 0000 0068 char tmp;
; 0000 0069 printf("asd");
	ST   -Y,R17
;	X -> Y+4
;	kod -> Y+2
;	y -> Y+1
;	tmp -> R17
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x8
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
; 0000 006A lcd_puts(menu_g[y].NAME);
	RCALL SUBOPT_0x9
	SUBI R30,LOW(-_menu_g_G000)
	SBCI R31,HIGH(-_menu_g_G000)
	MOVW R26,R30
	RCALL __GETW1P
	RCALL SUBOPT_0xA
; 0000 006B lcd_gotoxy(0,1);
	RCALL SUBOPT_0x7
; 0000 006C if(kod!=110) lcd_puts(X);
	RCALL SUBOPT_0x2
	CPI  R26,LOW(0x6E)
	LDI  R30,HIGH(0x6E)
	CPC  R27,R30
	BREQ _0x3A
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RCALL SUBOPT_0xA
; 0000 006D else PrintNumber(ModbusAdress);
	RJMP _0x3B
_0x3A:
	ST   -Y,R11
	RCALL _PrintNumber
; 0000 006E tmp=kod%10;
_0x3B:
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0xB
	RCALL __MODW21
	MOV  R17,R30
; 0000 006F if(tmp==menu_g[y].now) lcd_puts(" <");
	RCALL SUBOPT_0x9
	__ADDW1MN _menu_g_G000,4
	LD   R30,Z
	CP   R30,R17
	BRNE _0x3C
	__POINTW1MN _0x3D,0
	RCALL SUBOPT_0xA
; 0000 0070 
; 0000 0071 if (kod>100)
_0x3C:
	RCALL SUBOPT_0x2
	CPI  R26,LOW(0x65)
	LDI  R30,HIGH(0x65)
	CPC  R27,R30
	BRLT _0x3E
; 0000 0072 {
; 0000 0073     lcd_gotoxy(12,1);
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL SUBOPT_0xC
	RCALL _lcd_gotoxy
; 0000 0074     lcd_puts("Ok");
	__POINTW1MN _0x3D,3
	RCALL SUBOPT_0xA
; 0000 0075     Menu/=10;
	MOVW R26,R4
	RCALL SUBOPT_0xB
	RCALL __DIVW21
	MOVW R4,R30
; 0000 0076     EEPROM_write(AdrUBRRL,UBRRL);
	RCALL SUBOPT_0xD
	ST   -Y,R30
	RCALL _EEPROM_write
; 0000 0077 }
; 0000 0078 
; 0000 0079 }
_0x3E:
	LDD  R17,Y+0
	ADIW R28,6
	RET

	.DSEG
_0x3D:
	.BYTE 0x6
;
;void FuncMenu(short punkt)
; 0000 007C {

	.CSEG
_FuncMenu:
; 0000 007D lcd_clear();
;	punkt -> Y+0
	RCALL _lcd_clear
; 0000 007E switch(punkt)
	LD   R30,Y
	LDD  R31,Y+1
; 0000 007F     {
; 0000 0080         case 10:{lcd_puts(menu_g[0].NAME);TempAdr=ModbusAdress;break;}
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x42
	RCALL SUBOPT_0xE
	MOV  R10,R11
	RJMP _0x41
; 0000 0081             case 11:
_0x42:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x43
; 0000 0082             {
; 0000 0083                 lcd_puts(menu_g[0].NAME);
	RCALL SUBOPT_0xE
; 0000 0084                 PrintNumber(TempAdr);
	ST   -Y,R10
	RCALL _PrintNumber
; 0000 0085                 TempAdr++;
	INC  R10
; 0000 0086                 if(TempAdr>255) TempAdr=0;
	LDI  R30,LOW(255)
	CP   R30,R10
	BRSH _0x44
	CLR  R10
; 0000 0087                 break;
_0x44:
	RJMP _0x41
; 0000 0088             }
; 0000 0089         case 20:{lcd_puts(menu_g[1].NAME);break;}
_0x43:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0x45
	__GETW1MN _menu_g_G000,5
	RCALL SUBOPT_0xA
	RJMP _0x41
; 0000 008A             case 21:{MenuPrint(X3,punkt,1);break;}
_0x45:
	CPI  R30,LOW(0x15)
	LDI  R26,HIGH(0x15)
	CPC  R31,R26
	BRNE _0x46
	RCALL SUBOPT_0xF
	RCALL _MenuPrint
	RJMP _0x41
; 0000 008B             case 22:{MenuPrint(X4,punkt,1);break;}
_0x46:
	CPI  R30,LOW(0x16)
	LDI  R26,HIGH(0x16)
	CPC  R31,R26
	BRNE _0x47
	RCALL SUBOPT_0x10
	RCALL _MenuPrint
	RJMP _0x41
; 0000 008C             case 23:{MenuPrint(X5,punkt,1);break;}
_0x47:
	CPI  R30,LOW(0x17)
	LDI  R26,HIGH(0x17)
	CPC  R31,R26
	BRNE _0x48
	RCALL SUBOPT_0x11
	RCALL _MenuPrint
	RJMP _0x41
; 0000 008D             case 24:{MenuPrint(X6,punkt,1);break;}
_0x48:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0x49
	RCALL SUBOPT_0x12
	RCALL _MenuPrint
	RJMP _0x41
; 0000 008E             case 25:{MenuPrint(X7,punkt,1);break;}
_0x49:
	CPI  R30,LOW(0x19)
	LDI  R26,HIGH(0x19)
	CPC  R31,R26
	BRNE _0x4A
	RCALL SUBOPT_0x13
	RCALL _MenuPrint
	RJMP _0x41
; 0000 008F         case 30:{lcd_puts(menu_g[2].NAME);break;}
_0x4A:
	CPI  R30,LOW(0x1E)
	LDI  R26,HIGH(0x1E)
	CPC  R31,R26
	BRNE _0x4B
	__GETW1MN _menu_g_G000,10
	RCALL SUBOPT_0xA
	RJMP _0x41
; 0000 0090             case 31:{MenuPrint(X9,punkt,2);break;}
_0x4B:
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	BRNE _0x4C
	RCALL SUBOPT_0x14
	RJMP _0x41
; 0000 0091             case 32:{MenuPrint(X10,punkt,2);break;}
_0x4C:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0x4D
	RCALL SUBOPT_0x15
	RJMP _0x41
; 0000 0092             case 33:{MenuPrint(X11,punkt,2);break;}
_0x4D:
	CPI  R30,LOW(0x21)
	LDI  R26,HIGH(0x21)
	CPC  R31,R26
	BRNE _0x4E
	RCALL SUBOPT_0x16
	RJMP _0x41
; 0000 0093         case 40:{lcd_puts(menu_g[3].NAME);break;}
_0x4E:
	CPI  R30,LOW(0x28)
	LDI  R26,HIGH(0x28)
	CPC  R31,R26
	BRNE _0x4F
	__GETW1MN _menu_g_G000,15
	RCALL SUBOPT_0xA
	RJMP _0x41
; 0000 0094             case 41:{MenuPrint(X13,punkt,3);break;}
_0x4F:
	CPI  R30,LOW(0x29)
	LDI  R26,HIGH(0x29)
	CPC  R31,R26
	BRNE _0x50
	RCALL SUBOPT_0x17
	RJMP _0x41
; 0000 0095             case 42:{MenuPrint(X14,punkt,3);break;}
_0x50:
	CPI  R30,LOW(0x2A)
	LDI  R26,HIGH(0x2A)
	CPC  R31,R26
	BRNE _0x51
	RCALL SUBOPT_0x18
	RJMP _0x41
; 0000 0096         case 50:{lcd_puts(menu_g[4].NAME);break;}
_0x51:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0x52
	__GETW1MN _menu_g_G000,20
	RCALL SUBOPT_0xA
	RJMP _0x41
; 0000 0097             case 51:{MenuPrint(X16,punkt,4);break;}
_0x52:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0x53
	RCALL SUBOPT_0x19
	RJMP _0x41
; 0000 0098             case 52:{MenuPrint(X17,punkt,4);break;}
_0x53:
	CPI  R30,LOW(0x34)
	LDI  R26,HIGH(0x34)
	CPC  R31,R26
	BRNE _0x54
	RCALL SUBOPT_0x1A
	RJMP _0x41
; 0000 0099 
; 0000 009A 
; 0000 009B                 case 110:{ModbusAdress=TempAdr-1;MenuPrint(X1,punkt,0);EEPROM_write(AdrModbus,ModbusAdress);break;}
_0x54:
	CPI  R30,LOW(0x6E)
	LDI  R26,HIGH(0x6E)
	CPC  R31,R26
	BRNE _0x55
	MOV  R30,R10
	SUBI R30,LOW(1)
	MOV  R11,R30
	LDI  R30,LOW(_X1)
	LDI  R31,HIGH(_X1)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x8
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _MenuPrint
	LDI  R30,LOW(19)
	LDI  R31,HIGH(19)
	RCALL SUBOPT_0x8
	ST   -Y,R11
	RJMP _0xA2
; 0000 009C                 case 210:{menu_g[1].now=1;MenuPrint(X3,punkt,1);UBRRL=0x67;EEPROM_write(AdrUBRRL,UBRRL);break;}
_0x55:
	CPI  R30,LOW(0xD2)
	LDI  R26,HIGH(0xD2)
	CPC  R31,R26
	BRNE _0x56
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0xF
	RCALL _MenuPrint
	LDI  R30,LOW(103)
	RCALL SUBOPT_0x1C
	RJMP _0xA3
; 0000 009D                 case 220:{menu_g[1].now=2;MenuPrint(X4,punkt,1);UBRRL=0x33;EEPROM_write(AdrUBRRL,UBRRL);break;}
_0x56:
	CPI  R30,LOW(0xDC)
	LDI  R26,HIGH(0xDC)
	CPC  R31,R26
	BRNE _0x57
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x10
	RCALL _MenuPrint
	LDI  R30,LOW(51)
	RCALL SUBOPT_0x1C
	RJMP _0xA3
; 0000 009E                 case 230:{menu_g[1].now=3;MenuPrint(X5,punkt,1);UBRRL=0x19;EEPROM_write(AdrUBRRL,UBRRL);break;}
_0x57:
	CPI  R30,LOW(0xE6)
	LDI  R26,HIGH(0xE6)
	CPC  R31,R26
	BRNE _0x58
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x11
	RCALL _MenuPrint
	LDI  R30,LOW(25)
	RCALL SUBOPT_0x1C
	RJMP _0xA3
; 0000 009F                 case 240:{menu_g[1].now=4;MenuPrint(X6,punkt,1);UBRRL=0x0C;EEPROM_write(AdrUBRRL,UBRRL);break;}
_0x58:
	CPI  R30,LOW(0xF0)
	LDI  R26,HIGH(0xF0)
	CPC  R31,R26
	BRNE _0x59
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x12
	RCALL _MenuPrint
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x1C
	RJMP _0xA3
; 0000 00A0                 case 250:{menu_g[1].now=5;MenuPrint(X7,punkt,1);UBRRL=0x06;EEPROM_write(AdrUBRRL,UBRRL);break;}
_0x59:
	CPI  R30,LOW(0xFA)
	LDI  R26,HIGH(0xFA)
	CPC  R31,R26
	BRNE _0x5A
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x13
	RCALL _MenuPrint
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x1C
	RJMP _0xA3
; 0000 00A1                 case 310:{menu_g[2].now=1;MenuPrint(X9,punkt,2);E_UCSRC|=0x30;UCSRC=E_UCSRC;EEPROM_write(AdrUCSRC,E_UCSRC);break;}
_0x5A:
	CPI  R30,LOW(0x136)
	LDI  R26,HIGH(0x136)
	CPC  R31,R26
	BRNE _0x5B
	LDI  R30,LOW(1)
	__PUTB1MN _menu_g_G000,14
	RCALL SUBOPT_0x14
	LDI  R30,LOW(48)
	RCALL SUBOPT_0x1D
	RJMP _0xA2
; 0000 00A2                 case 320:{menu_g[2].now=2;MenuPrint(X10,punkt,2);E_UCSRC&=~0x30;E_UCSRC|=0x20;UCSRC=E_UCSRC;EEPROM_write(AdrUCSRC,E_UCSRC);break;}
_0x5B:
	CPI  R30,LOW(0x140)
	LDI  R26,HIGH(0x140)
	CPC  R31,R26
	BRNE _0x5C
	LDI  R30,LOW(2)
	__PUTB1MN _menu_g_G000,14
	RCALL SUBOPT_0x15
	LDI  R30,LOW(207)
	AND  R12,R30
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x1D
	RJMP _0xA2
; 0000 00A3                 case 330:{menu_g[2].now=3;MenuPrint(X11,punkt,2);E_UCSRC&=~0x30;UCSRC=E_UCSRC;EEPROM_write(AdrUCSRC,E_UCSRC);break;}
_0x5C:
	CPI  R30,LOW(0x14A)
	LDI  R26,HIGH(0x14A)
	CPC  R31,R26
	BRNE _0x5D
	LDI  R30,LOW(3)
	__PUTB1MN _menu_g_G000,14
	RCALL SUBOPT_0x16
	LDI  R30,LOW(207)
	RCALL SUBOPT_0x1E
	RJMP _0xA2
; 0000 00A4                 case 410:{menu_g[3].now=1;MenuPrint(X13,punkt,3);E_UCSRC&=~0x08;UCSRC=E_UCSRC;EEPROM_write(AdrUCSRC,E_UCSRC);break;}
_0x5D:
	CPI  R30,LOW(0x19A)
	LDI  R26,HIGH(0x19A)
	CPC  R31,R26
	BRNE _0x5E
	LDI  R30,LOW(1)
	__PUTB1MN _menu_g_G000,19
	RCALL SUBOPT_0x17
	LDI  R30,LOW(247)
	RCALL SUBOPT_0x1E
	RJMP _0xA2
; 0000 00A5                 case 420:{menu_g[3].now=2;MenuPrint(X14,punkt,3);E_UCSRC|=0x08;UCSRC=E_UCSRC;EEPROM_write(AdrUCSRC,E_UCSRC);break;}
_0x5E:
	CPI  R30,LOW(0x1A4)
	LDI  R26,HIGH(0x1A4)
	CPC  R31,R26
	BRNE _0x5F
	LDI  R30,LOW(2)
	__PUTB1MN _menu_g_G000,19
	RCALL SUBOPT_0x18
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x1D
	RJMP _0xA2
; 0000 00A6                 case 510:{menu_g[4].now=1;MenuPrint(X16,punkt,4);E_RLP=0x54;EEPROM_write(AdrRLP,E_RLP);break;}
_0x5F:
	CPI  R30,LOW(0x1FE)
	LDI  R26,HIGH(0x1FE)
	CPC  R31,R26
	BRNE _0x60
	LDI  R30,LOW(1)
	__PUTB1MN _menu_g_G000,24
	RCALL SUBOPT_0x19
	LDI  R30,LOW(84)
	RJMP _0xA4
; 0000 00A7                 case 520:{menu_g[4].now=2;MenuPrint(X17,punkt,4);E_RLP=0x00;EEPROM_write(AdrRLP,E_RLP);break;}
_0x60:
	CPI  R30,LOW(0x208)
	LDI  R26,HIGH(0x208)
	CPC  R31,R26
	BRNE _0x41
	LDI  R30,LOW(2)
	__PUTB1MN _menu_g_G000,24
	RCALL SUBOPT_0x1A
	LDI  R30,LOW(0)
_0xA4:
	STS  _E_RLP,R30
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	RCALL SUBOPT_0x8
	LDS  R30,_E_RLP
_0xA3:
	ST   -Y,R30
_0xA2:
	RCALL _EEPROM_write
; 0000 00A8     }
_0x41:
; 0000 00A9 }
	RJMP _0x2080003
;
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;
;void init()
; 0000 00AE {
_init:
; 0000 00AF E_UCSRC=EEPROM_read(AdrUCSRC);
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	RCALL SUBOPT_0x1F
	MOV  R12,R30
; 0000 00B0 E_UCSRC|=0x86;
	LDI  R30,LOW(134)
	OR   R12,R30
; 0000 00B1 E_UBRRL=EEPROM_read(AdrUBRRL);
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RCALL SUBOPT_0x1F
	MOV  R13,R30
; 0000 00B2 E_RLP=EEPROM_read(AdrRLP);
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	RCALL SUBOPT_0x1F
	STS  _E_RLP,R30
; 0000 00B3 ModbusAdress=EEPROM_read(AdrModbus);
	LDI  R30,LOW(19)
	LDI  R31,HIGH(19)
	RCALL SUBOPT_0x1F
	MOV  R11,R30
; 0000 00B4 TempAdr=ModbusAdress;
	MOV  R10,R11
; 0000 00B5 UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 00B6 UCSRB=0x08;
	LDI  R30,LOW(8)
	OUT  0xA,R30
; 0000 00B7 UCSRC=E_UCSRC;
	OUT  0x20,R12
; 0000 00B8     UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 00B9 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00BA UBRRL=E_UBRRL;
	OUT  0x9,R13
; 0000 00BB     UBRRL=0x0C;
	LDI  R30,LOW(12)
	OUT  0x9,R30
; 0000 00BC printf("%x ",E_UCSRC);                                             ////
	__POINTW1FN _0x0,10
	RCALL SUBOPT_0x8
	MOV  R30,R12
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
; 0000 00BD switch(E_UBRRL)
	MOV  R30,R13
; 0000 00BE {
; 0000 00BF     case 0x67:{menu_g[1].now=1;break;} // 1200
	CPI  R30,LOW(0x67)
	BRNE _0x65
	LDI  R30,LOW(1)
	RJMP _0xA5
; 0000 00C0     case 0x33:{menu_g[1].now=2;break;} // 2400
_0x65:
	CPI  R30,LOW(0x33)
	BRNE _0x66
	LDI  R30,LOW(2)
	RJMP _0xA5
; 0000 00C1     case 0x19:{menu_g[1].now=3;break;} // 4800
_0x66:
	CPI  R30,LOW(0x19)
	BRNE _0x67
	LDI  R30,LOW(3)
	RJMP _0xA5
; 0000 00C2     case 0x0C:{menu_g[1].now=4;break;} // 9600
_0x67:
	CPI  R30,LOW(0xC)
	BRNE _0x68
	LDI  R30,LOW(4)
	RJMP _0xA5
; 0000 00C3     case 0x06:{menu_g[1].now=5;break;} // 19200
_0x68:
	CPI  R30,LOW(0x6)
	BRNE _0x64
	LDI  R30,LOW(5)
_0xA5:
	__PUTB1MN _menu_g_G000,9
; 0000 00C4 }
_0x64:
; 0000 00C5 
; 0000 00C6 switch(E_UCSRC&0x08)
	MOV  R30,R12
	ANDI R30,LOW(0x8)
; 0000 00C7 {
; 0000 00C8     case 0:{menu_g[3].now=1;break;} // 1 - SB
	CPI  R30,0
	BRNE _0x6D
	LDI  R30,LOW(1)
	RJMP _0xA6
; 0000 00C9     case 0x08:{menu_g[3].now=2;break;} // 2 - SB
_0x6D:
	CPI  R30,LOW(0x8)
	BRNE _0x6C
	LDI  R30,LOW(2)
_0xA6:
	__PUTB1MN _menu_g_G000,19
; 0000 00CA 
; 0000 00CB }
_0x6C:
; 0000 00CC switch(E_UCSRC&0x30)
	MOV  R30,R12
	ANDI R30,LOW(0x30)
; 0000 00CD {
; 0000 00CE     case 0:{menu_g[2].now=3;break;}   // No
	CPI  R30,0
	BRNE _0x72
	LDI  R30,LOW(3)
	RJMP _0xA7
; 0000 00CF     case 20:{menu_g[2].now=2;break;}  // Even
_0x72:
	CPI  R30,LOW(0x14)
	BRNE _0x73
	LDI  R30,LOW(2)
	RJMP _0xA7
; 0000 00D0     case 30:{menu_g[2].now=1;break;}  // Odd
_0x73:
	CPI  R30,LOW(0x1E)
	BRNE _0x71
	LDI  R30,LOW(1)
_0xA7:
	__PUTB1MN _menu_g_G000,14
; 0000 00D1 }
_0x71:
; 0000 00D2 
; 0000 00D3 if(E_RLP==0x54)  //0x54 - yes  0x00 -No
	LDS  R26,_E_RLP
	CPI  R26,LOW(0x54)
	BRNE _0x75
; 0000 00D4 {
; 0000 00D5     EERing_find(&E_Reg);
	LDI  R30,LOW(_E_Reg_G000)
	LDI  R31,HIGH(_E_Reg_G000)
	RCALL SUBOPT_0x8
	RCALL _EERing_find
; 0000 00D6     Reg=EERing_read(E_Reg);
	LDI  R30,LOW(_E_Reg_G000)
	LDI  R31,HIGH(_E_Reg_G000)
	LDI  R26,4
	RCALL __PUTPARL
	RCALL _EERing_read
	MOV  R6,R30
	CLR  R7
; 0000 00D7     Load_Reg();
	RCALL _Load_Reg
; 0000 00D8     menu_g[4].now=1;
	LDI  R30,LOW(1)
	RJMP _0xA8
; 0000 00D9 }
; 0000 00DA else
_0x75:
; 0000 00DB {
; 0000 00DC     Reg=0x00;
	CLR  R6
	CLR  R7
; 0000 00DD     RES=0;
	CBI  0x15,4
; 0000 00DE     ZASH=1;
	SBI  0x15,3
; 0000 00DF     ZASH=0;
	CBI  0x15,3
; 0000 00E0     RES=1;
	SBI  0x15,4
; 0000 00E1 
; 0000 00E2     EERing_write(&E_Reg,Reg);
	LDI  R30,LOW(_E_Reg_G000)
	LDI  R31,HIGH(_E_Reg_G000)
	RCALL SUBOPT_0x8
	ST   -Y,R6
	RCALL _EERing_write
; 0000 00E3     menu_g[4].now=2;
	LDI  R30,LOW(2)
_0xA8:
	__PUTB1MN _menu_g_G000,24
; 0000 00E4 }
; 0000 00E5 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 00E6 }
	RET
;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;void main(void)
; 0000 00E9 {
_main:
; 0000 00EA DDRD&=~0b01101000;
	IN   R30,0x11
	ANDI R30,LOW(0x97)
	OUT  0x11,R30
; 0000 00EB PORTD|=0b01101000;
	IN   R30,0x12
	ORI  R30,LOW(0x68)
	OUT  0x12,R30
; 0000 00EC DDRC=0x7E;
	LDI  R30,LOW(126)
	OUT  0x14,R30
; 0000 00ED RES=1;
	SBI  0x15,4
; 0000 00EE DERE=0;
	CBI  0x12,2
; 0000 00EF 
; 0000 00F0 init();
	RCALL _init
; 0000 00F1 
; 0000 00F2 LED=1;
	SBI  0x15,1
; 0000 00F3 delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL SUBOPT_0x20
; 0000 00F4 LED=0;
	CBI  0x15,1
; 0000 00F5 
; 0000 00F6 
; 0000 00F7 lcd_puts(menu_g[0].NAME);
	RCALL SUBOPT_0xE
; 0000 00F8 Menu=10;
	RCALL SUBOPT_0xB
	MOVW R4,R30
; 0000 00F9 while (1)
_0x87:
; 0000 00FA     {
; 0000 00FB 
; 0000 00FC        if (!PIND.6)     // Select - button
	SBIC 0x10,6
	RJMP _0x8A
; 0000 00FD         {
; 0000 00FE             delay_ms(20);
	RCALL SUBOPT_0x21
; 0000 00FF             if(!PIND.6)
	SBIC 0x10,6
	RJMP _0x8B
; 0000 0100             {
; 0000 0101                 while(!PIND.6);
_0x8C:
	SBIS 0x10,6
	RJMP _0x8C
; 0000 0102                 if(!flag)
	TST  R9
	BRNE _0x8F
; 0000 0103                 {
; 0000 0104                     Menu++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 0105                     flag=1;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 0106                 }
; 0000 0107                 else
	RJMP _0x90
_0x8F:
; 0000 0108                 {
; 0000 0109                     flag=2;
	LDI  R30,LOW(2)
	MOV  R9,R30
; 0000 010A                     Menu*=10;
	MOVW R30,R4
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL __MULW12
	MOVW R4,R30
; 0000 010B                 }
_0x90:
; 0000 010C                 FuncMenu(Menu);
	RCALL SUBOPT_0x22
; 0000 010D             }
; 0000 010E         }
_0x8B:
; 0000 010F 
; 0000 0110 
; 0000 0111         if (!PIND.3)    // Back - button
_0x8A:
	SBIC 0x10,3
	RJMP _0x91
; 0000 0112         {
; 0000 0113             delay_ms(20);
	RCALL SUBOPT_0x21
; 0000 0114             if(!PIND.3)
	SBIC 0x10,3
	RJMP _0x92
; 0000 0115             {
; 0000 0116                 while(!PIND.3);
_0x93:
	SBIS 0x10,3
	RJMP _0x93
; 0000 0117                 Menu=10;
	RCALL SUBOPT_0xB
	MOVW R4,R30
; 0000 0118                 m1=0;
	CLR  R8
; 0000 0119                 flag=0;
	CLR  R9
; 0000 011A                 FuncMenu(Menu);
	RCALL SUBOPT_0x22
; 0000 011B 
; 0000 011C             }
; 0000 011D         }
_0x92:
; 0000 011E 
; 0000 011F 
; 0000 0120         if (!PIND.5)    // Next - button
_0x91:
	SBIC 0x10,5
	RJMP _0x96
; 0000 0121         {
; 0000 0122             delay_ms(20);
	RCALL SUBOPT_0x21
; 0000 0123             if(!PIND.5)
	SBIC 0x10,5
	RJMP _0x97
; 0000 0124             {
; 0000 0125                 while(!PIND.5);
_0x98:
	SBIS 0x10,5
	RJMP _0x98
; 0000 0126                 if(!flag)
	TST  R9
	BRNE _0x9B
; 0000 0127                 {
; 0000 0128                     Menu+=10;
	MOVW R30,R4
	ADIW R30,10
	MOVW R4,R30
; 0000 0129                     m1++;
	INC  R8
; 0000 012A                     if(Menu>50) {Menu=10;m1=0;}
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CP   R30,R4
	CPC  R31,R5
	BRGE _0x9C
	RCALL SUBOPT_0xB
	MOVW R4,R30
	CLR  R8
; 0000 012B                 }
_0x9C:
; 0000 012C                 else
	RJMP _0x9D
_0x9B:
; 0000 012D                 {
; 0000 012E                     Menu++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 012F                     if((menu_g[m1].Num+menu_g[m1].fl)==Menu) Menu=menu_g[m1].fl;
	RCALL SUBOPT_0x23
	MOVW R26,R30
	__ADDW1MN _menu_g_G000,2
	LD   R22,Z
	MOVW R30,R26
	__ADDW1MN _menu_g_G000,3
	LD   R30,Z
	MOV  R26,R22
	ADD  R26,R30
	MOVW R30,R4
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x9E
	RCALL SUBOPT_0x23
	__ADDW1MN _menu_g_G000,3
	LD   R4,Z
	CLR  R5
; 0000 0130                 }
_0x9E:
_0x9D:
; 0000 0131                 FuncMenu(Menu);
	RCALL SUBOPT_0x22
; 0000 0132 
; 0000 0133             }
; 0000 0134         }
_0x97:
; 0000 0135 
; 0000 0136 
; 0000 0137     }
_0x96:
	RJMP _0x87
; 0000 0138 
; 0000 0139 
; 0000 013A }
_0x9F:
	RJMP _0x9F
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

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x18,2
	RJMP _0x2000005
_0x2000004:
	CBI  0x18,2
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x18,3
	RJMP _0x2000007
_0x2000006:
	CBI  0x18,3
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x18,4
	RJMP _0x2000009
_0x2000008:
	CBI  0x18,4
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x18,5
	RJMP _0x200000B
_0x200000A:
	CBI  0x18,5
_0x200000B:
	__DELAY_USB 1
	SBI  0x18,1
	__DELAY_USB 3
	CBI  0x18,1
	__DELAY_USB 3
	RJMP _0x2080002
__lcd_write_data:
	LD   R30,Y
	RCALL SUBOPT_0x24
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	RCALL SUBOPT_0x24
	__DELAY_USB 33
	RJMP _0x2080002
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	RCALL SUBOPT_0x25
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x2080003:
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x25
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x20
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0xC
	RCALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x20
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	RJMP _0x2080002
_0x2000013:
_0x2000010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x12,7
	LD   R30,Y
	RCALL SUBOPT_0x25
	CBI  0x12,7
	RJMP _0x2080002
_lcd_puts:
	ST   -Y,R17
_0x2000014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2000014
_0x2000016:
	LDD  R17,Y+0
	RJMP _0x2080001
_lcd_init:
	SBI  0x17,2
	SBI  0x17,3
	SBI  0x17,4
	SBI  0x17,5
	SBI  0x17,1
	SBI  0x11,7
	SBI  0x17,0
	CBI  0x18,1
	CBI  0x12,7
	CBI  0x18,0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	RCALL SUBOPT_0x21
	LDI  R30,LOW(48)
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x26
	__DELAY_USB 67
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x24
	__DELAY_USB 67
	LDI  R30,LOW(40)
	RCALL SUBOPT_0x25
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x25
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x25
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x25
	RCALL _lcd_clear
	RJMP _0x2080002
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

	.CSEG
_putchar:
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x2080002:
	ADIW R28,1
	RET
_put_usart_G101:
	LDD  R30,Y+2
	ST   -Y,R30
	RCALL _putchar
	RCALL SUBOPT_0x5
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2080001:
	ADIW R28,3
	RET
__print_G101:
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	RCALL SUBOPT_0x27
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	RCALL SUBOPT_0x27
	RJMP _0x20200C9
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x28
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x2A
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	RCALL SUBOPT_0x2B
	RCALL SUBOPT_0x2C
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	RCALL SUBOPT_0x2B
	RCALL SUBOPT_0x2C
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	RCALL SUBOPT_0x2D
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	RCALL SUBOPT_0x2D
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	RCALL SUBOPT_0x2B
	RCALL SUBOPT_0x2E
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	RCALL SUBOPT_0x2B
	RCALL SUBOPT_0x2E
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	RCALL SUBOPT_0x27
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x2D
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	RCALL SUBOPT_0x27
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x2D
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CA
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x2A
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	RCALL SUBOPT_0x27
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x2A
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200C9:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR2
	MOVW R26,R28
	ADIW R26,4
	RCALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x8
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G101)
	LDI  R31,HIGH(_put_usart_G101)
	RCALL SUBOPT_0x8
	MOVW R30,R28
	ADIW R30,8
	RCALL SUBOPT_0x8
	RCALL __print_G101
	RCALL __LOADLOCR2
	ADIW R28,8
	POP  R15
	RET

	.CSEG

	.CSEG
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.DSEG
_X1:
	.BYTE 0xE
_X2:
	.BYTE 0xC
_X3:
	.BYTE 0x5
_X4:
	.BYTE 0x5
_X5:
	.BYTE 0x5
_X6:
	.BYTE 0x5
_X7:
	.BYTE 0x6
_X8:
	.BYTE 0x7
_X9:
	.BYTE 0x4
_X10:
	.BYTE 0x5
_X11:
	.BYTE 0x3
_X12:
	.BYTE 0xA
_X13:
	.BYTE 0x2
_X14:
	.BYTE 0x2
_X15:
	.BYTE 0x8
_X16:
	.BYTE 0x4
_X17:
	.BYTE 0x3
_menu_g_G000:
	.BYTE 0x19
_E_Reg_G000:
	.BYTE 0x4
_E_RLP:
	.BYTE 0x1
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x0:
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RJMP _EEPROM_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x1:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	RCALL SUBOPT_0x2
	ADIW R26,3
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	LD   R26,Y
	LDD  R27,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	RCALL SUBOPT_0x5
	ADIW R26,3
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 103 TIMES, CODE SIZE REDUCTION:100 WORDS
SUBOPT_0x8:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDD  R30,Y+1
	LDI  R26,LOW(5)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xA:
	RCALL SUBOPT_0x8
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RCALL SUBOPT_0x8
	IN   R30,0x9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE:
	LDS  R30,_menu_g_G000
	LDS  R31,_menu_g_G000+1
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(_X3)
	LDI  R31,HIGH(_X3)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x8
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(_X4)
	LDI  R31,HIGH(_X4)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x8
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(_X5)
	LDI  R31,HIGH(_X5)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x8
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(_X6)
	LDI  R31,HIGH(_X6)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x8
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(_X7)
	LDI  R31,HIGH(_X7)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x8
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(_X9)
	LDI  R31,HIGH(_X9)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x8
	LDI  R30,LOW(2)
	ST   -Y,R30
	RJMP _MenuPrint

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(_X10)
	LDI  R31,HIGH(_X10)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x8
	LDI  R30,LOW(2)
	ST   -Y,R30
	RJMP _MenuPrint

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(_X11)
	LDI  R31,HIGH(_X11)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x8
	LDI  R30,LOW(2)
	ST   -Y,R30
	RJMP _MenuPrint

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(_X13)
	LDI  R31,HIGH(_X13)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x8
	LDI  R30,LOW(3)
	ST   -Y,R30
	RJMP _MenuPrint

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(_X14)
	LDI  R31,HIGH(_X14)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x8
	LDI  R30,LOW(3)
	ST   -Y,R30
	RJMP _MenuPrint

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(_X16)
	LDI  R31,HIGH(_X16)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x8
	LDI  R30,LOW(4)
	ST   -Y,R30
	RJMP _MenuPrint

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(_X17)
	LDI  R31,HIGH(_X17)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x8
	LDI  R30,LOW(4)
	ST   -Y,R30
	RJMP _MenuPrint

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1B:
	__PUTB1MN _menu_g_G000,9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	OUT  0x9,R30
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1D:
	OR   R12,R30
	OUT  0x20,R12
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	RCALL SUBOPT_0x8
	ST   -Y,R12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	AND  R12,R30
	OUT  0x20,R12
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	RCALL SUBOPT_0x8
	ST   -Y,R12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	RCALL SUBOPT_0x8
	RJMP _EEPROM_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x20:
	RCALL SUBOPT_0x8
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	ST   -Y,R5
	ST   -Y,R4
	RJMP _FuncMenu

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	MOV  R30,R8
	LDI  R26,LOW(5)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	ST   -Y,R30
	RJMP __lcd_write_nibble_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x25:
	ST   -Y,R30
	RJMP __lcd_write_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x26:
	__DELAY_USB 67
	LDI  R30,LOW(48)
	RJMP SUBOPT_0x24

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x27:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x8
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x29:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2A:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	RCALL SUBOPT_0x8
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	RCALL SUBOPT_0x28
	RJMP SUBOPT_0x29

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2C:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2E:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x1F4
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__ASRW8:
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODB21U:
	RCALL __DIVB21U
	MOV  R30,R26
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARL:
	CLR  R27
__PUTPAR:
	ADD  R30,R26
	ADC  R31,R27
__PUTPAR0:
	LD   R0,-Z
	ST   -Y,R0
	SBIW R26,1
	BRNE __PUTPAR0
	RET

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
