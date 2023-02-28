`ifndef MY_CASE0__SV
`define MY_CASE0__SV
class case0_sequence extends uvm_sequence #(my_transaction);
   my_transaction m_trans;
  // wire progress;
   virtual  my_if vif1;
   wire progress;

   function  new(string name= "case0_sequence");
      super.new(name);
   endfunction 
   
    virtual task pre_body();
	  	$display("%s",get_full_name());

      if(uvm_config_db#(virtual my_if)::get(null, get_full_name(), "vif1", vif1))//get function, first variance must be component, but sequence is not component,use null
         `uvm_info("seq0", "get count value via config_db",UVM_LOW)
      else
         `uvm_error("seq0", "can't get count value!") 
	  if(uvm_config_db#(wire)::get(null, get_full_name(), "progress", progress))//get function, first variance must be component, but sequence is not component,use null
         `uvm_info("seq0", $sformatf("get count value %0d via config_db", progress), UVM_MEDIUM)
      else
         `uvm_error("seq0", "can't get count value!") 

   endtask

   virtual task body();

      if(starting_phase != null) 
         starting_phase.raise_objection(this);
      repeat (1) begin

	  for(int i = 0; i < 1024; i = i + 1)begin
         `uvm_do_with(m_trans,{m_trans.addr == i;m_trans.we == RD;m_trans.ram_en == 1'b1;m_trans.start == 1'b0;})//write 1024 data into SRAM
//		 get_response(rsp);
//		 rsp.print();
	  end

	  `uvm_do_with(m_trans,{m_trans.ram_en == 1'b0;m_trans.start == 1'b1;})
//	   get_response(rsp);
//	   rsp.print();

      
//	  while(vif1.progress == 1'b1)begin	  	
//	  `uvm_do_with(m_trans,{m_trans.ram_en == 1'b0;m_trans.start == 1'b1;})//wait for caluculation finished
//	  end

	  for(int i = 0;i < 1024;i = i + 1)begin
	  	 `uvm_do_with(m_trans,{m_trans.addr == i;m_trans.we == WR;m_trans.ram_en == 1'b1;m_trans.start == 1'b0;})//read 1024 data from SRAM
	//	 get_response(rsp);
	//     rsp.print();

	  end

      end
      #100;
      if(starting_phase != null) 
         starting_phase.drop_objection(this); 
   endtask

   `uvm_object_utils(case0_sequence)
endclass


class my_case0 extends base_test;
   
   virtual my_if vif;

   function new(string name = "my_case0", uvm_component parent = null);
      super.new(name,parent);
   endfunction 
   extern virtual function void build_phase(uvm_phase phase); 
   `uvm_component_utils(my_case0)
endclass


function void my_case0::build_phase(uvm_phase phase);
   super.build_phase(phase);
   if(!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif))
         `uvm_fatal("my_case", "virtual interface must be set for vif!!!")
	$display("%s",get_full_name());

   uvm_config_db#(uvm_object_wrapper)::set(this, 
                                           "env.i_agt.sqr.main_phase", 
                                           "default_sequence", 
                                           case0_sequence::type_id::get());//connect the sequence to sequencer
   
  
endfunction

`endif
