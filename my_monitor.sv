`ifndef MY_MONITOR__SV
`define MY_MONITOR__SV
class my_monitor extends uvm_monitor;

   virtual my_if vif;
   virtual my_if vif1;

   uvm_analysis_port #(my_transaction)  ap;//state a port
   
   `uvm_component_utils(my_monitor)
   function new(string name = "my_monitor", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif))
         `uvm_fatal("my_monitor", "virtual interface must be set for vif!!!")
	  if(!uvm_config_db#(virtual my_if)::get(this, "", "vif1", vif1))
         `uvm_fatal("my_monitor", "virtual interface must be set for vif1!!!")

      ap = new("ap", this);//install this port
   endfunction

   extern task main_phase(uvm_phase phase);
   extern task collect_one_pkt(my_transaction tr);
endclass

task my_monitor::main_phase(uvm_phase phase);
   my_transaction tr;
   while(1) begin
      tr = new("tr");
      collect_one_pkt(tr);
      ap.write(tr);//port monitor writes the data to other component 
   end
endtask

task my_monitor::collect_one_pkt(my_transaction tr);
   
  repeat(1) @(posedge vif.clk);
     tr.ram_en = vif.ram_en;
	 tr.we     = vif.we;//((tr.we == RD) ? 0 : 1);
	 tr.din    = vif.din;//(((tr.we == WR)&&(tr.ram_en)) ? tr.din : 0 );

	 tr.addr   = vif.addr;
	 tr.start  = vif.start;
	 tr.tabidx = vif.tabidx;
	 tr.mode   = vif.mode;
	 tr.es     = vif.es;
	 tr.func   = vif.func;
	 tr.auto   = vif.auto;   //0:manual 1: auto
	 tr.bit_rev = vif.bit_rev;   //0 

	 tr.progress = vif1.progress;
	 tr.done     = vif1.done;
	 tr.dout     = vif1.dout;
	 tr.rd_valid = vif1.rd_valid;
//	 tr.wr_valid = vif1.wr_valid;

	 
/*byte unsigned data_q[$];
   byte unsigned data_array[];
   logic [7:0] data;
   logic valid = 0;
   int data_size;*/
   
   /*while(1) begin
      @(posedge vif.clk);
      if(vif.valid) break;
   end
   
   `uvm_info("my_monitor", "begin to collect one pkt", UVM_LOW);
   while(vif.valid) begin
      data_q.push_back(vif.data);
      @(posedge vif.clk);
   end
   data_size  = data_q.size();   
   data_array = new[data_size];
   for ( int i = 0; i < data_size; i++ ) begin
      data_array[i] = data_q[i]; 
   end
   tr.pload = new[data_size - 18]; //da sa, e_type, crc
   data_size = tr.unpack_bytes(data_array) / 8; 
   `uvm_info("my_monitor", "end collect one pkt", UVM_LOW);*/


endtask


`endif
