`ifndef MY_CASE0__SV
`define MY_CASE0__SV
class case0_sequence extends uvm_sequence #(my_transaction);
   my_transaction m_trans;
 
   function  new(string name= "case0_sequence");
      super.new(name);
   endfunction 
   
    virtual task pre_body();
	  	$display("%s",get_full_name());

	use_response_handler(1);
	 
   endtask

  virtual function void response_handler(uvm_sequence_item response);
      if(!$cast(rsp, response))
         `uvm_error("seq", "can't cast")
      else begin
//         `uvm_info("seq", "get one response", UVM_MEDIUM)
//      `uvm_info("seq0", $sformatf("get count value %0d via config_db", rsp.progress), UVM_MEDIUM)

//         rsp.print();
      end
   endfunction

   virtual task body();

      if(starting_phase != null) 
         starting_phase.raise_objection(this);
      repeat (1) begin

	  for(int i = 0; i < `memsize; i = i + 1)begin
        // `uvm_do_with(m_trans,{m_trans.din == i;m_trans.addr == i;m_trans.we == WR;m_trans.ram_en == 1'b1;m_trans.start == 1'b0;})//write 1024 data into SRAM
			 `uvm_do_with(m_trans,{m_trans.addr == i;m_trans.we == WR;m_trans.ram_en == 1'b1;m_trans.start == 1'b0;})//write 1024 data into SRAM

	  end

	  `uvm_do_with(m_trans,{m_trans.ram_en == 1'b0;m_trans.we == RD;m_trans.addr == 32'd0;m_trans.start == 1'b1;})
	  `uvm_do_with(m_trans,{m_trans.ram_en == 1'b0;m_trans.we == RD;m_trans.addr == 32'd0;m_trans.start == 1'b0;})
	  `uvm_do_with(m_trans,{m_trans.ram_en == 1'b0;m_trans.we == RD;m_trans.addr == 32'd0;m_trans.start == 1'b0;})

      
	  while(1)begin	
	  	if(m_trans.progress == 1'b1)begin
	  		`uvm_do_with(m_trans,{m_trans.ram_en == 1'b0;m_trans.we == RD;m_trans.addr == 32'd0;m_trans.start == 1'b0;})//wait for caluculation finished
//	  		m_trans.print();	
	   end 
	   else
	  		break;
	  end

	  for(int i = 0;i < `memsize;i = i + 1)begin
	  	 `uvm_do_with(m_trans,{m_trans.addr == i;m_trans.we == RD;m_trans.ram_en == 1'b1;m_trans.start == 1'b0;})//read 1024 data from SRAM
//		 m_trans.print();
	  end
	  
	  repeat(3)begin
	  	  `uvm_do_with(m_trans,{m_trans.ram_en == 1'b0;m_trans.ram_en == 1'b0;m_trans.start == 1'b0;})
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

   uvm_config_db#(uvm_object_wrapper)::set(this, 
                                           "env.i_agt.sqr.main_phase", 
                                           "default_sequence", 
                                           case0_sequence::type_id::get());//connect the sequence to sequencer
   
  
endfunction

`endif
