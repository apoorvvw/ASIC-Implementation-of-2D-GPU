// $Id: $
// File name:   tb_main_controller.sv
// Created:     4/21/2016
// Author:      Shubham Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Wrapper for BLA and its controller

module bla_wrapper
(
	input logic clk,
	input logic n_rst,
	input logic vertice_num,
	input logic bla_en,
	input logic [47:0]coordinates,
	output logic [4095:0] line_buffer,
	output logic bla_done
);
	reg [7:0] x0;
	reg [7:0] x1;
	reg [7:0] y0;
	reg [7:0] y1;
	reg draw_en;
	reg x;
	reg y;
	reg draw_done;
	reg reset_buff;
	reg [63:0] [63:0] picture;
bresenham BLA
(
	.clk(clk),
	.n_rst(n_rst),
	.x0(x0),
	.y0(y0),
	.x1(x1),
	.y1(y1),
	.start(draw_en),
	.x(x),
	.y(y),
	.reset_buff(reset_buff),
	.line_buffer(line_buffer),
	.picture(picture),
	.done(draw_done)
);

bresenham_controller BLA_CTRL
(
	.clk(clk),
	.n_rst(n_rst),
	.draw_done(draw_done),
	.bla_en(bla_en),
	.vertice_num(vertice_num),
	.coordinates(coordinates),
	.reset_buff(reset_buff),
	.x0(x0),
	.y0(y0),
	.x1(x1),
	.y1(y1),
	.draw_en(draw_en),
	.bla_done(bla_done)
);
endmodule
