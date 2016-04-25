	// $Id: $
// File name:   fill_wrapper.sv
// Created:     4/23/2016
// Author:      Yudi Wu
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: the wrapper for the fill block



module phil
#(
	ADDR_SIZE_BITS = 24,
	WORD_SIZE_BYTES = 3,
	DATA_SIZE_WORDS = 64
	
)
(
	input wire clk,
	input wire n_rst,
	input logic fill_type,
	
	input logic [47:0] coordinates,
	input logic [1:0] texture_code,
	input logic [23:0] color_code,
	input logic layer_num,
	input logic [4095:0] line_buffer,

	input wire math_start,
	input wire row_start,
	input wire fill_start,
	
	input logic [(ADDR_SIZE_BITS-1):0]init_file_number,
	input logic [(ADDR_SIZE_BITS-1):0]dump_file_number,
	input wire mem_clr,
	input wire mem_init,
	input wire mem_dump,
	input logic [(ADDR_SIZE_BITS-1):0]start_address,
	input logic [(ADDR_SIZE_BITS-1):0]last_address,
	input wire verbose,

	output wire fill_done,
	output wire all_finish
	
	
);

	reg read_enable;
	reg write_enable;
	reg [(ADDR_SIZE_BITS-1):0] address;
	reg [((WORD_SIZE_BYTES * DATA_SIZE_WORDS * 8) - 1):0] write_data;
	reg [((WORD_SIZE_BYTES * DATA_SIZE_WORDS * 8) - 1):0] read_data;


	
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
	
	on_chip_sram_wrapper SRAM
	(
		.init_file_number(init_file_number),
		.dump_file_number(dump_file_number),
		.mem_clr(mem_clr),
		.mem_init(mem_init),
		.mem_dump(mem_dump),
		.start_address(start_address),
		.last_address(last_address),
		.verbose(verbose),
		.read_enable(read_enable),
		.write_enable(write_enable),
		.address(address),
		.read_data(read_data),
		.write_data(write_data)

	);







endmodule
