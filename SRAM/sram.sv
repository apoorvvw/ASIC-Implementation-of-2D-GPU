// $Id: $
// File name:   sram.sv
// Created:     5/24/2016
// Author:      Apoorv Vijay Wairagade
// Lab Section: 5
// Version:     1.0  Initial Design Entry
// Description: A simple on-chip sram.
 

module sram (
	
	output reg [(24 - 1):0] read_data,

	input [(24 - 1):0] write_data,
	input [(24 - 1):0] address,
	input write_enable,
	input read_enable,
	input clk
);
	reg [23:0] mem [127:0];
	
	always @ (posedge clk) begin
		if (write_enable)
			mem[address] <= write_data;

		if (read_enable)
			read_data <= mem[address]; // q doesn't get d in this clock cycle
	end

endmodule
