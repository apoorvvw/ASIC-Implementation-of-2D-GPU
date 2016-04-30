// $Id: $
// File name:   sram.sv
// Created:     5/24/2016
// Author:      Apoorv Vijay Wairagade
// Lab Section: 5
// Version:     1.0  Initial Design Entry
// Description: A simple on-chip sram.
 

module sram (

	input clk,
	input [((64*24) - 1):0] write_data,
	input [(24 - 1):0] address,
	input write_enable,
	input read_enable,	
	input reset,

	output reg [(64*24 - 1):0] read_data
);
	reg [208895:0][((8*3)-1):0]mem ;
	integer i;
	always @ (posedge clk) begin
		if (reset) begin
			mem = '1;
		end
		if (write_enable) begin
			mem[address + 0] <= write_data[ (24*1) - 1 : (24 * 0) ];
			mem[address + 1] <= write_data[ (24*2) - 1 : (24 * 1) ];
			mem[address + 2] <= write_data[ (24*3) - 1 : (24 * 2) ];
			mem[address + 3] <= write_data[ (24*4) - 1 : (24 * 3) ];
			mem[address + 4] <= write_data[ (24*5) - 1 : (24 * 4) ];
			mem[address + 5] <= write_data[ (24*6) - 1 : (24 * 5) ];
			mem[address + 6] <= write_data[ (24*7) - 1 : (24 * 6) ];
			mem[address + 7] <= write_data[ (24*8) - 1 : (24 * 7) ];
			mem[address + 8] <= write_data[ (24*9) - 1 : (24 * 8) ];
			mem[address + 9] <= write_data[ (24*10) - 1 : (24 * 9) ];
			
			mem[address + 10] <= write_data[ (24*11) - 1 : (24 * 10) ];
			mem[address + 11] <= write_data[ (24*12) - 1 : (24 * 11) ];
			mem[address + 12] <= write_data[ (24*13) - 1 : (24 * 12) ];
			mem[address + 13] <= write_data[ (24*14) - 1 : (24 * 13) ];
			mem[address + 14] <= write_data[ (24*15) - 1 : (24 * 14) ];
			mem[address + 15] <= write_data[ (24*16) - 1 : (24 * 15) ];
			mem[address + 16] <= write_data[ (24*17) - 1 : (24 * 16) ];
			mem[address + 17] <= write_data[ (24*18) - 1 : (24 * 17) ];
			mem[address + 18] <= write_data[ (24*19) - 1 : (24 * 18) ];
			mem[address + 19] <= write_data[ (24*20) - 1 : (24 * 19) ];

			mem[address + 20] <= write_data[ (24*21) - 1 : (24 * 20) ];
			mem[address + 21] <= write_data[ (24*22) - 1 : (24 * 21) ];
			mem[address + 22] <= write_data[ (24*23) - 1 : (24 * 22) ];
			mem[address + 23] <= write_data[ (24*24) - 1 : (24 * 23) ];
			mem[address + 24] <= write_data[ (24*25) - 1 : (24 * 24) ];
			mem[address + 25] <= write_data[ (24*26) - 1 : (24 * 25) ];
			mem[address + 26] <= write_data[ (24*27) - 1 : (24 * 26) ];
			mem[address + 27] <= write_data[ (24*28) - 1 : (24 * 27) ];
			mem[address + 28] <= write_data[ (24*29) - 1 : (24 * 28) ];
			mem[address + 29] <= write_data[ (24*30) - 1 : (24 * 29) ];

			mem[address + 30] <= write_data[ (24*31) - 1 : (24 * 30) ];
			mem[address + 31] <= write_data[ (24*32) - 1 : (24 * 31) ];
			mem[address + 32] <= write_data[ (24*33) - 1 : (24 * 32) ];
			mem[address + 33] <= write_data[ (24*34) - 1 : (24 * 33) ];
			mem[address + 34] <= write_data[ (24*35) - 1 : (24 * 34) ];
			mem[address + 35] <= write_data[ (24*36) - 1 : (24 * 35) ];
			mem[address + 36] <= write_data[ (24*37) - 1 : (24 * 36) ];
			mem[address + 37] <= write_data[ (24*38) - 1 : (24 * 37) ];
			mem[address + 38] <= write_data[ (24*39) - 1 : (24 * 38) ];
			mem[address + 39] <= write_data[ (24*40) - 1 : (24 * 39) ];

			mem[address + 40] <= write_data[ (24*41) - 1 : (24 * 40) ];
			mem[address + 41] <= write_data[ (24*42) - 1 : (24 * 41) ];
			mem[address + 42] <= write_data[ (24*43) - 1 : (24 * 42) ];
			mem[address + 43] <= write_data[ (24*44) - 1 : (24 * 43) ];
			mem[address + 44] <= write_data[ (24*45) - 1 : (24 * 44) ];
			mem[address + 45] <= write_data[ (24*46) - 1 : (24 * 45) ];
			mem[address + 46] <= write_data[ (24*47) - 1 : (24 * 46) ];
			mem[address + 47] <= write_data[ (24*48) - 1 : (24 * 47) ];
			mem[address + 48] <= write_data[ (24*49) - 1 : (24 * 48) ];
			mem[address + 49] <= write_data[ (24*50) - 1 : (24 * 49) ];

			mem[address + 50] <= write_data[ (24*51) - 1 : (24 * 50) ];
			mem[address + 51] <= write_data[ (24*52) - 1 : (24 * 51) ];
			mem[address + 52] <= write_data[ (24*53) - 1 : (24 * 52) ];
			mem[address + 53] <= write_data[ (24*54) - 1 : (24 * 53) ];
			mem[address + 54] <= write_data[ (24*55) - 1 : (24 * 54) ];
			mem[address + 55] <= write_data[ (24*56) - 1 : (24 * 55) ];
			mem[address + 56] <= write_data[ (24*57) - 1 : (24 * 56) ];
			mem[address + 57] <= write_data[ (24*58) - 1 : (24 * 57) ];
			mem[address + 58] <= write_data[ (24*59) - 1 : (24 * 58) ];
			mem[address + 59] <= write_data[ (24*60) - 1 : (24 * 59) ];
			mem[address + 60] <= write_data[ (24*61) - 1 : (24 * 60) ];

			mem[address + 61] <= write_data[ (24*62) - 1 : (24 * 61) ];
			mem[address + 62] <= write_data[ (24*63) - 1 : (24 * 62) ];
			mem[address + 63] <= write_data[ (24*64) - 1 : (24 * 63) ];

		end

		if (read_enable) begin
				read_data[ (24*1)- 1 : (24 * 0) ] <= mem[address + 0]; // q doesn't get d in this clock cycle
				read_data[ (24*2)- 1 : (24 * 1) ] <= mem[address + 1];
				read_data[ (24*3)- 1 : (24 * 2) ] <= mem[address + 2];
				read_data[ (24*4)- 1 : (24 * 3) ] <= mem[address + 3];
				read_data[ (24*5)- 1 : (24 * 4) ] <= mem[address + 4]; 
				read_data[ (24*6)- 1 : (24 * 5) ] <= mem[address + 5];
				read_data[ (24*7)- 1 : (24 * 6) ] <= mem[address + 6];
				read_data[ (24*8)- 1 : (24 * 7) ] <= mem[address + 7];
				read_data[ (24*9)- 1 : (24 * 8) ] <= mem[address + 8];
				read_data[ (24*10)- 1 : (24 * 9) ] <= mem[address + 9];

				read_data[ (24*11)- 1 : (24 * 10) ] <= mem[address + 10];
				read_data[ (24*12)- 1 : (24 * 11) ] <= mem[address + 11];
				read_data[ (24*13)- 1 : (24 * 12) ] <= mem[address + 12];
				read_data[ (24*14)- 1 : (24 * 13) ] <= mem[address + 13];
				read_data[ (24*15)- 1 : (24 * 14) ] <= mem[address + 14];
				read_data[ (24*16)- 1 : (24 * 15) ] <= mem[address + 15];
				read_data[ (24*17)- 1 : (24 * 16) ] <= mem[address + 16];
				read_data[ (24*18)- 1 : (24 * 17) ] <= mem[address + 17];
				read_data[ (24*19)- 1 : (24 * 18) ] <= mem[address + 18];
				read_data[ (24*20)- 1 : (24 * 19) ] <= mem[address + 19];

				read_data[ (24*21)- 1 : (24 * 20) ] <= mem[address + 20];
				read_data[ (24*22)- 1 : (24 * 21) ] <= mem[address + 21];
				read_data[ (24*23)- 1 : (24 * 22) ] <= mem[address + 22];
				read_data[ (24*24)- 1 : (24 * 23) ] <= mem[address + 23];
				read_data[ (24*25)- 1 : (24 * 24) ] <= mem[address + 24];
				read_data[ (24*26)- 1 : (24 * 25) ] <= mem[address + 25];
				read_data[ (24*27)- 1 : (24 * 26) ] <= mem[address + 26];
				read_data[ (24*28)- 1 : (24 * 27) ] <= mem[address + 27];
				read_data[ (24*29)- 1 : (24 * 28) ] <= mem[address + 28];
				read_data[ (24*30)- 1 : (24 * 29) ] <= mem[address + 29];

				read_data[ (24*31)- 1 : (24 * 30) ] <= mem[address + 30];
				read_data[ (24*32)- 1 : (24 * 31) ] <= mem[address + 31];
				read_data[ (24*33)- 1 : (24 * 32) ] <= mem[address + 32];
				read_data[ (24*34)- 1 : (24 * 33) ] <= mem[address + 33];
				read_data[ (24*35)- 1 : (24 * 34) ] <= mem[address + 34];
				read_data[ (24*36)- 1 : (24 * 35) ] <= mem[address + 35];
				read_data[ (24*37)- 1 : (24 * 36) ] <= mem[address + 36];
				read_data[ (24*38)- 1 : (24 * 37) ] <= mem[address + 37];
				read_data[ (24*39)- 1 : (24 * 38) ] <= mem[address + 38];
				read_data[ (24*40)- 1 : (24 * 39) ] <= mem[address + 39];

				read_data[ (24*41)- 1 : (24 * 40) ] <= mem[address + 40];
				read_data[ (24*42)- 1 : (24 * 41) ] <= mem[address + 41];
				read_data[ (24*43)- 1 : (24 * 42) ] <= mem[address + 42];
				read_data[ (24*44)- 1 : (24 * 43) ] <= mem[address + 43];
				read_data[ (24*45)- 1 : (24 * 44) ] <= mem[address + 44];
				read_data[ (24*46)- 1 : (24 * 45) ] <= mem[address + 45];
				read_data[ (24*47)- 1 : (24 * 46) ] <= mem[address + 46];
				read_data[ (24*48)- 1 : (24 * 47) ] <= mem[address + 47];
				read_data[ (24*49)- 1 : (24 * 48) ] <= mem[address + 48];
				read_data[ (24*50)- 1 : (24 * 49) ] <= mem[address + 49];

				read_data[ (24*51)- 1 : (24 * 50) ] <= mem[address + 50];
				read_data[ (24*52)- 1 : (24 * 51) ] <= mem[address + 51];
				read_data[ (24*53)- 1 : (24 * 52) ] <= mem[address + 52];
				read_data[ (24*54)- 1 : (24 * 53) ] <= mem[address + 53];
				read_data[ (24*55)- 1 : (24 * 54) ] <= mem[address + 54];
				read_data[ (24*56)- 1 : (24 * 55) ] <= mem[address + 55];
				read_data[ (24*57)- 1 : (24 * 56) ] <= mem[address + 56];
				read_data[ (24*58)- 1 : (24 * 57) ] <= mem[address + 57];
				read_data[ (24*59)- 1 : (24 * 58) ] <= mem[address + 58];
				read_data[ (24*60)- 1 : (24 * 59) ] <= mem[address + 59];

				read_data[ (24*61)- 1 : (24 * 60) ] <= mem[address + 60];
				read_data[ (24*62)- 1 : (24 * 61) ] <= mem[address + 61];
				read_data[ (24*63)- 1 : (24 * 62) ] <= mem[address + 62];
				read_data[ (24*64)- 1 : (24 * 63) ] <= mem[address + 63];
		end
	end 

endmodule
