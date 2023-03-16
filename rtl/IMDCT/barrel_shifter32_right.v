module barrel_shifter32_right(
input [31:0] din,
input [4:0] ctrl,
output reg [31:0] dout
);

always @(*)
  case (ctrl)
     5'h00: dout = din;
     5'h01: dout = {din[31], din[31:1]};
     5'h02: dout = {{2{din[31]}}, din[31:2]};
     5'h03: dout = {{3{din[31]}}, din[31:3]};
     5'h04: dout = {{4{din[31]}}, din[31:4]};
     5'h05: dout = {{5{din[31]}}, din[31:5]};
     5'h06: dout = {{6{din[31]}}, din[31:6]};
     5'h07: dout = {{7{din[31]}}, din[31:7]};
     5'h08: dout = {{8{din[31]}}, din[31:8]};
     5'h09: dout = {{9{din[31]}}, din[31:9]};
     5'h0a: dout = {{10{din[31]}}, din[31:10]};
     5'h0b: dout = {{11{din[31]}}, din[31:11]};
     5'h0c: dout = {{12{din[31]}}, din[31:12]};
     5'h0d: dout = {{13{din[31]}}, din[31:13]};
     5'h0e: dout = {{14{din[31]}}, din[31:14]};
     5'h0f: dout = {{15{din[31]}}, din[31:15]};
     5'h10: dout = {{16{din[31]}}, din[31:16]};
     5'h11: dout = {{17{din[31]}}, din[31:17]};
     5'h12: dout = {{18{din[31]}}, din[31:18]};
     5'h13: dout = {{19{din[31]}}, din[31:19]};
     5'h14: dout = {{20{din[31]}}, din[31:20]};
     5'h15: dout = {{21{din[31]}}, din[31:21]};
     5'h16: dout = {{22{din[31]}}, din[31:22]};
     5'h17: dout = {{23{din[31]}}, din[31:23]};
     5'h18: dout = {{24{din[31]}}, din[31:24]};
     5'h19: dout = {{25{din[31]}}, din[31:25]};
     5'h1a: dout = {{26{din[31]}}, din[31:26]};
     5'h1b: dout = {{27{din[31]}}, din[31:27]};
     5'h1c: dout = {{28{din[31]}}, din[31:28]};
     5'h1d: dout = {{29{din[31]}}, din[31:29]};
     5'h1e: dout = {{30{din[31]}}, din[31:30]};
     default: dout = {{31{din[31]}}, din[31]};
  endcase
  
endmodule
