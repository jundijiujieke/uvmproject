`ifndef MY_SCOREBOARD__SV
`define MY_SCOREBOARD__SV
class my_scoreboard extends uvm_scoreboard;
   my_transaction  expect_queue[$];
   uvm_blocking_get_port #(my_transaction)  exp_port;
   uvm_blocking_get_port #(my_transaction)  act_port;

   `uvm_component_utils(my_scoreboard)

   extern function new(string name, uvm_component parent = null);
   extern virtual function void build_phase(uvm_phase phase);
   extern virtual task main_phase(uvm_phase phase);
endclass 

function my_scoreboard::new(string name, uvm_component parent = null);
   super.new(name, parent);
endfunction 

function void my_scoreboard::build_phase(uvm_phase phase);
   super.build_phase(phase);
   exp_port = new("exp_port", this);
   act_port = new("act_port", this);
endfunction 

task my_scoreboard::main_phase(uvm_phase phase);
   my_transaction actual_tr,expect_tr,temp_tr;
   int i = 0; 
   bit result;

   super.main_phase(phase);

   fork
   while(1) begin
   		exp_port.get(expect_tr);
		expect_queue.push_back(expect_tr);
   end
   while(1) begin
      	act_port.get(actual_tr);
	
	 	if(actual_tr.rd_valid)begin//write input value into the data_in ram
			i = i + 1'd1;
			if(expect_queue.size() > 0)begin
				temp_tr = expect_queue.pop_front();
				result = (temp_tr.dout == actual_tr.dout) ? 1 : 0;
				if(result)begin
				//$display("%d", i-1);
				`uvm_info("my_scoreboard",$sformatf("NO.%0d data compare sucessfully",i),UVM_LOW);
				end
				else begin
				//$display("%d",i-1);
				`uvm_error("my_scoreboard",$sformatf("NO.%0d data compare failed",i))
				end
			end
			else begin
				`uvm_error("my_scoreboard","received from DUT while expect queue is empty");
				$display("the expected pkt is");
				actual_tr.print();
			end
		end
	
	end
	join
	
endtask
`endif


