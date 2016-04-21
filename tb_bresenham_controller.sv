// $Id: $
// File name:   tb_bresenham_controller.sv
// Created:     4/20/2016
// Author:      Apoorv Wairagade
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Test bench for bresenham internal FSM
`timescale 1ns / 100ps

module tb_bresenham_controller ();

	localparam	CLK_PERIOD	= 2.5;
    localparam  NUM_CNT_BITS = 4;
 
    reg tb_clk;
    reg tb_n_rst;
    reg tb_draw_done;
    reg tb_vertice_num;
    logic [47:0] tb_coordinates;
    logic [7:0] tb_x0;
	logic [7:0] tb_y0;
	logic [7:0] tb_x1;
	logic [7:0] tb_y1;
	logic tb_draw_en;
	logic tb_bla_done; 

	integer tb_test_case;

    bresenham_controller DUT ( .clk(tb_clk) , .n_rst(tb_n_rst) , 
    						   .draw_done(tb_draw_done), .vertice_num(tb_vertice_num), 
    						   .bla_en(tb_bla_en), .coordinates (tb_coordinates) , .x0(tb_x0)
    						   .y0(tb_y0) , .x1(tb_x1) , .y1(tb_y1) , .draw_en(tb_draw_en) , 
    						   .bla_done(tb_bla_done) );    

    // Tasks for regulating the timing of input stimulus to the design
    task send_packet;
        input  [7:0] data;
        input  stop_bit;
        input  time data_period;
        
        integer i;
    begin
        // First synchronize to away from clock's rising edge
        @(negedge tb_clk)
        
        // Send start bit
        tb_serial_in = 1'b0;
        #data_period;
        
        // Send data bits
        for(i = 0; i < 8; i = i + 1)
        begin
            tb_serial_in = data[i];
            #data_period;
        end
        
        // Send stop bit
        tb_serial_in = stop_bit;
        #data_period;
    end
    endtask

    // Clock generation block
	always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end

    initial
    begin
    	@(negedge tb_clk);
    	#(CLK_PERIOD)

    	tb_draw_done = 1'b0;
    	tb_vertice_num = 1'b0;
    	tb_bla_en = 1'b0;
    	tb_coordinates = 48'h000000;
    	#(CLK_PERIOD)
    	#(CLK_PERIOD)
    	#(CLK_PERIOD)
		tb_draw_done = 1'b0;
    	tb_vertice_num = 1'b0;
    	tb_bla_en = 1'b0;
    	tb_coordinates = 48'h000000;

    	// Should stay in IDLE
    	#(CLK_PERIOD)
    	tb_draw_done = 1'b0;
    	tb_vertice_num = 1'b0;
    	tb_bla_en = 1'b0;
    	tb_coordinates = 48'h000000;    	

    	// Go to DRAW2
    	#(CLK_PERIOD)
    	tb_draw_done = 1'b0;
    	tb_vertice_num = 1'b0;
    	tb_bla_en = 1'b1;
    	tb_coordinates = 48'h000000;    	


    end
endmodule
