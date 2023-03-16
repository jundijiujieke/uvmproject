module rom_rev35(
clk,
en,
addr,

dout
);

input clk;
input en;
input [5:0] addr;
output reg [8:0] dout;

reg [8:0] mem[0:34]={ 

9'h001,
9'h002,
9'h003,
9'h004,
9'h005,
9'h006,
9'h007,
9'h009,
9'h00a,
9'h00b,
9'h00c,
9'h00d,
9'h00e,
9'h00f,
9'h011,
9'h012,
9'h013,
9'h015,
9'h016,
9'h017,
9'h019,
9'h01b,
9'h01d,
9'h01e,
9'h01f,
9'h021,
9'h023,
9'h025,
9'h027,
9'h02b,
9'h02d,
9'h02f,
9'h033,
9'h037,
9'h03f
};
always @(posedge clk) 
  if (en)
    dout <= mem[addr];

endmodule
