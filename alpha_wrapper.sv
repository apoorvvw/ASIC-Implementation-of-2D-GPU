// $Id: $
// File name:   alp_wrapper
// Created:     4/22/2016
// Author:      Yudi Wu
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Wrapper for Alpha blending Controller and Alpha blending

module alp_wrapper
(
    input wire clk,
    input wire n_rst,
    input wire alpha_en,
    input wire read_done,
    input wire [7:0]color1,
    input wire [7:0]color2,
    input wire [3:0]alpha_value,
    output reg [7:0]alpha_result,
    output wire alpha_done
);
    wire pixel_ready;
    wire alpha_done;
    wire pixel_done;
   
    
    alpha_controller ALPCTR
    (
        .clk(clk),
        .n_rst(n_rst),
        .alpha_en(alpha_en),
        .pixel_done(pixel_done),
        .read_done(read_done),
        .pixel_ready(pixel_ready),
        .alpha_done(alpha_done)
    );

    alpha_blending ALP
    (
        .clk(clk),
        .n_rst(clk),
        .pixel_ready(pixel_ready),
        .color1(color1),
        .color2(color2),
        .alpha_value(alpha_value),
        .pixel_done(pixel_done),
        .alpha_result(alpha_result)
    );
    
    
endmodule
