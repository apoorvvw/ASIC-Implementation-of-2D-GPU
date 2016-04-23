-- $Id: $
-- File name:   on_chip_sram_wrapper.vhd
-- Created:     4/16/2013
-- Author:      foo
-- Lab Section: 99
-- Version:     1.0  Initial Design Entry
-- Description: Verilog-safe vhdl wrapper for parameterized course on-chip sram model.
-- Note: use a tab size of 2 spaces for best readablity

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library ECE337_IP;
use ECE337_IP.all;

entity on_chip_sram_wrapper is
	generic
	(   -- Generics are the same as parameters in verilog, you set them during portmapping
		-- with verilog's parameter mapping syntax (google it) or you can simply create a
		-- separate copy of this wrapper for each on-chip sram instance and modify them below.

		W_ADDR_SIZE_BITS  : natural := 22;    -- Address bus size in bits/pins with addresses corresponding to 
																					-- the starting word of the accesss
		W_WORD_SIZE_BYTES : natural := 3;   	-- Word size of the memory in bytes
		W_DATA_SIZE_WORDS : natural := 2;   	-- Data bus size in "words"
		W_READ_DELAY      : time    := 5 ns; 	-- Delay/latency per read access (total time between start of supplying address and when the data read from memory appears on the r_data port)
																					-- Keep the 5 ns delay for 0.5u on-chip SRAM
		W_WRITE_DELAY     : time    := 5 ns 	-- Delay/latency per write access (total time between start of supplying address and when the w_data value is written into memory)
																					-- Keep the 5 ns delay for 0.5u on-chip SRAM
	);
	port
	(
		-- Test bench control signals
		init_file_number	: in natural;	-- The number of the initialization file name to use during the next requested memory init
																		-- Only use values from 0 thru (2^31 - 1) as naturals are simply the postive range of a signed 32-bit integer
		dump_file_number	: in natural;	-- The number of the dump file name to use during the next requested memory dump
																		-- Only use values from 0 thru (2^31 - 1) as naturals are simply the postive range of a signed 32-bit integer
		mem_clr       : in  boolean;		-- Strobe this for at least 1 simulation timestep to zero all memory contents
    mem_init      : in  boolean;		-- Strobe this for at least 1 simulation timestep to set the values for addresses
																		-- currently selected init file to their corresponding values precribed in the file
    mem_dump      : in  boolean;		-- Strobe this for at least 1 simulation timestep to dump all values modified since
																		-- the most recent mem_clr activation.
																		-- Only the locations between the "start_address" and "last_address" (inclusive) will be printed
    start_address : in  natural;		-- The first address to start dumping memory contents from
    last_address  : in  natural;		-- The last address to dump memory contents from
    verbose       : in  boolean;		-- Active high enable for more verbose debugging information
		
		-- Memory interface signals (read enable, write enable, address of first word in the access, data from a read, data supplied for a write)
		read_enable		: in	std_logic;
		write_enable	: in	std_logic;
		address				: in	std_logic_vector((W_ADDR_SIZE_BITS - 1) downto 0);
		read_data			: out	std_logic_vector(((W_DATA_SIZE_WORDS * W_WORD_SIZE_BYTES * 8) - 1) downto 0);
		write_data		: in	std_logic_vector(((W_DATA_SIZE_WORDS * W_WORD_SIZE_BYTES * 8) - 1) downto 0)
	);
end on_chip_sram_wrapper;

architecture wrapper of on_chip_sram_wrapper is

	component simple_scale_mem is
	generic (
						-- Memory Model parameters
						ADDR_SIZE_BITS	: natural	:= 22;		-- Address bus size in bits/pins with addresses corresponding to 
																								-- the starting word of the accesss
						WORD_SIZE_BYTES	: natural	:= 3;			-- Word size of the memory in bytes
						DATA_SIZE_WORDS	: natural	:= 2;			-- Data bus size in "words"
						READ_DELAY			: time		:= 5 ns;	-- Delay/latency per read access
						WRITE_DELAY			: time		:= 5 ns		-- Delay/latency per write access
					);
	port 	(
					-- Test bench control signals
					mem_clr				: in	boolean;
					mem_init			: in	boolean;
					mem_dump			: in	boolean;
					verbose				: in	boolean;
					init_filename	: in 	string;
					dump_filename	: in 	string;
					start_address	: in	natural;
					last_address	: in	natural;
					
					-- Memory interface signals
					r_enable	: in	std_logic;
					w_enable	: in	std_logic;
					addr			: in	std_logic_vector((ADDR_SIZE_BITS - 1) downto 0);
					r_data		: out	std_logic_vector(((DATA_SIZE_WORDS * WORD_SIZE_BYTES * 8) - 1) downto 0);
					w_data		: in	std_logic_vector(((DATA_SIZE_WORDS * WORD_SIZE_BYTES * 8) - 1) downto 0)
				);
	end component simple_scale_mem;

	-- VHDL strings are statically allocated so you need to have all filenames be the same size
	-- Note: VHDL strings use whole number addressing and thus start off at 1
	constant MAX_INIT_FILENAME_SIZE	: natural	:= 18;
	constant MAX_DUMP_FILENAME_SIZE	: natural	:= 18;
	
	
	-- Declare the filename array type (allow the number of filenames to be determined on usage)
	type i_filenames is array(natural range <>) of string(1 to MAX_INIT_FILENAME_SIZE);
	type d_filenames is array(natural range <>) of string(1 to MAX_DUMP_FILENAME_SIZE);
	
	-- Declare and define filename array constants
	constant INIT_FILENAMES	: i_filenames	:=
	(
		"example_init_1.txt",
		"example_init_2.txt",
		"example_init_3.txt"
	);
	constant DUMP_FILENAMES	: d_filenames	:=
	(
		"example_dump_1.txt",
		"example_dump_2.txt",
		"example_dump_3.txt"
	);
	
	-- Declare the signals that will be connected to the actual SRAM module
	signal w_selected_init_filename	: string (1 to MAX_INIT_FILENAME_SIZE);
	signal w_selected_dump_filename	: string (1 to MAX_DUMP_FILENAME_SIZE);
	
	-- Declare internal bit to boolean signals
	signal w_mem_clr	:	boolean;
	signal w_mem_init	:	boolean;
	signal w_mem_dump	:	boolean;
	signal w_verbose	:	boolean;
	
begin
	
	MEM: simple_scale_mem
		generic map
		(
			-- Memory interface parameters
			ADDR_SIZE_BITS	=> W_ADDR_SIZE_BITS,
			WORD_SIZE_BYTES	=> W_WORD_SIZE_BYTES,
			DATA_SIZE_WORDS	=> W_DATA_SIZE_WORDS,
			READ_DELAY			=> W_READ_DELAY,
			WRITE_DELAY			=> W_WRITE_DELAY
		)
		port map
		(
			-- Test bench control signals
			mem_clr				=> mem_clr,
			mem_init			=> mem_init,
			mem_dump			=> mem_dump,
			verbose				=> verbose,
			start_address	=> start_address,
			last_address	=> last_address,
			init_filename	=> w_selected_init_filename,
			dump_filename	=> w_selected_dump_filename,
			
			-- Memory interface signals
			r_enable	=> read_enable,
			w_enable	=> write_enable,
			addr			=> address,
			r_data		=> read_data,
			w_data		=> write_data
		);
		
		-- Select the corresponding filenames to currently use
		w_selected_init_filename <= INIT_FILENAMES(init_file_number);
		w_selected_dump_filename <= DUMP_FILENAMES(dump_file_number);
		
end architecture wrapper;
