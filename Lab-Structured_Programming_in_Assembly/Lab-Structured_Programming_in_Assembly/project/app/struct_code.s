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
; -- CT1 P08 "Strukturierte Codierung" mit Assembler
; --
; -- $Id: struct_code.s 3787 2016-11-17 09:41:48Z kesr $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB

; ------------------------------------------------------------------
; -- Address-Defines
; ------------------------------------------------------------------
; input
ADDR_DIP_SWITCH_7_0       EQU        0x60000200
ADDR_BUTTONS              EQU        0x60000210

; output
ADDR_LED_31_0             EQU        0x60000100
ADDR_7_SEG_BIN_DS3_0      EQU        0x60000114
ADDR_LCD_COLOUR           EQU        0x60000340
ADDR_LCD_ASCII            EQU        0x60000300
ADDR_LCD_ASCII_BIT_POS    EQU        0x60000302
ADDR_LCD_ASCII_2ND_LINE   EQU        0x60000314


; ------------------------------------------------------------------
; -- Program-Defines
; ------------------------------------------------------------------
; value for clearing lcd
ASCII_DIGIT_CLEAR        EQU         0x00000000
LCD_LAST_OFFSET          EQU         0x00000028

; offset for showing the digit in the lcd
ASCII_DIGIT_OFFSET        EQU        0x00000030

; lcd background colors to be written
DISPLAY_COLOUR_RED        EQU        0
DISPLAY_COLOUR_GREEN      EQU        2
DISPLAY_COLOUR_BLUE       EQU        4

; ------------------------------------------------------------------
; -- myConstants
; ------------------------------------------------------------------
        AREA myConstants, DATA, READONLY
; display defines for hex / dec
DISPLAY_BIT               DCB        "Bit "
DISPLAY_2_BIT             DCB        "2"
DISPLAY_4_BIT             DCB        "4"
DISPLAY_8_BIT             DCB        "8"
        ALIGN

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY
        ENTRY

        ; imports for calls
        import adc_init
        import adc_get_value

main    PROC
        export main
        ; 8 bit resolution, cont. sampling
        BL         adc_init 
        BL         clear_lcd

main_loop
; STUDENTS: To be programmed

		BL		adc_get_value
		LDR		R7, =ADDR_7_SEG_BIN_DS3_0		
		LDR		R6, =ADDR_BUTTONS
		LDR		R1, [R6]
		MOVS	R4, #0x1
		MOVS	R5, #0xff
		TST		R1, R4
		BNE		ifGreen
		
ifBlueRed
		LDR		R6, =ADDR_LED_31_0
		MOVS	R4, #0x0
		STR		R4, [R6]
		LDR 	R6, =ADDR_DIP_SWITCH_7_0
		LDRB	R1, [R6]
		SUBS	R1, R1, R0
		CMP		R1, R4
		BGE		ifBlue
ifRed
		BL		lcdRed
		MOVS 	R0, R1
		MOVS	R3, #0x0
		MOVS	R4, #0x8
		B		redLoopTest
redLoop
		LSRS	R0, #0x1
		BCS		endIfZeroShifted
ifZeroShifted
		ADDS	R3, #0x1
endIfZeroShifted
		SUBS	R4, #0x1
redLoopTest
		BNE		redLoop
		
		LDR		R6, =ADDR_LCD_ASCII_2ND_LINE
		ADDS	R3, #0x30
		STR		R3, [R6]

		B		endIfBlueRed
ifBlue
		BL		lcdBlue
		BL		clear_lcd
endIfBlueRed
		ANDS	R1, R1, R5
		STRH	R1, [R7]
		B		endIfGreen

ifGreen
		
		BL 		lcdGreen
		BL		clear_lcd
		ANDS	R0, R0, R5
		STRH	R0, [R7]
				
		LSRS	R0, #0x3
		MOVS	R3, #0x1
		MOVS	R4, #0x0
		
		B		greenLoopTest
greenLoop
		LSLS	R3, #0x1
		ADDS	R3, #0x1
		SUBS	R0, #0x1

greenLoopTest
		CMP		R0, R4
		BNE		greenLoop
		
		LDR		R6, =ADDR_LED_31_0
		STR		R3, [R6]
		
endIfGreen

; END: To be programmed
        B          main_loop
	
; procedures	
lcdRed
		PUSH	{ R1, R5-R7, LR }
		
		BL		lcdOff
		BL		loadLcdAddr
		BL		loadFullLight
		LDR		R6, =DISPLAY_COLOUR_RED
		STR		R1, [R7, R6]
		
		POP		{ R1, R5-R7, PC }
			
lcdBlue
		PUSH	{ R1, R5-R7, LR }
		
		BL		lcdOff
		BL		loadLcdAddr
		BL		loadFullLight
		LDR		R6, =DISPLAY_COLOUR_BLUE
		STR		R1, [R7, R6]
		
		POP		{ R1, R5-R7, PC }
			
lcdGreen	
		PUSH	{ R1, R5-R7, LR }
		
		BL		lcdOff
		BL		loadLcdAddr
		BL		loadFullLight
		LDR		R6, =DISPLAY_COLOUR_GREEN
		STR		R1, [R7, R6]
		
		POP		{ R1, R5-R7, PC }
		
lcdOff
		PUSH 	{ R1, R6-R7, LR }
		
		BL		loadNoLight
		BL		loadLcdAddr
		LDR		R6, =DISPLAY_COLOUR_RED
		STR		R1, [R7, R6]
		LDR		R6, =DISPLAY_COLOUR_BLUE
		STR		R1, [R7, R6]
		LDR		R6, =DISPLAY_COLOUR_GREEN
		STR		R1, [R7, R6]
		
		POP		{ R1, R6-R7, PC }
		
loadFullLight
		LDR		R1, =0xFFFF
		BX		LR		
		
loadNoLight
		LDR		R1, =0x0
		BX		LR

loadLcdAddr			
		LDR		R7, =ADDR_LCD_COLOUR
		BX		LR
			
; end procedures
        
clear_lcd
        PUSH       {R0, R1, R2}
        LDR        R2, =0x0
clear_lcd_loop
        LDR        R0, =ADDR_LCD_ASCII
        ADDS       R0, R0, R2                       ; add index to lcd offset
        LDR        R1, =ASCII_DIGIT_CLEAR
        STR        R1, [R0]
        ADDS       R2, R2, #0x4                       ; increas index by 4 (word step)
        CMP        R2, #LCD_LAST_OFFSET             ; until index reached last lcd point
        BMI        clear_lcd_loop
        POP        {R0, R1, R2}
        BX         LR

write_bit_ascii
        PUSH       {R0, R1}
        LDR        R0, =ADDR_LCD_ASCII_BIT_POS 
        LDR        R1, =DISPLAY_BIT
        LDR        R1, [R1]
        STR        R1, [R0]
        POP        {R0, R1}
        BX         LR

        ENDP
        ALIGN


; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        END
