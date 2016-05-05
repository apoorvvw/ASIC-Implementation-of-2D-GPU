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
	output reg [4095:0] line_buffer,
	output reg done
);

	//Variable declarations

	logic signed [8:0]  deltaY; //absolute difference in Y coordinates
	logic signed [8:0]  deltaX; //absolute difference in X coordinates
	logic signed [1:0] sx; //Coordinate increment or decrement value
	logic signed [1:0] sy; //Coordinate increment or decrement value

	logic [4095:0] next_line_buffer; //Next state line buffer
	
	logic signed [8:0] nextErr;  //Next state error
	logic signed [8:0] currentErr; //current error, difference of deltaX and deltaY

	logic signed [8:0] nextETwo; //next state E two
	logic signed [8:0] currentETwo; //current E two used to decide increment in x and y
	
	logic signed [8:0] currentX; //current state X coordinate value
	logic signed [8:0] nextX; //next state X coordinate value
	
	logic signed [8:0] currentY; //current state Y coordinate value
	logic signed [8:0] nextY; //Next state Y coordinate value
	
	integer i;
	
	typedef enum logic [2:0] {IDLE, CALC, PROCESS, PROCESS_WAIT, RESET, DONE} state_type;
	state_type next_state , current_state;

	//signed coordinate
	wire signed[8:0] x0_signed, x1_signed, y1_signed, y0_signed;
	assign x0_signed = $signed(x0); 
	assign x1_signed = $signed(x1);
	assign y0_signed = $signed(y0);
	assign y1_signed = $signed(y1);
	
	//calculation of deltaX, deltaY, sx and sy
	assign deltaX = (x0_signed < x1_signed) ? (x1_signed - x0_signed) : (x0_signed - x1_signed); //has to be postive
	assign deltaY = (y0_signed < y1_signed) ? (y1_signed - y0_signed) : (y0_signed - y1_signed); //has to be positive
	assign sx =  (x0_signed < x1_signed) ? 1 : -1; //decrement if x0 is > x1 and vice versa
	assign sy =  (y0_signed < y1_signed) ? 1 : -1; //decrement if y0 is > y1 and vice versa

	always_ff @ ( posedge clk, negedge n_rst ) begin
		
		//reset to 0
		if (n_rst == 1'b0) begin
			current_state <= IDLE;
			currentErr <= '0; 
			currentETwo <= '0; 
			currentX <= '0; 
			currentY <= '0;	
			line_buffer <= '0;

		end
		//next state logic
		else begin
			currentErr <= nextErr; 
			currentETwo <= nextETwo; 
	 		currentX <= nextX; 
	 		currentY <= nextY;
	 		current_state <= next_state;
			line_buffer <= next_line_buffer;

		end
	end

    always_comb begin:	NEXT_STATE_LOGIC
		
		//default asignments
		next_state = current_state;
		nextErr = currentErr; 
		nextETwo = currentETwo;
		nextX = currentX;
		nextY = currentY;
		next_line_buffer = line_buffer;
		done = 1'b0;
		case(current_state)
			//Idle state
			IDLE: begin
				//calculations
				i = 0;
				done = 1'b0;
				nextErr = deltaX - deltaY;
				nextX = x0_signed;
				nextY = y0_signed;
				//reset the lien buffer is reset buff is high
				if(reset_buff == 1'b1)
					next_state = RESET;
				//if bla enable is high, beign calculations
				else if (start) begin
					next_state = CALC;
					nextETwo = 2 * currentErr;					
				end
				//else stay here
				else
					next_state = IDLE;
				
			end
			//Calculation state
			CALC:
			begin
				//calculate E two value
				nextETwo = 2 * currentErr;
				next_state = PROCESS;
			end
			//BLA main logic
			PROCESS: begin
				//Make current coordinate a 1 on buffer
				next_line_buffer [currentY * 64 + currentX] = 1'b1;
				//get out of state if BLA is done
				if (currentX == x1_signed && currentY == y1_signed)
				begin
					next_state = DONE;   
				end 
				//else continue BLA algorithm
				else 
				begin 
					//increment in Y and X
					if((currentETwo > (-1 *deltaY)) && ($signed(currentETwo) < $signed(deltaX)) && (currentX != x1_signed) && (currentY != y1_signed))
					begin
						nextErr = currentErr - deltaY + deltaX;
						nextX = $signed(currentX) + $signed(sx); 
						nextY = $signed(currentY) + $signed(sy); 
					end
					//increment in X
					else if(currentX != x1_signed && (currentETwo > (-1 *deltaY)))
					begin
						nextErr = currentErr - deltaY; 
						nextX = $signed(currentX) + $signed(sx); 
								
					end 
					//increment in Y
					else if((currentY != y1_signed) && ($signed(currentETwo) < $signed(deltaX)))
					begin
						nextErr = currentErr + deltaX; 
						nextY = $signed(currentY) + $signed(sy); 
					end
					//wait for values to be set for 1 clock cycle				
					next_state = PROCESS_WAIT;
					
				end 

			end
			//wait state for 1 clock cycle
			PROCESS_WAIT:
			begin
				//go to calc state again after 1 clock cycle
				next_state = CALC;
			end
			
			//if line buffer needs reset, reset the buffer
			RESET:
			begin
				next_line_buffer = 4096'd0; //reset line buffer
				//go to idle if a enable comes				
				if (start) begin
					next_state = IDLE;
					nextETwo = 2 * currentErr;					
				end
				// stay in reset
				else
					next_state = RESET;
				
			end
			//done state
			DONE: begin
				next_state = IDLE;
				done = 1'b1; //done flag high for 1 cycle
			end
		endcase


	end
endmodule // bresenham

