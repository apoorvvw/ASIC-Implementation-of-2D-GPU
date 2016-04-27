	// $Id: $
// File name:   fill_wrapper.sv
// Created:     4/23/2016
// Author:      Yudi Wu
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: the wrapper for the fill block

//The fill at this stage wouldn't be able to fill in textures

module fill_wrapper
#(
	ADDR_SIZE_BITS = 24,
	WORD_SIZE_BYTES = 3,
	DATA_SIZE_WORDS = 64
	
)
(
	input wire clk,
	input wire n_rst,
	input wire fill_en,
	output wire done,
	input logic fill_type,
	
	input logic [47:0] coordinates,
	input logic [1:0] texture_code,
	input logic [23:0] color_code,
	input logic layer_num,
	input logic [4095:0] line_buffer,
	
	output logic read_enable,
	output logic write_enable,
	input logic [((WORD_SIZE_BYTES * DATA_SIZE_WORDS * 8) - 1):0] read_data,
	output logic [((WORD_SIZE_BYTES * DATA_SIZE_WORDS * 8) - 1):0] write_data,
	output reg [(ADDR_SIZE_BITS-1):0] address

);

	
	reg math_start;
	reg row_start;
	reg fill_start, fill_done;
	reg all_finish;

	fill_controller FILL_CTR
	(
		.clk(clk),
		.n_rst(n_rst),
		.fill_en(fill_en),
		.all_finish(all_finish),
		.math_start(math_start),
		.row_start(row_start),
		.fill_start(fill_start),
		.fill_done(fill_done),
		.done(done)
	);

	
	fill_block FILL
	(
		.clk(clk),
		.n_rst(n_rst),
		.fill_type(fill_type),

		.coordinates(coordinates),
		.texture_code(texture_code),
		.color_code(color_code),
		.layer_num(layer_num),
		.line_buffer(line_buffer),
		
		.math_start(math_start),
		.row_start(row_start),
		.fill_start(fill_start),
		.fill_done(fill_done),
		.all_finish(all_finish),
		
		.read_enable(read_enable),
		.write_enable(write_enable),
		.read_data(read_data),
		.write_data(write_data),
		.address(address)

	);
	



endmodule
