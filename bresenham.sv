// $Id: $ 007
// File name:   bresenham.sv
// Created:     4/19/2016
// Author:      Apoorv Wairagade
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Draws line segments
module bresenham(
	input wire clk,
	input wire n_rst,
	input wire x0,
	input wire y0,
	input wire x1,
	input wire y1,
	input wire start,

	output reg x, 
	output reg y,
	output reg [4159:0] line_buffer,
	output reg done
);

	//Variable declarations

	logic [5:0] signed initialP; 

	logic [5:0] signed deltaY;
	logic [5:0] signed deltaX; 
	logic [5:0] signed positiveIncrement; 
	logic [5:0] signed negativeIncrement;

	logic [5:0] currentX; 
	logic [5:0] nextX; 
	
	logic [5:0] currentY; 
	logic [5:0] nextY; 
	
	logic [5:0] signed currentP; 
	logic [5:0] signed nextP;

	typedef enum logic [1:0] {IDLE , PROCESS , DONE } state_type;
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
			line_buffer <= '0;
		end
		else begin
			currentP <= nextP; 
	 		currentX <= nextX; 
	 		currentY <= nextY;
	 		current_state <= next_state;
	 	end
	end

    always_comb begin:	NEXT_STATE_LOGIC

		case(current_state)
		
			IDLE: 
			begin
				
				if (start)
					next_state = PROCESS;

				currentP = initialP;
				currentX = x0;
				currentY = y0;
			end

			PROCESS:
			begin
				if(currentP  < 1'b0)
				begin
					nextX = currentX + 1'b1;
					nextY = currentY; 
				end 
				else 
					nextX = currentX + 1'b1;
					nextY = currentY + 1'b1;
				end

				if( currentP > 1'b0)
					begin
						nextP = currentP + positiveIncrement;
					end 
					else 
					begin 
						nextP = currentP + negativeIncrement; 
					end
				end 

				next_state = current_state;
				if ( x1 == currentX ) && ( y1 == currentY )
					next_state = DONE;				

			end

			DONE:
			begin
				next_state = IDLE;
				done = 1'b1;
			end	
		
		//OUTPUT LOGIC
		// set pixel
		line_buffer [ 65*currentX + currentY ] = 1'b1;

	end
endmodule // bresenham
