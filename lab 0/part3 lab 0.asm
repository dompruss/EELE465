;Dominik J Pruss
;Casey Coffman
;Lab 0 465 


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
			
			BSET 6, PTBDD ; setting led to as output
			BSET 6, PTBD; ; turning off LED
			
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
	BSET 6, PTBD ; turn led off
	BRA mainLoop
	
LEDOn:
	LDA #255
	STA Counter2 ; resetting counter 2
	BCLR 6, PTBD ; turn on LED
	INC LEDStatus
	BRA mainLoop
	
Return:
	DEC Counter2
	BRA mainLoop

Vmtim_U:
		BCLR 7, MTIMSC ; clear the TOF 
		DEC Counter1;
		RTI


