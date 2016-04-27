// $Id: $
// File name:   tb_main_controller.sv
// Created:     4/21/2016
// Author:      Shubham Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Wrapper for Alpha, fill, BLA and decode

module alpha_fill_bla_wrapper
(
	input logic clk,
	input logic n_rst,
	input logic [81:0] fifo_data,
	input logic [1535:0] read_data,
	output logic [1535:0] write_data,
	output logic [23:0] address,
	output logic read_enable,
	output logic write_enable,
	
);

	reg [47:0] coordinates;
	reg alpha_val[3:0];
	reg texture_code[1:0];
	reg color_code[23:0];
	reg layer_num;
	reg vertice_num;
	reg inst_type;
	reg fill_type;
	reg read_en;
	reg alpha_en;
	reg bla_en;
	reg config_en;
	reg fill_en;
	reg [4095:0] line_buffer;

decode DECODE
(
	.fifo_data(fifo_data),
	.coordinates(coordinates),
	.alpha_val(alpha_val),
	.texture_code(texture_code),
	.color_code(color_code),
	.layer_num(layer_num),
	.vertice_num(vertice_num),
	.inst_type(inst_type),
	.fill_type(fill_type)
);

main_controller MC
(
	.clk(clk),
	.n_rst(n_rst),
	.inst_type(inst_type), //comes from outside
	.alpha_done(alpha_done), //comes from outside
	.fifo_empty(fifo_empty), //comes from outside
	.bla_done(bla_done), //comes from bw
	.config_in(config_in), //comes from conf
	.config_done(config_done), //comes from conf
	.fill_done(fill_done), //comes from fw
	.read_en(read_en), //goes to FIFO
	.alpha_en(alpha_en), //goes to alp
	.bla_en(bla_en), //goes to bw
	.config_en(config_en), //goes to conf
	.fill_en(fill_en) //goes to fill
);

bla_wrapper BLA_W
(
	.clk(clk),
	.n_rst(n_rst),
	.vertice_num(vertice_num), //come from outside
	.bla_en(bla_en), //come from mc
	.coordinates(coordinates), //come from outside
	.line_buffer(line_buffer), //goes to fw
	.bla_done(bla_done) //goes to outside
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
