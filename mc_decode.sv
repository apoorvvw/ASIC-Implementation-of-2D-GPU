// $Id: $
// File name:   main_controller.sv
// Created:     4/12/2016
// Author:      Shubham Sandeep Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Main Controller of the GPU

module mc_decode
(
	input logic clk,
	input logic n_rst,
	input logic [81:0] fifo_data,
	input logic config_in,
	input logic config_done
);
	reg inst_type;
	reg alpha_done;
	reg fifo_empty;
	reg bla_done;
	
	reg fill_done;
	reg read_en;
	reg alpha_en;
	reg bla_en;
	reg config_en;
	reg fill_en;
	reg [47:0] coordinates;
	reg [3:0] alpha_val;
	reg [1:0] texture_code;
	reg [23:0] color_code;
	reg layer_num;
	reg vertice_num;
	reg fill_type;

main_controller MC
(
	.clk(clk),
	.n_rst(n_rst),
	.inst_type(inst_type), //comes from decode
	.alpha_done(alpha_done), //comes from alpha
	.fifo_empty(fifo_empty), //comes from FIFO
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

decode_block DECODE
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

endmodule
