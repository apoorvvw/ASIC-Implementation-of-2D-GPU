// $Id: $
// File name:   tb_on_chip_sram_wrapper.sv
// Created:     4/16/2013
// Author:      foo
// Lab Section: 99
// Version:     1.0  Initial Design Entry
// Description: A simple verilog test bench for the VHDL on-chip sram wrapper.

`timescale 1ns / 100ps

module tb_on_chip_sram_wrapper ();
	// SRAM configuation parameters (based on values set in wrapper file)
	localparam TB_CLK_PERIOD			= 6.0;	// Read/Write delays are 5ns and need ~1 ns for wire propagation
	localparam TB_ADDR_SIZE_BITS	= 22; 	// 16 => 64K Words in Memory
	localparam TB_DATA_SIZE_WORDS	= 2;		// Single word access (only a demo case, can access arbitraliy many bytes during an access but all accesses must be the number of words wide)
	localparam TB_WORD_SIZE_BYTES	= 3;		// Single byte words (only a demo case, words can be as large as 3 bytes)
	localparam TB_ACCES_SIZE_BITS	= (TB_DATA_SIZE_WORDS * TB_WORD_SIZE_BYTES * 8);
	
	// Useful test bench constants
	localparam TB_CAPACITY_WORDS	= (2 ** (TB_ADDR_SIZE_BITS -1) );
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
	
	reg tb_read_enable;		// Active high read enable for the SRAM
	reg tb_write_enable;	// Active high write enable for the SRAM
	
	reg [(TB_ADDR_SIZE_BITS - 1):0]		tb_address; 		// The address of the first word in the access
	reg [(TB_ACCES_SIZE_BITS - 1):0]	tb_read_data;		// The data read from the SRAM
	reg [(TB_ACCES_SIZE_BITS - 1):0]	tb_write_data;	// The data to be written to the SRAM
	
	// Wrapper portmap
	sram DUT
	(
		// Memory interface signals
		.read_enable(tb_read_enable),
		.write_enable(tb_write_enable),
		.address(tb_address),
		.read_data(tb_read_data),
		.write_data(tb_write_data)
	);
	
	
	initial
	begin : TEST_BENCH
		// Initialize all test bench control signals and DUT inputs
		tb_mem_clr					<= 0;
		tb_mem_init					<= 0;
		tb_mem_dump					<= 0;
		tb_verbose					<= 0;
		tb_init_file_number	<= 0;
		tb_dump_file_number	<= 0;
		tb_start_address		<= 0;
		tb_last_address			<= 0;
	
		// Initialization of memory's interface input signals
		tb_read_enable	<= 0;
		tb_write_enable	<= 0;
		tb_address			<= 0;
		tb_write_data		<= TB_ZERO_ACC;
		
		#(TB_CLK_PERIOD * 10);
		
		// Test the write functionality
		tb_address			<= 9;
		tb_write_enable	<= 1;
		tb_write_data		<= 9;
		#TB_CLK_PERIOD;
		
		tb_address 			<= 8;
		tb_write_enable	<= 1;
		tb_write_data		<= 8;
		#TB_CLK_PERIOD;
		
		tb_write_enable	<= 0;
		
		// Test the read functionality
		tb_read_enable	<= 1;
		#TB_CLK_PERIOD;
		
		tb_address			<= 9;
		tb_read_enable	<= 1;
		#TB_CLK_PERIOD;
		 tb_address			<= 8;
		#TB_CLK_PERIOD;
		
		// Test error detection
		tb_read_enable	<= 1;
		tb_write_enable	<= 1;
		tb_write_data		<= TB_MAX_ACC;
		tb_address			<= 16;
		#TB_CLK_PERIOD;
		
		// Test Memory Dump feature
		$info("Testing Memory Dump Feature");
		tb_mem_dump					<= 1;
		tb_dump_file_number	<=	0;
		tb_start_address		<= 0;
		tb_last_address			<= TB_MAX_ADDRESS;
		#TB_CLK_PERIOD;
		
		tb_mem_dump	<= 0;
		
		// Test the data clr
		$info("Testing Data clear feature");
		tb_read_enable	<= 0;
		tb_write_enable	<= 0;
		tb_mem_clr			<= 1;
		#TB_CLK_PERIOD;
		
		tb_mem_clr	<= 0;
		#TB_CLK_PERIOD;
		
		
		// Test Verbose signal
		/*
		$info("Testing Verbose Signal");
		tb_verbose	<= 1;
		tb_mem_clr	<= 1;
		#TB_CLK_PERIOD;
		
		tb_mem_clr <= 0;
		#TB_CLK_PERIOD;
		*/
		
		// Test Memory Initialization feature
		/*
		$info("Testing Memory Initialziation Feature");
		tb_mem_init					<= 1;
		tb_init_file_number	<= 0;
		#TB_CLK_PERIOD;
		
		tb_mem_init	<= 0;
		
		tb_read_enable	<= 1;
		tb_address			<= 0;
		#TB_CLK_PERIOD;
		
		tb_read_enable	<= 1;
		tb_address			<= 2;
		#TB_CLK_PERIOD;
		
		tb_read_enable	<= 1;
		tb_address			<= 4;
		#TB_CLK_PERIOD;
		
		tb_read_enable	<= 1;
		tb_address			<= 8;
		#TB_CLK_PERIOD;
		
		tb_read_enable	<= 1;
		tb_address			<= 16;
		#TB_CLK_PERIOD;
		
		tb_read_enable	<= 1;
		tb_address			<= 64;
		#TB_CLK_PERIOD;
		
		tb_read_enable	<= 1;
		tb_address			<= 1024;
		#TB_CLK_PERIOD;
		*/
	end
	
endmodule
