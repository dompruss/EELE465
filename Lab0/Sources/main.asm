;Dominik J Pruss

;Lab 1 465 


; Include derivative-specific definitions
            INCLUDE 'derivative.inc'
            

; export symbols
            XDEF _Startup, main, Vmtim_U, Selector,   
            XREF __SEG_END_SSTACK,SetupPattern, SelectPattern, CheckPress   ; symbol defined by the linker for the end of the stack



MY_ZEROPAGE: SECTION  SHORT         ; Insert here your data definition
Counter1:   DS.B 1
LEDStatus:	DS.B 1
UpdateLEDS:	DS.B 1
Selector:	DS.B 1

MyCode:     SECTION
main:


_Startup:
			CLR Counter1 
			CLR LEDStatus ; clear out all of the stuff
			CLR Selector;
			LDA #70
			STA Counter1 ; counter 1 is stored
			LDA #$53
			STA SOPT1 ; Turning off watchdog	
			
			LDA #%01100000
			STA MTIMSC ; enabling the Modulo Timer
			
			LDA #%00001000
			STA MTIMCLK ; setting up prescaler
			
			LDA #255
			STA MTIMMOD ; set up the MTIMMOD it will be 255
			
			BSET 0, PTADD ; setting led to as output
			BSET 1, PTADD ; setting led to as output
			BSET 2, PTADD ; setting led to as output
			BSET 3, PTADD ; setting led to as output
			BSET 0, PTAD; ; turning off LED
			BSET 1, PTAD; ; turning off LED
			BSET 2, PTAD; ; turning off LED
			BSET 3, PTAD; ; turning off LED
			
			CLI ; enabling interrupts
			
			JSR SetupPattern;
			BRA mainLoop;

mainLoop:
	JSR CheckPress
	LDA Counter1
	BEQ LEDToggle; branch to led toggle if Counter 1 = 0
	LDA UpdateLEDS
	BNE JumpToLEDS;
	BRA    mainLoop				
LEDToggle:
	LDA #70; resetting counter 1 
	STA Counter1;
	INC UpdateLEDS;
	LDA LEDStatus ; load LED status
	BEQ LEDOn ; branch to turn on if 0 (which is off) otherwise fall through to turn off
LEDOff:
	DEC LEDStatus ; set variable to know it's off
	BSET 0, PTAD ; turn led off
	BSET 2, PTAD
	BRA mainLoop
LEDOn:
	BCLR 0, PTAD ; turn on LED
	BCLR 2, PTAD
	INC LEDStatus
	BRA mainLoop

Vmtim_U:		
		BCLR 7, MTIMSC ; clear the TOF 
		DEC Counter1;
		RTI
		
JumpToLEDS:
	JSR SelectPattern;
	CLR UpdateLEDS
	BRA mainLoop;


