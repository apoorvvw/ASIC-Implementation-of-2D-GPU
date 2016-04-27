// $Id: $
// File name:   tb_main_controller.sv
// Created:     4/21/2016
// Author:      Shubham Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Wrapper for Alpha, fill, BLA and decode

module overall
(
	input logic clk,
	input logic n_rst,
	
	//sram signals
	input logic [1535:0] read_data,
	output logic [1535:0] write_data,
	output logic [23:0] address,
	output logic read_enable,
	output logic write_enable,
	
	//FIFO signals
	input logic [81:0] fifo_data,
	input logic fifo_empty,
	
	//config signals
	input logic config_in,
	input logic config_done,
	output logic config_en,
	
	output logic out //this is the output from the alpha blending, goes to SDRAM
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
	reg fill_en;

	
	reg bla_done;
	reg fill_done;
	reg alpha_done;
	
	logic [4095:0] line_buffer;
	
	logic f_read_enable;
	logic f_write_enable;
	logic [23:0] f_address;
	logic [1535:0] f_write_data;
	logic a_read_enable;
	logic a_write_enable;
	logic [23:0] a_address;
	logic [1535:0] a_write_data;

	/*
	shubham FFIFFO
	(
		.clk(clk),
		.n_rst(n_rst),
		.r_enable(),
		.w_enable(),
		.w_data(),
		.r_data(),
		.empty(),
		.full()

	);
	*/	
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

	bla_wrapper BLA_W
	(
		.clk(clk),
		.n_rst(n_rst),
		.vertice_num(vertice_num), //come from DECODE
		.bla_en(bla_en), //come from mc
		.coordinates(coordinates), //come from DECODE
		.line_buffer(line_buffer), //goes to fw
		.bla_done(bla_done) //goes to MC
	);

	fill_wrapper FW
	(
		.clk(clk),
		.n_rst(n_rst),
		.fill_en(fill_en),//come from mc
		.done(fill_done), //goes to mc
		.fill_type(fill_type), //come from DECODE
		.coordinates(coordinates), //come from DECODE
		.texture_code(texture_code), //come from DECODE
		.color_code(color_code), //come from DECODE
		.layer_num(layer_num), //come from DECODE
		.line_buffer(line_buffer), //come from BLA
		.read_enable(f_read_enable), //goes to sram
		.write_enable(f_write_enable), //goes to sram
		.address(f_address), //goes to sram
		.read_data(read_data), //come from sram
		.write_data(f_write_data) //goes to sram
	);
	
	alpha_blend ALP
	(
		.clk(clk),
		.n_rst(n_rst),
	   	.alpha_en(alpha_en),
	   	.alpha_value(alpha_val),
	   	.alpha_done(alpha_done),
	   	
	   	.read_enable(a_read_enable),
	   	.write_enable(a_write_enable),
	   	.address(a_address),
		.read_data(read_data),
		.write_data(a_write_data)
	
	); 
	
	multiplexer MUX
	(	
		.alpha_en(alpha_en),
		.fill_en(fill_en),
		
		.f_read_enable(f_read_enable),
		.f_write_enable(f_write_enable),
		.f_address(f_address),
		.f_write_data(f_write_data),
		
		.a_read_enable(a_read_enable),
		.f_write_enable(f_write_enable),
		.a_address(a_address),
		.f_write_data(f_write_data),
		
		.read_enable(read_enable),
		.write_enable(write_enable),
		.address(address),
		.write_data(write_data)
	
	);
endmodule
