// $Id: $
// File name:   alpha_blend.sv
// Created:     4/17/2016
// Author:      Yudi Wu
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Alpha Blending 


//mighty alpha combinational state machine block

/*
SRAM ADDRESS
layerbuffer1 	0~65535
layerbuffer2 	65536~131071
texture1    	131072~135167
texture2		135168~139263
texture3		139264~143359

outputbuffer    143360~208895
*/

module alpha_blend
#(
	ADDR_SIZE_BITS = 24,
	WORD_SIZE_BYTES = 3,
	DATA_SIZE_WORDS = 64
	
)
(
    input wire clk,
    input wire n_rst,
   	input logic alpha_en,
   	input logic [3:0] alpha_value,
   	output reg alpha_done,
   	
   	output reg write_enable,
   	output reg read_enable,
   	output reg [(ADDR_SIZE_BITS-1):0] address,
	input logic [((WORD_SIZE_BYTES * DATA_SIZE_WORDS * 8) - 1):0] read_data,
	output reg [((WORD_SIZE_BYTES * DATA_SIZE_WORDS * 8) - 1):0] write_data
	
); 
	logic [3:0]alpha;
	wire [11:0]temp1, temp2;
	assign alpha = alpha_value;
	
	reg [31:0] j, next_j;
	wire [7:0] color1, color2;
	reg [(ADDR_SIZE_BITS-1):0] currentaddress, nextaddress;
	typedef enum logic [3:0] {IDLE, READ1, WAIT1, READ2, WAIT2, BLEND, WAIT3, WAIT4, UPDATE, DONE} 
	state_type;
	state_type state, next_state;
	reg [((WORD_SIZE_BYTES * DATA_SIZE_WORDS * 8) - 1):0] data1, next_data1, data2, next_data2;
	reg [((WORD_SIZE_BYTES * DATA_SIZE_WORDS * 8) - 1):0] next_write_data;
	always_ff @ (posedge clk, negedge n_rst)
	begin
		if(n_rst == 0)
		begin
			state <= IDLE;   
			j <= '0; 
			data1 <= '0;
			data2 <= '0;
			currentaddress <= '0;
			write_data <= '0;

		end
		else
		begin
			state <= next_state;	    
			j <= next_j;
			data1 <= next_data1;
			data2 <= next_data2;
			currentaddress <= nextaddress;
			write_data <= next_write_data;
			
		end
	end
	
	assign color1 = data1[(j * 8)+: 8];
	assign color2 = data2[(j * 8)+: 8];
	assign temp1 = color1 * alpha;
	assign temp2 = color2 * (4'd10 - alpha);
	
	always_comb
	begin
		next_state = state;
		next_j = j;
		alpha_done = 0;
		read_enable = 0;
		write_enable = 0;
		address = 0;
		next_data1 = data1;
		next_data2 = data2;
		next_write_data = write_data;
		nextaddress = currentaddress;


		case(state)
		IDLE: begin
			if(alpha_en)
				next_state = READ1;
		end
		READ1: begin
			if(currentaddress == 24'd65536)
			begin
				next_state = DONE;
			end else begin
				address = currentaddress;
				read_enable = 1'b1;
				next_state = WAIT1;
			end
		end
		WAIT1: begin
			next_data1 = read_data;
			next_state = READ2;
		end
		READ2: begin
			address = currentaddress + 24'd65536;
			read_enable = 1'b1;
			next_state = WAIT2;
		end
		
		WAIT2: begin
			next_data2 = read_data;
			next_j = 0;
			next_write_data = '0;
			next_state = BLEND;
		end
		
		BLEND: begin
			if(color1 == color2)
			begin
				next_write_data[(j * 8)+: 8] = color1;
			end
			else
			begin
				next_write_data[(j * 8)+: 8] = temp1/ 4'd10 + temp2/ 4'd10;
			end
			next_j = j + 1;
			next_state = BLEND;
			if(j == 192)
				next_state = WAIT3;
		end
		
		
		WAIT3: begin
		    address = currentaddress + 24'd143360;
		    write_enable = 1;	
			next_state = WAIT4;
		end
		WAIT4: begin
		    address = currentaddress + 24'd143360;
		    write_enable = 1;	
			next_state = UPDATE;
		end
			
		UPDATE: begin
			nextaddress = currentaddress + 24'd64;
			next_state = READ1;
		end
		DONE: begin
			alpha_done = 1;
			next_state = IDLE;
		end		
		endcase
	
	end
	
endmodule
