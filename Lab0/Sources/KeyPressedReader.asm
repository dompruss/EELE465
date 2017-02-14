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
	CLR KeyPress
	JSR CheckRowA;
	JSR CheckRowB;
	JSR	CheckRowC;
	JSR CheckRowD;
	
	LDA KeyPress
	BEQ GoHome
	CBEQA #%10001110, SetPatA;
	CBEQA #%10001101, SetPatB;
	CBEQA #%10001011, SetPatC;
	CBEQA #%10000111, SetPatD;
	RTS;
	
	
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



CheckRowD:
	LDA #%11111111
	STA PTBDD; 
	LDA #%01110010
	STA PTBD; writing to 010 for row A 
	NOP
	NOP
	BSET 3, PTBD; pull up the clock;
	NOP
	NOP
	LDA #%00001111
	STA PTBDD;
	LDA #%000000011
	STA PTBD; Reading from PTBD
	NOP
	NOP
	LDA PTBD; read from PTBD;
.	AND #%11110000 ; clear the first half;
	EOR #%11110000 ; EOR the top Row to see if any button is pressed
	BEQ GoHome ; go home
	STA KeyPress;
	LDA #%00000111
	ORA KeyPress;
	STA KeyPress
	RTS
	
GoHome:
	RTS;
	
CheckRowC:
	LDA #%11111111
	STA PTBDD; 
	LDA #%10110010
	STA PTBD; writing to 010 for row A 
	NOP
	NOP
	BSET 3, PTBD; pull up the clock;
	NOP
	NOP
	LDA #%00001111
	STA PTBDD;
	LDA #%000000011
	STA PTBD; Reading from PTBD
	NOP
	NOP
	LDA PTBD; read from PTBD;
	AND #%11110000 ; clear the first half;
	EOR #%11110000 ; EOR the top Row to see if any button is pressed
	BEQ GoHome ; go home
	STA KeyPress;
	LDA #%00001011
	ORA KeyPress;
	STA KeyPress
	RTS
	
	

	
CheckRowB
	LDA #%11111111
	STA PTBDD; 
	LDA #%11010010
	STA PTBD; writing to 010 for row A 
	NOP
	NOP
	BSET 3, PTBD; pull up the clock;
	NOP
	NOP
	LDA #%00001111
	STA PTBDD;
	LDA #%000000011
	STA PTBD; Reading from PTBD
	NOP
	NOP
	LDA PTBD; read from PTBD;
	AND #%11110000 ; clear the first half;
	EOR #%11110000 ; EOR the top Row to see if any button is pressed
	BEQ GoHome ; go home
	STA KeyPress;
	LDA #%00001101
	ORA KeyPress;
	STA KeyPress
	RTS	
	
CheckRowA:
	LDA #%11111111
	STA PTBDD; 
	LDA #%11100010
	STA PTBD; writing to 010 for row A 
	NOP
	NOP
	BSET 3, PTBD; pull up the clock;
	NOP
	NOP
	LDA #%00001111
	STA PTBDD;
	LDA #%000000011
	STA PTBD; Reading from PTBD
	NOP
	NOP
	LDA PTBD; read from PTBD;
	AND #%11110000 ; clear the first half;
	EOR #%11110000 ; EOR the top Row to see if any button is pressed
	BEQ GoHome ; go home
	STA KeyPress;
	LDA #%00001110
	ORA KeyPress;
	STA KeyPress
	RTS
	


