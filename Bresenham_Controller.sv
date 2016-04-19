// $Id: $
// File name:   Bresenham_Controller.sv
// Created:     4/19/2016
// Author:      Shubham Sandeep Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Decode Block for Decoding instructions

module Bresenham_Controller
(
	input logic draw_done,
	input logic vertice_num,
	input logic bla_en,
	input logic coordinates[47:0],
	output logic x0[7:0],
	output logic y0[7:0],
	output logic x1[7:0],
	output logic y1[7:0],
	output logic draw_en,
	output logic bla_done
);
typedef enum logic [3:0] {IDLE, DRAW2, DRAW3_1, DRAW3_2, DRAW3_3, DONE, WAIT2, WAIT3_1, WAIT3_2, DONE_WAIT};
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
		draw_en = 1'b0;
		bla_done = 1'b0;
		x0 = '0;
		y0 = '0;
		x1 = '0;
		y1 = '0;
		next_state = state;
		case (state)
		IDLE: begin
			draw_en = 1'b0;
			bla_done = 1'b0;
			x0 = '0;
			y0 = '0;
			x1 = '0;
			y1 = '0;
			if(bla_en == 1'b1 && vertice_num == 1'b1)
				next_state = DRAW3_1;
			else if(bla_en == 1'b1 && vertice_num == 1'b0)
				next_state = DRAW2;
			else
				next_state = IDLE;
		end
		DRAW2: begin
			draw_en = 1'b1;
			bla_done = 1'b0;
			x0 = coordinates[7:0];
			y0 = coordinates[15:8];
			x1 = coordinates[23:16];
			y1 = coordinates[31:24];
			if(draw_done == 1'b1)
				next_state = WAIT2;
			else
				next_state = DRAW2;
		end
		WAIT2: begin
			draw_en = 1'b0;
			bla_done = 1'b0;
			x0 = '0;
			y0 = '0;
			x1 = '0;
			y1 = '0;
			next_state = DONE;
		end
		DRAW3_1: begin
			draw_en = 1'b1;
			bla_done = 1'b0;
			x0 = coordinates[7:0];
			y0 = coordinates[15:8];
			x1 = coordinates[23:16];
			y1 = coordinates[31:24];
			if(draw_done == 1'b1)
				next_state = WAIT3_1;
			else
				next_state = DRAW3_1;
		end
		WAIT3_1: begin
			draw_en = 1'b0;
			bla_done = 1'b0;
			x0 = '0;
			y0 = '0;
			x1 = '0;
			y1 = '0;
			next_state = DRAW3_2;
		end
		DRAW3_2: begin
			draw_en = 1'b1;
			bla_done = 1'b0;
			x0 = coordinates[7:0];
			y0 = coordinates[15:8];
			x1 = coordinates[39:32];
			y1 = coordinates[47:40];
			if(draw_done == 1'b1)
				next_state = WAIT3_2;
			else
				next_state = DRAW3_2;		
		end
		WAIT3_2: begin
			draw_en = 1'b0;
			bla_done = 1'b0;
			x0 = '0;
			y0 = '0;
			x1 = '0;
			y1 = '0;
			next_state = DRAW3_3;
		end
		DRAW3_3: begin
			draw_en = 1'b1;
			bla_done = 1'b0;
			x0 = coordinates[23:16];
			y0 = coordinates[31:24];
			x1 = coordinates[39:32];
			y1 = coordinates[47:40];
			if(draw_done == 1'b1)
				next_state = DONE;
			else
				next_state = DRAW3_3;
		end
		DONE: begin
			draw_en = 1'b0;
			bla_done = 1'b1;
			x0 = '0;
			y0 = '0;
			x1 = '0;
			y1 = '0;
			next_state = DONE_WAIT;		
		end
		DONE_WAIT: begin
			draw_en = 1'b0;
			bla_done = 1'b0;
			x0 = '0;
			y0 = '0;
			x1 = '0;
			y1 = '0;
			next_state = IDLE;		
		end
		endcase
	end
endmodule
