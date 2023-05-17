`timescale 1ns/1ps
`define memsize 128
`define tab 0

module test();

import "DPI-C" function void DCT4_SV(input bit[31:0]d1[`memsize-1:0] ,output bit[31:0]d2[`memsize-1:0], input int  ms,input int tabidx);

reg [31:0] data_in [`memsize-1:0];
reg [31:0] data_out [`memsize-1:0];
reg clk = 0;

initial begin

forever #5 clk = ~clk; 
end

//integer i;

initial begin
	#50;

for (int i=0; i<`memsize; i=i+1) begin
  data_in[i] = i;
end
    $display("%0d, %0d", `memsize, `tab);
	DCT4_SV(data_in,data_out,`memsize, `tab);
	$finish;
end

endmodule


//endmodule
