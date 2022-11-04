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



; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY

        ENTRY

main    PROC
        export main
            
; STUDENTS: To be programmed
; read Dipswitch 0-7 (ONES)
		LDR		R0, =ADDR_DIP_SWITCH_7_0
		LDRB	R6, [R0]
		
	; read dipswitch 8-15 (TENS)
		LDR 	R0, =ADDR_DIP_SWITCH_15_8
		LDRB	R7, [R0]

	; display BCD TENS and BCD ONES into R5
		LSLS	R5, R7, #4
		ORRS	R5, R5, R6
	
		LDR		R0, =ADDR_LED_15_0
		STRB	R5, [R0]
		
	; display result in binary into R4
		
		
		MOVS	R4, R7				; Move value 10's into R4
		
		
		LDR     R1, =ADDR_BUTTONS
		LDR		R2, [R1]
		MOVS	R1, #1				;Store value 1 in R1
		ANDS	R2, R2, R1			;ver-Ande value button witth value in R1 (state off or on)	
		
		CMP		R2, #0	;if button is OFF
		BEQ		go_else
		
		;if body for shift add mult if button pressed
		
		LDR		R0, =ADDR_LCD_RED
		LDR		R1, =LCD_BACKLIGHT_FULL
		STRH	R1, [R0]
		
		LSLS	R3, R4, #1
		LSLS	R2, R4, #3
		ADDS	R4, R3, R2
		
		LDR 	R0, =go_here
		BX 		R0
		; endif
		
		
go_else	MOVS	R0, #10
		MULS	R4, R0, R4

		LDR		R0, =ADDR_LCD_BLUE
		LDR		R1, =LCD_BACKLIGHT_FULL
		STRH	R1, [R0]
		; ende else
		
go_here	ADDS	R4, R4, R6
		
		LDR		R0, =ADDR_LED_15_0 
		STRB	R4, [R0, #1]					;Write Binary value in LED 8-15

	; prepare same result (in R4) to seven segment display
		LDR		R0, =ADDR_7_SEG_BIN_DS3_0
		STRB	R5, [R0]
		STRB	R4, [R0, #1]

;3.2

; count bits

		MOVS 	R0, #7		; loop variable
		MOVS	R1, #0		; counter
		LDR		R3, =cond

		B		cond

loop1	
		SUBS	R0, #1		; minus one for loop var
		
		LSRS	R4, #1		; shift oneo to the right
	;check condition
		BCS		carySet
	; else
		BX		R3
; if condition true
carySet	
		ADDS	R1, #1		; add one to counter

cond	
		CMP		R0, #0
		BNE		loop1
		
		

; display amount of ones (amount in R1)

		
		
		; if amount of ones is zero, skip
		CMP		R1, #0
		BEQ		skip1
		; else make a 1
		MOVS	R2, #1		; RESULT IN R2
		; and left shift it as much as amount of ones (for loop)
		MOVS 	R0, R1		; loop variable!!!
		
		B		cond2
loop2	
		MOVS	R3, #1
		LSLS	R2, R2, R3		;shift one to da left
		ADDS	R2, R2, #1
		
cond2
		SUBS	R0, #1			; minus one for loop var
		CMP		R0, #0			; is loop over?
		BNE		loop2			; if not, go to next iteration of loop

skip1	

		; as many ones in R2 as needed to display the bar
		LDR		R6, =ADDR_LED_31_16
		
		
		; rotate stuff
		LSLS	R3, R2, #16				; shift halfword to the left
		ORRS	R3, R3, R2				; duplicate 	RESULT IN R3
		
		
		
		; loop 16 times with pauses
		MOVS	R0, #1 		; 1
		MOVS	R1, #16			; loop variable
		
		B		cond3
loop3	
		RORS	R3, R3, R0		; rotate 1
		SUBS	R1, #1			; minus one for loop var
		BL 		pause			; take break
		
cond3
		STRH	R3, [R6]				; display the bar
		CMP		R1, #0			; is loop over?
		BNE		loop3			; if not, go to next iteration of loop
		
; turn off lcd
		LDR		R0, =ADDR_LCD_BLUE
		LDR		R1, =LCD_BACKLIGHT_OFF
		STRH	R1, [R0]
		
		LDR		R0, =ADDR_LCD_RED
		LDR		R1, =LCD_BACKLIGHT_OFF
		STRH	R1, [R0]
		
	
		
		



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
