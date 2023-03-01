`ifndef MY_DRIVER__SV
`define MY_DRIVER__SV
class my_driver extends uvm_driver#(my_transaction);

   virtual my_if vif;
   virtual my_if vif1;

   `uvm_component_utils(my_driver)
   function new(string name = "my_driver", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif))
         `uvm_fatal("my_driver", "virtual interface must be set for vif!!!")
	  //`uvm_info("Trace",$sformatf("%m"),UVM_HIGH);
	 if(!uvm_config_db#(virtual my_if)::get(this, "", "vif1", vif1))
         `uvm_fatal("my_driver", "virtual interface must be set for vif1!!!")
	  //`uvm_info("Trace",$sformatf("%m"),UVM_HIGH);

   endfunction

   extern task main_phase(uvm_phase phase);
   extern task drive_one_pkt(my_transaction tr);
endclass

task my_driver::main_phase(uvm_phase phase);
	
	vif.din = 32'b0;
	vif.ram_en = 1'b0;
	vif1.done = 1'b0;
	vif1.progress = 1'b0;

   while(!vif.rst_n)
      @(posedge vif.clk);
   while(1) begin
      seq_item_port.get_next_item(req);
      drive_one_pkt(req);
      seq_item_port.item_done();
   end
endtask

task my_driver::drive_one_pkt(my_transaction tr);
	`uvm_info("my_driver", "begin to drive one pkt", UVM_LOW);
	vif.we = ((tr.we == RD) ? 0 : 1);
   repeat(1) @(posedge vif.clk);
	 vif.din = tr.din;
	 vif.we = tr.we;
	 vif.ram_en = tr.ram_en;
	 vif.addr = tr.addr;
	 vif.start = tr.start;
	 vif.tabidx = tr.tabidx;
	 vif.mode = tr.mode;
	 vif.es = tr.es;
	 vif.func = tr.func;
	 vif.auto = tr.auto;   //0:manual 1: auto
	 vif.bit_rev = tr.bit_rev;   //0 
	 tr.done = vif1.done;
	 tr.progress = vif1.progress;

	 
	@(posedge vif.clk);
	if(tr.we == RD)begin
		tr.dout = vif1.dout; 
	end        
   

 endtask


`endif
