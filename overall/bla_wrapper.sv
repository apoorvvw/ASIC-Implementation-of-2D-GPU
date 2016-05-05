// $Id: $
// File name:   tb_bla_wrapper.sv
// Created:     4/21/2016
// Author:      Shubham Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Wrapper for BLA and its controller

module bla_wrapper
(
	input wire clk,
	input wire n_rst,
	
	input wire vertice_num,
	input wire bla_en,
	input wire [47:0]coordinates,
	
	output wire [4095:0] line_buffer,
	output wire bla_done
);
	wire [7:0] x0;
	wire [7:0] x1;
	wire [7:0] y0;
	wire [7:0] y1;
	wire draw_en;
	wire draw_done;
	wire reset_buff;
//	wire [63:0] [63:0] picture;
bresenham BLA
(
	.clk(clk),
	.n_rst(n_rst),
	.x0(x0),
	.y0(y0),
	.x1(x1),
	.y1(y1),
	.start(draw_en),
	.reset_buff(reset_buff),
	.line_buffer(line_buffer),
//	.picture(picture),
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
