;* ------------------------------------------------------------------
;* --  _____       ______  _____                                    -
;* -- |_   _|     |  ____|/ ____|                                   -
;* --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
;* --   | | | '_ \|  __|  \___ \   Zurich University of             -
;* --  _| |_| | | | |____ ____) |  Applied Sciences                 -
;* -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
;* ------------------------------------------------------------------
;* --
;* -- Project     : CT1 - Lab 10
;* -- Description : Search Max
;* -- 
;* -- $Id: search_max.s 879 2014-10-24 09:00:00Z muln $
;* ------------------------------------------------------------------


; -------------------------------------------------------------------
; -- Constants
; -------------------------------------------------------------------
                AREA myCode, CODE, READONLY
                THUMB
                    
; STUDENTS: To be programmed




; END: To be programmed
; -------------------------------------------------------------------                    
; Searchmax
; - tableaddress in R0
; - table length in R1
; - result returned in R0
; -------------------------------------------------------------------   
search_max      PROC
                EXPORT search_max

                ; STUDENTS: To be programmed

				; R0 adresse
				; R1 anzahl
				PUSH 	{R2, R3, R4, R5, R6, R7}
				
				
				; check if R0 is 0
				CMP 	R1, #0
				BNE 	not_zero
				LDR		R0, =0x80000000
				B		go_end
				
not_zero		
				MOVS	R3, R0				; table address in R3
				; iterate and find max

initialize_iteration		
				SUBS	R1, R1, #1			; -1 for amount of elements in array (size-1)
				MOVS	R2, #0				; loop index in R2
				MOVS	R6, #0				; table-access index
				MOVS	R7, #4				; index multiplier
				LDR		R5, [R3, #0]		; current element in R5
				MOVS	R0, #0				; initialize maximum with 0
				B		loop_test

loop			
				ADDS	R2, #1				; increase loop index
				MOVS	R6, R2				; table index = loop index
				MULS	R6, R7, R6			; table index = table index * 4
				
				LDR		R5, [R3, R6]		; current = new table value
				
loop_test		
				CMP		R5, R0
				BLE		check_if_loop_done
				MOVS	R0, R5
check_if_loop_done			
				CMP		R2, R1
				BNE		loop

go_end
				POP		{R2, R3, R4, R5, R6, R7}
				BX	LR				
				




                ; END: To be programmed
                ALIGN
                ENDP
; -------------------------------------------------------------------
; -- End of file
; -------------------------------------------------------------------                      
                END

