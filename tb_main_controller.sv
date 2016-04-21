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
 
    logic tb_clk;
    logic tb_n_rst;
    logic tb_decode_fin;
    logic tb_inst_type;
    logic tb_alpha_fin;
    logic tb_fifo_empty;
    logic tb_bla_fin;
    logic tb_config_in;
    logic tb_config_done;
    logic tb_fill_done;
    logic tb_decode_full;
    
    logic tb_read_en;
    logic tb_alpha_en;
    logic tb_bla_en;
    logic tb_config_en;

	integer tb_test_case;

    bresenham_controller DUT ( .clk(tb_clk) , .n_rst(tb_n_rst) , 
        .decode_fin(tb_draw_done), .inst_type(tb_inst_type) , .alpha_fin(tb_alpha_fin), 
        .fifo_empty(tb_fifo_empty), .bla_fin(tb_bla_fin), .config_in(tb_config_in),
        .config_done(tb_config_done) , .fill_done(tb_fill_done), .decode_full(tb_decode_full),
        .read_en(tb_read_en) ,.alpha_en(tb_alpha_en) , .bla_en(tb_bla_en), 
        .config_en(tb_config_en), .fill_en(tb_fill_en)   );    

    // Tasks for regulating the timing of input stimulus to the design

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

        tb_decode_fin = 1'b0;
        tb_inst_type = 1'b0;
        tb_alpha_fin = 1'b0;
        tb_fifo_empty = 1'b0;
        tb_bla_fin = 1'b0;
        tb_config_in = 1'b0;
        tb_config_done = 1'b0;
        tb_fill_done = 1'b0;
        tb_decode_full = 1'b0; 	
        @(negedge tb_clk);
        #(CLK_PERIOD)

        #(CLK_PERIOD)
        tb_decode_fin = 1'b0;
        tb_inst_type = 1'b0;
        tb_alpha_fin = 1'b0;
        tb_fifo_empty = 1'b0;
        tb_bla_fin = 1'b0;
        tb_config_in = 1'b0;
        tb_config_done = 1'b0;
        tb_fill_done = 1'b0;
        tb_decode_full = 1'b0;

        // IDLE TO CONFIG
        #(CLK_PERIOD)
        tb_config_in = 1'b1;
        #(CLK_PERIOD)
        
        //CONFIG TO WAIT_CONFIG
        tb_config_in = 1'b0;
        tb_config_done = 1'b1;
        #(CLK_PERIOD)

        //WAIT_CONFIG TO DECODE
        #(CLK_PERIOD)
        
        tb_config_done = 1'b0;
        tb_bla_fin = 1'b1;
        //DECODE TO BLA

    end
endmodule
