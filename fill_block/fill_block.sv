// $Id: $
// File name:   decode_block.sv
// Created:     4/22/2016
// Author:      Yudi Wu
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Fill block for filling on SRAM


/*
This block right now only is able to fill in color_code in pixels.

SRAM ADDRESS
layerbuffer1 	0~65535
layerbuffer2 	65536~131071
texture1    	131072~135167
texture2		135168~139263
texture3		139264~143359


*/
module fill_block
#(
	ADDR_SIZE_BITS = 24,
	WORD_SIZE_BYTES = 3,
	DATA_SIZE_WORDS = 64
	
)
(
	input logic clk,
	input logic n_rst,
	input logic fill_type,

	input logic [47:0] coordinates,
	input logic [1:0] texture_code,
	input logic [23:0] color_code,
	input logic layer_num,
	input logic [4095:0] line_buffer,

	input logic math_start,
	input logic row_start,
	input logic fill_start,
	output logic fill_done,
	output logic all_finish,
	
	output logic read_enable,
	output logic write_enable,
	input logic [((WORD_SIZE_BYTES * DATA_SIZE_WORDS * 8) - 1):0] read_data,
	output logic [((WORD_SIZE_BYTES * DATA_SIZE_WORDS * 8) - 1):0] write_data,
	output reg [(ADDR_SIZE_BITS-1):0] address

);
    reg [31:0] i,nexti,j;
    
    reg [7:0]xmin,nextxmin;
    reg [7:0]ymin,nextymin;
    
   
       
    always_ff @ (posedge clk,negedge n_rst)
	begin
	    if(n_rst == 0) begin
            xmin <= '0;
            ymin <= '0;
            i <= '0;
        end 
        else 
        begin
			xmin <= nextxmin;
       	    ymin <= nextymin;
       	    if(math_start)
       	    	i <= '0;
       	    else
       	    	i <= nexti;
		end
    end

   //find ymin,xmin
    always_comb 
    begin
        nextxmin = xmin;
        nextymin = ymin;
        if(math_start == 1'b1)
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
                nextymin = coordinates[39:32];
			
        end

    end
    
	reg unsigned [23:0]currentaddress, nextaddress;
	reg [63:0]lineline;
	reg [5:0]adr1;
	reg [5:0]adr2;
	reg found_flag;
	
   typedef enum logic [2:0] {IDLE, FILL, WAIT1, WAIT2, UPDATE, DONE} 
	state_type;
	state_type state, next_state;
	
    always_ff @ (posedge clk, negedge n_rst)
	begin
	    if(n_rst == 0) begin
	    	currentaddress <= 24'h000000;
	    	state <= IDLE;
	   	end else begin
	   		state <= next_state;
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
	
   //get sdram address for the xmin,ymin for layer buffer
   	
    always_comb
    begin
    
    	read_enable = 0;
    	write_enable = 0;
		
		if(row_start)
		begin
			address = currentaddress;
			read_enable = 1'b1;
		end
		

		address = 24'h000000;
		nexti = i;
		nextaddress = currentaddress;
		next_state = state;
		found_flag = 0;
		fill_done = 0;
		case(state)
        IDLE: begin
            if(fill_start)
            	next_state = FILL;
        end
        FILL: begin
			write_data = read_data;
        	//load 64 bits from sram
            lineline = line_buffer[i*64+:64];
        	//find a1, find a2
            for (j = 0; j < 64; j++)
            begin
                if(lineline[j] == 1'b1)
                begin
                    adr1 = j;
                    found_flag = 1;
                    break;
                end             
            end
            
            //if there is information on the line, do next ste
            if(found_flag) begin
		        for (j = 63; j >= 0; j--)
		        begin
		            if(lineline[j] == 1'b1)
		            begin
		                adr2 = j;
		                break;
		            end    
		        end
		        
		        //if two address are equal, only fill that pixel
		        
		        if (adr1 == adr2) begin
		        
		        	write_data[adr1 * 24+:24] = color_code;
		       	end else 
		       	begin//fill anything in between
		       		for(j = 0; j < 64; j++)
		       		begin
		       		
		       			if(j >= adr1)
		       			begin
		       			
 							if(j > adr2) begin
		       				    break;
		       				end else begin
		       					write_data[(j * 24)+:24] = color_code;  
		       				end    
		       			end
		       			
		       		end
		       	end
		       	
		       	
		    end
		 	next_state = WAIT1;
		end
		WAIT1: begin
		    address = currentaddress;
		    write_enable = 1;	
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
		    next_state = DONE;
		   
        end
       	DONE: begin
       		fill_done = 1;
            if(fill_start & ~all_finish) 
            	next_state = FILL;
       	end
       	endcase
	end
	assign all_finish = (i >= 64);
	
endmodule
