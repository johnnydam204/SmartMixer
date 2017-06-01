
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega8A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
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

	#pragma AVRPART ADMIN PART_NAME ATmega8A
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
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
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
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
	.DEF _Set_Turn=R5
	.DEF _Turn=R4
	.DEF _Ratio=R7

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
	RJMP _ana_comp_isr
	RJMP 0x00
	RJMP 0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x19

_0x3:
	.DB  0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8
	.DB  0x80,0x90
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0A
	.DW  _DIGIT
	.DW  _0x3*2

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

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : Smart Blender
;Version : 1.0
;Date    : 3/11/2016
;Author  : DTTH
;Company : Newhitek
;Comments:
;
;
;Chip type               : ATmega8A
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
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
;#include <eeprom.h>
;#include <delay.h>
;#include <math.h>
;
;#define     ON              1
;#define     OFF             0
;
;#define     BEEP            PORTD.5
;
;#define     SCLK            PORTD.2
;#define     STR             PORTD.3
;#define     DATA            PORTD.1
;
;#define     UP              PIND.0
;#define     START           PINC.5
;#define     DOWN            PINC.4
;
;#define     MOTOR_SW        PORTB.0
;#define     MOTOR_PUMP      PORTB.2
;#define     MOTOR_BLEND     PORTB.1
;
;#define     LEVEL_CHANNEL           2
;#define     TEMPERATURE_CHANNEL     1
;
;#define     B   3955
;#define     R0  10000
;#define     T0  298.15
;
;void shift_data(unsigned char Data);
;void Display(unsigned char Data);
;unsigned char check_level(void);
;unsigned char read_temperature(void);
;float read_adc(unsigned char adc_input);
;
;// Voltage Reference: AREF pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;
;unsigned char DIGIT[10] = {0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90};

	.DSEG
;
;unsigned char Set_Turn = 0, Turn = 0, Ratio = 25;
;
;eeprom unsigned char Storage_Turn @0x10;
;eeprom unsigned char Storage_Ratio @0x20;
;
;eeprom unsigned char Storage_Turn = 0;
;eeprom unsigned char Storage_Ratio = 25;
;
;float Rth, T;
;
;// Analog Comparator interrupt service routine
;interrupt [ANA_COMP] void ana_comp_isr(void)
; 0000 004C {

	.CSEG
_ana_comp_isr:
; .FSTART _ana_comp_isr
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
; 0000 004D     Turn++;
	INC  R4
; 0000 004E     delay_ms(10);
	RCALL SUBOPT_0x0
; 0000 004F }
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
;unsigned char read_temperature(void)
; 0000 0052 {
_read_temperature:
; .FSTART _read_temperature
; 0000 0053     float templature, volt;
; 0000 0054 
; 0000 0055     volt = read_adc(TEMPERATURE_CHANNEL);
	SBIW R28,8
;	templature -> Y+4
;	volt -> Y+0
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x1
; 0000 0056 
; 0000 0057     Rth = 10000 * 5 / volt - 10000 ;
	RCALL __GETD1S0
	__GETD2N 0x47435000
	RCALL __DIVF21
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
	RCALL __SWAPD12
	RCALL __SUBF12
	STS  _Rth,R30
	STS  _Rth+1,R31
	STS  _Rth+2,R22
	STS  _Rth+3,R23
; 0000 0058 
; 0000 0059     T = B * T0 / (B + T0 * log(Rth / R0));
	LDS  R26,_Rth
	LDS  R27,_Rth+1
	LDS  R24,_Rth+2
	LDS  R25,_Rth+3
	RCALL SUBOPT_0x3
	RCALL __DIVF21
	RCALL SUBOPT_0x2
	RCALL _log
	__GETD2N 0x43951333
	RCALL __MULF12
	__GETD2N 0x45773000
	RCALL __ADDF12
	__GETD2N 0x498FF17A
	RCALL __DIVF21
	STS  _T,R30
	STS  _T+1,R31
	STS  _T+2,R22
	STS  _T+3,R23
; 0000 005A 
; 0000 005B     templature = T - 273.15;
	__GETD2N 0x43889333
	RCALL __SUBF12
	__PUTD1S 4
; 0000 005C 
; 0000 005D     #asm("wdr")
	wdr
; 0000 005E 
; 0000 005F     return((unsigned char)(templature));
	__GETD1S 4
	RCALL __CFD1U
	ADIW R28,8
	RET
; 0000 0060 }
; .FEND
;
;void shift_data(unsigned char Data)
; 0000 0063 {
_shift_data:
; .FSTART _shift_data
; 0000 0064 	unsigned char i;
; 0000 0065 
; 0000 0066 	for(i = 0; i < 8; i++)
	ST   -Y,R26
	ST   -Y,R17
;	Data -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x5:
	CPI  R17,8
	BRSH _0x6
; 0000 0067 	{
; 0000 0068 		if((Data & 0x80) == 0x80)
	LDD  R30,Y+1
	ANDI R30,LOW(0x80)
	CPI  R30,LOW(0x80)
	BRNE _0x7
; 0000 0069 		{
; 0000 006A 			DATA = 1;
	SBI  0x12,1
; 0000 006B 		}
; 0000 006C 		else
	RJMP _0xA
_0x7:
; 0000 006D 		{
; 0000 006E 			DATA = 0;
	CBI  0x12,1
; 0000 006F 		}
_0xA:
; 0000 0070 
; 0000 0071 		SCLK = 0;
	CBI  0x12,2
; 0000 0072 		Data *= 2;
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
; 0000 0073         #asm("wdr")
	wdr
; 0000 0074 		SCLK = 1;
	SBI  0x12,2
; 0000 0075 	}
	SUBI R17,-1
	RJMP _0x5
_0x6:
; 0000 0076 
; 0000 0077 	SCLK = 0;
	CBI  0x12,2
; 0000 0078 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
; .FEND
;
;void Display(unsigned char Data)
; 0000 007B {
_Display:
; .FSTART _Display
; 0000 007C     shift_data(DIGIT[Data % 10]);
	ST   -Y,R26
;	Data -> Y+0
	LD   R26,Y
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	RCALL SUBOPT_0x4
; 0000 007D     shift_data(DIGIT[Data / 10]);
	LD   R26,Y
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	RCALL SUBOPT_0x4
; 0000 007E 
; 0000 007F     #asm("wdr")
	wdr
; 0000 0080 
; 0000 0081 	STR = 1;
	SBI  0x12,3
; 0000 0082 	delay_ms(1);
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x5
; 0000 0083 	STR = 0;
	CBI  0x12,3
; 0000 0084 }
	ADIW R28,1
	RET
; .FEND
;
;float read_adc(unsigned char adc_input)
; 0000 0087 {
_read_adc:
; .FSTART _read_adc
; 0000 0088     unsigned long int value = 0;
; 0000 0089     int i;
; 0000 008A     float volt;
; 0000 008B 
; 0000 008C     ADMUX = adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
	SBIW R28,8
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+5,R30
	STD  Y+6,R30
	STD  Y+7,R30
	RCALL __SAVELOCR2
;	adc_input -> Y+10
;	value -> Y+6
;	i -> R16,R17
;	volt -> Y+2
	LDD  R30,Y+10
	OUT  0x7,R30
; 0000 008D 
; 0000 008E     delay_us(10);
	__DELAY_USB 27
; 0000 008F 
; 0000 0090     for(i = 0; i < 200; i++)
	__GETWRN 16,17,0
_0x18:
	__CPWRN 16,17,200
	BRGE _0x19
; 0000 0091     {
; 0000 0092         // Start the AD conversion
; 0000 0093         ADCSRA |= (1 << ADSC);
	SBI  0x6,6
; 0000 0094         // Wait for the AD conversion to complete
; 0000 0095         while ((ADCSRA & (1 << ADIF)) == 0)
_0x1A:
	SBIC 0x6,4
	RJMP _0x1C
; 0000 0096         {
; 0000 0097             #asm("wdr")
	wdr
; 0000 0098         }
	RJMP _0x1A
_0x1C:
; 0000 0099 
; 0000 009A         ADCSRA |= (1 << ADIF);
	SBI  0x6,4
; 0000 009B 
; 0000 009C         value += ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	RCALL SUBOPT_0x6
	CLR  R22
	CLR  R23
	RCALL __ADDD12
	RCALL SUBOPT_0x7
; 0000 009D     }
	__ADDWRN 16,17,1
	RJMP _0x18
_0x19:
; 0000 009E     volt = (float)(value) / 200;
	RCALL SUBOPT_0x8
	RCALL __CDF1U
	RCALL SUBOPT_0x2
	__GETD1N 0x43480000
	RCALL __DIVF21
	RCALL SUBOPT_0x9
; 0000 009F     return (volt * 5 / 1024);
	__GETD2S 2
	__GETD1N 0x40A00000
	RCALL __MULF12
	RCALL SUBOPT_0x2
	__GETD1N 0x44800000
	RCALL __DIVF21
	RCALL __LOADLOCR2
	ADIW R28,11
	RET
; 0000 00A0 }
; .FEND
;
;void Setting(void)
; 0000 00A3 {
_Setting:
; .FSTART _Setting
; 0000 00A4     // Declare your local variables here
; 0000 00A5     OSCCAL = 0x9D;
	LDI  R30,LOW(157)
	OUT  0x31,R30
; 0000 00A6     // Input/Output Ports initialization
; 0000 00A7     // Port B initialization
; 0000 00A8     // Function: Bit7=In Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 00A9     DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(63)
	OUT  0x17,R30
; 0000 00AA     // State: Bit7=T Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 00AB     PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00AC 
; 0000 00AD     // Port C initialization
; 0000 00AE     // Function: Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=In Bit1=In Bit0=In
; 0000 00AF     DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (1<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(8)
	OUT  0x14,R30
; 0000 00B0     // State: Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=T Bit1=T Bit0=T
; 0000 00B1     PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00B2 
; 0000 00B3     // Port D initialization
; 0000 00B4     // Function: Bit7=In Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=In
; 0000 00B5     DDRD=(0<<DDD7) | (0<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(62)
	OUT  0x11,R30
; 0000 00B6     // State: Bit7=T Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=T
; 0000 00B7     PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00B8 
; 0000 00B9     // Timer/Counter 0 initialization
; 0000 00BA     // Clock source: System Clock
; 0000 00BB     // Clock value: Timer 0 Stopped
; 0000 00BC     TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 00BD     TCNT0=0x00;
	OUT  0x32,R30
; 0000 00BE 
; 0000 00BF     // Timer/Counter 1 initialization
; 0000 00C0     // Clock source: System Clock
; 0000 00C1     // Clock value: Timer1 Stopped
; 0000 00C2     // Mode: Normal top=0xFFFF
; 0000 00C3     // OC1A output: Disconnected
; 0000 00C4     // OC1B output: Disconnected
; 0000 00C5     // Noise Canceler: Off
; 0000 00C6     // Input Capture on Falling Edge
; 0000 00C7     // Timer1 Overflow Interrupt: Off
; 0000 00C8     // Input Capture Interrupt: Off
; 0000 00C9     // Compare A Match Interrupt: Off
; 0000 00CA     // Compare B Match Interrupt: Off
; 0000 00CB     TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 00CC     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 00CD     TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00CE     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00CF     ICR1H=0x00;
	OUT  0x27,R30
; 0000 00D0     ICR1L=0x00;
	OUT  0x26,R30
; 0000 00D1     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00D2     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00D3     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00D4     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00D5 
; 0000 00D6     // Timer/Counter 2 initialization
; 0000 00D7     // Clock source: System Clock
; 0000 00D8     // Clock value: Timer2 Stopped
; 0000 00D9     // Mode: Normal top=0xFF
; 0000 00DA     // OC2 output: Disconnected
; 0000 00DB     ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00DC     TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00DD     TCNT2=0x00;
	OUT  0x24,R30
; 0000 00DE     OCR2=0x00;
	OUT  0x23,R30
; 0000 00DF 
; 0000 00E0     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00E1     TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 00E2 
; 0000 00E3     // External Interrupt(s) initialization
; 0000 00E4     // INT0: Off
; 0000 00E5     // INT1: Off
; 0000 00E6     MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 00E7 
; 0000 00E8     // USART initialization
; 0000 00E9     // USART disabled
; 0000 00EA     UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 00EB 
; 0000 00EC 
; 0000 00ED     // Analog Comparator initialization
; 0000 00EE     // Analog Comparator: On
; 0000 00EF     // The Analog Comparator's positive input is
; 0000 00F0     // connected to the AIN0 pin
; 0000 00F1     // The Analog Comparator's negative input is
; 0000 00F2     // connected to the AIN1 pin
; 0000 00F3     // Interrupt on Rising Output Edge
; 0000 00F4     // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00F5     ACSR=(0<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (1<<ACIE) | (0<<ACIC) | (1<<ACIS1) | (1<<ACIS0);
	LDI  R30,LOW(11)
	OUT  0x8,R30
; 0000 00F6     SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00F7 
; 0000 00F8     // ADC initialization
; 0000 00F9     // ADC Clock frequency: 500.000 kHz
; 0000 00FA     // ADC Voltage Reference: AREF pin
; 0000 00FB     ADMUX=ADC_VREF_TYPE;
	OUT  0x7,R30
; 0000 00FC     ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 00FD     SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00FE 
; 0000 00FF     // SPI initialization
; 0000 0100     // SPI disabled
; 0000 0101     SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0102 
; 0000 0103     // TWI initialization
; 0000 0104     // TWI disabled
; 0000 0105     TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0106 
; 0000 0107     // Watchdog Timer initialization
; 0000 0108     // Watchdog Timer Prescaler: OSC/1024k
; 0000 0109     #pragma optsize-
; 0000 010A     WDTCR=(1<<WDCE) | (1<<WDE) | (1<<WDP2) | (1<<WDP1) | (0<<WDP0);
	LDI  R30,LOW(30)
	OUT  0x21,R30
; 0000 010B     WDTCR=(0<<WDCE) | (1<<WDE) | (1<<WDP2) | (1<<WDP1) | (0<<WDP0);
	LDI  R30,LOW(14)
	OUT  0x21,R30
; 0000 010C     #ifdef _OPTIMIZE_SIZE_
; 0000 010D     #pragma optsize+
; 0000 010E     #endif
; 0000 010F 
; 0000 0110     // Global enable interrupts
; 0000 0111     #asm("sei")
	sei
; 0000 0112 
; 0000 0113     BEEP = ON;
	RCALL SUBOPT_0xA
; 0000 0114     delay_ms(50);
; 0000 0115     BEEP = OFF;
	RCALL SUBOPT_0xB
; 0000 0116     delay_ms(200);
; 0000 0117     BEEP = ON;
	RCALL SUBOPT_0xA
; 0000 0118     delay_ms(50);
; 0000 0119     BEEP = OFF;
	CBI  0x12,5
; 0000 011A 
; 0000 011B     #asm("wdr")
	wdr
; 0000 011C 
; 0000 011D     Set_Turn = Storage_Turn;
	LDI  R26,LOW(_Storage_Turn)
	LDI  R27,HIGH(_Storage_Turn)
	RCALL __EEPROMRDB
	MOV  R5,R30
; 0000 011E 
; 0000 011F     Ratio =  Storage_Ratio;
	LDI  R26,LOW(_Storage_Ratio)
	LDI  R27,HIGH(_Storage_Ratio)
	RCALL __EEPROMRDB
	MOV  R7,R30
; 0000 0120 
; 0000 0121 }
	RET
; .FEND
;
;unsigned char check_level(void)
; 0000 0124 {
_check_level:
; .FSTART _check_level
; 0000 0125     float level;
; 0000 0126     level = read_adc(LEVEL_CHANNEL);
	SBIW R28,4
;	level -> Y+0
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x1
; 0000 0127 
; 0000 0128     if(level < 4.5)
	RCALL __GETD2S0
	__GETD1N 0x40900000
	RCALL __CMPF12
	BRSH _0x25
; 0000 0129     {
; 0000 012A         return(1);
	LDI  R30,LOW(1)
	RJMP _0x20A0002
; 0000 012B     }
; 0000 012C     else
_0x25:
; 0000 012D     {
; 0000 012E         return(0);
	LDI  R30,LOW(0)
; 0000 012F     }
; 0000 0130 }
_0x20A0002:
	ADIW R28,4
	RET
; .FEND
;
;void main(void)
; 0000 0133 {
_main:
; .FSTART _main
; 0000 0134     unsigned char count = 0, pump_manual = 0;
; 0000 0135     unsigned int i, amount_delay;
; 0000 0136     unsigned char level;
; 0000 0137     unsigned char temperature;
; 0000 0138 
; 0000 0139     Setting();
	SBIW R28,2
;	count -> R17
;	pump_manual -> R16
;	i -> R18,R19
;	amount_delay -> R20,R21
;	level -> Y+1
;	temperature -> Y+0
	LDI  R17,0
	LDI  R16,0
	RCALL _Setting
; 0000 013A /*
; 0000 013B     while(1)
; 0000 013C     {
; 0000 013D         temperature = read_temperature();
; 0000 013E         Display(temperature);
; 0000 013F         delay_ms(200);
; 0000 0140     }
; 0000 0141 */
; 0000 0142     while (1)
_0x27:
; 0000 0143     {
; 0000 0144         Begin:
_0x2A:
; 0000 0145 
; 0000 0146         Display(Set_Turn);
	MOV  R26,R5
	RCALL _Display
; 0000 0147 
; 0000 0148         count = 0;
	LDI  R17,LOW(0)
; 0000 0149 
; 0000 014A         #asm("wdr")
	wdr
; 0000 014B 
; 0000 014C         if(!UP)
	SBIC 0x10,0
	RJMP _0x2B
; 0000 014D         {
; 0000 014E             BEEP = ON;
	RCALL SUBOPT_0xA
; 0000 014F             delay_ms(50);
; 0000 0150 
; 0000 0151             while(!UP)
_0x2E:
	SBIC 0x10,0
	RJMP _0x30
; 0000 0152             {
; 0000 0153                 #asm("wdr")
	wdr
; 0000 0154             }
	RJMP _0x2E
_0x30:
; 0000 0155 
; 0000 0156             BEEP = OFF;
	CBI  0x12,5
; 0000 0157 
; 0000 0158             if(pump_manual == 0)
	CPI  R16,0
	BRNE _0x33
; 0000 0159             {
; 0000 015A                 if((Set_Turn * Ratio) < 300)
	RCALL SUBOPT_0xC
	BRGE _0x34
; 0000 015B                 {
; 0000 015C                     Set_Turn++;
	INC  R5
; 0000 015D                     Storage_Turn = Set_Turn;
	RCALL SUBOPT_0xD
; 0000 015E                 }
; 0000 015F             }
_0x34:
; 0000 0160         }
_0x33:
; 0000 0161         if(!DOWN)
_0x2B:
	SBIC 0x13,4
	RJMP _0x35
; 0000 0162         {
; 0000 0163             BEEP = ON;
	RCALL SUBOPT_0xA
; 0000 0164             delay_ms(50);
; 0000 0165             BEEP = OFF;
	CBI  0x12,5
; 0000 0166 
; 0000 0167             while(!DOWN)
_0x3A:
	SBIC 0x13,4
	RJMP _0x3C
; 0000 0168             {
; 0000 0169                 #asm("wdr")
	wdr
; 0000 016A                 delay_ms(10);
	RCALL SUBOPT_0x0
; 0000 016B                 count++;
	SUBI R17,-1
; 0000 016C                 if(count > 100)
	CPI  R17,101
	BRLO _0x3D
; 0000 016D                 {
; 0000 016E                     count = 0;
	LDI  R17,LOW(0)
; 0000 016F                     MOTOR_PUMP = ON;
	SBI  0x18,2
; 0000 0170                     while(!DOWN)
_0x40:
	SBIC 0x13,4
	RJMP _0x42
; 0000 0171                     {
; 0000 0172                         #asm("wdr")
	wdr
; 0000 0173                     }
	RJMP _0x40
_0x42:
; 0000 0174                     MOTOR_PUMP = OFF;
	CBI  0x18,2
; 0000 0175                     pump_manual = 1;
	LDI  R16,LOW(1)
; 0000 0176                 }
; 0000 0177             }
_0x3D:
	RJMP _0x3A
_0x3C:
; 0000 0178 
; 0000 0179             if(pump_manual == 0)
	CPI  R16,0
	BRNE _0x45
; 0000 017A             {
; 0000 017B                 if(Set_Turn >= 1)
	LDI  R30,LOW(1)
	CP   R5,R30
	BRLO _0x46
; 0000 017C                 {
; 0000 017D                     Set_Turn--;
	DEC  R5
; 0000 017E                 }
; 0000 017F                 if(Set_Turn == 0) Set_Turn = 99;
_0x46:
	TST  R5
	BRNE _0x47
	LDI  R30,LOW(99)
	MOV  R5,R30
; 0000 0180 
; 0000 0181                 Storage_Turn = Set_Turn;
_0x47:
	RCALL SUBOPT_0xD
; 0000 0182             }
; 0000 0183 
; 0000 0184         }
_0x45:
; 0000 0185 
; 0000 0186         if(!START)
_0x35:
	SBIC 0x13,5
	RJMP _0x48
; 0000 0187         {
; 0000 0188             BEEP = ON;
	RCALL SUBOPT_0xA
; 0000 0189             delay_ms(50);
; 0000 018A             BEEP = OFF;
	CBI  0x12,5
; 0000 018B             #asm("wdr")
	wdr
; 0000 018C             while(!START)
_0x4D:
	SBIC 0x13,5
	RJMP _0x4F
; 0000 018D             {
; 0000 018E                 delay_ms(10);
	RCALL SUBOPT_0x0
; 0000 018F                 count++;
	SUBI R17,-1
; 0000 0190                 if(count > 100)
	CPI  R17,101
	BRLO _0x50
; 0000 0191                 {
; 0000 0192                     count = 0;
	LDI  R17,LOW(0)
; 0000 0193 
; 0000 0194                     BEEP = ON;
	RCALL SUBOPT_0xA
; 0000 0195                     delay_ms(50);
; 0000 0196                     BEEP = OFF;
	CBI  0x12,5
; 0000 0197 
; 0000 0198                     while(!START)
_0x55:
	SBIC 0x13,5
	RJMP _0x57
; 0000 0199                     {
; 0000 019A                         #asm("wdr")
	wdr
; 0000 019B                     }
	RJMP _0x55
_0x57:
; 0000 019C                     delay_ms(500);
	RCALL SUBOPT_0xE
; 0000 019D 
; 0000 019E                     while(1)
_0x58:
; 0000 019F                     {
; 0000 01A0                         Display(Ratio);
	MOV  R26,R7
	RCALL _Display
; 0000 01A1                         #asm("wdr")
	wdr
; 0000 01A2                         if(!UP)
	SBIC 0x10,0
	RJMP _0x5B
; 0000 01A3                         {
; 0000 01A4                             BEEP = ON;
	RCALL SUBOPT_0xA
; 0000 01A5                             delay_ms(50);
; 0000 01A6                             while(!UP)
_0x5E:
	SBIC 0x10,0
	RJMP _0x60
; 0000 01A7                             {
; 0000 01A8                                 #asm("wdr")
	wdr
; 0000 01A9                             }
	RJMP _0x5E
_0x60:
; 0000 01AA                             BEEP = OFF;
	CBI  0x12,5
; 0000 01AB 
; 0000 01AC                             if((Set_Turn * Ratio) < 300)
	RCALL SUBOPT_0xC
	BRGE _0x63
; 0000 01AD                             {
; 0000 01AE                                 Ratio++;
	INC  R7
; 0000 01AF                                 Storage_Ratio = Ratio;
	RCALL SUBOPT_0xF
; 0000 01B0                             }
; 0000 01B1 
; 0000 01B2                         }
_0x63:
; 0000 01B3                         if(!DOWN)
_0x5B:
	SBIC 0x13,4
	RJMP _0x64
; 0000 01B4                         {
; 0000 01B5                             BEEP = ON;
	RCALL SUBOPT_0xA
; 0000 01B6                             delay_ms(50);
; 0000 01B7                             while(!DOWN)
_0x67:
	SBIC 0x13,4
	RJMP _0x69
; 0000 01B8                             {
; 0000 01B9                                 #asm("wdr")
	wdr
; 0000 01BA                             }
	RJMP _0x67
_0x69:
; 0000 01BB                             BEEP = OFF;
	CBI  0x12,5
; 0000 01BC 
; 0000 01BD                             if(Ratio > 2)
	LDI  R30,LOW(2)
	CP   R30,R7
	BRSH _0x6C
; 0000 01BE                             {
; 0000 01BF                                 Ratio--;
	DEC  R7
; 0000 01C0                                 Storage_Ratio = Ratio;
	RCALL SUBOPT_0xF
; 0000 01C1                             }
; 0000 01C2 
; 0000 01C3                         }
_0x6C:
; 0000 01C4                         if(!START)
_0x64:
	SBIC 0x13,5
	RJMP _0x6D
; 0000 01C5                         {
; 0000 01C6                             BEEP = ON;
	RCALL SUBOPT_0xA
; 0000 01C7                             delay_ms(50);
; 0000 01C8                             while(!START)
_0x70:
	SBIC 0x13,5
	RJMP _0x72
; 0000 01C9                             {
; 0000 01CA                                 #asm("wdr")
	wdr
; 0000 01CB                             }
	RJMP _0x70
_0x72:
; 0000 01CC                             BEEP = OFF;
	CBI  0x12,5
; 0000 01CD 
; 0000 01CE                             goto Begin;
	RJMP _0x2A
; 0000 01CF                         }
; 0000 01D0                         delay_ms(100);
_0x6D:
	LDI  R26,LOW(100)
	RCALL SUBOPT_0x5
; 0000 01D1                     }
	RJMP _0x58
; 0000 01D2 
; 0000 01D3                 }
; 0000 01D4             }
_0x50:
	RJMP _0x4D
_0x4F:
; 0000 01D5 
; 0000 01D6             level = check_level();
	RCALL _check_level
	STD  Y+1,R30
; 0000 01D7 
; 0000 01D8             temperature = read_temperature();
	RCALL _read_temperature
	ST   Y,R30
; 0000 01D9 
; 0000 01DA             Display(temperature);
	LD   R26,Y
	RCALL _Display
; 0000 01DB 
; 0000 01DC             #asm("wdr")
	wdr
; 0000 01DD 
; 0000 01DE             delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _delay_ms
; 0000 01DF 
; 0000 01E0             if((level == 0) || (temperature > 50) || (temperature < 40))
	LDD  R26,Y+1
	CPI  R26,LOW(0x0)
	BREQ _0x76
	LD   R26,Y
	CPI  R26,LOW(0x33)
	BRSH _0x76
	CPI  R26,LOW(0x28)
	BRSH _0x75
_0x76:
; 0000 01E1             {
; 0000 01E2                 BEEP = ON;
	RCALL SUBOPT_0xA
; 0000 01E3                 delay_ms(50);
; 0000 01E4                 BEEP = OFF;
	RCALL SUBOPT_0xB
; 0000 01E5                 delay_ms(200);
; 0000 01E6                 BEEP = ON;
	RCALL SUBOPT_0xA
; 0000 01E7                 delay_ms(50);
; 0000 01E8                 BEEP = OFF;
	RCALL SUBOPT_0xB
; 0000 01E9                 delay_ms(200);
; 0000 01EA                 BEEP = ON;
	RCALL SUBOPT_0xA
; 0000 01EB                 delay_ms(50);
; 0000 01EC                 BEEP = OFF;
	CBI  0x12,5
; 0000 01ED 
; 0000 01EE                 goto Begin;
	RJMP _0x2A
; 0000 01EF             }
; 0000 01F0 
; 0000 01F1             MOTOR_SW = ON;
_0x75:
	SBI  0x18,0
; 0000 01F2             delay_ms(500);
	RCALL SUBOPT_0xE
; 0000 01F3 
; 0000 01F4             while(Turn < Set_Turn)
_0x86:
	CP   R4,R5
	BRSH _0x88
; 0000 01F5             {
; 0000 01F6                 #asm("wdr")
	wdr
; 0000 01F7                 Display(Turn);
	MOV  R26,R4
	RCALL _Display
; 0000 01F8                 delay_ms(50);
	LDI  R26,LOW(50)
	RCALL SUBOPT_0x5
; 0000 01F9             }
	RJMP _0x86
_0x88:
; 0000 01FA 
; 0000 01FB             Turn = 0;
	CLR  R4
; 0000 01FC 
; 0000 01FD             MOTOR_SW = OFF;
	CBI  0x18,0
; 0000 01FE             delay_ms(500);
	RCALL SUBOPT_0xE
; 0000 01FF 
; 0000 0200             if(pump_manual == 0)
	CPI  R16,0
	BRNE _0x8B
; 0000 0201             {
; 0000 0202                 MOTOR_PUMP = ON;
	SBI  0x18,2
; 0000 0203 
; 0000 0204                 amount_delay = (unsigned int)(Set_Turn * Ratio / 25);
	MOV  R26,R5
	CLR  R27
	MOV  R30,R7
	LDI  R31,0
	RCALL __MULW12
	MOVW R26,R30
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	RCALL __DIVW21
	MOVW R20,R30
; 0000 0205 
; 0000 0206                 for(i = 0; i < amount_delay ; i++)
	__GETWRN 18,19,0
_0x8F:
	__CPWRR 18,19,20,21
	BRSH _0x90
; 0000 0207                 {
; 0000 0208                     delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0209                     #asm("wdr")
	wdr
; 0000 020A                 }
	__ADDWRN 18,19,1
	RJMP _0x8F
_0x90:
; 0000 020B 
; 0000 020C                 MOTOR_PUMP = OFF;
	CBI  0x18,2
; 0000 020D             }
; 0000 020E 
; 0000 020F             MOTOR_BLEND = ON;
_0x8B:
	SBI  0x18,1
; 0000 0210 
; 0000 0211             Display(Set_Turn);
	MOV  R26,R5
	RCALL _Display
; 0000 0212 
; 0000 0213             for(i = 0; i < 10 ; i++)
	__GETWRN 18,19,0
_0x96:
	__CPWRN 18,19,10
	BRSH _0x97
; 0000 0214             {
; 0000 0215                 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0216                 #asm("wdr")
	wdr
; 0000 0217             }
	__ADDWRN 18,19,1
	RJMP _0x96
_0x97:
; 0000 0218 
; 0000 0219             MOTOR_BLEND = OFF;
	CBI  0x18,1
; 0000 021A 
; 0000 021B             pump_manual = 0;
	LDI  R16,LOW(0)
; 0000 021C         }
; 0000 021D 
; 0000 021E         #asm("wdr")
_0x48:
	wdr
; 0000 021F 
; 0000 0220         delay_ms(100);
	LDI  R26,LOW(100)
	RCALL SUBOPT_0x5
; 0000 0221     }
	RJMP _0x27
; 0000 0222 }
_0x9A:
	RJMP _0x9A
; .FEND

	.CSEG

	.CSEG
_log:
; .FSTART _log
	RCALL __PUTPARD2
	SBIW R28,4
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x6
	RCALL __CPD02
	BRLT _0x202000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x20A0001
_0x202000C:
	RCALL SUBOPT_0x8
	RCALL __PUTPARD1
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R17
	PUSH R16
	RCALL _frexp
	POP  R16
	POP  R17
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x6
	__GETD1N 0x3F3504F3
	RCALL __CMPF12
	BRSH _0x202000D
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x6
	RCALL __ADDF12
	RCALL SUBOPT_0x7
	__SUBWRN 16,17,1
_0x202000D:
	RCALL SUBOPT_0x10
	RCALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x10
	RCALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x6
	RCALL __MULF12
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x11
	__GETD2N 0x3F654226
	RCALL __MULF12
	RCALL SUBOPT_0x2
	__GETD1N 0x4054114E
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x6
	RCALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x11
	__GETD2N 0x3FD4114D
	RCALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R16
	RCALL __CWD1
	RCALL __CDF1
	__GETD2N 0x3F317218
	RCALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
_0x20A0001:
	RCALL __LOADLOCR2
	ADIW R28,10
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_DIGIT:
	.BYTE 0xA

	.ESEG

	.ORG 0x10
_Storage_Turn:
	.DB  0x0

	.ORG 0x0

	.ORG 0x20
_Storage_Ratio:
	.DB  0x19

	.ORG 0x0

	.DSEG
_Rth:
	.BYTE 0x4
_T:
	.BYTE 0x4
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(10)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	RCALL _read_adc
	RCALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	__GETD1N 0x461C4000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	SUBI R30,LOW(-_DIGIT)
	SBCI R31,HIGH(-_DIGIT)
	LD   R26,Z
	RJMP _shift_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x5:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x8:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:20 WORDS
SUBOPT_0xA:
	SBI  0x12,5
	LDI  R26,LOW(50)
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	CBI  0x12,5
	LDI  R26,LOW(200)
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	MOV  R26,R5
	CLR  R27
	MOV  R30,R7
	LDI  R31,0
	RCALL __MULW12
	CPI  R30,LOW(0x12C)
	LDI  R26,HIGH(0x12C)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	MOV  R30,R5
	LDI  R26,LOW(_Storage_Turn)
	LDI  R27,HIGH(_Storage_Turn)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	MOV  R30,R7
	LDI  R26,LOW(_Storage_Ratio)
	LDI  R27,HIGH(_Storage_Ratio)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	RCALL SUBOPT_0x8
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	__GETD1S 2
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

_frexp:
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	CLR  R24
	SUBI R23,0x7E
	SBC  R24,R24
	ST   X+,R23
	ST   X,R24
	LDI  R23,0x7E
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

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

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

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

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
