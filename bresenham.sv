// $Id: $
// File name:   bresenham.sv
// Created:     4/23/2016
// Author:      Pooja Kale
// Lab Section: 04
// Version:     1.0  Initial Design Entry
// Description: Bresenham


module bresenham(
	input wire clk,
	input wire n_rst,
	input wire [7:0] x0,
	input wire [7:0] y0,
	input wire [7:0] x1,
	input wire [7:0] y1,
	input wire start,
	output reg x,
	output reg y,
	output reg test,
	output reg [4095:0] line_buffer,
	output reg [63:0] [63:0] picture,
	output reg done
);

	//Variable declarations


	logic [7:0]  deltaY;
	logic [7:0]  deltaX; 
	logic signed sx; 
	logic signed sy;

	
	logic signed [7:0] nextErr; // signed or unsigned? 
	logic signed [7:0] currentErr;

	logic signed [7:0] nextETwo; // signed or unsigned? 
	logic signed [7:0] currentETwo;
	
	logic [7:0] currentX; 
	logic [7:0] nextX; 
	
	logic [7:0] currentY; 
	logic [7:0] nextY; 
	
	
	integer row = 0;

	typedef enum logic [1:0] {IDLE, PROCESS, DONE } state_type;
	state_type next_state , current_state;

	//DataFlow
	assign deltaX = x1 - x0; 
	assign deltaY = y1 - y0; 
	assign sx =  (x0 < x1) ? 1: -1;
	assign sy =  (y0 < y1) ? 1: -1;	
    
    // State register
	always_ff @ ( posedge clk, negedge n_rst ) begin
		
		if (n_rst == 1'b0) begin
			current_state <= IDLE;
			currentErr <= deltaX - deltaY; 
			currentETwo <= 2 * currentErr; 
			currentX <= x0; 
			currentY <= y0;	
		end
		else begin
			currentErr <= nextErr; 
			currentETwo <= nextETwo; 
	 		currentX <= nextX; 
	 		currentY <= nextY;
	 		current_state <= next_state;
	 	end
	end

    always_comb begin:	NEXT_STATE_LOGIC
		
		next_state = current_state;
		nextErr = currentErr; 
		nextETwo = currentETwo;
		nextX = currentX;
		nextY = currentY;
		case(current_state)
		
			IDLE: begin
				done = 1'b0;
				picture  = 4096'b0;
				if (start)
					next_state = PROCESS;

				
			end

			PROCESS: begin
				picture[currentX][currentY] = 1'b1 ;
				if (currentX == x1)
				begin
					if(currentY == y1)
					begin
						next_state = DONE;  
					end  
				end 
				else 
				begin 
					nextETwo = 2 * currentErr;
					if(currentETwo > (-1 * deltaY))
					begin
						nextErr = currentErr - deltaY; 
						nextX = currentX + sx; 
								
					end 
					if( currentETwo < deltaX)  
					begin
						nextErr = currentErr + deltaX; 
						nextY = currentY + sy; 
					end
					
					next_state = PROCESS;
					
				end 

			end

			DONE: begin
				next_state = IDLE;
				done = 1'b1;
			end	
		endcase
		//OUTPUT LOGIC
		// set pixel

		//line_buffer [ 64*currentY + currentX ] = 1'b1;
		//start = currentY * 64 + 64;
		//endd = currentY * 64;
		//line_buffer[: ] ;
				

		//assert(1) $display ("%b",test);

	end
endmodule // bresenham
