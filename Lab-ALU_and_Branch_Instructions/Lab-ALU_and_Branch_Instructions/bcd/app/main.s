; ------------------------------------------------------------------
; --  _____       ______  _____                                    -
; -- |_   _|     |  ____|/ ____|                                   -
; --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
; --   | | | '_ \|  __|  \___ \   Zurich University of             -
; --  _| |_| | | | |____ ____) |  Applied Sciences                 -
; -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
; ------------------------------------------------------------------
; --
; -- main.s
; --
; -- CT1 P06 "ALU und Sprungbefehle" mit MUL
; --
; -- $Id: main.s 4857 2019-09-10 17:30:17Z akdi $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB

; ------------------------------------------------------------------
; -- Address Defines
; ------------------------------------------------------------------

ADDR_LED_7_0			EQU		0x60000100
ADDR_LED_15_8			EQU		0x60000101
ADDR_LED_31_16          EQU     0x60000102
ADDR_DIP_SWITCH_7_0     EQU     0x60000200
ADDR_DIP_SWITCH_15_8    EQU     0x60000201
ADDR_7_SEG_BIN_DS3_0    EQU     0x60000114
ADDR_7_SEG_BIN_DS3_2	EQU		0x60000115
ADDR_BUTTONS            EQU     0x60000210

ADDR_LCD_RED            EQU     0x60000340
ADDR_LCD_GREEN          EQU     0x60000342
ADDR_LCD_BLUE           EQU     0x60000344
LCD_BACKLIGHT_FULL      EQU     0xffff
LCD_BACKLIGHT_OFF       EQU     0x0000
	
BITMASK_UPPER			EQU		0x0f
MASK_KEY_T0             EQU     0x00000001


; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY

        ENTRY

main    PROC
        export main
            
; STUDENTS: To be programmed
		;3.1
		LDR R0, =ADDR_LED_7_0
		LDR R1, =ADDR_LED_15_8
		LDR R2, =ADDR_DIP_SWITCH_7_0
		LDR R3, =ADDR_DIP_SWITCH_15_8
		LDR R5, =BITMASK_UPPER
		LDR R6, =ADDR_7_SEG_BIN_DS3_0
		LDRB R2, [R2]
		ANDS R2, R2, R5
		LDRB R3, [R3]
		ANDS R3, R3, R5
		LSLS R4, R3, #4
		ADDS R4, R4, R2
		STRB R4, [R0]
		STRB R4, [R6]
		
		;Branch
		LDR R1, =ADDR_BUTTONS
		LDRB R1, [R1]
		MOVS R0, #0x01
		TST R1, R0
		BNE mult_manuell
		
		;Multiplikation 
		LDR R0, =ADDR_LED_7_0
		LDR R1, =ADDR_LED_15_8
		LDR R5, =10
		MULS R3, R5, R3
		ADDS R4, R3, R2
		STRB R4, [R1]
		;set background
		LDR		R7, =ADDR_LCD_RED
		LDR		R6, =LCD_BACKLIGHT_OFF
		STRH	r6, [R7]
		LDR     R7, =ADDR_LCD_BLUE
        LDR     R6, =LCD_BACKLIGHT_FULL
        STRH    R6, [R7]  
		;manuelle multiplikation muss nun übersprungen werden
		B	skip_2nd_mul
		
		;Multiplikation manuell = mit shift und add
mult_manuell
		;Adresse neu setzten, da R1 und R0 überschrieben wurden
		LDR R0, =ADDR_LED_7_0
		LDR R1, =ADDR_LED_15_8
		;set background
		LDR		R7, =ADDR_LCD_BLUE
		LDR		R6, =LCD_BACKLIGHT_OFF
		STRH	R6, [R7]
		LDR     R7, =ADDR_LCD_RED
        LDR     R6, =LCD_BACKLIGHT_FULL
        STRH    R6, [R7]   
		;multiplikation mit shift und add
		LSLS R5, R3, #3
		ADDS R5, R5, R3
		ADDS R5, R5, R3
		ADDS R4, R5, R2
		STRB R4, [R1]

skip_2nd_mul

		LDR R1, =ADDR_7_SEG_BIN_DS3_2
		STRB R4, [R1]


		;and operator mit 000..1 -> falls ungleich null -> leftshift +1 auf dem zähler-> leftshift comparator -> loop up
		MOVS R1, #00000001
		LDR R6, =0
		LDR R7, =8
counterloop
		LDR R5, =0
		MOVS R5, R4
		ANDS R5, R5, R1
		BEQ skip			;skip if its not one, leftshift plus one if it is a one
		LSLS R6, R6, #1
		ADDS R6, R6, #0x01
skip
		LSLS R1, R1, #1
		SUBS R7, R7, #1
		BNE counterloop		;loop until all 8 bits are evaluated
		LDR R7, =ADDR_LED_31_16
		STR R6, [R7]
	
		;copies the value in R6 to the left to have the value in it twice to make sure the 32bit value can be displayed with 16bits
		MOVS R2, R6
		LSLS R6, R6, #16
		ADDS R6, R6, R2
		LDR R2, =15
		;rotates to the right, makes a pause reduces counter (R6) by 1 to loop through it 15 times (1 full rotation, technically half a rotation of a word consisting of two equal halfwords, that looks like a full rotation on the 16 bit display)
repeat15
		LDR R5, =1
		RORS R6, R6, R5
		STR R6, [R7]
		BL pause
		SUBS R2, R2, #0x01
		BNE repeat15


; END: To be programmed

        B       main
        ENDP
            
;----------------------------------------------------
; Subroutines
;----------------------------------------------------

;----------------------------------------------------
; pause for disco_lights
pause           PROC
        PUSH    {R0, R1}
        LDR     R1, =1
        LDR     R0, =0x000FFFFF
        
loop        
        SUBS    R0, R0, R1
        BCS     loop
    
        POP     {R0, R1}
        BX      LR
        ALIGN
        ENDP

; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        END
