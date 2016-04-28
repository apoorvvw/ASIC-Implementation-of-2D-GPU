// $Id: $
// File name:   fill.sv
// Created:     4/27/2016
// Author:      Yudi Wu
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: new fill block

/*
SRAM ADDRESS
layerbuffer1 	0~65535
layerbuffer2 	65536~131071
texture1    	131072~135167
texture2		135168~139263
texture3		139264~143359

outputbuffer    143360~208895
*/

module fill
#(
	ADDR_SIZE_BITS = 24,
	WORD_SIZE_BYTES = 3,
	DATA_SIZE_WORDS = 64
	
)
(
	input wire clk,
	input wire n_rst,
	input wire fill_en,
	output reg 	fill_done,
	input logic fill_type,
	
	input logic [47:0] coordinates,
	input logic [1:0] texture_code,
	input logic vertice_num,
	input logic [23:0] color_code,
	input logic layer_num,
	input logic [4095:0] line_buffer,
	
	output logic read_enable,
	output logic write_enable,
	input logic [((WORD_SIZE_BYTES * DATA_SIZE_WORDS * 8) - 1):0] read_data,
	output logic [((WORD_SIZE_BYTES * DATA_SIZE_WORDS * 8) - 1):0] write_data,
	output reg [(ADDR_SIZE_BITS-1):0] address

);

    reg [31:0] i,nexti,j,k,next_k,h;
    reg found_flag;
    reg [5:0]adr1,adr2,next_adr1,next_adr2;
    reg [7:0]xmin,nextxmin;
    reg [7:0]ymin,nextymin;
    reg [23:0]currentaddress, nextaddress;
    logic [((WORD_SIZE_BYTES * DATA_SIZE_WORDS * 8) - 1):0] next_write_data;
    reg [63:0] lineline;
    typedef enum logic [3:0] {IDLE, MATH, READ, WAIT1, FIND1,INITIAL,FIND2,FILL, WAIT2, UPDATE, DONE} 
	state_type;
	state_type state, next_state;
   
       
    always_ff @ (posedge clk,negedge n_rst)
	begin
	    if(n_rst == 0) begin
            xmin <= '0;
            ymin <= '0;
            i <= '0;
            k <= '0;
            currentaddress <= 24'h000000;
	    	state <= IDLE;
	    	write_data <= '0;
	    	adr1 <= 0;
	    	adr2 <= 0;
        end 
        else 
        begin
			xmin <= nextxmin;
       	    ymin <= nextymin;
       	    i <= nexti;
       	    k <= next_k;
       	    state <= next_state;
       	    write_data <= next_write_data;
       	    adr1 <= next_adr1;
       	    adr2 <= next_adr2;
	  		if( nexti == 0)
	  		begin
				if(layer_num == 0)
				    currentaddress <= 0  + ymin * 256  + xmin;
				else
				    currentaddress <= 65536 + ymin * 256 + xmin;
			end
			else begin
				currentaddress <= nextaddress;
			end
		end
    end
    
    assign lineline = line_buffer[i*64+:64];
    
    always_comb
    begin
    	next_state = state;
    	nexti = i;
    	next_k = k;
    	nextxmin = xmin;
        nextymin = ymin;
        address = '0;
        read_enable = 0;
        write_enable = 0;
        nextaddress = currentaddress;
        next_write_data = write_data;
        found_flag = 0;
        next_adr1 = adr1;
        next_adr2 = adr2;
        fill_done = 0;
    	case(state)
    	IDLE: begin
			if(fill_en == 1'b1)
				next_state = MATH;
		end
		MATH: begin
			nexti = 0;
			if(vertice_num)
			begin
				nextxmin = coordinates[7:0];
		        if (coordinates[23:16] < nextxmin)
		            nextxmin = coordinates[23:16];
		        if (coordinates[39:32] < nextxmin)
		            nextxmin = coordinates[39:32];

		       
		        nextymin = coordinates[15:8];
		        if (coordinates[31:24] < nextymin)
		            nextymin = coordinates[31:24];
		        if (coordinates[47:40] < nextymin)
		            nextymin = coordinates[47:40];
			end
    		else
			begin
				nextxmin = coordinates[7:0];
				if(coordinates[23:16] < nextxmin)
					nextxmin = coordinates[23:16];
					
				nextymin = coordinates[15:8];
            	if (coordinates[31:24] < nextymin)
                	nextymin = coordinates[31:24];
			end
			next_state = READ;
    	end
    	
    	READ: begin
    		if(i == 64) begin
				next_state = DONE;
			end else begin
				address = currentaddress;
				read_enable = 1'b1;
				next_state = WAIT1;
			end
    	end
    	
    	WAIT1: begin
    		address = currentaddress;
			read_enable = 1'b1;
			next_state = FIND1;
		end
		FIND1: begin
			next_write_data  = read_data;
			for (j = 0; j < 64; j++)
            begin
                if(lineline[j] == 1'b1)
                begin
                    next_adr1 = j;
                    found_flag = 1;
                    break;
                end             
            end
            if(found_flag)
            	next_state = INITIAL;
            else
            	next_state = WAIT2;
        end
        
        INITIAL: begin
			next_k = 63;
			next_state = FIND2;
		end
		FIND2: begin
		    if(lineline[k] == 1'b1)
		    begin
		        next_adr2 = k;
		        next_state = FILL; 
		    end else begin   
				next_k = k - 1;
		    	next_state = FIND2;
		    	if (k == 0)
		    		next_state = FILL;
		    end
		end
		

        
        FILL: begin
        	if(adr1 == adr2)
        		next_write_data[adr1 * 24+:24] = color_code;
        	else
      		begin//fill anything in between
		    for(h = 0; h < 64; h++)
		        begin
		       		if(h >= adr1)
		       		begin
		       			if(h > adr2) begin
		       				break;
		       			end else begin
		       				next_write_data[(h * 24)+:24] = color_code;  
		       			end    
		       		end
		       			
		        end
		   	end
        	next_state = WAIT2;
        end
        
		WAIT2: begin
		    address = currentaddress;
		    write_enable = 1;	
			next_state = UPDATE;
		end
		UPDATE: begin
		    nextaddress = currentaddress + 24'd256;
		    nexti = i + 1;
		    next_state = READ;
		   
        end
        DONE: begin
        	fill_done = 1;
        	next_state = IDLE;
        end
    	endcase
    
    end
    

endmodule
