/* -----------------------------------------------------------------
 * --  _____       ______  _____                                    -
 * -- |_   _|     |  ____|/ ____|                                   -
 * --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
 * --   | | | '_ \|  __|  \___ \   Zurich University of             -
 * --  _| |_| | | | |____ ____) |  Applied Sciences                 -
 * -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
 * ------------------------------------------------------------------
 * --
 * -- main.c
 * --
 * -- main for Computer Engineering "Bit Manipulations"
 * --
 * -- $Id: main.c 744 2014-09-24 07:48:46Z ruan $
 * ------------------------------------------------------------------
 */
//#include <reg_ctboard.h>
#include "utils_ctboard.h"

#define ADDR_DIP_SWITCH_31_0 0x60000200
#define ADDR_DIP_SWITCH_7_0  0x60000200
#define ADDR_LED_31_24       0x60000103
#define ADDR_LED_23_16       0x60000102
#define ADDR_LED_15_8        0x60000101
#define ADDR_LED_7_0         0x60000100
#define ADDR_BUTTONS         0x60000210


// define your own macros for bitmasks below (#define)


/// STUDENTS: To be programmed

#define bit_mask_Dark 0xCF
#define bit_mask_Bright 0xC0 
#define bit_mask_t0 0x1
#define bit_mask_t1 0x2
#define bit_mask_t2 0x4
#define bit_mask_t3 0x8
/// END: To be programmed

int main(void)
{
    uint8_t led_value = 0;
		

    // add variables below
    /// STUDENTS: To be programmed
				uint8_t counter_variable = 0;
				uint8_t btn_value =0 ;
				uint8_t push_event = 0;
				uint8_t push_counter = 0; 
				uint8_t last_btn_value = 0x0;
				uint8_t edge_pushed_value = 0x0;
				uint8_t edge_push_event = 0;


    /// END: To be programmed

    while (1) {
        // ---------- Task 3.1 ----------
        led_value = read_byte(ADDR_DIP_SWITCH_7_0);
				

        /// STUDENTS: To be programmed
				led_value |=(bit_mask_Bright);
				led_value &=(bit_mask_Dark);
				


        /// END: To be programmed
				write_byte(ADDR_LED_7_0, led_value);
        

        // ---------- Task 3.2 and 3.3 ----------
        /// STUDENTS: To be programmed
				btn_value = read_byte(ADDR_BUTTONS) & 0xF; 

			
			if( btn_value == 0x1) {
				counter_variable++;
				write_byte(ADDR_LED_15_8,counter_variable);

			}
			
			if (btn_value == 0x1 && push_event == 0)  {
				push_counter++;
				push_event = 1;
			} else if(btn_value == 0x0 && push_event ==1) {
					push_event = 0;
			}
			
			write_byte(ADDR_LED_31_24,push_counter);
			edge_pushed_value = (btn_value) & (~last_btn_value);
			last_btn_value = btn_value;
			
			
			
			
			
			
			
			if((edge_pushed_value & bit_mask_t3) == bit_mask_t3) {
					edge_push_event = read_byte(ADDR_DIP_SWITCH_7_0);
					write_byte(ADDR_LED_23_16, edge_push_event);
				}
				else if((edge_pushed_value & bit_mask_t2) == bit_mask_t2){
					edge_push_event = (~edge_push_event);
					write_byte(ADDR_LED_23_16, edge_push_event);
				}
				else if((edge_pushed_value & bit_mask_t1) == bit_mask_t1){
					edge_push_event = edge_push_event << 1;
					write_byte(ADDR_LED_23_16, edge_push_event);
				}
				else if((edge_pushed_value & bit_mask_t0) == bit_mask_t0){
					edge_push_event = edge_push_event >> 1;
					write_byte(ADDR_LED_23_16, edge_push_event);
				}
				else{
					write_byte(ADDR_LED_23_16, edge_push_event);
				}
			
			
			
			
			
			
			
			}
			
				



        /// END: To be programmed
			
    }

