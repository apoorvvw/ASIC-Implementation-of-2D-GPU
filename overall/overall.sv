// $Id: $
// File name:   tb_main_controller.sv
// Created:     4/21/2016
// Author:      Shubham Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Wrapper for the overall design

module overall
(
	input wire clk,
	input wire n_rst,
	
	//sram signals
	input wire [1535:0] read_data,
	output wire [1535:0] write_data,
	output wire [18:0] address,
	output wire read_enable,
	output wire write_enable,
	
	//FIFO signals
	input wire [81:0] fifo_data,
	input wire fifo_empty,
	
	//config signals
	input wire config_in,
	input wire config_done,
	output wire config_en,
	
	output wire bla_done,
	output wire fill_done,
	output wire alpha_done
);
	
	wire [47:0] coordinates;
	wire [3:0] alpha_val;
	wire [1:0] texture_code;
	wire [23:0] color_code;
	wire layer_num;
	wire vertice_num;
	wire inst_type;
	wire fill_type;

	//DECODE BLOCK
	assign inst_type = fifo_data[0];
	assign coordinates = (fifo_data[1]) ? {fifo_data[49:34], fifo_data[33:18], fifo_data[17:2]} : {8'b0, fifo_data[33:18] ,fifo_data[17:2]};
	assign vertice_num = fifo_data[1];
	assign alpha_val = fifo_data[81:78];
	assign layer_num = fifo_data[50];
	assign fill_type = fifo_data[51];
	assign color_code = fifo_data[75:52];
	assign texture_code = fifo_data[77:76];
	

	
	wire read_en; 
	wire alpha_en;
	wire bla_en;
	wire fill_en;
	wire [4095:0] line_buffer;
	wire f_read_enable;
	wire f_write_enable;
	wire [18:0] f_address;
	wire [1535:0] f_write_data;
	wire a_read_enable;
	wire a_write_enable;
	wire [18:0] a_address;
	wire [1535:0] a_write_data;
	
	//port map for the main controller
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
	
	//port map for the bresenham wrapper
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

	//port map for the fill block
	fill FW
	(
		.clk(clk),
		.n_rst(n_rst),
		.fill_en(fill_en),//come from mc
		.fill_done(fill_done), //goes to mc
		.fill_type(fill_type), //come from DECODE
		.coordinates(coordinates), //come from DECODE
		.texture_code(texture_code), //come from DECODE
		.vertice_num(vertice_num),
		.color_code(color_code), //come from DECODE
		.layer_num(layer_num), //come from DECODE
		.line_buffer(line_buffer), //come from BLA
		.read_enable(f_read_enable), //goes to sram
		.write_enable(f_write_enable), //goes to sram
		.address(f_address), //goes to sram
		.read_data(read_data), //come from sram
		.write_data(f_write_data) //goes to sram
	);
	
	//port map for the alpha blend block
	alpha_blend ALP
	(
		.clk(clk),
		.n_rst(n_rst),
	   	.alpha_en(alpha_en), //from main controller
	   	.alpha_value(alpha_val), //from decode
	   	.alpha_done(alpha_done), //to the main controller
	   	
	   	.read_enable(a_read_enable), //to the multiplexer
	   	.write_enable(a_write_enable), //from the multiplexer
	   	.address(a_address), //to the sram
		.read_data(read_data), //from sram
		.write_data(a_write_data) //to the sram
	
	); 
	
	//port map for the multiplexer
	multiplexer MUX
	(	
		.alpha_en(alpha_en), //from main controller
		
		.read_enable2(f_read_enable), 
		.write_enable2(f_write_enable),
		.address2(f_address),
		.write_data2(f_write_data),
		.read_enable1(a_read_enable),
		.write_enable1(a_write_enable),
		.address1(a_address),
		.write_data1(a_write_data),
		
		.read_enable(read_enable),
		.write_enable(write_enable),
		.address(address),
		.write_data(write_data)
	
	);
endmodule
