;Dominik J Pruss

;Lab 1 465 


; Include derivative-specific definitions
            INCLUDE 'derivative.inc'
            

; export symbols
            XDEF CheckPress;
            XREF __SEG_END_SSTACK, Selector, SetupPattern   ; symbol defined by the linker for the end of the stack








MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition
KeyPress:	DS.B 1



MyCode:     SECTION
CheckPress:
	
	
	
	CBEQA #%10000001,SetPatA;
	CBEQA #%01000001,SetPatB;
	CBEQA #%00100001,SetPatA;
	CBEQA #%00010001,SetPatA;
	RTS;

CheckRowA:
	LDA #%11111111
	STA PTBDD; 
	LDA #%01110010
	STA PTBD; writing to 010 for row A 
	NOP
	NOP
	BSET 3, PTBD; pull up the clock;
	NOP
	NOP
	LDA #%000011111
	STA PTBDD;
	LDA #%000000011
	STA PTBD; Reading from PTBD
	
	
	
CheckColumn:
	


SetPatA:
	CLR Selector;
	JSR SetupPattern;
	RTS;
	
SetPatB:
	CLR Selector
	INC Selector;
	JSR SetupPattern;
	RTS
	
SetPatC:
	CLR Selector;
	INC Selector;
	INC Selector;
	JSR SetupPattern;
	RTS
	
SetPatD:
	CLR Selector;
	INC Selector;
	INC Selector;
	INC Selector;
	JSR SetupPattern;
	RTS
GoHome:
	RTS;
