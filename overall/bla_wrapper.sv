// $Id: $
// File name:   tb_main_controller.sv
// Created:     4/21/2016
// Author:      Shubham Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Wrapper for BLA and its controller

module bla_wrapper
(
	input wire clk,
	input wire n_rst,
	input wire vertice_num, //number of vertices to draw
	input wire bla_en, //enable to bla wrapper
	input wire [47:0]coordinates, //coordinates to draw
	output wire [4095:0] line_buffer, //line buffer 
	output wire bla_done //bla done flag to Main Controller
);
	wire [7:0] x0; //first x coordinate
	wire [7:0] x1; //first y coordinate
	wire [7:0] y0; //second x coordinate
	wire [7:0] y1; //second y coordinate
	wire draw_en; //draw enable to bla block
	wire draw_done; //done flag from bla block
	wire reset_buff; //reset signal to reset line buffer
//bla port map
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
	.done(draw_done)
);

//bla controller port map
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
