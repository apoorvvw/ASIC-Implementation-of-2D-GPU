module single_clk_ram(
 output reg [7:0] q,
 input [7:0] d,
 input [6:0] write_address, read_address,
 input we, clk
);
 reg [7:0] mem [127:0];
 always @ (posedge clk) begin
 if (we)
 mem[write_address] <= d;
 q <= mem[read_address]; // q doesn't get d in this clock cycle
 end
endmodule
