// $Id: $
// File name:   tb_decode.sv
// Created:     4/22/2016
// Author:      Shubham Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Test bench for decode
`timescale 1ns / 100ps

module tb_decode_block ();

	localparam CLK_PERIOD = 2.5;
	localparam NUM_CNT_BITS = 4;
	//logic tb_clk;
	//logic tb_n_rst;
	logic [81:0] tb_fifo_data;
	logic [47:0] tb_coordinates;
	logic [3:0] tb_alpha_val;
	logic [1:0] tb_texture_code;
	logic [23:0] tb_color_code;
	logic [1:0] tb_layer_num;
	logic tb_inst_type;
	logic tb_fill_type;
	
	decode_block DB
	(
		.fifo_data(tb_fifo_data),
		.coordinates(tb_coordinates),
		.texture_code(tb_texture_code),
		.color_code(tb_color_code),
		.layer_num(tb_layer_num),
		.vertice_num(tb_vertice_num),
		.inst_type(tb_inst_type),
		.fill_type(tb_fill_type)
	);
	
	initial
	begin
		tb_fifo_data = 81'b0101010111111111111111100111111111111111111111111111111111111111111111111110;

	end
endmodule
		
		
