`ifndef MY_MODEL__SV
`define MY_MODEL__SV

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
 
   reg [31:0] data_in [1023:0];
   int  cnt = 0;
   super.main_phase(phase);

   while(1) begin
      port.get(tr);
	
 	if((tr.ram_en)&&(tr.we))begin//write input value into the data_in ram
		if(cnt <= 1023)begin
			data_in[cnt] = tr.din;
			cnt = cnt + 1'd1;
		end
	end
	
	if(tr.start&(cnt == 1024))begin	//display the data_in ram
		for(int i=0;i<1024;i=i+1)begin
				$display("%0d input random value is %0h",i,data_in[i]);
			end

	end

       ap.write(tr);
   end

endtask
`endif


