// $Id: $
// File name:   tb_fill_wrapper.sv
// Created:     4/23/2016
// Author:      Yudi Wu
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: testbench for the overall fill block design

`timescale 1ns / 100ps
module tb_fill_wrapper ();
	
	// SRAM configuation parameters (based on values set in wrapper file)
	localparam TB_CLK_PERIOD	= 6.0;	// Read/Write delays are 5ns and need ~1 ns for wire propagation
	localparam TB_ADDR_SIZE_BITS	= 30; 	// 16 => 64K Words in Memory
	localparam TB_DATA_SIZE_WORDS	= 64;		// Single word access (only a demo case, can access arbitraliy many bytes during an access but all accesses must be the number of words wide)
	localparam TB_WORD_SIZE_BYTES	= 3;		// Single byte words (only a demo case, words can be as large as 3 bytes)
	localparam TB_ACCES_SIZE_BITS	= (TB_DATA_SIZE_WORDS * TB_WORD_SIZE_BYTES * 8);
	
	
	// Test bench variables
	integer unsigned tb_init_file_number;	// Can't be larger than a value of (2^31 - 1) due to how VHDL stores unsigned ints/natural data types
	integer unsigned tb_dump_file_number;	// Can't be larger than a value of (2^31 - 1) due to how VHDL stores unsigned ints/natural data types
	integer unsigned tb_start_address;	// The first address to start dumping memory contents from
	integer unsigned tb_last_address;		// The last address to dump memory contents from
	
	reg tb_mem_clr;		// Active high strobe for at least 1 simulation timestep to zero memory contents
	reg tb_mem_init;	// Active high strobe for at least 1 simulation timestep to set the values for address in
										// currently selected init file to their corresonding values prescribed in the file
	reg tb_mem_dump;	// Active high strobe for at least 1 simulation timestep to dump all values modified since most recent mem_clr activation to
										// the currently chosen dump file. 
										// Only the locations between the "tb_start_address" and "tb_last_address" (inclusive) will be dumped
	reg tb_verbose;		// Active high enable for more verbose debuging information
	
	
	reg [(TB_ADDR_SIZE_BITS - 1):0]		tb_address; 		// The address of the first word in the access
	reg [(TB_ACCES_SIZE_BITS - 1):0]	tb_read_data;		// The data read from the SRAM
	reg [(TB_ACCES_SIZE_BITS - 1):0]	tb_write_data;	// The data to be written to the SRAM
	
	reg tb_clk;
    reg tb_n_rst;
    reg tb_fill_en;
    reg tb_done;
    reg tb_fill_type;
    reg [47:0]tb_coordinates;
	reg [1:0] tb_texture_code;
	reg [23:0] tb_color_code;
	reg tb_layer_num;
	reg [4095:0] tb_line_buffer;
	
	 // Clock gen block
	 
    always
    begin : CLK_GEN
		tb_clk = 1'b0;
		#(TB_CLK_PERIOD / 2.0);
		tb_clk = 1'b1;
		#(TB_CLK_PERIOD / 2.0);
    end
    
    
	fill_wrapper DUT
	(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
		.fill_en(tb_fill_en),	
		.done(tb_done),
		.fill_type(tb_fill_type), //not used
		
		.coordinates(tb_coordinates),
		.texture_code(tb_texture_code), //not used
		.color_code(tb_color_code),
		.layer_num(tb_layer_num), 
		.line_buffer(tb_line_buffer),
	
		.init_file_number(tb_init_file_number),
		.dump_file_number(tb_dump_file_number),
		.mem_clr(tb_mem_clr), 
		.mem_init(tb_mem_init),
		.mem_dump(tb_mem_dump),
		.start_address(tb_start_address),
		.last_address(tb_last_address),
		.verbose(tb_verbose)
	);
	
	initial
    begin
    	
    	// Initialize all test bench control signals and DUT inputs
		tb_mem_clr					<= 0;
		tb_mem_init					<= 0;
		tb_mem_dump					<= 0;
		tb_verbose					<= 0;
		tb_init_file_number	<= 0;
		tb_dump_file_number	<= 0;
		tb_start_address		<= 0;
		tb_last_address			<= 0;
		
		#(TB_CLK_PERIOD * 10);
		tb_line_buffer = '0;
		tb_line_buffer[0] = 		1'b1;
		tb_line_buffer[65:64] = 	2'b11;
		tb_line_buffer[130:128] =   3'b101;
		tb_line_buffer[195:192] =   4'b1001;
		tb_line_buffer[260:256] =   5'b11111;
		
		tb_coordinates = 48'hC8C8C8CCCCCCC;
		tb_layer_num = 1;
		#TB_CLK_PERIOD;
		#TB_CLK_PERIOD;
		#TB_CLK_PERIOD;
		
    end
endmodule
	

		
