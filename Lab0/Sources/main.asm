;Dominik J Pruss

;Lab 1 465 


; Include derivative-specific definitions
            INCLUDE 'derivative.inc'
            

; export symbols
            XDEF _Startup, main, Vmtim_U
            ; we export both '_Startup' and 'main' as symbols. Either can
            ; be referenced in the linker .prm file or from C/C++ later on
            
            
            
            XREF __SEG_END_SSTACK   ; symbol defined by the linker for the end of the stack

RAMSPACE	EQU $F0		;RAM memory Location
PORTB 		EQU PTBD



	org RAMSPACE ;
Counter1:   DS.B 1
Counter2: 	DS.B 1
Counter3: 	DS.B 1
LEDStatus:	DS.B 1
BUSLINE:    DS.B 1

Design:		DS.B 1
Sequence:	DS.B 1
Shifter:    DS.B 1
Adder:		DS.B 1



main:


_Startup:
			
			CLR Counter1 
			CLR Counter2 ; resetting variables in case of carry over
			CLR Counter3 ; 
			CLR LEDStatus ; clear out all of the stuff
			
			LDA #35
			STA Counter1 ; counter 1 is stored
			
			LDA #%01010010
			STA SOPT1 ; Turning off watchdog	
			
			LDA #%01100000
			STA MTIMSC ; enabling the Modulo Timer
			
			LDA #%00000000
			STA MTIMCLK ; setting up prescaler
			
			LDA #255
			STA MTIMMOD ; set up the MTIMMOD it will be 255
			
			BSET 0, PTADD ; setting led to as output
			BSET 0, PTAD; ; turning off LED
			
			CLI ; enabling interrupts
			
			
			
			

mainLoop:
	LDA Counter1
	BEQ LEDToggle; branch to led toggle if Counter 1 = 0
	BRA    mainLoop

LEDToggle:
	
	LDA #70; resetting counter 1 
	STA Counter1 ; counter 1 is stored
	LDA Counter2
	BNE Return
	LDA LEDStatus ; load LED status
	BEQ LEDOn ; branch to turn on if 0 (which is off)
	; otherwise fall through to turn off
LEDOff:
	LDA #255
	STA Counter2 ; resetting counter 2
	DEC LEDStatus ; set variable to know it's off
	BSET 0, PTAD ; turn led off
	BRA mainLoop
	
LEDOn:
	LDA #255
	STA Counter2 ; resetting counter 2
	BCLR 0, PTAD ; turn on LED
	INC LEDStatus
	BRA mainLoop
	
Return:
	DEC Counter2
	BRA mainLoop

Vmtim_U:
		BCLR 7, MTIMSC ; clear the TOF 
		DEC Counter1;
		RTI
		
		

SetupPattern:
	LDA Selector;
	BEQ SetPatternA;
	DECA
	BEQ SetPatternB;
	DECA
	BEQ SetPatternC;
	BRA SetPatternD

SetPatternA:
	LDA #%01010101;
	STA Pattern;
	BRA mainLoop;
SetPatternB:
	LDA #%01111111;
	STA Pattern;
	BRA mainLoop;
SetPatternC:
	LDA #%000XX000;
	STA Pattern;
	LDA #3;
	STA Shifter;
	BRA mainLoop;
SetPatternD:
	LDA #%00XXXX00;
	STA Pattern;
	LDA #5;
	STA Shifter;
	LDA #3
	STA Adder	
	BRA mainLoop;
	
PatternA:
	;setting the bus as output
	LDA 11111111;
	STA PTBDD;

	;loading pattern and sending it.
	LDA Pattern;
	JSR SendOne;
	LDA Pattern;
	JSR SendTwo;
	RTS;

PatternB:
	;setting the bus as output
	LDA 11111111;
	STA PTBDD;

	;loading pattern and sending it.
	LDA Pattern;
	JSR SendOne;
	
LDA Pattern;
	NSA;
	JSR SendTwo;

	;Rotate Right through Carry#
	ROR Pattern;
	RTS; 





PatternC:
	;setting the bus as output
	LDA 11111111;
	STA PTBDD;

	;loading pattern and sending it.
	LDA Pattern;
	JSR SendOne;

	LDA Pattern;
	NSA;
	JSR SendTwo;
	LDA Shifter;
	BEQ PatternCIn;


PatternCOut:
	DEC Shifter
	LDA Pattern;
	;shift it right once
	LSRA
	AND #%00000111
	;now we should have the right half correct
	STAX;
	LDA Pattern;
	LSLA
	AND #%11100000
	;now we should have the left half correct so we or it with partOne
	ORAX;
	STA Pattern;
	BRA PatternCEnd;


PatternCIn:
	LDA Pattern;
	;shift it Right one
	LDA Pattern;
	;shift it right once
	LSRA
	AND #%01110000
	;now we should have the left half correct
	STAX;
	LDA Pattern;
	LSLA
	AND #%00001110
	;now we should have the right half correct so we or it with the first half (X)
	ORAX;
	STA Pattern;

PatternCEnd:
	DEC sequence;
	BEQ SetupPattern;
	RTS;
	

PatternD:
	;setting the bus as output
	LDA 11111111;
	STA PTBDD;

	;loading pattern and sending it.
	LDA Pattern;
	JSR SendOne;
	
	;Nibble swapping pattern and  sending it on the second half
	LDA Pattern;
	NSA;
	JSR SendTwo;
	;check if we are going in or out
	LDA Shifter;
	BEQ PatternDIn;


PatternDOut:
	DEC Shifter;
	LSR Pattern;
	DEC sequence;
	BRA PatternDEnd;

PatternDIn:
	LSL Pattern;
	;check if we have to add a 1 at the end
	LDA Adder;
	BEQ PatternDEnd;
	INC Pattern;
	DEC Adder;

PatternDEnd:
	DEC sequence;
	BEQ SetupPattern;
	RTS;


	SendOne:
	;Pattern is in A, and we want to send it all out of PTBD
	;so we have to clear the lower ports to send to 138
	AND #%11110000
	;now we have the pattern I want in slots 7->4 so OR with destination 000
	ORA #%00000000
	STA PTBD; 
	RTS;



SendTwo:
	;Pattern is in A, and we want to send it all out of PTBD
	;so we have to clear the lower ports to send to 138
	AND #%11110000
	;now we have the pattern I want in slots 7->4 so OR with destination 001
	ORA #%00000001
	STA PTBD;
	RTS;
	LDA #%00001111 ; setting this up as the 

		
		
		
		


