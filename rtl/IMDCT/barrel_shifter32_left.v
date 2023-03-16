module barrel_shifter32_left(
input [31:0] din,
input [4:0] ctrl,
output reg [31:0] dout
);

always @(*)
  case (ctrl)
     5'h00: dout = din;
     5'h01: dout = {din[30:0], 1'b0};
     5'h02: dout = {din[29:0], 2'b0};
     5'h03: dout = {din[28:0], 3'b0};
     5'h04: dout = {din[27:0], 4'b0};
     5'h05: dout = {din[26:0], 5'b0};
     5'h06: dout = {din[25:0], 6'b0};
     5'h07: dout = {din[24:0], 7'b0};
     5'h08: dout = {din[23:0], 8'b0};
     5'h09: dout = {din[22:0], 9'b0};
     5'h0a: dout = {din[21:0], 10'b0};
     5'h0b: dout = {din[20:0], 11'b0};
     5'h0c: dout = {din[19:0], 12'b0};
     5'h0d: dout = {din[18:0], 13'b0};
     5'h0e: dout = {din[17:0], 14'b0};
     5'h0f: dout = {din[16:0], 15'b0};
     5'h10: dout = {din[15:0], 16'b0};
     5'h11: dout = {din[14:0], 17'b0};
     5'h12: dout = {din[13:0], 18'b0};
     5'h13: dout = {din[12:0], 19'b0};
     5'h14: dout = {din[11:0], 20'b0};
     5'h15: dout = {din[10:0], 21'b0};
     5'h16: dout = {din[9:0], 22'b0};
     5'h17: dout = {din[8:0], 23'b0};
     5'h18: dout = {din[7:0], 24'b0};
     5'h19: dout = {din[6:0], 25'b0};
     5'h1a: dout = {din[5:0], 26'b0};
     5'h1b: dout = {din[4:0], 27'b0};
     5'h1c: dout = {din[3:0], 28'b0};
     5'h1d: dout = {din[2:0], 29'b0};
     5'h1e: dout = {din[1:0], 30'b0};
     default: dout = {din[0], 31'b0};
  endcase
  
endmodule
