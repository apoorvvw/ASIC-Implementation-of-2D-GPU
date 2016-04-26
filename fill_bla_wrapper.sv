// $Id: $
// File name:   fill_bla_wrapper.sv
// Created:     4/25/2016
// Author:      Shubham Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Wrapper for BLA and the fill block

module fill_bla_wrapper
(
	input logic clk,
	input logic n_rst,
	input logic vertice_num,
	input logic [47:0]coordinates,
	input wire inst_type,
	input wire alpha_done,
	input wire fifo_empty,
	input wire config_in,
	input wire config_done,
	input wire fill_type,
	input wire [1:0] texture_code,
	input wire [23:0] color_code,
	input wire layer_num,
	input wire [23:0] init_file_number,
	input wire [23:0] dump_file_number,
	input wire mem_clr,
	input wire mem_init,
	input wire mem_dump,
	input wire [23:0] start_address,
	input wire [23:0] last_address,
	input wire verbose,
	output reg done,
	output reg bla_done
	
);

	reg read_en;
	reg alpha_en;
	reg bla_en;
	reg config_en;
	reg fill_en;
	reg fill_done;
	reg [4095:0] line_buffer;

bla_wrapper bla_w
(
	.clk(clk),
	.n_rst(n_rst),
	.vertice_num(vertice_num),
	.bla_en(bla_en),
	.coordinates(coordinates),
	.line_buffer(line_buffer),
	.bla_done(bla_done)
);

main_controller MC
(
	.clk(clk),
	.n_rst(n_rst),
	.inst_type(inst_type),
	.alpha_done(alpha_done),
	.fifo_empty(fifo_empty),
	.bla_done(bla_done),
	.config_in(config_in),
	.config_done(config_done),
	.fill_done(fill_done),
	.read_en(read_en),
	.alpha_en(alpha_en),
	.bla_en(bla_en),
	.config_en(config_en),
	.fill_en(fill_en)
);

fill_wrapper FILL_W
(
	.clk(clk),
	.n_rst(n_rst),
	.fill_en(fill_en),
	.done(done),
	.fill_type(fill_type),
	.coordinates(coordinates),
	.texture_code(texture_code),
	.color_code(color_code),
	.layer_num(layer_num),
	.line_buffer(line_buffer),
	.init_file_number(init_file_number),
	.dump_file_number(dump_file_number),
	.mem_clr(mem_clr),
	.mem_init(mem_init),
	.mem_dump(mem_dump),
	.start_address(start_address),
	.last_address(last_address),
	.verbose(verbose)
	
);

endmodule
