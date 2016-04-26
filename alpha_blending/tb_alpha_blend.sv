`timescale 1ns / 100ps
module tb_alpha_blend ();
	
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
	reg tb_alpha_en;
	reg [3:0] tb_alpha_value;
	reg tb_alpha_done;
	reg [(TB_ACCES_SIZE_BITS - 1):0]	tb_out;
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
	
	alpha_blend DUT
	(
		.clk(tb_clk),
		.n_rst(tb_n_rst),
	   	.alpha_en(tb_alpha_en),
	   	.alpha_value(tb_alpha_value),
	   	.alpha_done(tb_alpha_done),
	   	
	   	.read_enable(tb_read_enable),
	   	.address(tb_address),
		.read_data(tb_read_data),
		.write_data(tb_out)
	
	); 
	
	initial
	begin
		tb_n_rst = 0;
    	#TB_CLK_PERIOD;
    	tb_n_rst = 1;
    	tb_alpha_en = 0;

    	#TB_CLK_PERIOD;
    	
    	// Initialize all test bench control signals and DUT inputs
		tb_mem_clr					<= 0;//default, do not change its value
		tb_mem_init					<= 0;//default, do not change its value
		tb_mem_dump					<= 0;//default, do not change its value
		tb_verbose					<= 0;//default, do not change its value
		tb_init_file_number	<= 0;//default, do not change its value
		tb_dump_file_number	<= 0;//default, do not change its value
		tb_start_address		<= 0;//default, do not change its value
		tb_last_address			<= 0;//default, do not change its value

		tb_write_enable	<= 0;
		tb_write_data		<= TB_ZERO_ACC;
		#(TB_CLK_PERIOD * 10);
		
		tb_alpha_en = 1;
		tb_alpha_value = 4'b0010;
    	#TB_CLK_PERIOD;
		tb_alpha_en = 0;
    	#TB_CLK_PERIOD;	
	end
	
	
endmodule
