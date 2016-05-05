// $Id: $
// File name:   main_controller.sv
// Created:     4/12/2016
// Author:      Shubham Sandeep Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Main Controller of the GPU

module main_controller
(
	input wire clk, //clock
	input wire n_rst, //reset
	input wire inst_type, // the type of instruction
	input wire alpha_done, //alpha done from alpha block
	input wire fifo_empty, //empty flag from fifo
	input wire bla_done, //done flag from the BLA block
	input wire config_in, //config in from slave
	input wire config_done, //done flag form the config block
	input wire fill_done, //done flag from the fill block
	output reg read_en, //read enable to the FIFO
	output reg alpha_en, //Alpha enablke to the alpha block
	output reg bla_en, //Enable to the BLA block
	output reg config_en, //Enable to the config block
	output reg fill_en //Enable to the fill block
);
typedef enum logic [3:0] {IDLE, CONFIG, DECODE, BLA, FILL, ALPHA, DONE, WAIT_BLA, WAIT_FILL, WAIT_ALPHA, WAIT_CONFIG}
	state_type;
	state_type state, next_state;
	always_ff @ (posedge clk, negedge n_rst)
	begin
		if(n_rst == 1'b0)
			state <= IDLE; //reset to idle state
		else
			state <= next_state; //next state logic
	end
	always_comb
	begin
		//initial declarations to avoid latches
		next_state = state;
		read_en = 1'b0;
		alpha_en = 1'b0;
		bla_en = 1'b0;
		config_en = 1'b0;
		fill_en = 1'b0;
		case(state)
		
		//Idle state 
		IDLE: begin
			//If config in is high go to config block
			if(config_in == 1'b1)
				next_state = CONFIG;
			//else stay in idle
			else
				next_state = IDLE;
		end
		//Config state
		CONFIG: begin
			config_en = 1'b1; //config enable high
			//If config done is high move to wait state
			if(config_done == 1'b1)
				next_state = WAIT_CONFIG;
			//else stay in config state
			else
				next_state = CONFIG;	
		end
		// wait state for 1 clock cycle
		WAIT_CONFIG: begin
			//Go to decode after a clock cycle
			next_state = DECODE;
		end
		//decode state
		DECODE: begin
			read_en = 1'b1; //read enable high to fifo
			//instruction type is a shape
			if(inst_type == 1'b0) 
				next_state = BLA;
			//instruction type is alpha
			else
				next_state = ALPHA;
		end
		//Bresenham state
		BLA: begin
			bla_en = 1'b1; //BLA enable high, start drawing on line buffer
			//BLA done then got to wait state
			if(bla_done == 1'b1)
				next_state = WAIT_BLA;
			//else stay in BLA state
			else
				next_state = BLA;
		end
		// wait state for 1 clock cycle
		WAIT_BLA: begin
			next_state = FILL;	//go to fill state after one clock cycle	
		end
		//Fill state
		FILL: begin
			fill_en = 1'b1; //fill enable high, start filling on SRAM
			//if fill done, go to wait state
			if(fill_done == 1'b1)
				next_state = WAIT_FILL;
			//else stay in fill state
			else
				next_state = FILL;		
		end
		//wait state till fifo has more instructions
		WAIT_FILL: begin
			//stay till fifo is not empty
			if(fifo_empty == 1'b1)
				next_state = WAIT_FILL;
			else
				next_state = DECODE;
		
		end
		//Alpha state
		ALPHA: begin
			alpha_en = 1'b1; //Alpha enable high, start alpha blend
			//If alpha done, go to wait state
			if(alpha_done == 1'b1)
				next_state = WAIT_ALPHA;
			//else stay in alpha state
			else
				next_state = ALPHA;
		end
		//Wait state for 1 clock cycle
		WAIT_ALPHA: begin
			//go to IDLE after 1 clock cycle
			next_state = IDLE;
		end
		endcase
		
	end
endmodule
