// $Id: $
// File name:   main_controller.sv
// Created:     4/12/2016
// Author:      Shubham Sandeep Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Main Controller of the GPU

module main_controller
(
	input wire decode_fin,
	input wire inst_type,
	input wire alpha_fin,
	input wire fifo_empty,
	input wire draw_fin,
	input wire config_in,
	input wire config_done,
	input wire decode_full,
	output reg decode_en,
	output reg alpha_en,
	output reg draw_en,
	output reg config_en
);
typedef enum logic [3:0] {IDLE, CONFIG, DECODE, DEC_DRAW, DRAW, ALPHA} 
	state_type;
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
			decode_en = 1'b0;
			draw_en = 1'b0;
			alpha_en = 1'b0;
			if(config_in == 1'b1)
				next_state = CONFIG;
			else
				next_state = IDLE;
		end
		CONFIG: begin
			config_en = 1'b1;
			decode_en = 1'b0;
			draw_en = 1'b0;
			alpha_en = 1'b0;
			if(config_done == 1'b1 && fifo_empty == 1'b0)
				next_state = DECODE;
			else
				next_state = CONFIG;
		end
		DECODE: begin
			config_en = 1'b0;
			decode_en = 1'b1;
			draw_en = 1'b0;
			alpha_en = 1'b0;
			if(decode_fin == 1'b1 && fifo_empty == 1'b0)
				next_state = DEC_DRAW;
			else if(decode_fin == 1'b1 && fifo_empty == 1'b1)
				next_state = DRAW;
			else if(inst_type == 1'b1) //Alpha instruction
				next_state = ALPHA;
		end
		DEC_DRAW: begin
			config_en = 1'b0;
			decode_en = 1'b1;
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
			decode_en = 1'b0;
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
			decode_en = 1'b0;
			draw_en = 1'b0;
			alpha_en = 1'b1;
			if(alpha_fin == 1'b0)
				next_state = ALPHA
			else
				next_state = IDLE;
		end
		endcase
	end
endmodule
			
