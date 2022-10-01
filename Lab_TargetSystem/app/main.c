#include "utils_ctboard.h"
#include <stdio.h>

#define LED_ADDR 0x60000100
#define DIPSW_ADDR 0x60000200
#define ROTSW_ADDR 0x60000211
#define DISP0_ADDR 0x60000110
#define LED_VALUE 0x12
//binary from ennis.zhaw.ch(7-segments) converted to hex 
#define null 0xC0 
#define eins 0xF9
#define zwei 0xA4
#define drei 0xB0
#define vier 0x99
#define fuenf 0x92
#define sechs 0x82
#define sieben 0xF8
#define acht 0x80
#define neun 0x90
#define A 0x88
#define b 0x83
#define C 0xC6
#define d 0xA1
#define E 0x86
#define F 0x8E



int main(void)
{

	while(1) {
		uint8_t hexarray[16] = {null, eins, zwei, drei, vier, fuenf, sechs, sieben, acht, neun, A, b, C, d, E, F};
		
		uint32_t dipSwitch = read_word(DIPSW_ADDR);
	  write_word(LED_ADDR,dipSwitch);
		

		write_byte(DISP0_ADDR, hexarray[read_byte(ROTSW_ADDR) & 0x0F]); //0X0F is to mask upper 4 bits
		
	
	}



}