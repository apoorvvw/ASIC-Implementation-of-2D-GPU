// This code serves as a test bench for the 1 bit adder design 

`timescale 1ns / 100ps

module tb_adder_8bit
();
	// Define local parameters used by the test bench
	localparam NUM_INPUT_BITS			= 8;
	localparam NUM_OUTPUT_BITS		= NUM_INPUT_BITS + 1;
	localparam MAX_OUTPUT_BIT			= NUM_OUTPUT_BITS - 1;
	localparam NUM_TEST_BITS 			= (NUM_INPUT_BITS * 2) + 1;
	localparam MAX_TEST_BIT				= NUM_TEST_BITS - 1;
	localparam NUM_TEST_CASES 		= 2 ** NUM_TEST_BITS;
	localparam MAX_TEST_VALUE 		= NUM_TEST_CASES - 1;
	localparam TEST_A_BIT					= 0;
	localparam TEST_B_BIT					= NUM_INPUT_BITS;
	localparam TEST_CARRY_IN_BIT	= MAX_TEST_BIT;
	localparam TEST_SUM_BIT				= NUM_INPUT_BITS;
	localparam TEST_CARRY_OUT_BIT	= MAX_OUTPUT_BIT;
	localparam TEST_DELAY					= 10;
	
	// Declare Design Under Test (DUT) portmap signals
	wire	[7:0] tb_a;
	wire	[7:0] tb_b;
	wire	tb_carry_in;
	wire	[7:0] tb_sum;
	wire	tb_carry_out;
	
	// Declare test bench signals
	integer tb_test_case;
	reg [MAX_TEST_BIT:0] tb_test_inputs;
	reg [MAX_OUTPUT_BIT:0] tb_expected_outputs;
	
	// DUT port map
	adder_8bit DUT(.a(tb_a), .b(tb_b), .carry_in(tb_carry_in), .sum(tb_sum), .overflow(tb_carry_out));
	
	// Connect individual test input bits to a vector for easier testing
	assign tb_a					= tb_test_inputs[7:0];
	assign tb_b					= tb_test_inputs[15:NUM_INPUT_BITS];
	assign tb_carry_in	= tb_test_inputs[NUM_INPUT_BITS*2];
	
	// Test bench process
	initial
	begin
		// Initialize test inputs for DUT
		tb_test_inputs = 2*NUM_INPUT_BITS;
		
		// Interative Exhaustive Testing Loop
		for(tb_test_case = 0; tb_test_case < NUM_TEST_CASES; tb_test_case = tb_test_case + 1)
		begin
			// Send test input to the design
			tb_test_inputs = tb_test_case[MAX_TEST_BIT:0];
			
			// Wait for a bit to allow this process to catch up with assign statements triggered
			// by test input assignment above
			#1;
			
			// Calculate the expected outputs
			tb_expected_outputs = tb_a + tb_b + tb_carry_in;
			
			// Wait for DUT to process the inputs
			#(TEST_DELAY - 1);
			
			// Check the DUT's Sum output value
			if(tb_expected_outputs[NUM_INPUT_BITS-1:0] == tb_sum)
			begin
				$info("Correct Sum value for test case %d!", tb_test_case);
			end
			else
			begin
				$error("Incorrect Sum value for test case %d!", tb_test_case);
			end
			
			// Check the DUT's Carry Out output value
			if(tb_expected_outputs[TEST_CARRY_OUT_BIT] == tb_carry_out)
			begin
				$info("Correct Carry Out value for test case %d!", tb_test_case);
			end
			else
			begin
				$error("Incorrect Carry Out value for test case %d!", tb_test_case);
			end
		end
	end
	
	// Wrap-up process
	final
	begin
		if(NUM_TEST_CASES != tb_test_case)
		begin
			// Didn't run the test bench through all test cases
			$display("This test bench was not run long enough to execute all test cases. Please run this test bench for at least a total of %d ns", (NUM_TEST_CASES * TEST_DELAY));
		end
		else
		begin
			// Test bench was run to completion
			$display("This test bench has run to completion");
		end
	end
endmodule
