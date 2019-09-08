
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
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

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	.DEF _i=R5
	.DEF _b=R4
	.DEF __lcd_x=R7
	.DEF __lcd_y=R6
	.DEF __lcd_maxx=R9

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _myInterrupt
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G103:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G103:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0

_0x30:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_0x0:
	.DB  0x41,0x54,0x2B,0x52,0x4D,0x41,0x41,0x44
	.DB  0xD,0xA,0x0,0x41,0x54,0x2B,0x42,0x49
	.DB  0x4E,0x44,0x3D,0x39,0x38,0x44,0x33,0x2C
	.DB  0x41,0x31,0x2C,0x46,0x35,0x42,0x35,0x34
	.DB  0x38,0xD,0xA,0x0,0x41,0x54,0x2B,0x42
	.DB  0x49,0x4E,0x44,0x3D,0x39,0x38,0x44,0x33
	.DB  0x2C,0x32,0x31,0x2C,0x46,0x37,0x33,0x42
	.DB  0x38,0x31,0xD,0xA,0x0,0x41,0x54,0x2B
	.DB  0x49,0x4E,0x49,0x54,0xD,0xA,0x0,0x41
	.DB  0x54,0x2B,0x49,0x4E,0x51,0xD,0xA,0x0
	.DB  0x41,0x54,0x2B,0x4C,0x49,0x4E,0x4B,0x3D
	.DB  0x39,0x38,0x44,0x33,0x2C,0x41,0x31,0x2C
	.DB  0x46,0x35,0x42,0x35,0x34,0x38,0xD,0xA
	.DB  0x0,0x41,0x54,0x2B,0x4C,0x49,0x4E,0x4B
	.DB  0x3D,0x39,0x38,0x44,0x33,0x2C,0x32,0x31
	.DB  0x2C,0x46,0x37,0x33,0x42,0x38,0x31,0xD
	.DB  0xA,0x0,0x41,0x54,0x2B,0x44,0x49,0x53
	.DB  0x43,0xD,0xA,0x0,0x4F,0x76,0x65,0x72
	.DB  0x4C,0x44,0x2C,0x4B,0x67,0x20,0x0,0x53
	.DB  0x61,0x66,0x65,0x4C,0x44,0x2C,0x4B,0x67
	.DB  0x20,0x0,0x49,0x6E,0x73,0x74,0x61,0x62
	.DB  0x6C,0x65,0x2C,0x7A,0x3D,0x0,0x4E,0x65
	.DB  0x75,0x74,0x72,0x61,0x6C,0x2C,0x7A,0x3D
	.DB  0x0,0x53,0x74,0x61,0x62,0x6C,0x65,0x2C
	.DB  0x7A,0x3D,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0B
	.DW  _0x31
	.DW  _0x0*2

	.DW  0x19
	.DW  _0x31+11
	.DW  _0x0*2+11

	.DW  0x19
	.DW  _0x31+36
	.DW  _0x0*2+36

	.DW  0x0A
	.DW  _0x31+61
	.DW  _0x0*2+61

	.DW  0x09
	.DW  _0x31+71
	.DW  _0x0*2+71

	.DW  0x19
	.DW  _0x31+80
	.DW  _0x0*2+80

	.DW  0x19
	.DW  _0x31+105
	.DW  _0x0*2+105

	.DW  0x0A
	.DW  _0x31+130
	.DW  _0x0*2+130

	.DW  0x0B
	.DW  _0x31+140
	.DW  _0x0*2+140

	.DW  0x0B
	.DW  _0x31+151
	.DW  _0x0*2+151

	.DW  0x0C
	.DW  _0x31+162
	.DW  _0x0*2+162

	.DW  0x0B
	.DW  _0x31+174
	.DW  _0x0*2+174

	.DW  0x0A
	.DW  _0x31+185
	.DW  _0x0*2+185

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

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

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include <mega32.h>
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
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;#include <delay.h>
;#include <string.h>
;#include <stdlib.h>
;
;#define bt_vcc PORTB.5
;#define bt_en PORTB.6
;#define bt_state PORTB.7
;// Declare your global variables here
;
;unsigned char at_rmaad[8], at_bind_A[26], at_bind_B[26], at_init[11], at_inq[10], at_link_A[26], at_link_B[26], dicson[7 ...
;unsigned char recData[5];        //To declare 8bit character variable
;char i=0, b=0;    //To declare single bit
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;
;void usart_transmit(unsigned char ch )
; 0000 0017 {

	.CSEG
_usart_transmit:
; .FSTART _usart_transmit
; 0000 0018     while ( !( UCSRA & (1<<UDRE)) );
	ST   -Y,R26
;	ch -> Y+0
_0x3:
	SBIS 0xB,5
	RJMP _0x3
; 0000 0019     UDR = ch;
	LD   R30,Y
	OUT  0xC,R30
; 0000 001A }
	JMP  _0x20C0005
; .FEND
;
;interrupt [USART_RXC] void myInterrupt(void)
; 0000 001D {
_myInterrupt:
; .FSTART _myInterrupt
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 001E     recData[i] = getchar();     //Get Character from UDR
	CALL SUBOPT_0x0
	PUSH R31
	PUSH R30
	CALL _getchar
	POP  R26
	POP  R27
	ST   X,R30
; 0000 001F 
; 0000 0020     if(recData[i]=='M')
	CALL SUBOPT_0x0
	LD   R26,Z
	CPI  R26,LOW(0x4D)
	BRNE _0x6
; 0000 0021     {
; 0000 0022         recData[i]=0x00;
	CALL SUBOPT_0x0
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0023         b=1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 0024     }
; 0000 0025 
; 0000 0026     i++;
_0x6:
	INC  R5
; 0000 0027     if(i>=5)
	LDI  R30,LOW(5)
	CP   R5,R30
	BRLO _0x7
; 0000 0028     {
; 0000 0029         i=0;
	CLR  R5
; 0000 002A     }
; 0000 002B }
_0x7:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;void pair_with_bluetooth_A(void)
; 0000 002F {
_pair_with_bluetooth_A:
; .FSTART _pair_with_bluetooth_A
; 0000 0030     int j=0;
; 0000 0031     //UCSRB=(0<<RXCIE)|(0<<RXEN);
; 0000 0032 
; 0000 0033     PORTB.6=0;
	CALL SUBOPT_0x1
;	j -> R16,R17
; 0000 0034     PORTB.5=0;
; 0000 0035     delay_ms(200);
; 0000 0036 
; 0000 0037     PORTB.6=1;
; 0000 0038     delay_ms(100);
; 0000 0039     PORTB.5=1;
; 0000 003A 
; 0000 003B     for (j=0; j<strlen(at_rmaad); j++)
_0x11:
	CALL SUBOPT_0x2
	BRSH _0x12
; 0000 003C     {
; 0000 003D         usart_transmit(at_rmaad[j]);
	CALL SUBOPT_0x3
; 0000 003E     }
	__ADDWRN 16,17,1
	RJMP _0x11
_0x12:
; 0000 003F     delay_ms(1000);
	CALL SUBOPT_0x4
; 0000 0040 
; 0000 0041     for (j=0; j<strlen(at_bind_A); j++)
_0x14:
	LDI  R26,LOW(_at_bind_A)
	LDI  R27,HIGH(_at_bind_A)
	CALL _strlen
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x15
; 0000 0042     {
; 0000 0043         usart_transmit(at_bind_A[j]);
	LDI  R26,LOW(_at_bind_A)
	LDI  R27,HIGH(_at_bind_A)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	RCALL _usart_transmit
; 0000 0044     }
	__ADDWRN 16,17,1
	RJMP _0x14
_0x15:
; 0000 0045     delay_ms(1000);
	RJMP _0x20C0006
; 0000 0046 
; 0000 0047     PORTB.6=0;
; 0000 0048     PORTB.5=0;
; 0000 0049 
; 0000 004A     delay_ms(200);
; 0000 004B     PORTB.5=1;
; 0000 004C }
; .FEND
;
;void pair_with_bluetooth_B(void)
; 0000 004F {
_pair_with_bluetooth_B:
; .FSTART _pair_with_bluetooth_B
; 0000 0050     int j=0;
; 0000 0051 
; 0000 0052     PORTB.6=0;
	CALL SUBOPT_0x1
;	j -> R16,R17
; 0000 0053     PORTB.5=0;
; 0000 0054     delay_ms(200);
; 0000 0055 
; 0000 0056     PORTB.6=1;
; 0000 0057     delay_ms(100);
; 0000 0058     PORTB.5=1;
; 0000 0059 
; 0000 005A 
; 0000 005B     for (j=0; j<strlen(at_rmaad); j++)
_0x25:
	CALL SUBOPT_0x2
	BRSH _0x26
; 0000 005C     {
; 0000 005D         usart_transmit(at_rmaad[j]);
	CALL SUBOPT_0x3
; 0000 005E     }
	__ADDWRN 16,17,1
	RJMP _0x25
_0x26:
; 0000 005F     delay_ms(1000);
	CALL SUBOPT_0x4
; 0000 0060 
; 0000 0061 
; 0000 0062     for (j=0; j<strlen(at_bind_B); j++)
_0x28:
	LDI  R26,LOW(_at_bind_B)
	LDI  R27,HIGH(_at_bind_B)
	CALL _strlen
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x29
; 0000 0063     {
; 0000 0064         usart_transmit(at_bind_B[j]);
	LDI  R26,LOW(_at_bind_B)
	LDI  R27,HIGH(_at_bind_B)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	RCALL _usart_transmit
; 0000 0065     }
	__ADDWRN 16,17,1
	RJMP _0x28
_0x29:
; 0000 0066     delay_ms(1000);
_0x20C0006:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 0067 
; 0000 0068     PORTB.6=0;
	CBI  0x18,6
; 0000 0069     PORTB.5=0;
	CBI  0x18,5
; 0000 006A 
; 0000 006B     delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0000 006C     PORTB.5=1;
	SBI  0x18,5
; 0000 006D }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;void main(void)
; 0000 0070 {
_main:
; .FSTART _main
; 0000 0071 // Declare your local variables here
; 0000 0072 char disp1[16], disp2[16];
; 0000 0073 unsigned char loadA[5], loadB[5];
; 0000 0074 float A=0, B=0, Tot=0;
; 0000 0075 float x=0, y=0, z=0;
; 0000 0076 int clk=0;
; 0000 0077 char coordX[5], coordY[5], coordZ[5], totalLoad[5];
; 0000 0078 // Input/Output Ports initialization
; 0000 0079 DDRA=0xFF;
	SBIW R28,63
	SBIW R28,23
	LDI  R24,24
	LDI  R26,LOW(20)
	LDI  R27,HIGH(20)
	LDI  R30,LOW(_0x30*2)
	LDI  R31,HIGH(_0x30*2)
	CALL __INITLOCB
;	disp1 -> Y+70
;	disp2 -> Y+54
;	loadA -> Y+49
;	loadB -> Y+44
;	A -> Y+40
;	B -> Y+36
;	Tot -> Y+32
;	x -> Y+28
;	y -> Y+24
;	z -> Y+20
;	clk -> R16,R17
;	coordX -> Y+15
;	coordY -> Y+10
;	coordZ -> Y+5
;	totalLoad -> Y+0
	__GETWRN 16,17,0
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 007A 
; 0000 007B // Port B initialization
; 0000 007C // Function: Bit7=In Bit6=Out Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 007D DDRB=(0<<DDB7) | (1<<DDB6) | (1<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(96)
	OUT  0x17,R30
; 0000 007E // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 007F PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0080 
; 0000 0081 
; 0000 0082 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 0083 MCUCSR=0xFF;  //(0<<ISC2);
	LDI  R30,LOW(255)
	OUT  0x34,R30
; 0000 0084 
; 0000 0085 // USART initialization
; 0000 0086 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0087 // USART Receiver: On
; 0000 0088 // USART Transmitter: Off
; 0000 0089 // USART Mode: Asynchronous
; 0000 008A // USART Baud Rate: 9600
; 0000 008B UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 008C UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 008D UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 008E UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 008F UBRRL=0x19;
	LDI  R30,LOW(25)
	OUT  0x9,R30
; 0000 0090 
; 0000 0091 
; 0000 0092 
; 0000 0093 #asm ("sei");
	sei
; 0000 0094 // Alphanumeric LCD initialization
; 0000 0095 // Connections are specified in the
; 0000 0096 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0097 // RS - PORTA Bit 0
; 0000 0098 // RD - PORTA Bit 1
; 0000 0099 // EN - PORTA Bit 2
; 0000 009A // D4 - PORTA Bit 4
; 0000 009B // D5 - PORTA Bit 5
; 0000 009C // D6 - PORTA Bit 6
; 0000 009D // D7 - PORTA Bit 7
; 0000 009E // Characters/line: 16
; 0000 009F lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 00A0 strcpy(at_rmaad, "AT+RMAAD\r\n");
	LDI  R30,LOW(_at_rmaad)
	LDI  R31,HIGH(_at_rmaad)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x31,0
	CALL _strcpy
; 0000 00A1 
; 0000 00A2 strcpy(at_bind_A, "AT+BIND=98D3,A1,F5B548\r\n");
	LDI  R30,LOW(_at_bind_A)
	LDI  R31,HIGH(_at_bind_A)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x31,11
	CALL _strcpy
; 0000 00A3 strcpy(at_bind_B, "AT+BIND=98D3,21,F73B81\r\n");
	LDI  R30,LOW(_at_bind_B)
	LDI  R31,HIGH(_at_bind_B)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x31,36
	CALL _strcpy
; 0000 00A4 
; 0000 00A5 strcpy(at_init, "AT+INIT\r\n");
	LDI  R30,LOW(_at_init)
	LDI  R31,HIGH(_at_init)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x31,61
	CALL _strcpy
; 0000 00A6 strcpy(at_inq, "AT+INQ\r\n");
	LDI  R30,LOW(_at_inq)
	LDI  R31,HIGH(_at_inq)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x31,71
	CALL _strcpy
; 0000 00A7 
; 0000 00A8 strcpy(at_link_A, "AT+LINK=98D3,A1,F5B548\r\n");
	LDI  R30,LOW(_at_link_A)
	LDI  R31,HIGH(_at_link_A)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x31,80
	CALL _strcpy
; 0000 00A9 strcpy(at_link_B, "AT+LINK=98D3,21,F73B81\r\n");
	LDI  R30,LOW(_at_link_B)
	LDI  R31,HIGH(_at_link_B)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x31,105
	CALL _strcpy
; 0000 00AA 
; 0000 00AB strcpy(dicson, "AT+DISC\r\n");
	LDI  R30,LOW(_dicson)
	LDI  R31,HIGH(_dicson)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x31,130
	CALL _strcpy
; 0000 00AC 
; 0000 00AD PORTB.5=1;
	SBI  0x18,5
; 0000 00AE 
; 0000 00AF while (1)
_0x34:
; 0000 00B0       {
; 0000 00B1       // Place your code here
; 0000 00B2 
; 0000 00B3             //Receiving from Bluetooth transmitter A
; 0000 00B4             //coordinate of the loadcell: x=10m, y=5m, z=4m
; 0000 00B5 
; 0000 00B6             pair_with_bluetooth_A();
	RCALL _pair_with_bluetooth_A
; 0000 00B7 
; 0000 00B8             while(PINB.7==0)
_0x37:
	SBIS 0x16,7
; 0000 00B9             {
; 0000 00BA //                lcd_clear();
; 0000 00BB //                lcd_gotoxy(0,0);
; 0000 00BC //                lcd_puts("No B.tooth Con. A");
; 0000 00BD //                delay_ms(3);
; 0000 00BE             }
	RJMP _0x37
; 0000 00BF             delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 00C0 
; 0000 00C1             usart_transmit('U');
	LDI  R26,LOW(85)
	RCALL _usart_transmit
; 0000 00C2             while(b==0 && clk<50)
_0x3A:
	TST  R4
	BRNE _0x3D
	__CPWRN 16,17,50
	BRLT _0x3E
_0x3D:
	RJMP _0x3C
_0x3E:
; 0000 00C3             {
; 0000 00C4                 //recData[0]='\0';
; 0000 00C5                 i=0;
	CLR  R5
; 0000 00C6                 usart_transmit('U');
	LDI  R26,LOW(85)
	CALL SUBOPT_0x5
; 0000 00C7                 delay_ms(100);
; 0000 00C8                 clk++;
; 0000 00C9             }
	RJMP _0x3A
_0x3C:
; 0000 00CA             strcpy(loadA, recData);
	MOVW R30,R28
	ADIW R30,49
	CALL SUBOPT_0x6
; 0000 00CB             clk=0;
; 0000 00CC             //if (b==1)
; 0000 00CD             //{
; 0000 00CE                 //recData[0]='\0';
; 0000 00CF                 b=0;
; 0000 00D0                 i=0;
; 0000 00D1                 //delay_ms(300);
; 0000 00D2 
; 0000 00D3             //}
; 0000 00D4 //            delay_ms(500);
; 0000 00D5 //            usart_transmit('U');
; 0000 00D6 //            while(b==0);
; 0000 00D7 //            if (b==1)
; 0000 00D8 //            {
; 0000 00D9 //                strcpy(loadA, recData);
; 0000 00DA //                b=0;
; 0000 00DB //                i=0;
; 0000 00DC //            }
; 0000 00DD 
; 0000 00DE             //Receiving from Bluetooth transmitter B
; 0000 00DF             //coordinate of the loadcell: x=-8m, y=3m, z=-1m
; 0000 00E0 
; 0000 00E1             pair_with_bluetooth_B();
	RCALL _pair_with_bluetooth_B
; 0000 00E2 
; 0000 00E3             while(PINB.7==0)
_0x3F:
	SBIS 0x16,7
; 0000 00E4             {
; 0000 00E5 //                lcd_clear();
; 0000 00E6 //                lcd_gotoxy(0,0);
; 0000 00E7 //                lcd_puts("No B.tooth Con. B");
; 0000 00E8 //                delay_ms(3);
; 0000 00E9             }
	RJMP _0x3F
; 0000 00EA             delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 00EB 
; 0000 00EC             usart_transmit('V');
	LDI  R26,LOW(86)
	RCALL _usart_transmit
; 0000 00ED             while(b==0 && clk<50)
_0x42:
	TST  R4
	BRNE _0x45
	__CPWRN 16,17,50
	BRLT _0x46
_0x45:
	RJMP _0x44
_0x46:
; 0000 00EE             {
; 0000 00EF                 //recData[0]='\0';
; 0000 00F0                 i=0;
	CLR  R5
; 0000 00F1                 usart_transmit('V');
	LDI  R26,LOW(86)
	CALL SUBOPT_0x5
; 0000 00F2                 delay_ms(100);
; 0000 00F3                 clk++;
; 0000 00F4             }
	RJMP _0x42
_0x44:
; 0000 00F5             strcpy(loadB, recData);
	MOVW R30,R28
	ADIW R30,44
	CALL SUBOPT_0x6
; 0000 00F6             //
; 0000 00F7             clk=0;
; 0000 00F8             //if (b==1)
; 0000 00F9             //{
; 0000 00FA                 //recData[0]='\0';
; 0000 00FB                 b=0;
; 0000 00FC                 i=0;
; 0000 00FD             //    delay_ms(300);
; 0000 00FE             //}
; 0000 00FF //            delay_ms(500);
; 0000 0100 //            usart_transmit('V');
; 0000 0101 //            while(b==0);
; 0000 0102 //            if (b==1)
; 0000 0103 //            {
; 0000 0104 //                strcpy(loadB, recData);
; 0000 0105 //                b=0;
; 0000 0106 //                i=0;
; 0000 0107 //            }
; 0000 0108 
; 0000 0109             A=atof(loadA);
	MOVW R26,R28
	ADIW R26,49
	CALL _atof
	__PUTD1S 40
; 0000 010A             B=atof(loadB);
	MOVW R26,R28
	ADIW R26,44
	CALL _atof
	__PUTD1S 36
; 0000 010B 
; 0000 010C             if(A<100)
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
	BRSH _0x47
; 0000 010D             {
; 0000 010E                 A=0;
	LDI  R30,LOW(0)
	__CLRD1S 40
; 0000 010F             }
; 0000 0110             if(B<100)
_0x47:
	CALL SUBOPT_0x9
	CALL SUBOPT_0x8
	BRSH _0x48
; 0000 0111             {
; 0000 0112                 B=0;
	LDI  R30,LOW(0)
	__CLRD1S 36
; 0000 0113             }
; 0000 0114 
; 0000 0115             A/=1000;
_0x48:
	CALL SUBOPT_0x7
	CALL SUBOPT_0xA
	__PUTD1S 40
; 0000 0116             B/=1000;
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
	__PUTD1S 36
; 0000 0117 
; 0000 0118 //            x=(10*(long)A-8*(long)B)/((long)A+(long)B);
; 0000 0119 //            y=(5*(long)A+3*(long)B)/((long)A+(long)B);
; 0000 011A //            z=(2*(long)A-(long)B)/((long)A+(long)B);
; 0000 011B 
; 0000 011C             x=(10*A-8*B)/(A+B);
	CALL SUBOPT_0xB
	__GETD2N 0x41200000
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC
	__GETD2N 0x41000000
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0xD
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xE
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	__PUTD1S 28
; 0000 011D             y=(5*A+3*B)/(A+B);
	CALL SUBOPT_0xB
	__GETD2N 0x40A00000
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xC
	__GETD2N 0x40400000
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xE
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	__PUTD1S 24
; 0000 011E             z=(4*A-B)/(A+B);
	CALL SUBOPT_0xB
	__GETD2N 0x40800000
	CALL __MULF12
	CALL SUBOPT_0x9
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xE
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	__PUTD1S 20
; 0000 011F             if(A==0 && B==0)
	CALL SUBOPT_0x7
	CALL __CPD02
	BRNE _0x4A
	CALL SUBOPT_0x9
	CALL __CPD02
	BREQ _0x4B
_0x4A:
	RJMP _0x49
_0x4B:
; 0000 0120             {
; 0000 0121                 x=0;
	LDI  R30,LOW(0)
	__CLRD1S 28
; 0000 0122                 y=0;
	__CLRD1S 24
; 0000 0123                 z=0;
	__CLRD1S 20
; 0000 0124             }
; 0000 0125 
; 0000 0126 
; 0000 0127             Tot=A+B;
_0x49:
	CALL SUBOPT_0xE
	__PUTD1S 32
; 0000 0128             if(Tot>5.0)
	__GETD2S 32
	__GETD1N 0x40A00000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x4C
; 0000 0129             {
; 0000 012A                 strcpy(disp1, "OverLD,Kg ");
	CALL SUBOPT_0xF
	__POINTW2MN _0x31,140
	RJMP _0x53
; 0000 012B                 ftoa(Tot,2, totalLoad);
; 0000 012C                 strcat(disp1, totalLoad);
; 0000 012D             }
; 0000 012E             else
_0x4C:
; 0000 012F             {
; 0000 0130                 strcpy(disp1, "SafeLD,Kg ");
	CALL SUBOPT_0xF
	__POINTW2MN _0x31,151
_0x53:
	CALL _strcpy
; 0000 0131                 ftoa(Tot,2, totalLoad);
	__GETD1S 32
	CALL __PUTPARD1
	LDI  R30,LOW(2)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,5
	CALL _ftoa
; 0000 0132                 strcat(disp1, totalLoad);
	CALL SUBOPT_0xF
	MOVW R26,R28
	ADIW R26,2
	CALL _strcat
; 0000 0133             }
; 0000 0134             //Metacenter z-coordinate 3m
; 0000 0135 
; 0000 0136 //            strcpy(disp1, "x=");
; 0000 0137 //            ftoa(x,2, coordX);
; 0000 0138 //            strcat(disp1, coordX);
; 0000 0139 //
; 0000 013A //            strcat(disp1, "  y=");
; 0000 013B //            ftoa(y,2, coordY);
; 0000 013C //            strcat(disp1, coordY);
; 0000 013D 
; 0000 013E             if(z>3.0)
	__GETD2S 20
	__GETD1N 0x40400000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x4E
; 0000 013F             {
; 0000 0140                 strcpy(disp2, "Instable,z=");
	CALL SUBOPT_0x10
	__POINTW2MN _0x31,162
	RJMP _0x54
; 0000 0141                 ftoa(z,3, coordZ);
; 0000 0142                 strcat(disp2, coordZ);
; 0000 0143             }
; 0000 0144             else if(z==3.0)
_0x4E:
	__GETD2S 20
	__CPD2N 0x40400000
	BRNE _0x50
; 0000 0145             {
; 0000 0146                 strcpy(disp2, "Neutral,z=");
	CALL SUBOPT_0x10
	__POINTW2MN _0x31,174
	RJMP _0x54
; 0000 0147                 ftoa(z,3, coordZ);
; 0000 0148                 strcat(disp2, coordZ);
; 0000 0149             }
; 0000 014A             else
_0x50:
; 0000 014B             {
; 0000 014C                 strcpy(disp2, "Stable,z=");
	CALL SUBOPT_0x10
	__POINTW2MN _0x31,185
_0x54:
	CALL _strcpy
; 0000 014D                 ftoa(z,3, coordZ);
	__GETD1S 20
	CALL __PUTPARD1
	LDI  R30,LOW(3)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	CALL _ftoa
; 0000 014E                 strcat(disp2, coordZ);
	CALL SUBOPT_0x10
	MOVW R26,R28
	ADIW R26,7
	CALL _strcat
; 0000 014F             }
; 0000 0150 
; 0000 0151             lcd_clear();
	RCALL _lcd_clear
; 0000 0152             lcd_gotoxy(0, 0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 0153             lcd_puts(disp1);
	MOVW R26,R28
	SUBI R26,LOW(-(70))
	SBCI R27,HIGH(-(70))
	RCALL _lcd_puts
; 0000 0154             lcd_gotoxy(0, 1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _lcd_gotoxy
; 0000 0155             lcd_puts(disp2);
	MOVW R26,R28
	ADIW R26,54
	RCALL _lcd_puts
; 0000 0156             //delay_ms(3000);
; 0000 0157       }
	RJMP _0x34
; 0000 0158 }
_0x52:
	RJMP _0x52
; .FEND

	.DSEG
_0x31:
	.BYTE 0xC3
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
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 27
	SBI  0x1B,2
	__DELAY_USB 27
	CBI  0x1B,2
	__DELAY_USB 27
	RJMP _0x20C0005
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RJMP _0x20C0005
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R7,Y+1
	LDD  R6,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x11
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x11
	LDI  R30,LOW(0)
	MOV  R6,R30
	MOV  R7,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R7,R9
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R6
	MOV  R26,R6
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x20C0005
_0x2000007:
_0x2000004:
	INC  R7
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x20C0005
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LDD  R9,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x12
	CALL SUBOPT_0x12
	CALL SUBOPT_0x12
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 400
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0005:
	ADIW R28,1
	RET
; .FEND

	.CSEG
_strcat:
; .FSTART _strcat
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcat0:
    ld   r22,x+
    tst  r22
    brne strcat0
    sbiw r26,1
strcat1:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcat1
    movw r30,r24
    ret
; .FEND
_strcpy:
; .FSTART _strcpy
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
    movw r30,r24
    ret
; .FEND
_strcpyf:
; .FSTART _strcpyf
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
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
; .FEND

	.CSEG
_ftoa:
; .FSTART _ftoa
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x204000D
	CALL SUBOPT_0x13
	__POINTW2FN _0x2040000,0
	CALL _strcpyf
	RJMP _0x20C0004
_0x204000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x204000C
	CALL SUBOPT_0x13
	__POINTW2FN _0x2040000,1
	CALL _strcpyf
	RJMP _0x20C0004
_0x204000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x204000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	LDI  R30,LOW(45)
	ST   X,R30
_0x204000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2040010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2040010:
	LDD  R17,Y+8
_0x2040011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2040013
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
	RJMP _0x2040011
_0x2040013:
	CALL SUBOPT_0x19
	CALL __ADDF12
	CALL SUBOPT_0x14
	LDI  R17,LOW(0)
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x18
_0x2040014:
	CALL SUBOPT_0x19
	CALL __CMPF12
	BRLO _0x2040016
	CALL SUBOPT_0x16
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x18
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2040017
	CALL SUBOPT_0x13
	__POINTW2FN _0x2040000,5
	CALL _strcpyf
	RJMP _0x20C0004
_0x2040017:
	RJMP _0x2040014
_0x2040016:
	CPI  R17,0
	BRNE _0x2040018
	CALL SUBOPT_0x15
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2040019
_0x2040018:
_0x204001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x204001C
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
	__GETD2N 0x3F000000
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x15
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	CALL SUBOPT_0x16
	CALL SUBOPT_0x1C
	CALL __MULF12
	CALL SUBOPT_0x1D
	CALL SUBOPT_0xD
	CALL SUBOPT_0x14
	RJMP _0x204001A
_0x204001C:
_0x2040019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20C0003
	CALL SUBOPT_0x15
	LDI  R30,LOW(46)
	ST   X,R30
_0x204001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2040020
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x14
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x15
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	LDI  R31,0
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1C
	CALL SUBOPT_0xD
	CALL SUBOPT_0x14
	RJMP _0x204001E
_0x2040020:
_0x20C0003:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0004:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
; .FEND
_atof:
; .FSTART _atof
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,10
	CALL __SAVELOCR6
	LDI  R30,LOW(0)
	__CLRD1S 8
_0x204003C:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R30,X
	MOV  R21,R30
	MOV  R26,R30
	CALL _isspace
	CPI  R30,0
	BREQ _0x204003E
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP _0x204003C
_0x204003E:
	LDI  R30,LOW(0)
	STD  Y+7,R30
	CPI  R21,43
	BREQ _0x204006C
	CPI  R21,45
	BRNE _0x2040041
	LDI  R30,LOW(1)
	STD  Y+7,R30
_0x204006C:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
_0x2040041:
	LDI  R30,LOW(0)
	MOV  R20,R30
	MOV  R21,R30
	__GETWRS 16,17,16
_0x2040042:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R26,X
	CALL _isdigit
	CPI  R30,0
	BRNE _0x2040045
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R26,X
	LDI  R30,LOW(46)
	CALL __EQB12
	MOV  R21,R30
	CPI  R30,0
	BREQ _0x2040044
_0x2040045:
	OR   R20,R21
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP _0x2040042
_0x2040044:
	__GETWRS 18,19,16
	CPI  R20,0
	BREQ _0x2040047
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
_0x2040048:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BREQ _0x204004A
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R30,X
	LDI  R31,0
	SBIW R30,48
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1C
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41200000
	CALL __DIVF21
	CALL SUBOPT_0x1F
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP _0x2040048
_0x204004A:
_0x2040047:
	CALL SUBOPT_0x20
_0x204004B:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	SBIW R26,1
	STD  Y+16,R26
	STD  Y+16+1,R27
	CP   R26,R16
	CPC  R27,R17
	BRLO _0x204004D
	LD   R30,X
	LDI  R31,0
	SBIW R30,48
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1C
	CALL __MULF12
	CALL SUBOPT_0x1E
	CALL __ADDF12
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x22
	RJMP _0x204004B
_0x204004D:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R21,X
	CPI  R21,101
	BREQ _0x204004F
	CPI  R21,69
	BREQ _0x204004F
	RJMP _0x204004E
_0x204004F:
	LDI  R30,LOW(0)
	MOV  R20,R30
	STD  Y+6,R30
	MOVW R26,R18
	LD   R21,X
	CPI  R21,43
	BREQ _0x204006D
	CPI  R21,45
	BRNE _0x2040053
	LDI  R30,LOW(1)
	STD  Y+6,R30
_0x204006D:
	__ADDWRN 18,19,1
_0x2040053:
_0x2040054:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	MOV  R21,R30
	MOV  R26,R30
	CALL _isdigit
	CPI  R30,0
	BREQ _0x2040056
	LDI  R26,LOW(10)
	MULS R20,R26
	MOVW R30,R0
	ADD  R30,R21
	SUBI R30,LOW(48)
	MOV  R20,R30
	RJMP _0x2040054
_0x2040056:
	CPI  R20,39
	BRLO _0x2040057
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x2040058
	__GETD1N 0xFF7FFFFF
	RJMP _0x20C0002
_0x2040058:
	__GETD1N 0x7F7FFFFF
	RJMP _0x20C0002
_0x2040057:
	LDI  R21,LOW(32)
	CALL SUBOPT_0x20
_0x2040059:
	CPI  R21,0
	BREQ _0x204005B
	CALL SUBOPT_0x23
	CALL SUBOPT_0x21
	CALL __MULF12
	CALL SUBOPT_0x22
	MOV  R30,R20
	AND  R30,R21
	BREQ _0x204005C
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x22
_0x204005C:
	LSR  R21
	RJMP _0x2040059
_0x204005B:
	LDD  R30,Y+6
	CPI  R30,0
	BREQ _0x204005D
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1E
	CALL __DIVF21
	RJMP _0x204006E
_0x204005D:
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1E
	CALL __MULF12
_0x204006E:
	__PUTD1S 8
_0x204004E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x204005F
	__GETD1S 8
	CALL __ANEGF1
	CALL SUBOPT_0x1F
_0x204005F:
	__GETD1S 8
_0x20C0002:
	CALL __LOADLOCR6
	ADIW R28,18
	RET
; .FEND

	.DSEG

	.CSEG
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
_getchar:
; .FSTART _getchar
getchar0:
     sbis usr,rxc
     rjmp getchar0
     in   r30,udr
	RET
; .FEND

	.CSEG
_isdigit:
; .FSTART _isdigit
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
; .FEND
_isspace:
; .FSTART _isspace
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL __GETD1S0
	RJMP _0x20C0001
__floor1:
    brtc __floor0
	CALL __GETD1S0
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x20C0001:
	ADIW R28,4
	RET
; .FEND

	.DSEG
_at_rmaad:
	.BYTE 0x8
_at_bind_A:
	.BYTE 0x1A
_at_bind_B:
	.BYTE 0x1A
_at_init:
	.BYTE 0xB
_at_inq:
	.BYTE 0xA
_at_link_A:
	.BYTE 0x1A
_at_link_B:
	.BYTE 0x1A
_dicson:
	.BYTE 0x7
_recData:
	.BYTE 0x5
__base_y_G100:
	.BYTE 0x4
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	MOV  R30,R5
	LDI  R31,0
	SUBI R30,LOW(-_recData)
	SBCI R31,HIGH(-_recData)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1:
	ST   -Y,R17
	ST   -Y,R16
	__GETWRN 16,17,0
	CBI  0x18,6
	CBI  0x18,5
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x18,6
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x18,5
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_at_rmaad)
	LDI  R27,HIGH(_at_rmaad)
	CALL _strlen
	CP   R16,R30
	CPC  R17,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(_at_rmaad)
	LDI  R27,HIGH(_at_rmaad)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	JMP  _usart_transmit

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	CALL _usart_transmit
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
	__ADDWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_recData)
	LDI  R27,HIGH(_recData)
	CALL _strcpy
	__GETWRN 16,17,0
	CLR  R4
	CLR  R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7:
	__GETD2S 40
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	__GETD1N 0x42C80000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	__GETD2S 36
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	__GETD1N 0x447A0000
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	__GETD1S 40
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	__GETD1S 36
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE:
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x7
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	MOVW R30,R28
	SUBI R30,LOW(-(70))
	SBCI R31,HIGH(-(70))
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	MOVW R30,R28
	ADIW R30,54
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x12:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 400
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x15:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x19:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	__GETD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1B:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	__PUTD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	RCALL SUBOPT_0x1A
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	__GETD1S 12
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
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

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
