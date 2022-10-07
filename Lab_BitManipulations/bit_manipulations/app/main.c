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

#define bit_mask_Bright 		0xCF
#define bit_mask_Dark				0xC0 

/// END: To be programmed

int main(void)
{
    uint8_t led_value = 0;

    // add variables below
    /// STUDENTS: To be programmed
		




    /// END: To be programmed

    while (1) {
        // ---------- Task 3.1 ----------
        led_value = read_byte(ADDR_DIP_SWITCH_7_0);


        /// STUDENTS: To be programmed
				led_value &=(bit_mask_Bright);
				led_value |=(bit_mask_Dark);
				write_byte(ADDR_LED_7_0, led_value);


        /// END: To be programmed

        

        // ---------- Task 3.2 and 3.3 ----------
        /// STUDENTS: To be programmed
				
				uint8_t btn_value = read_byte(ADDR_BUTTONS);	
				write_byte(ADDR_LED_15_8,btn_value & 0x0F);
				for(uint8_t counter_variable = 0; btn_value==0x01; counter_variable++){
				
				write_byte(ADDR_LED_15_8,counter_variable & 0x0F);
				}
						
				
				
							
			}
				



        /// END: To be programmed
    }

