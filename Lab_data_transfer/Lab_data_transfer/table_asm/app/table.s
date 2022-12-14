; ------------------------------------------------------------------
; --  _____       ______  _____                                    -
; -- |_   _|     |  ____|/ ____|                                   -
; --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
; --   | | | '_ \|  __|  \___ \   Zurich University of             -
; --  _| |_| | | | |____ ____) |  Applied Sciences                 -
; -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
; ------------------------------------------------------------------
; --
; -- table.s
; --
; -- CT1 P04 Ein- und Ausgabe von Tabellenwerten
; --
; -- $Id: table.s 800 2014-10-06 13:19:25Z ruan $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB
; ------------------------------------------------------------------
; -- Symbolic Literals
; ------------------------------------------------------------------
ADDR_DIP_SWITCH_7_0         EQU     0x60000200
ADDR_DIP_SWITCH_15_8        EQU     0x60000201
ADDR_DIP_SWITCH_31_24       EQU     0x60000203
ADDR_LED_7_0                EQU     0x60000100
ADDR_LED_15_8               EQU     0x60000101
ADDR_LED_23_16              EQU     0x60000102
ADDR_LED_31_24              EQU     0x60000103
ADDR_BUTTONS                EQU     0x60000210

BITMASK_KEY_T0              EQU     0x01
BITMASK_LOWER_NIBBLE        EQU     0x0F

; ------------------------------------------------------------------
; -- Variables
; ------------------------------------------------------------------
        AREA MyAsmVar, DATA, READWRITE
; STUDENTS: To be programmed
		; Task 3.3
data_table SPACE 16



; END: To be programmed
        ALIGN

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY

main    PROC
        EXPORT main

readInput
        BL    waitForKey                    ; wait for key to be pressed and released
; STUDENTS: To be programmed	3.2
		LDR	 R0,=BITMASK_LOWER_NIBBLE
		
		LDR  R1,=ADDR_DIP_SWITCH_15_8
		LDR  R4,=ADDR_LED_15_8
		
		LDR	 R2,=ADDR_DIP_SWITCH_7_0 
		LDR  R3,=ADDR_LED_7_0

		LDR  R5,[R2]                       ; Read value Dip Switch 0-7 into R5
		STR	 R5,[R3]					   ; Write value Dipt switch 0-7 into LED 0-7
		
		LDR  R6,[R1]                       ; Read value Dip Switch 8-15 into R6
		ands R6,R0,R6					   ; Bitmask of Dipswitch for 8-11
		STR	 R6,[R4]					   ; Write value Dipt switch 8-15 into LED 8-15
		;Task 3.3
		LDR	 R7,=data_table
		STRB R5,[R7,R6]					   ;Dipswitch 0-7 in table with offset dipswitch value 8-11	
		
		;3.4
		LDR R0,=ADDR_DIP_SWITCH_31_24
		LDR R1,=ADDR_LED_31_24
		LDR R3,=BITMASK_LOWER_NIBBLE
		
		LDR 	R2,[R0]
		ands 	R2,R3,R2
		STR 	R2,[R1]
		
		;3.5
		LDRB 	R0,[R7,R2]				; Access table
		LDR		R1,=ADDR_LED_23_16 
		STRB    R0,[R1]   	    
		
		
		
		
		



; END: To be programmed
        B       readInput
        ALIGN

; ------------------------------------------------------------------
; Subroutines
; ------------------------------------------------------------------

; wait for key to be pressed and released
waitForKey
        PUSH    {R0, R1, R2}
        LDR     R1, =ADDR_BUTTONS           ; laod base address of keys
        LDR     R2, =BITMASK_KEY_T0         ; load key mask T0

waitForPress
        LDRB    R0, [R1]                    ; load key values
        TST     R0, R2                      ; check, if key T0 is pressed
        BEQ     waitForPress

waitForRelease
        LDRB    R0, [R1]                    ; load key values
        TST     R0, R2                      ; check, if key T0 is released
        BNE     waitForRelease
                
        POP     {R0, R1, R2}
        BX      LR
        ALIGN

; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        ENDP
        END
