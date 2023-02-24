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
         `uvm_fatal("my_driver", "virtual interface must be set for vif!!!")
	  //`uvm_info("Trace",$sformatf("%m"),UVM_HIGH);

   endfunction

   extern task main_phase(uvm_phase phase);
 //  extern task drive_one_pkt(my_transaction tr);
endclass

task my_driver::main_phase(uvm_phase phase);
   phase.raise_objection(this);
   `uvm_info("my_driver", "main_phase is called", UVM_LOW);
    vif.auto = 1'b0;
	vif.es  = 5'b0;
	vif.func = 1'b0;
	vif.bit_rev = 1'b1;
	vif.tabidx = 1'b0;//when it is 0, write 512 data
	vif.start = 1'b0;
	vif.ram_en = 1'b0;
	vif.we = 1'b0;
	vif.mode = 1'b1;

   while(!vif.rst_n)
      @(posedge vif.clk);

	vif.auto = 1'b1;
	vif.es  = 5'd2;
	vif.func = 1'b0;
	vif.bit_rev = 1'b0;
	vif.tabidx = 1'b1;//when it is 1, write 1024 data
	vif.addr = 10'b0;
	vif.ram_en = 1'b1;
	vif.we = 1'b1;
	vif.din = 32'd0; 
	vif.mode = 1'b0;
	
	@(posedge vif.clk);
	  vif.ram_en <= 1'b1;
	  vif.we <= 1'b1;

   for ( int i = 0; i < 1024; i++ ) begin
      @(posedge vif.clk);
    //  vif.valid <= 1'b1;
	  vif.addr <= i;
      vif.din <= $urandom_range(0,255); 
   end
  
   @(posedge vif.clk);
   begin
   	vif.ram_en <= 1'b0;
   	vif.we <= 1'b0;
	vif.start <= 1'b1;
   end

   @(posedge vif.clk);
   begin
   		vif.start <= 1'b0;
   end
   
   @(negedge vif1.progress);
   		vif.ram_en <= 1'b1;

 for ( int i = 0; i < 1024; i++ ) begin
      @(posedge vif.clk);
    //  vif.valid <= 1'b1;
	  vif.addr <= i;
      vif.din <= i; 
   end

   phase.drop_objection(this);
endtask


`endif
