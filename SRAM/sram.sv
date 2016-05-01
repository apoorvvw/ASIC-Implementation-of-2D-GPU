// $Id: $
// File name:   sram.sv
// Created:     5/24/2016
// Author:      Apoorv Vijay Wairagade
// Lab Section: 5
// Version:     1.0  Initial Design Entry
// Description: A simple on-chip sram.

// NEED : 208,896 * 24 = 5 mil

//  MAX : 1,048,576
// DIV1 : 0000000 to   41,799 //1,002,000
// DIV2 : 41,800.0 to  83,558
// DIV3 : 83,559.0 to 125,337
// DIV3 : 125,338 to 167,116
// DIV4 : 167,117 to 208895
module sram (

	input clk,
	input [((64*24) - 1):0] write_data,
	input [(18 - 1):0] address,
	input write_enable,
	input read_enable,	
	input reset,

	output reg [(64*24 - 1):0] read_data
);
	//reg [41799:0][23:0]mem;
	reg [41799:0][23:0]mem1;
	reg [41799:0][23:0]mem2;
	reg [41799:0][23:0]mem3;
	reg [41799:0][23:0]mem4;
	reg [41799:0][23:0]mem5;
	//reg [208895:0][23:0]mem;
	logic i;
	
	always @ (posedge clk) begin
		if (reset) begin
			mem1 = '1;
			mem2 = '1;
			mem3 = '1;
			mem4 = '1;
			mem5 = '1;
			//mem = '1;
		end
		if (write_enable) begin
			for( i = 0 ; i <= 63 ; i++)
			begin
				if((address + i) <= 41799)
					mem1[address + i] <= write_data[ (24*i)+:24 ];
				else if((address + i) > 41799 && (address + i) <= 83558)
					mem2[address + i] <= write_data[ (24*i)+:24 ];
				else if((address + i) > 83588 && (address + i) <= 125337)
					mem3[address + i] <= write_data[ (24*i)+:24 ];
				else if((address + i) > 125337 && (address + i) <= 167116)
					mem4[address + i] <= write_data[ (24*i)+:24 ];
				else
					mem5[address + i] <= write_data[ (24*i)+:24 ];
			end

		end

		if (read_enable) begin
			for( i = 0 ; i <= 63 ; i++)
			begin
				if((address + i) <= 41799)
					read_data[(24*i)+:24] <= mem1[address + i];
				else if((address + i) > 41799 && (address + i) <= 83558)
					read_data[(24*i)+:24] <= mem2[address + i];
				else if((address + i) > 83588 && (address + i) <= 125337)
					read_data[(24*i)+:24] <= mem3[address + i];
				else if((address + i) > 125337 && (address + i) <= 167116)
					read_data[(24*i)+:24] <= mem4[address + i];
				else
					read_data[(24*i)+:24] <= mem5[address + i];
			end
	end

	//$display("%h %h %h\n", mem[41647] , mem[2640] , mem[2641]);

	end 

endmodule
