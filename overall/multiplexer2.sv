// $Id: $
// File name:   mutli_read.sv
// Created:     4/26/2016
// Author:      Yudi Wu
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Multiplexer for several signals go to SRAM

module multiplexer2
(
	input logic init,
	
	input logic f_read_enable,
	input logic f_write_enable,
	input logic [23:0] f_address,
	input logic [1535:0]f_write_data,
	
	input logic a_read_enable,
	input logic a_write_enable,
	input logic [23:0] a_address,
	input logic [1535:0]a_write_data,
		
	output logic read_enable,
	output logic [23:0]address,
	output logic [1535:0]write_data,
	output logic write_enable
	

);
	always_comb
	begin
		read_enable = 0;
		write_enable = 0;
		address = '0;
		write_data = '0;
		if(init) begin
			read_enable = a_read_enable;
			write_enable = a_write_enable;
			address = a_address;
			write_data = a_write_data;
		end else  begin
			read_enable = f_read_enable;
			write_enable = f_write_enable;
			address = f_address;
			write_data = f_write_data;	
		end
	
	end



endmodule
