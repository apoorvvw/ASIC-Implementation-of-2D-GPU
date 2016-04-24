// $Id: $
// File name:   tb_fill_block.sv
// Created:     4/23/2016
// Author:      Yudi Wu
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: testbench for fill_block

`timescale 1ns / 100ps
module tb_fill_block ();

    // Define parameters
    // basic test bench parameters
    localparam	CLK_PERIOD = 5ns;
    localparam	CHECK_DELAY = 1ns; 

    // DUT Signals
    reg tb_clk;
    reg tb_n_rst;
    reg [47:0]tb_coordinates;
    reg tb_math_start;
    reg tb_math_done;

    
    // Clock gen block
    always
    begin : CLK_GEN
	tb_clk = 1'b0;
	#(CLK_PERIOD / 2.0);
	tb_clk = 1'b1;
	#(CLK_PERIOD / 2.0);
    end
	

    // DUT portmap
	fill_block DUT
	(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
		.fill_type(),

		.coordinates(tb_coordinates),
		.texture_code(),
		.color_code(),
		.layer_num(),
		.line_buffer(),
		
		.math_start(tb_math_start),
		.row_start(),
		.fill_start(),
		.math_done(tb_math_done),
		.row_done(),
		.fill_done(),
		.all_finish(),
	
		.read_enable(),
		.write_enable(),
		.read_data(),
		.write_data(),
		.address(),
		.xmin(tb_xmin),
		.ymin(tb_ymin)

	);
    initial
    begin
        //test1
        tb_n_rst = 0;
        #CLK_PERIOD;
        
     	tb_n_rst = 1;
        tb_coordinates = 48'hFFFF1212EEEE;
        tb_math_start = 1;
        #CLK_PERIOD;
        
        if(tb_math_done == 1)
        	tb_math_start = 0;
         #CLK_PERIOD;

        
    
    end
    
endmodule
