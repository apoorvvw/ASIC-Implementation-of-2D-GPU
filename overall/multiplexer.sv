// $Id: $
// File name:   mutli_read.sv
// Created:     4/26/2016
// Author:      Yudi Wu
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Multiplexer for several signals go to SRAM

module mutliplexer.sv
(
	input wire alpha_en,
	input wire fill_en,
	input wire f_read_enable,
	input wire f_write_enable,
	input wire [23:0] f_address,
	input wire [1535:0]f_write_data,
	input wire a_read_enable,
	input wire [23:0] a_address,
	output wire read_enable,
	output wire [23:0]address,
	output wire [1535:0]write_data,
	output wire write_enable

);
	always_comb
	begin
		read_enable = 0;
		write_enable = 0;
		address = '0;
		wrire_data = '0;
		if(alpha_en) begin
			read_enable = a_read_enable;
			address = a_address;
		end else if (fill_en) begin
			read_enable = f_read_enable;
			write_enable = f_write_enable;
			address = f_address;
			write_data = f_write_data;	
		end
	
	end



endmodule
