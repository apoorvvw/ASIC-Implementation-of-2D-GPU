`timescale 1ns / 100ps

module tb_bresenham_controller();
	localparam CLK_PERIOD = 2.5;
	localparam NUM_CNT_BITS = 4;
	logic tb_draw_done;
	logic tb_vertice_num;
	logic tb_bla_en;
	logic [47:0]tb_coordinates;
	logic [7:0]tb_x0;
	logic [7:0]tb_y0;
	logic [7:0]tb_x1;
	logic [7:0]tb_y1;
	logic tb_draw_en;
	logic tb_bla_done;
	logic tb_clk;
	logic tb_n_rst;
	
	bresenham_controller BC
	(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
		.draw_done(tb_draw_done),
		.vertice_num(tb_vertice_num),
		.bla_en(tb_bla_en),
		.coordinates(tb_coordinates),
		.x0(tb_x0),
		.y0(tb_y0),
		.x1(tb_x1),
		.y1(tb_y1),
		.draw_en(tb_draw_en),
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
		//Test case 1
		tb_bla_en = 1'b1;
		tb_vertice_num = 1'b1;
		@(negedge tb_clk);
		@(negedge tb_clk);
		tb_n_rst = 1'b0;
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		tb_n_rst = 1'b1;
		//Test case 2
		tb_bla_en = 1'b1;
		tb_vertice_num = 1'b0;
		@(negedge tb_clk);
		@(negedge tb_clk);
		tb_n_rst = 1'b0;
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		tb_n_rst = 1'b1;
		//Test case 3
		tb_bla_en = 1'b1;
		tb_vertice_num = 1'b0;
		tb_coordinates = 48'b010101010101010111111111111111110000000100000001;
		@(negedge tb_clk);
		@(negedge tb_clk);
		if(tb_draw_en == 1'b0)
			$error("Not in draw state");
		else
			$info("In draw state");
		if(tb_x0 == 8'b00000000 && tb_y0 == 8'b00000000 && tb_x1 == 8'b11111111 && tb_y1 == 8'b11111111)
			$info("Values good");
		else
			$error("Values are wrong");
		tb_n_rst = 1'b0;
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		tb_n_rst = 1'b1;
		//Test case 4
		tb_bla_en = 1'b1;
		tb_vertice_num = 1'b0;
		tb_coordinates = 48'b010101010101010111111111111111110000000100000001;
		@(negedge tb_clk);
		@(negedge tb_clk);
		tb_draw_done = 1'b1;
		@(negedge tb_clk);
		if(tb_draw_en == 1'b0 && tb_bla_done == 1'b0 && tb_x0 == 8'd0 && tb_y0 == 8'd0 && tb_x1 == 8'd0 && tb_y1 == 8'b0)
			$info("In wait state");
		else
			$error("Not in wait state");
		tb_n_rst = 1'b0;
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		tb_n_rst = 1'b1;
		//Test case 5
		tb_bla_en = 1'b1;
		tb_vertice_num = 1'b0;
		tb_coordinates = 48'b010101010101010111111111111111110000000100000001;
		@(negedge tb_clk);
		@(negedge tb_clk);
		tb_draw_done = 1'b1;
		@(negedge tb_clk);
		@(negedge tb_clk);
		if(tb_draw_en == 1'b0 && tb_bla_done == 1'b1 && tb_x0 == 8'd0 && tb_y0 == 8'd0 && tb_x1 == 8'd0 && tb_y1 == 8'b0)
			$info("In done state");
		else
			$error("Not in done state");
		tb_n_rst = 1'b0;
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		tb_n_rst = 1'b1;
		//Test case 6
		tb_bla_en = 1'b1;
		tb_vertice_num = 1'b0;
		tb_coordinates = 48'b010101010101010111111111111111110000000100000001;
		@(negedge tb_clk);
		@(negedge tb_clk);
		tb_draw_done = 1'b1;
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		if(tb_draw_en == 1'b0 && tb_bla_done == 1'b0 && tb_x0 == 8'd0 && tb_y0 == 8'd0 && tb_x1 == 8'd0 && tb_y1 == 8'b0)
			$info("In done wait state");
		else
			$error("Not in done wait state");
		tb_n_rst = 1'b0;
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		tb_n_rst = 1'b1;
		//Test case 7
		tb_bla_en = 1'b1;
		tb_vertice_num = 1'b0;
		tb_coordinates = 48'b010101010101010111111111111111110000000100000001;
		@(negedge tb_clk);
		@(negedge tb_clk);
		tb_draw_done = 1'b1;
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		if(tb_draw_en == 1'b0 && tb_bla_done == 1'b0 && tb_x0 == 8'd0 && tb_y0 == 8'd0 && tb_x1 == 8'd0 && tb_y1 == 8'b0)
			$info("In idle state");
		else
			$error("Not in idle state");
		tb_n_rst = 1'b0;
		@(negedge tb_clk);
		@(negedge tb_clk);
		@(negedge tb_clk);
		tb_n_rst = 1'b1;
		
		//Test Case 8
		tb_bla_en = 1'b1;
		tb_vertice_num = 1'b1;
		tb_coordinates = 48'b010101010101010111111111111111110000000100000001;
		@(negedge tb_clk);
		@(negedge tb_clk);
		if(tb_draw_en == 1'b1 && tb_bla_done == 1'b0 && tb_x0 == 8'd0 && tb_y0 == 8'd0 && tb_x1 == 8'b11111111 && tb_y1 == 8'b11111111)
			$info("Draw 3 1 looks good");
		else
			$error("Not good for draw 3 1");
		@(negedge tb_clk);
		if(tb_draw_en == 1'b0 && tb_bla_done == 1'b0 && tb_x0 == 8'd0 && tb_y0 == 8'd0 && tb_x1 == 8'd0 && tb_y1 == 8'b0)
			$info("In draw 3 1 wait state");
		else
			$error("Not in draw 3 1 wait state");
		@(negedge tb_clk);
		if(tb_draw_en == 1'b1 && tb_bla_done == 1'b0 && tb_x0 == 8'd0 && tb_y0 == 8'd0 && tb_x1 == 8'b01010101 && tb_y1 == 8'b0101010101)
			$info("Draw 3 2 looks good");
		else
			$error("Not good for draw 3 2");
		@(negedge tb_clk);
		if(tb_draw_en == 1'b0 && tb_bla_done == 1'b0 && tb_x0 == 8'd0 && tb_y0 == 8'd0 && tb_x1 == 8'd0 && tb_y1 == 8'b0)
			$info("In draw 3 2 wait state");
		else
			$error("Not in draw 3 2 wait state");
		@(negedge tb_clk);
		if(tb_draw_en == 1'b1 && tb_bla_done == 1'b0 && tb_x0 == 8'b11111111 && tb_y0 == 8'b11111111 && tb_x1 == 8'b01010101 && tb_y1 == 8'b0101010101)
			$info("Draw 3 3 looks good");
		else
			$error("Not good for draw 3 3");
		@(negedge tb_clk);
		if(tb_draw_en == 1'b0 && tb_bla_done == 1'b1 && tb_x0 == 8'd0 && tb_y0 == 8'd0 && tb_x1 == 8'd0 && tb_y1 == 8'b0)
			$info("In done state");
		else
			$error("Not in done state");
		@(negedge tb_clk);
		if(tb_draw_en == 1'b0 && tb_bla_done == 1'b0 && tb_x0 == 8'd0 && tb_y0 == 8'd0 && tb_x1 == 8'd0 && tb_y1 == 8'b0)
			$info("In done wait state");
		else
			$error("Not in done wait state");
		@(negedge tb_clk);
		if(tb_draw_en == 1'b0 && tb_bla_done == 1'b0 && tb_x0 == 8'd0 && tb_y0 == 8'd0 && tb_x1 == 8'd0 && tb_y1 == 8'b0)
			$info("In idle state");
		else
			$error("Not in idle state");
		tb_n_rst = 1'b0;
	end
endmodule
		
	
	

