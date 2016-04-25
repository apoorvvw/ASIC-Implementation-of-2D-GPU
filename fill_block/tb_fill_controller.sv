// $Id: $
// File name:   tb_fill_controller.sv
// Created:     4/23/2016
// Author:      Pooja Kale
// Lab Section: 04
// Version:     1.0  Initial Design Entry
// Description: Test Bench


`timescale 1ns / 100ps

module tb_fill_controller();
	localparam CLK_PERIOD = 2.5;
	localparam NUM_CNT_BITS = 4;
	
	//INPUTS
	logic tb_clk;
	logic tb_n_rst;
	logic tb_fill_en;
	logic tb_math_done;
	logic tb_fill_done;
	logic tb_all_finish;
	

	//OUTPUTS
	logic tb_math_start;
	logic tb_row_start; 
	logic tb_fill_start; 
	logic tb_done; 
	

	fill_controller PHIL
	(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
		.fill_en(tb_fill_en),
		.math_done(tb_math_done),
		.fill_done(tb_fill_done),
		.all_finish(tb_all_finish),
		.math_start(tb_math_start),
		.row_start(tb_row_start),
		.fill_start(tb_fill_start), 
		.done(tb_done)
	);
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end
	integer i;
	initial
	begin
		tb_n_rst = 0 ; 
		tb_all_finish = 1'b0; 
		tb_fill_done = 1'b0; 
		#(CLK_PERIOD)
		#(CLK_PERIOD)
		#(CLK_PERIOD)
		tb_n_rst = 1;  
		tb_fill_en = 1'b1; 
		#(CLK_PERIOD)
		#(CLK_PERIOD)
		tb_math_done = 1'b1;
		#(CLK_PERIOD)
		#(CLK_PERIOD)

		#(CLK_PERIOD)
		#(CLK_PERIOD)
		tb_fill_done = 1'b0; 
		#(CLK_PERIOD)
		#(CLK_PERIOD)
		tb_all_finish = 1'b1;
		#(CLK_PERIOD)
		#(CLK_PERIOD)
		#(CLK_PERIOD)
		#(CLK_PERIOD)
		tb_fill_start = 1'b1;
		#(CLK_PERIOD)
		#(CLK_PERIOD)
		#(CLK_PERIOD)
		#(CLK_PERIOD)
		tb_fill_en = 1'b0;
		#(CLK_PERIOD)
		#(CLK_PERIOD)
		#(CLK_PERIOD)
		#(CLK_PERIOD)
		tb_fill_en = 1'b1; 
			
		
	end

endmodule
