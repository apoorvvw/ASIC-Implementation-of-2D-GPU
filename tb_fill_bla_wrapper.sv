// $Id: $
// File name:   tb_fill_bla_wrapper.sv
// Created:     4/25/2016
// Author:      Shubham Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description:  testbench for the wrapper for BLA and the fill block

`timescale 1ns / 100ps

module tb_fill_bla_wrapper();
	// SRAM configuation parameters (based on values set in wrapper file)
	localparam TB_CLK_PERIOD	= 6.0;	// Read/Write delays are 5ns and need ~1 ns for wire propagation
	localparam TB_ADDR_SIZE_BITS	= 24; 	// 16 => 64K Words in Memory
	localparam TB_DATA_SIZE_WORDS	= 64;		// Single word access (only a demo case, can access arbitraliy many bytes during an access but all accesses must be the number of words wide)
	localparam TB_WORD_SIZE_BYTES	= 3;		// Single byte words (only a demo case, words can be as large as 3 bytes)
	
	localparam TB_ACCES_SIZE_BITS	= (TB_DATA_SIZE_WORDS * TB_WORD_SIZE_BYTES * 8);
	localparam TB_CAPACITY_WORDS	= (2 ** (TB_ADDR_SIZE_BITS-1));
	localparam TB_MAX_ADDRESS			= (TB_CAPACITY_WORDS - 1);
	localparam TB_WORD_SIZE_BITS	= (TB_WORD_SIZE_BYTES * 8);
	localparam TB_MAX_WORD_BIT		= (TB_WORD_SIZE_BITS - 1);
	localparam TB_ACC_SIZE_BITS		= (TB_WORD_SIZE_BITS * TB_DATA_SIZE_WORDS);
	localparam TB_MAX_ACC_BIT			= (TB_ACC_SIZE_BITS - 1);
	
	localparam TB_MAX_WORD	= ((2 ** (TB_WORD_SIZE_BYTES * 8)) - 1);
	localparam TB_ZERO_WORD	= 0;
	localparam TB_MAX_ACC		= ((2 ** TB_ACCES_SIZE_BITS) - 1);
	localparam TB_ZERO_ACC	= 0;	
	
	// Test bench variables
	reg unsigned [(TB_ADDR_SIZE_BITS-1):0] tb_init_file_number;	// Can't be larger than a value of (2^31 - 1) due to how VHDL stores unsigned ints/natural data types
	reg unsigned [(TB_ADDR_SIZE_BITS-1):0] tb_dump_file_number;	// Can't be larger than a value of (2^31 - 1) due to how VHDL stores unsigned ints/natural data types
	reg unsigned [(TB_ADDR_SIZE_BITS-1):0] tb_start_address;	// The first address to start dumping memory contents from
	reg unsigned [(TB_ADDR_SIZE_BITS-1):0] tb_last_address;		// The last address to dump memory contents from
	
	reg tb_mem_clr;		// Active high strobe for at least 1 simulation timestep to zero memory contents
	reg tb_mem_init;	// Active high strobe for at least 1 simulation timestep to set the values for address in
										// currently selected init file to their corresonding values prescribed in the file
	reg tb_mem_dump;	// Active high strobe for at least 1 simulation timestep to dump all values modified since most recent mem_clr activation to
										// the currently chosen dump file. 
										// Only the locations between the "tb_start_address" and "tb_last_address" (inclusive) will be dumped
	reg tb_verbose;		// Active high enable for more verbose debuging information
	
	reg tb_read_enable;		// Active high read enable for the SRAM
	reg tb_write_enable;	// Active high write enable for the SRAM
	
	reg [(TB_ADDR_SIZE_BITS - 1):0]		tb_address; 		// The address of the first word in the access
	reg [(TB_ACCES_SIZE_BITS - 1):0]	tb_read_data;		// The data read from the SRAM
	reg [(TB_ACCES_SIZE_BITS - 1):0]	tb_write_data;	// The data to be written to the SRAM
		
	reg tb_clk;
    reg tb_n_rst;

	reg tb_vertice_num;
	reg [47:0] tb_coordinates;
	reg tb_inst_type;
	reg tb_alpha_done;
	reg tb_fifo_empty;
	reg tb_config_in;
	reg tb_config_done;
	reg tb_fill_type;
	reg [1:0] tb_texture_code;
	reg [23:0] tb_color_code;
	reg tb_layer_num; 
	reg tb_bla_done, tb_fill_done;
	reg [4095:0]tb_line_buffer;
	reg [7:0] x0;
	reg [7:0] y0;
	reg [7:0] x1;
	reg [7:0] y1;
	reg [7:0] x2;
	reg [7:0] y2;
	
	always
    begin : CLK_GEN
		tb_clk = 1'b0;
		#(TB_CLK_PERIOD / 2.0);
		tb_clk = 1'b1;
		#(TB_CLK_PERIOD / 2.0);
    end
    
	
    on_chip_sram_wrapper SRAM
	(
		.init_file_number(tb_init_file_number),
		.dump_file_number(tb_dump_file_number),
		.mem_clr(tb_mem_clr),
		.mem_init(tb_mem_init),
		.mem_dump(tb_mem_dump),
		.start_address(tb_start_address),
		.last_address(tb_last_address),
		.verbose(tb_verbose),
		.read_enable(tb_read_enable),
		.write_enable(tb_write_enable),
		.address(tb_address),
		.read_data(tb_read_data),
		.write_data(tb_write_data)

	);
	fill_bla_wrapper FBW
	(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
	
		.vertice_num(tb_vertice_num),
		.coordinates(tb_coordinates),
		.inst_type(tb_inst_type),
		.alpha_done(tb_alpha_done),
		.fifo_empty(tb_fifo_empty),
		.config_in(tb_config_in),
		.config_done(tb_config_done),
		.fill_type(tb_fill_type),
		.texture_code(tb_texture_code),
		.color_code(tb_color_code),
		.layer_num(tb_layer_num),
		
		.read_enable(tb_read_enable),
		.write_enable(tb_write_enable),
		.address(tb_address),
		.read_data(tb_read_data),
		.write_data(tb_write_data),
		.fill_done(tb_fill_done),
		.bla_done(tb_bla_done),
		.line_buffer(tb_line_buffer)

	);

	initial
	begin
		tb_n_rst = 1'b0;
    	#TB_CLK_PERIOD;
		tb_n_rst = 1'b1;
    	#TB_CLK_PERIOD;
    	

		tb_inst_type = 1'b0;
		tb_vertice_num = 1'b1;
		x0 = 8'd2;
		y0 = 8'd2;
		x1 = 8'd62;
		y1 = 8'd2;
		x2 = 8'd32;
		y2 = 8'd60;
		tb_coordinates = {y2, x2, y1, x1, y0, x0};

		tb_layer_num = 1'b0;
		tb_fill_type = 1'b0;
		tb_color_code = 24'hFFD700;
		tb_texture_code = '0;	
		
    	// Initialize all test bench control signals and DUT inputs
		tb_mem_clr					<= 0;//default, do not change its value
		tb_mem_init					<= 0;//default, do not change its value
		tb_mem_dump					<= 0;//default, do not change its value
		tb_verbose					<= 0;//default, do not change its value
		tb_init_file_number	<= 0;//default, do not change its value
		tb_dump_file_number	<= 0;//default, do not change its value
		tb_start_address		<= 0;//default, do not change its value
		tb_last_address			<= 0;//default, do not change its value
		#(TB_CLK_PERIOD * 10);
		
    	tb_config_in = 1'b1;
		#TB_CLK_PERIOD;
		tb_config_in = 1'b0;
		tb_config_done = 1'b1;
		#TB_CLK_PERIOD;
		tb_config_done = 1'b0;
		#TB_CLK_PERIOD;
		
		while(1 == 1)
		begin
			#TB_CLK_PERIOD;
			if(tb_bla_done == 1'b1)
				break;
				
		end
		#TB_CLK_PERIOD;
		for(integer i = 0; i < 64; i++)
		begin
			$display("%b\n",tb_line_buffer[(i *64)+:64]);
		end
		while(1 == 1)
		begin
			#TB_CLK_PERIOD;
			if(tb_fill_done == 1'b1)
				break;

		end
		#TB_CLK_PERIOD;	
		tb_fifo_empty = 1'b1;
		// Test Memory Dump feature
		$info("Testing Memory Dump Feature");
		tb_mem_dump					<= 1;
		tb_dump_file_number	<=	0;
		tb_start_address		<= 0;
		tb_last_address			<= TB_MAX_ADDRESS;
		#TB_CLK_PERIOD;
		
		tb_mem_dump	<= 0;
	end
endmodule
		
	
