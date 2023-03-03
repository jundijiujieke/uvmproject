`ifndef MY_TRANSACTION__SV
`define MY_TRANSACTION__SV

typedef enum{IMDCT, FFT}func_op;
typedef enum{RAM512,RAM1024}tabidx_op;
typedef enum{RD, WR} op;

class my_transaction extends uvm_sequence_item;


rand bit [31:0] din;
rand op we;
rand bit ram_en;
rand bit [9:0] addr;
rand bit start;
//rand tabidx_op tabidx;
rand tabidx_op tabidx;
rand bit mode;
rand bit [4:0] es;
//rand func_op func;   //0: IMDCT, 1: FFT
rand func_op func;
rand bit auto;   //0:manual 1: auto
rand bit bit_rev;   //0 : ext_addr no rev, 1 : ext_addr bit rev,

bit rd_valid;
//bit wr_valid;
bit [31:0] dout; 
bit done;
bit progress;

constraint tabidx_c{ tabidx == RAM1024;}
constraint mode_c{ mode == 1'b0;}
constraint es_c{ es == 5'd2;}
constraint func_c{ func == IMDCT;}
constraint auto_c{ auto == 1'b1;}
constraint bit_rev_c{ bit_rev == 1'b0;}

   `uvm_object_utils_begin(my_transaction)
      `uvm_field_int(din, UVM_ALL_ON)
	  `uvm_field_enum(op,we, UVM_ALL_ON)
	  `uvm_field_int(ram_en, UVM_ALL_ON)
   	  `uvm_field_int(addr, UVM_ALL_ON)
	  `uvm_field_int(start, UVM_ALL_ON)
	  `uvm_field_enum(tabidx_op,tabidx, UVM_ALL_ON)
	  `uvm_field_int(mode, UVM_ALL_ON)
	  `uvm_field_int(es, UVM_ALL_ON)
	  `uvm_field_enum(func_op,func, UVM_ALL_ON)
	  `uvm_field_int(auto, UVM_ALL_ON)
	  `uvm_field_int(bit_rev, UVM_ALL_ON)
	  `uvm_field_int(dout, UVM_ALL_ON)
	  `uvm_field_int(done, UVM_ALL_ON)
	  `uvm_field_int(progress, UVM_ALL_ON)
	  `uvm_field_int(rd_valid, UVM_ALL_ON)
//	  `uvm_field_int(wr_valid, UVM_ALL_ON)


   `uvm_object_utils_end

   function new(string name = "my_transaction");
      super.new();
   endfunction

endclass
`endif
