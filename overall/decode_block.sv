// $Id: $
// File name:   decode_block.sv
// Created:     4/13/2016
// Author:      Shubham Sandeep Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Decode Block for Decoding instructions
module decode_block
(
	input wire [81:0] fifo_data,
	output reg [47:0] coordinates,
	output reg [3:0] alpha_val,
	output reg [1:0] texture_code,
	output reg [23:0] color_code,
	output reg layer_num,
	output reg vertice_num,
	output reg inst_type,
	output reg fill_type
);
always_comb
begin
	inst_type = fifo_data[0];
	if(fifo_data[0] == 1'd0) //instruction type is not alpha
	begin
		vertice_num = fifo_data[1];
		if(fifo_data[1] == 1'd0) //vertice number is 2
		begin
			coordinates = {fifo_data[17:2], fifo_data[33:18], '0};
		end
		else if(fifo_data[1] == 1'd1) //vertice number is 3
		begin
			coordinates = fifo_data[17:2], fifo_data[33:18], fifp_data[49:34]};
		end
		layer_num = fifo_data[50];
		if(fifo_data[51] == 1'd0) //fill type is solid color
		begin
			fill_type = fifo_data[51];
			color_code = fifo_data[75:52];
		end
		else //fill type is texture
		begin
			fill_type = fifo_data[51];
			texture_code = fifo_data[77:76];
		end
		alpha_val = fifo_data[81:78];
	end
	else
	begin
		alpha_val = fifo_data[3:1];
		coordinates[47:0] = '0;
		texture_code[1:0] = '0;
		color_code[23:0] = '0;
		layer_num = '0;
		vertice_num[2:0] = '0;
	end

end
endmodule
