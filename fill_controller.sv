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
	input logic data_in,
	input logic math_done,
	input logic row_done,
	input logic fill_done,
	output logic fill_start,
	output logic math_start,
	output logic row_start
	output logic fill_start,
	output logic done
);
typedef enum logic [3:0] {IDLE, MATH, GETROW, FILL, DONE, MATH_WAIT, ROW_WAIT} 
	state_type;
	state_type state, next_state;
	IDLE: 
	begin
		math_start = 1'b0;
		fill_start = 1'b0;
		row_start = 1'b0;
		fill_start = 1'b0;
		done = 1'b0;
		if(fill_en == 1'b1)
			next_state = MATH;
		else
			next_state = IDLE;
	end
	MATH:
	begin
		math_start = 1'b1;
		fill_start = 1'b0;
		row_start = 1'b1;
		fill_start = 1'b0;
		done = 1'b0;
		if(math_done == 1'b1)
			next_state = MATH_WAIT;
		else
			next_state = MATH;
	end
	MATH_WAIT:
	begin
		math_start = 1'b0;
		fill_start = 1'b0;
		row_start = 1'b0;
		fill_start = 1'b0;
		done = 1'b0;
		next_state = GETROW;
	end
	GETROW:
	begin
		math_start = 1'b0;
		fill_start = 1'b0;
		row_start = 1'b1;
		fill_start = 1'b0;
		done = 1'b0;
		if(row_done == 1'b1)
			next_state = GETROW;
		else
			next_state = ROW_WAIT;
	end	
	ROW_WAIT:
	begin
		math_start = 1'b0;
		fill_start = 1'b0;
		row_start = 1'b0;
		fill_start = 1'b0;
		done = 1'b0;
		next_state = FILL;
	end
	FILL:
	begin
		math_start = 1'b0;
		fill_start = 1'b0;
		row_start = 1'b0;
		fill_start = 1'b1;
		done = 1'b0;
		if(fill_done == 1'b1)
			next_state = FILL_WAIT;
		else
			next_state = FILL;	
	end
	FILL_WAIT:
	begin
		math_start = 1'b0;
		fill_start = 1'b0;
		row_start = 1'b0;
		fill_start = 1'b0;
		done = 1'b0;
		next_state = DONE;
	end
	DONE:
	begin
		math_start = 1'b0;
		fill_start = 1'b0;
		row_start = 1'b0;
		fill_start = 1'b0;
		done = 1'b1;
		next_state = IDLE;
	end
	endcase
endmodule
