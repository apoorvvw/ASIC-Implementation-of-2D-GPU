// $Id: $
// File name:   bresenham.sv
// Created:     4/23/2016
// Author:      Pooja Kale
// Lab Section: 04
// Version:     1.0  Initial Design Entry
// Description: Bresenham


module bresenham
(
	input wire clk,
	input wire n_rst,
	input wire [7:0] x0,
	input wire [7:0] y0,
	input wire [7:0] x1,
	input wire [7:0] y1,
	input wire start,
	input wire reset_buff,
	output reg x,
	output reg y,
	output reg [63:0] [63:0] picture,
	output reg [4095:0] line_buffer,
	output reg done
);

	//Variable declarations


	logic signed [8:0]  deltaY;
	logic signed [8:0]  deltaX; 
	logic signed [1:0] sx; 
	logic signed [1:0] sy;

	
	logic signed [8:0] nextErr; // signed or unsigned? 
	logic signed [8:0] currentErr;

	logic signed [8:0] nextETwo; // signed or unsigned? 
	logic signed [8:0] currentETwo;
	
	logic signed [8:0] currentX; 
	logic signed [8:0] nextX; 
	
	logic signed [8:0] currentY; 
	logic signed [8:0] nextY; 
	
	logic [5:0] x0_mod;
	logic [5:0] y0_mod;
	logic [5:0] x1_mod;
	logic [5:0] y1_mod;
	
	
	integer i = 0;
	//reg [63:0] [63:0] pic;
	
	typedef enum logic [2:0] {IDLE, CALC, CALC_WAIT, PROCESS, PROCESS_WAIT, RESET, DONE} state_type;
	state_type next_state , current_state;

	//DataFlow
	assign x0_mod = x0 % 64;
	assign y0_mod = y0 % 64;
	assign x1_mod = x1 % 64;
	assign y1_mod = y1 % 64;
	assign deltaX = (x0_mod < x1_mod) ? (x1_mod - x0_mod) : (x0_mod - x1_mod); 
	assign deltaY = (y0_mod < y1_mod) ? (y1_mod - y0_mod) : (y0_mod - y1_mod); 
	assign sx =  (x0_mod < x1_mod) ? 1 : -1;
	assign sy =  (y0_mod < y1_mod) ? 1 : -1;	
    // State register
	always_ff @ ( posedge clk, negedge n_rst ) begin
		
		if (n_rst == 1'b0) begin
			current_state <= IDLE;
			currentErr <= deltaX - deltaY; 
			currentETwo <= 2 * currentErr; 
			currentX <= x0_mod; 
			currentY <= y0_mod;	
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
		line_buffer = '0;
		picture ='0;
		done = 1'b0;
		case(current_state)
		
			IDLE: begin
				i = 0;
				done = 1'b0;
				nextErr = deltaX - deltaY;
				nextX = x0_mod;
				nextY = y0_mod;
				if(reset_buff == 1'b1)
					next_state = RESET;
				else if (start) begin
					next_state = CALC;
					nextETwo = 2 * currentErr;					
				end
				else
					next_state = IDLE;
				
			end
			
			CALC:
			begin
				nextETwo = 2 * currentErr;
				next_state = CALC_WAIT;
			end
			CALC_WAIT:
			begin
				next_state = PROCESS;
			end			
			
			PROCESS: begin
				picture[currentY][currentX] = 1'b1;
				line_buffer [currentY * 64 + currentX] = 1'b1;
				if (currentX == x1_mod && currentY == y1_mod)
				begin
					next_state = DONE;   
				end 
				else 
				begin 
					if((currentETwo > (-1 *deltaY)) && ($signed(currentETwo) < $signed(deltaX)) && (currentX != x1_mod) && (currentY != y1_mod))
					begin
						nextErr = currentErr - deltaY + deltaX;
						nextX = $signed(currentX) + $signed(sx); 
						nextY = $signed(currentY) + $signed(sy); 
					end
					else if(currentX != x1_mod && (currentETwo > (-1 *deltaY)))
					begin
						nextErr = currentErr - deltaY; 
						nextX = $signed(currentX) + $signed(sx); 
								
					end 
					else if((currentY != y1_mod) && ($signed(currentETwo) < $signed(deltaX)))
					begin
						nextErr = currentErr + deltaX; 
						nextY = $signed(currentY) + $signed(sy); 
					end
										
					next_state = PROCESS_WAIT;
					
				end 

			end
			PROCESS_WAIT:
			begin
				next_state = CALC;
			end
			
			RESET:
			begin
				picture = 4096'd0;
				line_buffer = 4096'd0;
				if (start) begin
					next_state = IDLE;
					nextETwo = 2 * currentErr;					
				end
				else
					next_state = RESET;
				
			end

			DONE: begin
				next_state = IDLE;
				done = 1'b1;
			end
			default:
			begin
				line_buffer = '0;
				picture ='0;
				done = 1'b0;
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

