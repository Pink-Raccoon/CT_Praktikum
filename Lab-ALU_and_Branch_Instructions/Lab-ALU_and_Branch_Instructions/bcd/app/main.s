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

ADDR_LED_15_0          	EQU     0x60000100
ADDR_LED_31_16          EQU     0x60000102
ADDR_DIP_SWITCH_7_0     EQU     0x60000200
ADDR_DIP_SWITCH_15_8    EQU     0x60000201
ADDR_7_SEG_BIN_DS3_0    EQU     0x60000114
ADDR_BUTTONS            EQU     0x60000210

ADDR_LCD_RED            EQU     0x60000340
ADDR_LCD_GREEN          EQU     0x60000342
ADDR_LCD_BLUE           EQU     0x60000344
LCD_BACKLIGHT_FULL      EQU     0xffff
LCD_BACKLIGHT_OFF      	EQU     0x0000
BIT_MASK				EQU		0x0F


; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY

        ENTRY

main    PROC
        export main
            
; STUDENTS: To be programmed
		LDR		R0,=ADDR_DIP_SWITCH_7_0					;Load address Dip_Switch 0-7			
		LDRB	R0,[R0]									;Read value of Dipswitch 0-7
		LDR		R1,=BIT_MASK							;Load Bit_Mask for switch	
		ands	R0,R0,R1								;and the bitmask with Dipswitch 0-7 so only 0-3 gets displayed
		LSLS	R0,R0,#8								;shift value of Dipswitch 0-3 so that it's displayed on LED 8-11
		LDR		R1,=ADDR_LED_15_0 						;Load address LED 0-15			
		STR		R0,[R1]									;Write value of Dipswitch 0-7 into LED 0-15
		
		LDR		R1,=ADDR_DIP_SWITCH_15_8				;Load address Dipswitch 8-15
		LDRB	R1,[R1]									;Read value of dipswitch 8-15
		LDR		R2,=BIT_MASK							;Load Bitmask switch
		ands	R1,R1,R2								;and the bitmask with Dipswitch 8-15 so only 8-11 gets displayed
		LSLS	R1,R1,#12							;shift value of dipswitch 8-11 so that it's displayed on LED 12-15
		LDR		R2,=ADDR_LED_15_0 						;Load address LED 0-15
		STR		R1,[R2]									;Write value of Dipswitch 8-15 into LED 0-15
		
		
		

		
		



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
