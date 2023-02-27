`ifndef MY_IF__SV
`define MY_IF__SV

interface my_if(input clk, input rst_n);


logic [31:0] din;
logic we;
logic ram_en;
logic [9:0] addr;
logic start;
logic tabidx;
logic mode;
logic [4:0] es;
logic func;   //0: IMDCT, 1: FFT
logic auto;   //0:manual 1: auto
logic bit_rev;   //0 : ext_addr no rev, 1 : ext_addr bit rev, 


logic [31:0] dout; 
logic done;
logic progress;

endinterface

`endif
