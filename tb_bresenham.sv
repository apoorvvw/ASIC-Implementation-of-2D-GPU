`timescale 1ns / 100ps

module tb_bresenham();
	localparam CLK_PERIOD = 2.5;
	localparam NUM_CNT_BITS = 4;
	
	//INPUTS
	logic tb_clk;
	logic tb_n_rst;
	logic [7:0]tb_x0;
	logic [7:0]tb_y0;
	logic [7:0]tb_x1;
	logic [7:0]tb_y1;
	logic tb_start;
	//OUTPUTS
	logic tb_x;	
	logic tb_y;
	logic [4159:0] tb_line_buffer;
	logic tb_done;
	
	bresenham BH
	(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
		.x0(tb_x0),
		.y0(tb_y0),
		.x1(tb_x1),
		.y1(tb_y1),
		.start(tb_start),
		.x(tb_x),
		.y(tb_y), 
		.line_buffer(tb_line_buffer), 
		.done(tb_done) 
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
		
	end

endmodule
		
	
	
