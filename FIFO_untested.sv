// $Id: $
// File name:   fifo.sv
// Created:     4/13/2016
// Author:      Yudi Wu
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: FIFO

module fifo
(
    input wire clk,
    input wire n_rst,
    input wire r_enable,
    input wire w_enable,
    input wire [82:0]w_data,
    output reg [82:0]r_data,
    output wire empty,
    output wire full

);
    reg [82:0]data1, next_data1;
    reg [82:0]data2, next_data2;    
    reg [82:0]data3, next_data3;
    reg [82:0]data4, next_data4;
    reg [2:0] r_pointer, next_r_pointer;
    reg [2:0] w_pointer, next_w_pointer;

  always_ff @ (posedge clk, negedge n_rst)
  begin
    if(n_rst == 0)
    begin
      data1 = '0
      data2 = '0
      data3 = '0
      data4 = '0
      r_pointer = '0;
      w_pointer = '0;
    end
    else
      begin
	 data1 = next_data1;
         data2 = next_data2;
         data3 = next_data3; 
         data4 = next_data4;
         r_pointer = next_r_pointer;
         w_pointer = next_w_pointer;
      end
	 
  end

  always_comb begin //pointer_advance 
      if(r_enable) begin
          next_r_pointer = r_pointer + 1; 
      end else if(r_pointer == 3'b100)
	  next_r_pointer = 3'b000;  
      end else begin
          next_r_pointer = r_poitner;
      end

      if(w_enable) begin
          next_w_pointer = w_poitner + 1;
      end else if (w_pointer = 3'b100)
          next_w_pointer = 3'b000;
      end else begin
          next_w_pointer = w_pointer; 
          
  end
  
  always_comb begin //load_info
      next_data1 = data1;
      next_data2 = data2;
      next_data3 = data3; 
      next_data4 = data4;
      if w_enable begin
         if(w_pointer == 0) begin
	     next_data1 = w_data;
         end
         if(w_pointer == 1) begin
 	     next_data2 = w_data;
         end
         if(w_pointer == 2) begin
             next_data3 = w_data;
         end
         if(w_pointer == 3) begin
             next_data4 = w_data; 
      end

  end
  
  always_comb begin //write_info
       if r_enable begin
         if(r_pointer == 0) begin
             r_data = data1;
         if(r_pointer == 1) begin
	     r_data = data2;
         end
         if(r_pointer == 2) begin
             r_data = data3;
         end
         if(r_pointer == 3) begin
             r_data = data4;
         end
      end	

  end 
  

  assign full = (w_pointer == 3'b82 && w_enable == 1)
  assign empty = (next_data1 == '0) 

endmodule