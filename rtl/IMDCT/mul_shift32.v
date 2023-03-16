module mul_shift32(
input rst_n,
input clk,
input signed [31:0] in1,
input signed [31:0] in2,
output reg [31:0] out
);

wire signed [63:0] mul_res = in1 * in2;

always @(negedge rst_n or posedge clk)
  if (~rst_n)
    out <= 32'h0;
  else
    out <= mul_res[63:32];

endmodule 
