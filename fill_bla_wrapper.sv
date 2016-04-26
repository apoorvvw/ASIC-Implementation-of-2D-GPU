// $Id: $
// File name:   fill_bla_wrapper.sv
// Created:     4/25/2016
// Author:      Shubham Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Wrapper for BLA and the fill block

module fill_bla_wrapper
#(
	ADDR_SIZE_BITS = 24,
	WORD_SIZE_BYTES = 3,
	DATA_SIZE_WORDS = 64
	
)
(
	input logic clk,
	input logic n_rst,

	input logic vertice_num, //bw
	input logic [47:0]coordinates, //bw,fill
	input wire inst_type, //mc
	input wire alpha_done, //mc
	input wire fifo_empty, //mc
	input wire config_in, //mc
	input wire config_done, //mc
	input wire fill_type, //fill
	input wire [1:0] texture_code, //fill
	input wire [23:0] color_code, //fill
	input wire layer_num, //fill
	
	output logic read_enable,
	output logic write_enable,
	input logic [((WORD_SIZE_BYTES * DATA_SIZE_WORDS * 8) - 1):0] read_data,
	output logic [((WORD_SIZE_BYTES * DATA_SIZE_WORDS * 8) - 1):0] write_data,
	output reg [(ADDR_SIZE_BITS-1):0] address,
	output reg fill_done,
	output reg bla_done,
	output reg [4095:0] line_buffer
	
);

	reg read_en;
	reg alpha_en;
	reg bla_en;
	reg config_en;
	reg fill_en;


	bla_wrapper bla_w
	(
		.clk(clk),
		.n_rst(n_rst),
		.vertice_num(vertice_num), //come from outside
		.bla_en(bla_en), //come from mc
		.coordinates(coordinates), //come from outside
		.line_buffer(line_buffer), //goes to fw
		.bla_done(bla_done) //goes to outside
	);

	main_controller MC
	(
		.clk(clk),
		.n_rst(n_rst),
		.inst_type(inst_type), //come from outside
		.alpha_done(alpha_done), //come from outside
		.fifo_empty(fifo_empty), //come from outside
		.bla_done(bla_done), //come from bw
		.config_in(config_in), //come from conf
		.config_done(config_done), //come from conf
		.fill_done(fill_done), //come from fw
		.read_en(read_en), //goes to FIFO
		.alpha_en(alpha_en), //goes to alp
		.bla_en(bla_en), //goes to bw
		.config_en(config_en), //goes to conf
		.fill_en(fill_en) //goes to fill
	); 

	fill_wrapper FW
	(
		.clk(clk),
		.n_rst(n_rst),
		.fill_en(fill_en),//come from mc
		.done(fill_done), //goes to mc
		.fill_type(fill_type), //come from outside
		
		.coordinates(coordinates), //come from outside
		.texture_code(texture_code), //come from outside
		.color_code(color_code), //come from outside
		.layer_num(layer_num), //come from outside
		.line_buffer(line_buffer), //come from outside
	
		.read_enable(read_enable), //goes to outside
		.write_enable(write_enable), //goes to outside
		.address(address), //goes to outside
		.read_data(read_data), //come from outside
		.write_data(write_data) //goes to outside
	);

endmodule
