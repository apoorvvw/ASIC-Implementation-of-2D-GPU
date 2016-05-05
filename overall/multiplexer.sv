// $Id: $
// File name:   mutli_read.sv
// Created:     4/26/2016
// Author:      Yudi Wu
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Multiplexer for several signals go to SRAM

module multiplexer
(
	input logic alpha_en, // This signal selects which block controls the SRAM 
	
	input wire read_enable1,
	input wire write_enable1,
	input wire [18:0] address1,
	input wire [1535:0]write_data1,
	
	input wire read_enable2,
	input wire write_enable2,
	input wire [18:0] address2,
	input wire [1535:0]write_data2,
		
	output wire read_enable,
	output wire [18:0]address,
	output wire [1535:0]write_data,
	output wire write_enable

);

	/*
		
		The deisgn uses Multiplexers to make sure that SRAM gets only one set 
		of enabale signals so same signal does not conflict

		This Multiplexer seperates Fill and alpha signal
	*/

	assign read_enable = (alpha_en) ? read_enable1 : read_enable2;
	assign write_enable = (alpha_en) ? write_enable1 : write_enable2;
	assign address = (alpha_en) ? address1 : address2;
	assign write_data = (alpha_en) ? write_data1 : write_data2;



endmodule
