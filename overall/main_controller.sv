// $Id: $
// File name:   main_controller.sv
// Created:     4/12/2016
// Author:      Shubham Sandeep Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Main Controller of the GPU

module main_controller
(
	input wire clk,
	input wire n_rst,
	input wire inst_type,
	input wire alpha_done,
	input wire fifo_empty,
	input wire bla_done,
	input wire config_in,
	input wire config_done,
	input wire fill_done,
	output reg read_en,
	output reg alpha_en,
	output reg bla_en,
	output reg config_en,
	output reg fill_en
);
typedef enum logic [3:0] {IDLE, CONFIG, DECODE, BLA, FILL, ALPHA, DONE, WAIT_BLA, WAIT_FILL, WAIT_ALPHA, WAIT_CONFIG}
	state_type;
	state_type state, next_state;
	always_ff @ (posedge clk, negedge n_rst)
	begin
		if(n_rst == 1'b0)
			state <= IDLE;
		else
			state <= next_state;
	end
	always_comb
	begin
		next_state = state;
		read_en = 1'b0;
		alpha_en = 1'b0;
		bla_en = 1'b0;
		config_en = 1'b0;
		fill_en = 1'b0;
		case(state)
		IDLE: begin
			read_en = 1'b0;
			alpha_en = 1'b0;
			bla_en = 1'b0;
			config_en = 1'b0;
			fill_en = 1'b0;
			if(config_in == 1'b1)
				next_state = CONFIG;
			else
				next_state = IDLE;
		end
		CONFIG: begin
			read_en = 1'b0;
			alpha_en = 1'b0;
			bla_en = 1'b0;
			config_en = 1'b1;
			fill_en = 1'b0;
			if(config_done == 1'b1)
				next_state = WAIT_CONFIG;
			else
				next_state = CONFIG;	
		end
		WAIT_CONFIG: begin
			read_en = 1'b0;
			alpha_en = 1'b0;
			bla_en = 1'b0;
			config_en = 1'b0;
			fill_en = 1'b0;
			next_state = DECODE;
		end
		DECODE: begin
			read_en = 1'b1;
			alpha_en = 1'b0;
			bla_en = 1'b0;
			config_en = 1'b0;
			fill_en = 1'b0;
			if(inst_type == 1'b0) //instruction type is a shape
				next_state = BLA;
			else
				next_state = ALPHA;
		end
		BLA: begin
			read_en = 1'b0;
			alpha_en = 1'b0;
			bla_en = 1'b1;
			config_en = 1'b0;
			fill_en = 1'b0;
			if(bla_done == 1'b1)
				next_state = WAIT_BLA;
			else
				next_state = BLA;
		end
		WAIT_BLA: begin
			read_en = 1'b0;
			alpha_en = 1'b0;
			bla_en = 1'b0;
			config_en = 1'b0;
			fill_en = 1'b0;
			next_state = FILL;		
		end
		FILL: begin
			read_en = 1'b0;
			alpha_en = 1'b0;
			bla_en = 1'b0;
			config_en = 1'b0;
			fill_en = 1'b1;
			if(fill_done == 1'b1)
				next_state = WAIT_FILL;
			else
				next_state = FILL;		
		end
		WAIT_FILL: begin
			read_en = 1'b0;
			alpha_en = 1'b0;
			bla_en = 1'b0;
			config_en = 1'b0;
			fill_en = 1'b0;
			if(fifo_empty == 1'b1)
				next_state = WAIT_FILL;
			else
				next_state = DECODE;
		
		end
		ALPHA: begin
			read_en = 1'b0;
			alpha_en = 1'b1;
			bla_en = 1'b0;
			config_en = 1'b0;
			fill_en = 1'b0;
			if(alpha_done == 1'b1)
				next_state = WAIT_ALPHA;
			else
				next_state = ALPHA;
		end
		WAIT_ALPHA: begin
			read_en = 1'b0;
			alpha_en = 1'b0;
			bla_en = 1'b0;
			config_en = 1'b0;
			fill_en = 1'b0;
			next_state = IDLE;
		end
		endcase
		
	end
endmodule
/*
typedef enum logic [3:0] {IDLE, CONFIG, DECODE, DEC&DRAW, DRAW, ALPHA} 
	state_type state, next_state;
	always_ff @ (posedge clk, negedge n_rst)
	begin
		if(n_rst == 0)
			state <= IDLE;     
		else
			state <= next_state;	    
	end
	always_comb
	begin
		next_state = state;
		case (state)
		IDLE: begin
			config_en = 1'b0;
			read_en = 1'b0;
			draw_en = 1'b0;
			alpha_en = 1'b0;
			if(config_in == 1'b1)
				next_state = CONFIG;
			else
				next_state = IDLE;
		end
		CONFIG: begin
			config_en = 1'b1;
			read_en = 1'b0;
			draw_en = 1'b0;
			alpha_en = 1'b0;
			if(config_done == 1'b1 && fifo_empty == 1'b0)
				next_state = DECODE;
			else
				next_state = CONFIG;
		end
		DECODE: begin
			config_en = 1'b0;
			read_en = 1'b1;
			draw_en = 1'b0;
			alpha_en = 1'b0;
			if(decode_fin == 1'b1 && fifo_empty == 1'b0)
				next_state = DEC&DRAW;
			else if(decode_fin == 1'b1 && fifo_empty == 1'b1)
				next_state = DRAW;
			else if(inst_type == 1'b1) //Alpha instruction
				next_state = ALPHA;
		end
		DEC&DRAW: begin
			config_en = 1'b0;
			read_en = 1'b1;
			draw_en = 1'b1;
			alpha_en = 1'b0;
			if(decode_fin == 1'b1 && draw_fin == 1'b0)
				next_state = DRAW;
			//else if(decode_fin == 1'b0 && draw_fin == 1'b1 && decode_full == 1'b0) //if decode is done before draw then just make draw enable low because the first decode state is used when 2 instructions have been drawn and filled
			//draw_en = 1'b0;
			else if(decode_fin == 1'b0 && draw_fin == 1'b1)
			begin
				next_state = DECODE;
			end
			else
				next_state = DEC&DRAW;
			
		end
		DRAW: begin
			config_en = 1'b0;
			read_en = 1'b0;
			draw_en = 1'b1;
			alpha_en = 1'b0;
			if(inst_type == 1'b1 && draw_fin == 1'b1)
				next_state = ALPHA;
			//else if(inst_type == 1'b1 && draw_fin == 1'b0)
			//	next_state = DRAW;
			//redundant because if alpha is there or not only oscillate between dec&draw and draw depending on the cases
			else if(fifo_empty == 1'b0 && decode_full == 1'b0 && draw_fin == 1'b1)
				next_state = DECODE;
			else if(fifo_empty == 1'b0 && decode_full == 1'b0 && draw_fin == 1'b0)
				next_state = DEC&DRAW;
			else if(fifo_empty == 1'b0 && decode_full == 1'b1 && draw_fin == 1'b0)
				next_state = DRAW;
		end
		ALPHA: begin
			config_en = 1'b0;
			read_en = 1'b0;
			draw_en = 1'b0;
			alpha_en = 1'b1;
			if(alpha_fin == 1'b0)
				next_state = ALPHA
			else
				next_state = IDLE;
		end
		endcase
	end*/
			
