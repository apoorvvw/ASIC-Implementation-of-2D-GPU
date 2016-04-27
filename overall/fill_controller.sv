    // $Id: $
// File name:   fill_controller.sv
// Created:     4/23/2016
// Author:      Shubham Sandeep Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Fill block controller

module fill_controller
(
	input logic clk,
	input logic n_rst,
	input logic fill_en,
	input logic fill_done,
	input logic all_finish,
	output logic math_start,
	output logic row_start,
	output logic fill_start,
	output logic done
);
typedef enum logic [3:0] {IDLE, MATH, WAIT1, READROW, WAIT2, FILL, WAIT3, DONE} 
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
		math_start = 1'b0;
		row_start = 1'b0;
		fill_start = 1'b0;
		done = 1'b0;
		
		case(state)
		IDLE: begin
			if(fill_en == 1'b1)
				next_state = MATH;
		end
		MATH: begin
			math_start = 1'b1;
			next_state = WAIT1;
		end
		WAIT1:
		begin
			next_state = READROW;
	
		end
		READROW: begin
			if(all_finish == 1'b1) begin
				next_state = DONE;
			end else begin
				row_start = 1'b1;
				next_state = WAIT2;
			end

		end	
		
		WAIT2:
		begin
			next_state = FILL;
	
		end
		FILL:
		begin
			fill_start = 1'b1;
			next_state = WAIT3;
	
		end
		WAIT3:
		begin
			if(fill_done == 1'b1)
				next_state = READROW;
	
		end
		
		DONE:
		begin
			done = 1'b1;
			next_state = IDLE;
		end
		endcase
	end
endmodule

