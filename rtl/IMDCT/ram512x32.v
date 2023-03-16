module ram512x32(
input clk,
input [31:0] din,
input we,
input [8:0] waddr,
input [8:0] raddr,
input en,

output reg [31:0] dout
);

// ram model
reg [31:0] mem[511:0];

always @(posedge clk)
  if (we)
    mem[waddr] <= din;
  
always @(posedge clk) 
  if (en)
    dout <= mem[raddr];

endmodule
