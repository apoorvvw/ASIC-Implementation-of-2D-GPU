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

	logic signed [7:0]  initialP; 

	logic signed [7:0]  deltaY;
	logic signed [7:0]  deltaX; 
	logic signed [7:0]  positiveIncrement; 
	logic signed [7:0]  negativeIncrement;

	logic [7:0] currentX; 
	logic [7:0] nextX; 
	
	logic [7:0] currentY; 
	logic [7:0] nextY; 
	
	logic signed [7:0]  currentP; 
	logic signed [7:0]  nextP;
	
	integer row = 0;

	typedef enum logic [1:0] {IDLE, PROCESS, DONE } state_type;
	state_type next_state , current_state;

	//DataFlow
	assign deltaX = x1 - x0; 
	assign deltaY = y1 - y0; 
	assign negativeIncrement =  (2 * deltaY);
	assign positiveIncrement = 2 * deltaY -  2 * deltaX;	
	assign initialP = (2 * deltaY) - deltaX;
    
    // State register
	always_ff @ ( posedge clk, negedge n_rst ) begin
		
		if ( n_rst == 1'b0) begin
			current_state <= IDLE;
			currentP <= initialP ;
			currentX <= x0; 
			currentY <= y0;	
		end
		else begin
			currentP <= nextP; 
	 		currentX <= nextX; 
	 		currentY <= nextY;
	 		current_state <= next_state;
	 	end
	end

    always_comb begin:	NEXT_STATE_LOGIC
		
		next_state = current_state;
		nextP = currentP;
		nextX = currentX;
		nextY = currentY;
		case(current_state)
		
			IDLE: begin
				//currentP = initialP;
				//currentX = x0;
				//currentY = y0;
				done = 1'b0;
				//line_buffer = 4096'b0;
				picture  = 4096'b0;
				if (start)
					next_state = PROCESS;

				
			end

			PROCESS: begin
				if(currentP  < 1'b0)
				begin
					nextX = currentX + 1'b1;
					nextY = currentY; 
				end 
				else 
				begin
					nextX = currentX + 1'b1;
					nextY = currentY + 1'b1;
				end

				row = row + 1;

				if(currentP > 1'b0)
				begin
					nextP = currentP + positiveIncrement;
				end 
				else 
				begin 
					nextP = currentP + negativeIncrement; 
				end
					
				next_state = PROCESS;

				if(x1 == currentX) 
				begin
					if(y1 == currentY)
					begin
						next_state = DONE;	
					end 
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

		picture[currentX][currentY] = 1'b1 ;				

		//assert(1) $display ("%b",test);

	end
endmodule // bresenham
