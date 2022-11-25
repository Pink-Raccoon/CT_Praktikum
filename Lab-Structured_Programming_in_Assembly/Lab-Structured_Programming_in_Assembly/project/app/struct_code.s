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
S3_Mask					  EQU		 0x00000008

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
		;Check if button is pressed
		LDR			R0, =ADDR_BUTTONS
		LDRB		R0, [R0]
		MOVS		R1, #0x01
		TST			R0,R1							; R0 && 1
		BNE			button_pressed					; if and = 1 then Z = 0 so NE to test if 1
		

		
display		;display adc value on 7 seg display
		;call adc_get_value
		BL			adc_get_value					;stores value in R0
		MOVS		R7, R0
		LDR			R3, =ADDR_7_SEG_BIN_DS3_0
		STR			R7,	[R3]
		
		MOVS		R1, R7
		LSRS		R1, R1, #3
		MOVS		R2, #0x0000
		CMP			R1, R2
		BEQ			make_one
		BL			calculate_bar_ones
make_one
		ADDS		R2, R2, #0x01
		B			make_led_bar
		
calculate_bar_ones
		CMP			R1,R2
		BLO			make_led_bar
		LSLS		R2, R2, #0x01
		ADDS		R2, R2, #0x01
		B			calculate_bar_ones
		
make_led_bar
		LDR			R0, =ADDR_LED_31_0
		MOVS		R5, #0x00FF
		ANDS		R2, R2, R5 
		STR			R2, [R0]
		



		
		


						



; END: To be programmed
        B          main_loop


;---------------------------------------------------------subroutines		
adc_divide_by_eight
		LSRS		R0, R1, #3
		BX			LR
		
button_pressed
		;set background of LCD to green
		LDR			R0, =ADDR_LCD_COLOUR
		LDR			R1, =0xffff
		LDR			R2, =DISPLAY_COLOUR_GREEN
		STRH		R1, [R0, R2]

		B			display
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
clear_lcd
        PUSH       {R0, R1, R2}
        LDR        R2, =0x0
clear_lcd_loop
        LDR        R0, =ADDR_LCD_ASCII
        ADDS       R0, R0, R2                       ; add index to lcd offset
        LDR        R1, =ASCII_DIGIT_CLEAR
        STR        R1, [R0]
        ADDS       R2, R2, #4                       ; increas index by 4 (word step)
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
