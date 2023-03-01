`ifndef MY_ENV__SV
`define MY_ENV__SV

class my_env extends uvm_env;

   my_agent   i_agt;
   
   function new(string name = "my_env", uvm_component parent);
      super.new(name, parent);
   endfunction
   
   virtual function void start_of_simulation_phase(uvm_phase phase);//print the uvm_tree
   	super.start_of_simulation_phase(phase);
	uvm_top.print_topology(uvm_default_tree_printer);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      i_agt = my_agent::type_id::create("i_agt", this);

   endfunction

   extern virtual function void connect_phase(uvm_phase phase);
   
   `uvm_component_utils(my_env)
endclass

function void my_env::connect_phase(uvm_phase phase);
   super.connect_phase(phase);
endfunction

`endif
