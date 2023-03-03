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
 //  my_transaction new_tr;
   reg [31:0] data_in [1023:0];
   int  cnt = 0;
  

   
   super.main_phase(phase);

   while(1) begin
      port.get(tr);
	 if(tr.start&(cnt == 1024))begin	
		for(int i=0;i<1024;i=i+1)begin
				$display("%0d input random value is %0h",i,data_in[i]);
			end

	end
 //$display(" input ram_en is %h, we is %h, din is %h", tr.ram_en, tr.we, tr.din);
	/*if(cnt == 1024)begin
		for(int i=0;i<1024;i=i+1)begin
				$display("%0d input random value is %0h",i,data_in[i]);
			end
	end*/

 	if((tr.ram_en)&&(tr.we))begin
		if(cnt <= 1023)begin
			data_in[cnt] = tr.din;
			cnt = cnt + 1'd1;
      //$display("no.%0d input ram_en is %h, we is %h, din is %h,value is %h", cnt,tr.ram_en, tr.we, tr.din, data_in[cnt-1]);
		end
		/*else begin
			$display("%0d",cnt);
			for(int i=0;i<1024;i=i+1)begin
				$display("%0d input random value is %0h",i,data_in[i]);
			end
			$display("%0d input random value is ",cnt);
			break;
		end*/
	end
	 if(tr.start&(cnt == 1024))begin	
		for(int i=0;i<1024;i=i+1)begin
				$display("%0d input random value is %0h",i,data_in[i]);
			end

	end

       ap.write(tr);
   end

endtask
`endif

/*	for(int i=0;i<1024;i=i+1)begin
				$display("%0d input random value is %0h",i,data_in[i]);
			end
			$display("%0d input random value is ",cnt);*/

/*
// new_tr = new("new_tr");
	  //assert(tr.randomize() with {is_vlan == 1;});//added new
	  //assert(new_tr.randomize() with {is_vlan == 1;});//added new
  //    new_tr.copy(tr);
      `uvm_info("my_model", "get one transaction, print the input data:", UVM_LOW)
      new_tr.print();
      ap.write(new_tr);
*/


		  /*if(cnt < 1024)begin
		  		data_in[cnt] = tr.din;
			//	$display("before add NO%0d input random data is %h, %h, %h", cnt, tr.ram_en, tr.we, tr.wr_valid);
				cnt = cnt + 1'd1;
			//	$display("after add NO%0d input random data is %h, %h, %h", cnt, tr.ram_en, tr.we, tr.wr_valid);

		  end*/
/*
	  if(tr.ram_en&tr.we)begin
	  		if(cnt < 1024)begin
				for(cnt = 0; cnt < 1024; cnt = cnt + 1)begin
					data_in[cnt] = tr.din;
					$display(" NO%0d input ram_en is %h, we is %h, din is %h", cnt, tr.ram_en, tr.we, tr.din);

				end
			end
			else begin
				for(int i = 0; i<1024;i = i+1)begin
					$display("no %0d,input random value is %0h", i,data_in[i]);
				end
				break;
			end
	  end
	 */
	  /*else begin
	  		continue;
	  end*/


