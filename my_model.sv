`ifndef MY_MODEL__SV
`define MY_MODEL__SV

//import "DPI-C" function void dct4_1024_c(input bit[31:0]data[`memsize-1:0] ,output bit[31:0]result[`memsize-1:0] ); 
import "DPI-C" function void DCT4_SV(input bit[31:0]d1[`memsize-1:0] ,output bit[31:0]d2[`memsize-1:0], input int  ms,input int tabidx);

class my_model extends uvm_component;
   
   uvm_blocking_get_port #(my_transaction)  port;
   uvm_analysis_port #(my_transaction)  ap;

   extern function new(string name, uvm_component parent);
   extern function void build_phase(uvm_phase phase);
   extern virtual  task main_phase(uvm_phase phase);

   `uvm_component_utils(my_model)
endclass 

function my_model::new(string name, uvm_component parent);
   super.new(name, parent);
endfunction 

function void my_model::build_phase(uvm_phase phase);
   super.build_phase(phase);
   port = new("port", this);
   ap = new("ap", this);
endfunction

task my_model::main_phase(uvm_phase phase);
   my_transaction tr;

   my_transaction new_tr;
  
   reg [31:0] data_in [`memsize-1:0];
   reg [31:0] data_out [`memsize-1:0];

   int  cnt = 0;
   super.main_phase(phase);

   while(1) begin
      port.get(tr);	  
 	if((tr.ram_en)&&(tr.we))begin//write input value into the data_in ram
		if(cnt < `memsize)begin
			data_in[cnt] = tr.din;
			cnt = cnt + 1'd1;
		end
	end
	
	if(tr.start&(cnt == `memsize))begin	//display the data_in ram
//		dct4_1024_c(data_in,data_out);
		DCT4_SV(data_in,data_out,`memsize, `tab);
		for(int i=0;i< `memsize;i=i+1)begin
				new_tr = new("new_tr");
				new_tr.dout = data_out[i];
				ap.write(new_tr);
		end

	end

   end

endtask
`endif

