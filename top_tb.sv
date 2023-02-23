`timescale 1ns/1ps
`include "uvm_macros.svh"

import uvm_pkg::*;//export UVM factory
`include "my_if.sv"
`include "my_transaction.sv"
`include "my_sequencer.sv"
`include "my_driver.sv"
`include "my_monitor.sv"
`include "my_agent.sv"
`include "my_model.sv"
`include "my_scoreboard.sv"
`include "my_env.sv"
`include "base_test.sv"
`include "my_case0.sv"

module top_tb;

reg rst_n;
reg clk;
reg [31:0] din;
reg we;
reg ram_en;
reg [9:0] addr;
reg start;
reg tabidx;
reg mode;
reg [4:0] es;
reg func;   //0: IMDCT, 1: FFT
reg auto;   //0:manual 1: auto
reg bit_rev;   //0 : ext_addr no rev, 1 : ext_addr bit rev, 


wire [31:0] dout; 
wire done;
wire progress;

my_if input_if(clk, rst_n);
my_if output_if(clk, rst_n);

imdct_fft_with_ram256 imdct_fft_with_ram256_inst(
 .rst_n 	( rst_n 			),
 .clk   	( clk   			),
 .din		(input_if.din		),
 .we		(input_if.we		),
 .ram_en	(input_if.ram_en	),
 .addr		(input_if.addr		),
 .start		(input_if.start		),
 .tabidx	(input_if.tabidx	),
 .mode		(input_if.mode		),
 .es		(input_if.es		),
 .func		(input_if.func	    ),   //0: IMDCT, 1: FFT
 .auto		(input_if.auto		),   //0:manual 1: auto
 .bit_rev	(input_if.bit_rev	),   //0 : ext_addr no rev, 1 : ext_addr bit rev, 


 .dout    	(output_if.dout     ), 
 .done    	(output_if.done     ),
 .progress  (output_if.progress ) 
);

initial begin
   clk = 0;
   forever begin
      #100 clk = ~clk;
   end
end

initial begin
   rst_n = 1'b0;
   #1000;
   rst_n = 1'b1;
end

initial begin
   run_test("my_case0");
end

initial begin
    uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.i_agt.drv", "vif", input_if);
//    uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.i_agt.mon", "vif", input_if);
//    uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.o_agt.mon", "vif", output_if);
    
end 
    
endmodule
    
    
    
    
    
    
    
    
    
    
