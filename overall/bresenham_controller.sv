// $Id: $
// File name:   Bresenham_Controller.sv
// Created:     4/19/2016
// Author:      Shubham Sandeep Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: This block is the FSM for the Bresenham module.
//				It makes sure that the bresenham gets the correct coordinates
//				and draws the lines. This block sends a done to the fill block
//				which enables it.



//Everything is working

module bresenham_controller
(
	input wire clk,
	input wire n_rst,
	
	input logic draw_done,			// bresenham module returns this signifying line is drawn
	input logic vertice_num,		// Number of vertices either 2 or 3
	input logic bla_en,				// Enables this module
	input logic [47:0]coordinates,	// input coordinates where the shape needs to be drawn
	
	output logic reset_buff,		// Clears the buffer when layer is done
	
	output logic [7:0] x0,			// These are inputs to the bresenham block which tell it between which two pointst the line needs to be drawn
	output logic [7:0] y0,
	output logic [7:0] x1,
	output logic [7:0] y1,
	
	output logic draw_en,
	output logic bla_done			// High for 1 cycle when the entire shape is done drawing
);
	typedef enum logic [3:0] {IDLE, MIN_CALC, DRAW2, DRAW3_1, DRAW3_2, DRAW3_3, DONE, WAIT2, WAIT3_1, WAIT3_2, DONE_WAIT, RESET} state_type;
	state_type state, next_state;
	reg [7:0] min_x;
	reg [7:0] min_y;
	reg [7:0] next_min_x;
	reg [7:0] next_min_y;

	// STATE REGISTER
	always_ff @ (posedge clk, negedge n_rst)
	begin
		if(n_rst == 0)
		begin
			state <= IDLE; 
			min_x <= '0;
			min_y <= '0;
		end else begin
			state <= next_state;
			min_x <= next_min_x;
			min_y <= next_min_y;
		end
	end

	// NEXT STATE LOGIC and OUTPUT LOGIC
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
			if(bla_en == 1'b1)
				next_state = MIN_CALC;
			else
				next_state = IDLE;
		end
		MIN_CALC:			// Selects which coordniates go first
		begin
			if(vertice_num == 1'b1)
			begin
						next_min_x = coordinates[7:0];
            			if (coordinates[23:16] < next_min_x)
                			next_min_x = coordinates[23:16];
            			if (coordinates[39:32] < next_min_x)
                			next_min_x = coordinates[39:32];

           
            			next_min_y = coordinates[15:8];
            			if (coordinates[31:24] < next_min_y)
                			next_min_y = coordinates[31:24];
            			if (coordinates[47:40] < next_min_y)
                			next_min_y = coordinates[47:40];
			end
			else
			begin
						next_min_x = coordinates[7:0];
						if(coordinates[23:16] < next_min_x)
							next_min_x = coordinates[23:16];
						next_min_y = coordinates[15:8];
            			if (coordinates[31:24] < next_min_y)
                			next_min_y = coordinates[31:24];
			end
			next_state = RESET;
		end
		RESET:
		begin
			reset_buff = 1'b1;
			if(vertice_num == 1'b1)
				next_state = DRAW3_1;
			else
				next_state = DRAW2;
		end
		DRAW2: begin 					// Moves the shape to the top left of the buffer for easy in manupulation in other modules
			draw_en = 1'b1;
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
			next_state = DONE;
		end
		DRAW3_1: begin 			// Draw First line 
			draw_en = 1'b1;
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
			next_state = DRAW3_2;
		end
		DRAW3_2: begin				// Draw Second line 
			draw_en = 1'b1;
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
			next_state = DRAW3_3;
		end
		DRAW3_3: begin 			// Draw Thrid line 
			draw_en = 1'b1;
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
			bla_done = 1'b1;
			next_state = DONE_WAIT;		
		end
		DONE_WAIT: begin 			// reset the bla_done flag
			next_state = IDLE;		
		end
		endcase
	end
endmodule
