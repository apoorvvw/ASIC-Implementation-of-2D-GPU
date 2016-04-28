// $Id: $
// File name:   Bresenham_Controller.sv
// Created:     4/19/2016
// Author:      Shubham Sandeep Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Decode Block for Decoding instructions
//Everything is working
module bresenham_controller
(
	input logic clk,
	input logic n_rst,
	input logic draw_done,
	input logic vertice_num,
	input logic bla_en,
	input logic [47:0]coordinates,
	output logic reset_buff,
	output logic [7:0] x0,
	output logic [7:0] y0,
	output logic [7:0] x1,
	output logic [7:0] y1,
	output logic draw_en,
	output logic bla_done
);
	typedef enum logic [3:0] {IDLE, MIN_CALC, DRAW2, DRAW3_1, DRAW3_2, DRAW3_3, DONE, WAIT2, WAIT3_1, WAIT3_2, DONE_WAIT, RESET} state_type;
	state_type state, next_state;
	reg [7:0] min_x;
	reg [7:0] min_y;
	reg [7:0] next_min_x;
	reg [7:0] next_min_y;
	always_ff @ (posedge clk, negedge n_rst)
	begin
		if(n_rst == 0)
			state <= IDLE; 
			min_x <= '0;
			min_y <= '0;
		else
			state <= next_state;
			min_x <= next_min_x;
			min_y <= next_min_y;
	end

	always_comb
	begin
		draw_en = 1'b0;
		bla_done = 1'b0;
		reset_buff = 1'b0;
		x0 = '0;
		y0 = '0;
		x1 = '0;
		y1 = '0;
		next_state = state;
		next_min_x = min_x;
		next_min_y = min_y;
		case (state)
		IDLE: begin
			draw_en = 1'b0;
			bla_done = 1'b0;
			reset_buff = 1'b0;
			x0 = '0;
			y0 = '0;
			x1 = '0;
			y1 = '0;
			if(bla_en == 1'b1)
				next_state = MIN_CALC;
			else
				next_state = IDLE;
		end
		MIN_CALC:
		begin
			if(vertice_num == 1'b1)
			begin
				next_min_x = coordinates[7:0];
            			if (coordinates[23:16] < min_x)
                			next_min_x = coordinates[23:16];
            			if (coordinates[39:32] < min_x)
                			next_min_x = coordinates[39:32];

           
            			next_min_y = coordinates[15:8];
            			if (coordinates[31:24] < min_y)
                			next_min_x = coordinates[31:24];
            			if (coordinates[47:40] < min_y)
                			next_min_x = coordinates[39:32];
			end
			else
			begin
				next_min_x = coordinates[7:0];
				if(coordinates[23:16] < min_x)
					next_min_x = coordinates[23:16];
				next_min_y = coordinates[15:8];
            			if (coordinates[31:24] < min_y)
                			next_min_x = coordinates[31:24];
			end
			next_state = RESET;
		end
		RESET:
		begin
			draw_en = 1'b0;
			bla_done = 1'b0;
			reset_buff = 1'b1;
			x0 = '0;
			y0 = '0;
			x1 = '0;
			y1 = '0;
			if(vertice_num == 1'b1)
				next_state = DRAW3_1;
			else
				next_state = DRAW2;
		end
		DRAW2: begin
			draw_en = 1'b1;
			bla_done = 1'b0;
			reset_buff = 1'b0;
			x0 = coordinates[7:0] - min_x;
			y0 = coordinates[15:8] - min_y;
			x1 = coordinates[23:16] - min_x;
			y1 = coordinates[31:24] - min_y;
			if(draw_done == 1'b1)
				next_state = WAIT2;
			else
				next_state = DRAW2;
		end
		WAIT2: begin
			draw_en = 1'b0;
			bla_done = 1'b0;
			reset_buff = 1'b0;
			x0 = '0;
			y0 = '0;
			x1 = '0;
			y1 = '0;
			next_state = DONE;
		end
		DRAW3_1: begin
			draw_en = 1'b1;
			bla_done = 1'b0;
			reset_buff = 1'b0;
			x0 = coordinates[7:0] - min_x;
			y0 = coordinates[15:8] - min_y;
			x1 = coordinates[23:16] - min_x;
			y1 = coordinates[31:24] - min_y;
			if(draw_done == 1'b1)
				next_state = WAIT3_1;
			else
				next_state = DRAW3_1;
		end
		WAIT3_1: begin
			draw_en = 1'b0;
			bla_done = 1'b0;
			reset_buff = 1'b0;
			x0 = '0;
			y0 = '0;
			x1 = '0;
			y1 = '0;
			next_state = DRAW3_2;
		end
		DRAW3_2: begin
			draw_en = 1'b1;
			bla_done = 1'b0;
			reset_buff = 1'b0;
			x0 = coordinates[7:0] - min_x;
			y0 = coordinates[15:8] - min_y;
			x1 = coordinates[39:32] - min_x;
			y1 = coordinates[47:40] - min_y;
			if(draw_done == 1'b1)
				next_state = WAIT3_2;
			else
				next_state = DRAW3_2;		
		end
		WAIT3_2: begin
			draw_en = 1'b0;
			bla_done = 1'b0;
			reset_buff = 1'b0;
			x0 = '0;
			y0 = '0;
			x1 = '0;
			y1 = '0;
			next_state = DRAW3_3;
		end
		DRAW3_3: begin
			draw_en = 1'b1;
			bla_done = 1'b0;
			reset_buff = 1'b0;
			x0 = coordinates[23:16] - min_x;
			y0 = coordinates[31:24] - min_y;
			x1 = coordinates[39:32] - min_x;
			y1 = coordinates[47:40] - min_y;
			if(draw_done == 1'b1)
				next_state = DONE;
			else
				next_state = DRAW3_3;
		end
		DONE: begin
			draw_en = 1'b0;
			bla_done = 1'b1;
			reset_buff = 1'b0;
			x0 = '0;
			y0 = '0;
			x1 = '0;
			y1 = '0;
			next_state = DONE_WAIT;		
		end
		DONE_WAIT: begin
			draw_en = 1'b0;
			bla_done = 1'b0;
			reset_buff = 1'b0;
			x0 = '0;
			y0 = '0;
			x1 = '0;
			y1 = '0;
			next_state = IDLE;		
		end
		endcase
	end
endmodule
