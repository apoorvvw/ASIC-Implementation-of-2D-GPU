// $Id: $
// File name:   tb_rx_fifo.sv
// Created:     2/24/2016
// Author:      Shubham Sandeep Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: fifo test bench

`timescale 1ns / 10ps

module tb_rx_fifo();
	localparam CLK_PERIOD = 10.4;
	localparam NUM_CNT_BITS = 4;
	reg tb_clk;
	reg tb_n_rst;
	reg tb_r_enable;
	reg tb_w_enable;
	reg [7:0] tb_w_data;
	reg [7:0] tb_r_data;
	reg tb_empty;
	reg tb_full;
	rx_fifo DUT
	(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
		.r_enable(tb_r_enable),
		.w_enable(tb_w_enable),
		.w_data(tb_w_data),
		.r_data(tb_r_data),
		.empty(tb_empty),
		.full(tb_full)
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
		tb_n_rst = 1'b1;
		//Test 1
		tb_w_enable = 1'b1;
		#1
		tb_w_data = 8'b11111111;
		@(posedge tb_clk);
		tb_w_enable = 1'b0;
		tb_r_enable = 1'b1;
		#1
		if(tb_r_data == 8'b11111111)
		begin
			$info("Test 1 passed");
		end
		else
		begin
			$error("Test 1 failed");	
		end
		//Test 2
		tb_w_enable = 1'b1;
		#1
		tb_w_data = 8'b11111111;
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		#1
		tb_w_data = 8'b11111110;
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		#1
		tb_w_data = 8'b11111101;
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		#1
		tb_w_data = 8'b11111100;
		@(posedge tb_clk);
		tb_w_enable = 1'b0;
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		if(tb_r_data == 8'b11111100)
		begin
			$info("Test 2 passed");
		end
		else
		begin
			$error("Test 2 failed");	
		end
		//Test 3
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111111;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111110;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111101;
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111100;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111011;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111010;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111001;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11110111;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b0;
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;	
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		if(tb_r_data == 8'b11110111)
		begin
			$info("Test 3 passed");
		end
		else
		begin
			$error("Test 3 failed");	
		end
		//Test 4
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111111;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111110;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111101;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111100;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111011;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111010;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111001;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11110111;
		#10
		@(posedge tb_clk);
		if(tb_full == 1'b1)
		begin
			$info("Test 4 passed");
		end
		else
		begin
			$error("Test 4 failed");
		end
		tb_w_enable = 1'b0;
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		//Test 5
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111111;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111110;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111101;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111100;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111011;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111010;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111001;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11110111;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b0;
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#10
		if(tb_empty == 1'b1)
		begin
			$info("Test 5 passed");
		end
		else
		begin
			$error("Test 5 failed");
		end	
		//Test 6
		tb_w_enable = 1'b1;
		#1
		tb_w_data = 8'b11111111;
		@(posedge tb_clk);
		tb_w_enable = 1'b0;
		tb_n_rst = 1'b0;
		tb_r_enable = 1'b1;
		#1
		if(tb_r_data == 8'b00000000)
		begin
			$info("Test 6 passed");
		end
		else
		begin
			$error("Test 6 failed");	
		end
		tb_n_rst = 1'b1;
		//Test 1
		tb_w_enable = 1'b1;
		#1
		tb_w_data = 8'b11111111;
		@(posedge tb_clk);
		tb_w_enable = 1'b0;
		tb_r_enable = 1'b1;
		#1
		if(tb_r_data == 8'b11111111)
		begin
			$info("Test 1 passed");
		end
		else
		begin
			$error("Test 1 failed");	
		end
		//Test 2
		tb_w_enable = 1'b1;
		#1
		tb_w_data = 8'b11111111;
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		#1
		tb_w_data = 8'b11111110;
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		#1
		tb_w_data = 8'b11111101;
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		#1
		tb_w_data = 8'b11111100;
		@(posedge tb_clk);
		tb_w_enable = 1'b0;
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		if(tb_r_data == 8'b11111100)
		begin
			$info("Test 2 passed");
		end
		else
		begin
			$error("Test 2 failed");	
		end
		//Test 3
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111111;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111110;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111101;
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111100;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111011;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111010;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111001;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11110111;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b0;
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;	
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		if(tb_r_data == 8'b11110111)
		begin
			$info("Test 3 passed");
		end
		else
		begin
			$error("Test 3 failed");	
		end
		//Test 4
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111111;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111110;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111101;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111100;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111011;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111010;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111001;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11110111;
		#10
		@(posedge tb_clk);
		if(tb_full == 1'b1)
		begin
			$info("Test 4 passed");
		end
		else
		begin
			$error("Test 4 failed");
		end
		tb_w_enable = 1'b0;
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		//Test 5
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111111;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111110;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111101;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111100;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111011;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111010;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11111001;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b1;
		tb_w_data = 8'b11110111;
		#1
		@(posedge tb_clk);
		tb_w_enable = 1'b0;
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#10
		if(tb_empty == 1'b1)
		begin
			$info("Test 5 passed");
		end
		else
		begin
			$error("Test 5 failed");
		end	
		//Test 6
		tb_w_enable = 1'b1;
		#1
		tb_w_data = 8'b11111111;
		@(posedge tb_clk);
		tb_w_enable = 1'b0;
		tb_n_rst = 1'b0;
		tb_r_enable = 1'b1;
		#1
		if(tb_r_data == 8'b00000000)
		begin
			$info("Test 6 passed");
		end
		else
		begin
			$error("Test 6 failed");	
		end
		#1
		tb_w_enable = 1'b0;
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#1
		@(posedge tb_clk);
		tb_r_enable = 1'b1;
		#10
		if(tb_empty == 1'b1)
		begin
			$info("Test 5 passed");
		end
		else
		begin
			$error("Test 5 failed");
		end	
	end
endmodule
