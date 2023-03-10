`timescale 1ns/1ps
module tb_AES;

import "DPI-C" function void dct4_1024_c(input bit[31:0]data[255:0] ,output bit[31:0]result[255:0] );

reg [31:0] data_in [255:0];
reg [31:0] data_out [255:0];

reg clk = 0;
always #5 clk = ~clk; 

reg rst = 1;
    initial begin
        #50 
	rst = 0;
    end 
 
integer i;
initial begin
	#50; 
//	repeat (256) @ (posedge clk) begin
//		data_in = data_in + 1'b1;
//	end
for (i=0; i<256; i=i+1) begin
  data_in[i] = i;
end
	dct4_1024_c(data_in,data_out);
	$finish;
end

endmodule

