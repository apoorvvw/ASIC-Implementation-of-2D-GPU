// $Id: $
// File name:   decode_block.sv
// Created:     4/13/2016
// Author:      Shubham Sandeep Rastogi
// Lab Section: 337-04
// Version:     1.0  Initial Design Entry
// Description: Decode Block for Decoding instructions
module decode_block
(
	input wire fifo_data[100:0],
	output reg coordinates[63:0],
	output reg alpha_val[3:0],
	output reg texture_code[1:0],
	output reg color_code[23:0],
	output reg layer_num[1:0],
	output reg vertice_num[2:0],
	output reg inst_type,
	output reg fill_type
);
always_comb
begin
	inst_type = fifo_data[0];
	if(fifo_data[0] == 1'd0) //instruction type is not alpha
	begin
		vertice_num = fifo_data[3:1];
		if(fifo_data[3:1] == 3'd2) //vertice number is 2
		begin
			coordinates = {fifo_data[19:4], fifo_data[35:20], '0};
		end
		else if(fifo_data[3:1] == 3'd3) //vertice number is 3
		begin
			coordinates = {fifo_data[19:4], fifo_data[35:20], fifo_data[51:36], '0};
		end
		else
		begin
			coordinates = {fifo_data[19:4], fifo_data[35:20], fifo_data[51:36], fifo_data[67:52]};
		end
		layer_num = fifo_data[69:68];
		if(fifo_data[70] == 1'd0) //fill type is solid color
		begin
			fill_type = fifo_data[70];
			color_code = fifo_data[94:71];
		end
		else //fill type is texture
		begin
			fill_type = fifo_data[70];
			texture_code = fifo_data[72:71];
		end
		layer_num = fifo_data[96:94];
		alpha_val = fifo_data[100:97];
	end
	else
	begin
		alpha_val = fifo_data[3:1];
		coordinates[63:0] = '0;
		texture_code[1:0] = '0;
		color_code[23:0] = '0;
		layer_num[1:0] = '0;
		vertice_num[2:0] = '0;
	end

end
endmodule
