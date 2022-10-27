; ------------------------------------------------------------------
; --  _____       ______  _____                                    -
; -- |_   _|     |  ____|/ ____|                                   -
; --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
; --   | | | '_ \|  __|  \___ \   Zurich University of             -
; --  _| |_| | | | |____ ____) |  Applied Sciences                 -
; -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
; ------------------------------------------------------------------
; --
; -- sumdiff.s
; --
; -- CT1 P05 Summe und Differenz
; --
; -- $Id: sumdiff.s 705 2014-09-16 11:44:22Z muln $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB

; ------------------------------------------------------------------
; -- Symbolic Literals
; ------------------------------------------------------------------
ADDR_DIP_SWITCH_7_0     EQU     0x60000200
ADDR_DIP_SWITCH_15_8    EQU     0x60000201
ADDR_LED_7_0            EQU     0x60000100
ADDR_LED_15_8           EQU     0x60000101
ADDR_LED_23_16          EQU     0x60000102
ADDR_LED_31_24          EQU     0x60000103

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA MyCode, CODE, READONLY

main    PROC
        EXPORT main

user_prog
        ; STUDENTS: To be programmed
		LDR 	R0, =ADDR_DIP_SWITCH_15_8				;Load address of Dipswitch 8-15 into R0
		LDR		R0,[R0]									;(Operand A) Read value of Dipswitches 8-15 into R0 
		LSLS	R0,R0,#24								;Shift value of dipswitch 8-15 to the left by 24 bits (right hand side filled with 0)
		
		LDR		R1,=ADDR_DIP_SWITCH_7_0 				;Load address of Dipswitch 0-7 into R1
		LDR		R1,[R1]									;(Operand B) Read value of Dipswitches 0-7 into R1
		LSLS	R1,R1,#24								;Shift value of Dipswitches 0-7 to the left by 24bits (right hand side filled with 0)
		
		ADDS	R0,R0,R1								;R0 = R0+R1 added Values Dipswitch 8-15 and Dipswicht 0-7
		MRS		R4, APSR								;Read processor flag into R4
		LSRS	R0,R0,#24								;Shift right to afterwards display bit 31-28
		LDR     R2,=ADDR_LED_7_0						;Load address of LED 0-7 into R2
		STRB	R0,[R2]									;Write sum value in R0 into R2 (LED 0-7)
		LDR		R6,=ADDR_LED_15_8 						;Load address of LED 8-15 into R6
		LSRS	R4,R4,#24				
		STRB	R4,[R6]									;Write value sum R4 into R6 LED 12-15

		LDR 	R0, =ADDR_DIP_SWITCH_15_8				;Load address of Dipswitch 8-15 into R0
		LDR		R0,[R0]									;(Operand A) Read value of Dipswitches 8-15 into R0 
		LSLS	R0,R0,#24								;Shift value of dipswitch 8-15 to the left by 24 bits (right hand side filled with 0)
		
		LDR		R1,=ADDR_DIP_SWITCH_7_0 				;Load address of Dipswitch 0-7 into R1
		LDR		R1,[R1]									;(Operand B) Read value of Dipswitches 0-7 into R1
		LSLS	R1,R1,#24

		LDR		R3,=ADDR_LED_23_16 						;Load address of LED 16-23 into R3		
		SUBS    R1,R0,R1								;R1 = R0-R1 subtract Values Dipswitch 8-15 and Dipswitch 0-7
		MRS 	R5,APSR									;Read processor flag into R5
		LSRS	R1,R1,#24								;Shift right to afterwards display bit 12-15	
		LDR     R7,=ADDR_LED_31_24 
		LSRS	R5,R5,#24
		STRB	R5,[R7]									;Write Flag value subtraction R5 into R7 LED 28-31		

		STRB	R1,[R3]									;Write difference value in R1 into R3 (LED 16-23)	

		
		



        ; END: To be programmed
        B       user_prog
        ALIGN
; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        ENDP
        END
