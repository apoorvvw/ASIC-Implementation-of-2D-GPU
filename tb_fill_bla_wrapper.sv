// $Id: $
// File name:   tb_fill_bla_wrapper.sv
// Created:     4/25/2016
// Author:      Shubham Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description:  testbench for the wrapper for BLA and the fill block

`timescale 1ns / 100ps

module tb_fill_bla_wrapper();
	
	localparam CLK_PERIOD = 2.5;
	localparam NUM_CNT_BITS = 4;
	logic tb_clk;
	logic tb_n_rst;
	logic tb_vertice_num;
	logic [47:0] tb_coordinates;
	logic tb_inst_type;
	logic tb_alpha_done;
	logic tb_fifo_empty;
	logic tb_config_in;
	logic tb_config_done;
	logic tb_fill_type;
	logic [1:0] tb_texture_code;
	logic [23:0] tb_color_code;
	logic tb_layer_num; 
	logic [23:0] tb_init_file_number;
	logic [23:0] tb_dump_file_number;
	logic tb_mem_clr;
	logic tb_mem_init;
	logic tb_mem_dump;
	logic [23:0] tb_start_address;
	logic [23:0] tb_last_address;
	logic tb_verbose;
	logic tb_done;
	logic tb_bla_done;

	reg [7:0] x0;
	reg [7:0] y0;
	reg [7:0] x1;
	reg [7:0] y1;
	reg [7:0] x2;
	reg [7:0] y2;

fill_bla_wrapper FBW
(
	.clk(tb_clk),
	.n_rst(tb_n_rst),
	.vertice_num(tb_vertice_num),
	.coordinates(tb_coordinates),
	.inst_type(tb_inst_type),
	.alpha_done(tb_alpha_done),
	.fifo_empty(tb_fifo_empty),
	.config_in(tb_config_in),
	.config_done(tb_config_done),
	.fill_type(tb_fill_type),
	.texture_code(tb_texture_code),
	.color_code(tb_color_code),
	.layer_num(tb_layer_num),
	.init_file_number(tb_init_file_number),
	.dump_file_number(tb_dump_file_number),
	.mem_clr(tb_mem_clr),
	.mem_init(tb_mem_init),
	.mem_dump(tb_mem_dump),
	.start_address(tb_start_address),
	.last_address(tb_last_address),
	.verbose(tb_verbose),
	.done(tb_done),
	.bla_done(tb_bla_done)
);
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end
	initial
	begin
		tb_n_rst = 1'b0;
		@(negedge tb_clk);
		tb_n_rst = 1'b1;
		@(negedge tb_clk);
		tb_mem_clr = 0;//default, do not change its value
		tb_mem_init = 0;//default, do not change its value
		tb_mem_dump = 0;//default, do not change its value
		tb_verbose = 0;//default, do not change its value
		tb_init_file_number = 0;//default, do not change its value
		tb_dump_file_number = 0;//default, do not change its value
		tb_start_address = 0;//default, do not change its value
		tb_last_address = 0;//default, do not change its value
		tb_config_in = 1'b1;
		@(negedge tb_clk);
		tb_config_in = 1'b0;
		tb_config_done = 1'b1;
		@(negedge tb_clk);
		tb_config_done = 1'b0;
		@(negedge tb_clk);
		tb_inst_type = 1'b0;
		tb_vertice_num = 1'b1;
		x0 = 8'd0;
		y0 = 8'd0;
		x1 = 8'd23;
		y1 = 8'd23;
		x2 = 8'd0;
		y2 = 8'd23;
		tb_coordinates = {y2, x2, y1, x1, y0, x0};
		tb_layer_num = 1'b0;
		tb_fill_type = 1'b0;
		tb_color_code = '1;
		tb_texture_code = '0;	
		@(negedge tb_clk);
		while(1 == 1)
		begin
			if(tb_bla_done == 1'b1)
				break;
			else
				@(negedge tb_clk);
		end
		@(negedge tb_clk);
		while(1 == 1)
		begin
			if(tb_done == 1'b1)
				break;
			else
				@(negedge tb_clk);
		end
		@(negedge tb_clk);
		tb_fifo_empty = 1'b1;
	end
endmodule
		
	
