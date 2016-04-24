// $Id: $
// File name:   alpha_blend.sv
// Created:     4/17/2016
// Author:      Yudi Wu
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Alpha Blending combinational

module alpha_blending
(
    input wire clk,
    input wire n_rst,
    input wire pixel_ready,
    input wire [7:0]color1,
    input wire [7:0]color2,
    input wire [3:0]alpha_value,
    output reg pixel_done,
    output reg [7:0]alpha_result
); 
    reg nextpixeldone;
    always_ff @ (posedge clk,negedge n_rst)
	begin
	    if(n_rst == 0) begin
            pixel_done <= 0;
        end else begin
      		if(pixel_ready == 0) begin
	   			pixel_done <= 0;
       		end
       		else begin
	   			pixel_done <= nextpixeldone;
       		end
		end
    end

    wire [3:0]inv_alp;
    assign inv_alp = 4'd10 - alpha_value;
    always_comb begin
        nextpixeldone = 1'b0;
		if(pixel_ready)
	    	alpha_result = color1 * alpha_value / 10 + color2 * inv_alp / 10;
            nextpixeldone = 1'b1;
    end

	
endmodule
