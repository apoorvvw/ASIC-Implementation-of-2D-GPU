// $Id: $
// File name:   Bresenham_Controller.sv
// Created:     4/24/2016
// Author:      Shubham Sandeep Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: test bench bla wrapper

`timescale 1ns / 100ps

module tb_bla_wrapper();
	localparam CLK_PERIOD = 2.5;
	localparam NUM_CNT_BITS = 4;
	logic tb_clk;
	logic tb_n_rst;
	logic tb_vertice_num;
	logic tb_bla_en;
	logic [47:0] tb_coordinates;
	logic [4095:0] tb_line_buffer;
	logic tb_bla_done;

integer i;
	reg [7:0] x0;
	reg [7:0] y0;
	reg [7:0] x1;
	reg [7:0] y1;
	reg [7:0] x2;
	reg [7:0] y2;

bla_wrapper BLA_W
(
	.clk(tb_clk),
	.n_rst(tb_n_rst),
	.vertice_num(tb_vertice_num),
	.bla_en(tb_bla_en),
	.coordinates(tb_coordinates),
	.line_buffer(tb_line_buffer),
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
		tb_bla_en = 1'b1;
		tb_vertice_num = 1'b1;
		x0 = 8'd10;
		y0 = 8'd12;
		x1 = 8'd69;
		y1 = 8'd45;
		x2 = 8'd24;
		y2 = 8'd25;
		tb_coordinates = {y2, x2, y1, x1, y0, x0};
		@(negedge tb_clk);
		@(negedge tb_clk);
		/*if(tb_draw_en == 1'b1 && tb_bla_done == 1'b0 && tb_x0 == 8'd0 && tb_y0 == 8'd0 && tb_x1 == 8'b11111111 && tb_y1 == 8'b11111111)
			$info("Draw 3 1 looks good");
		else
			$error("Not good for draw 3 1");*/
		@(negedge tb_clk);
		/*if(tb_draw_en == 1'b0 && tb_bla_done == 1'b0 && tb_x0 == 8'd0 && tb_y0 == 8'd0 && tb_x1 == 8'd0 && tb_y1 == 8'b0)
			$info("In draw 3 1 wait state");
		else
			$error("Not in draw 3 1 wait state");*/
		@(negedge tb_clk);
		/*if(tb_draw_en == 1'b1 && tb_bla_done == 1'b0 && tb_x0 == 8'd0 && tb_y0 == 8'd0 && tb_x1 == 8'b01010101 && tb_y1 == 8'b0101010101)
			$info("Draw 3 2 looks good");
		else
			$error("Not good for draw 3 2");*/
		@(negedge tb_clk);
		/*if(tb_draw_en == 1'b0 && tb_bla_done == 1'b0 && tb_x0 == 8'd0 && tb_y0 == 8'd0 && tb_x1 == 8'd0 && tb_y1 == 8'b0)
			$info("In draw 3 2 wait state");
		else
			$error("Not in draw 3 2 wait state");*/
		@(negedge tb_clk);
		/*if(tb_draw_en == 1'b1 && tb_bla_done == 1'b0 && tb_x0 == 8'b11111111 && tb_y0 == 8'b11111111 && tb_x1 == 8'b01010101 && tb_y1 == 8'b0101010101)
			$info("Draw 3 3 looks good");
		else
			$error("Not good for draw 3 3");*/
		@(negedge tb_clk);
		/*if(tb_draw_en == 1'b0 && tb_bla_done == 1'b1 && tb_x0 == 8'd0 && tb_y0 == 8'd0 && tb_x1 == 8'd0 && tb_y1 == 8'b0)
			$info("In done state");
		else
			$error("Not in done state");*/
		@(negedge tb_clk);
		/*if(tb_draw_en == 1'b0 && tb_bla_done == 1'b0 && tb_x0 == 8'd0 && tb_y0 == 8'd0 && tb_x1 == 8'd0 && tb_y1 == 8'b0)
			$info("In done wait state");
		else
			$error("Not in done wait state");*/
		@(negedge tb_clk);
	/*	if(tb_draw_en == 1'b0 && tb_bla_done == 1'b0 && tb_x0 == 8'd0 && tb_y0 == 8'd0 && tb_x1 == 8'd0 && tb_y1 == 8'b0)
			$info("In idle state");
		else
			$error("Not in idle state");*/
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		i = 0;
	end
endmodule
