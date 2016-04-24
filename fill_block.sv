// $Id: $
// File name:   decode_block.sv
// Created:     4/22/2016
// Author:      Yudi Wu
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Fill block for filling on SRAM

module fill_block
(
	input logic clk,
	input logic n_rst,
	input logic fill_type,
	input wire math_en,
	input logic [47:0] coordinates,
	//input logic [1:0] texture_code,
	input logic [23:0] color_code,
	input logic layer_num,
	input logic [4095:0] line_buffer,
	//input logic [1535:0] texture,
	output reg math_done,
	output logic [1535:0] layer_row,
	

);
    integer i, j;
    reg [7:0]xmin, nextxmin;
    reg [7:0]ymin, nextymin;
    
    always_ff @ (posedge clk,negedge n_rst)
	begin
	    if(n_rst == 0) begin
            xmin <= '0;
            ymin <= '0;
        end 
        else 
        begin
			xmin <= nextxmin;
       	    ymin <= nextymin;
		end
    end
   //find ymin,xmin
    always_comb 
    begin
        //math_done = 0;
        nextxmin = xmin;
        nextymin = ymin;
        if(math_en == 1'b1)
        begin
            nextxmin = coordinates[7:0];
            if (coordinates[23:16] > nextxmin)
            begin
                nextxmin = coordinates[23:16];
            end
            if (coordinates[39:32] > nextxmin)
            begin
                nextxmin = coordinates[39:32];
            end
           
            nextymin = coordinates[15:8];
            if (coordinates[31:24] > nextymin)
            begin
                nextymin = coordinates[31:24];
            end
            if (coordinates[48:40] > nextymin)
            begin
                nextymin = coordinates[39:32];
            end
            math_done = 1'b1;
        end
		else
			math_done = 1'b0;
    end
    
   reg [31:0]currentaddress;
   reg [63:0]lineline;
   reg [5:0]adr1;
   reg [5:0]adr2;
   reg found_flag;
   //get sdram address for the xmin,ymin for layer buffer
    always_comb
    begin
        if(layer_num == 0)
        begin
            currentaddress = layerbuffer1 + ymin * 256 * 24 + xmin * 24;
        end
        else
        begin
            currentaddress = layerbuffer2 + ymin * 256 * 24 + xmin * 24;
        end
    
        //for all lines
		
        for (i = 0; i < 64; i++) 
        begin
        	found_flag = 0;
        	//load 64 * 8 * 3 bits from sram
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
            //if there is information on the line, do next step
            if (found_flag = 1)
            begin
		        for (j = 63; j >= 0; j--)
		        begin
		            if(lineline[j] == 1'b1)
		            begin
		                adr2 = j;
		                break;
		            end    
		        end
		        //if two address are equal, only fill that pixel
		        if (adr1 == adr2)
		        begin
		        	///write to the pixel
		       	end
		       	else
		       	begin//fill anything in between
		       		for(j = 0; j < 64; j++)
		       		begin
		       			if(j >= adr1)
		       			begin
 							if(j > adr2)
		       				    break
		       				///write to the registers    
		       				    
		       			end
		       	end
		    end
        end
	end
endmodule
