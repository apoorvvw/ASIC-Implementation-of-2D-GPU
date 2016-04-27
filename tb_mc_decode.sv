// $Id: $
// File name:   main_controller.sv
// Created:     4/12/2016
// Author:      Shubham Sandeep Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Main Controller of the GPU
`timescale 1ns / 100ps

module tb_mc_decode();

	localparam CLK_PERIOD = 6.0;
	localparam NUM_CNT_BITS = 4;
	logic tb_clk;
	logic tb_n_rst;
	logic [81:0] tb_fifo_data;
	logic tb_config_in;
	logic tb_config_done;
	//logic [47:0] tb_coordinates;
	//logic [3:0] tb_alpha_val;
	//logic [1:0] tb_texture_code;
	//logic [23:0] tb_color_code;
	//logic [1:0] tb_layer_num;
	//logic tb_inst_type;
	//logic tb_fill_type;
	reg x;
	/*decode_block DB
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
	*/
	mc_decode MC_D
	(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
		.fifo_data(tb_fifo_data),
		.config_in(tb_config_in),
		.config_done(tb_config_done)
	);

always
    begin : CLK_GEN
		tb_clk = 1'b0;
		#(CLK_PERIOD / 2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD / 2.0);
    end
    
	initial
	begin
		tb_n_rst = 1'b0;
    		@(negedge tb_clk);
		tb_n_rst = 1'b1;
    		@(negedge tb_clk);
		tb_config_in = 1'b1;	
		@(negedge tb_clk);
		tb_config_in = 1'b0;
		tb_config_done = 1'b1;
		tb_fifo_data = 81'b0101010111111111111111100111111111111111111111111111111111111111111111111110;
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		x = 1;
	end
endmodule
		
		
