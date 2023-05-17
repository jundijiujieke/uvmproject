// See LICENSE.SiFive for license details.

module RoccBlackBox
//  #( parameter xLen,
//     PRV_SZ,
//     coreMaxAddrBits,
//     dcacheReqTagBits,
//     M_SZ,
//     mem_req_bits_size_width,
//     coreDataBits,
//     coreDataBytes,
//     paddrBits,
//     FPConstants_RM_SZ,
//     fLen,
//     FPConstants_FLAGS_SZ )
  #( parameter xLen = 32,
     parameter PRV_SZ = 2,
     parameter coreMaxAddrBits = 32,
     parameter dcacheReqTagBits = 9,
     parameter M_SZ = 5,
     parameter mem_req_bits_size_width = 2,
     parameter coreDataBits = 32,
     parameter coreDataBytes = 4,
     parameter paddrBits = 32,
     parameter FPConstants_RM_SZ = 3,
     parameter fLen = 32,
     parameter FPConstants_FLAGS_SZ =5 )
  ( input clock,
    input reset,
	input rocc_tram_sel,
    output rocc_cmd_ready,
    input rocc_cmd_valid,
    input [6:0] rocc_cmd_bits_inst_funct,
    input [4:0] rocc_cmd_bits_inst_rs2,
    input [4:0] rocc_cmd_bits_inst_rs1,
    input rocc_cmd_bits_inst_xd,
    input rocc_cmd_bits_inst_xs1,
    input rocc_cmd_bits_inst_xs2,
    input [4:0] rocc_cmd_bits_inst_rd,
    input [6:0] rocc_cmd_bits_inst_opcode,
    input [xLen-1:0] rocc_cmd_bits_rs1,
    input [xLen-1:0] rocc_cmd_bits_rs2,
    input rocc_cmd_bits_status_debug,
    input rocc_cmd_bits_status_cease,
    input rocc_cmd_bits_status_wfi,
    input [31:0] rocc_cmd_bits_status_isa,
    input [PRV_SZ-1:0] rocc_cmd_bits_status_dprv,
    input [PRV_SZ-1:0] rocc_cmd_bits_status_prv,
    input rocc_cmd_bits_status_sd,
    input [26:0] rocc_cmd_bits_status_zero2,
    input [1:0] rocc_cmd_bits_status_sxl,
    input [1:0] rocc_cmd_bits_status_uxl,
    input rocc_cmd_bits_status_sd_rv32,
    input [7:0] rocc_cmd_bits_status_zero1,
    input rocc_cmd_bits_status_tsr,
    input rocc_cmd_bits_status_tw,
    input rocc_cmd_bits_status_tvm,
    input rocc_cmd_bits_status_mxr,
    input rocc_cmd_bits_status_sum,
    input rocc_cmd_bits_status_mprv,
    input [1:0] rocc_cmd_bits_status_xs,
    input [1:0] rocc_cmd_bits_status_fs,
    input [1:0] rocc_cmd_bits_status_vs,
    input [1:0] rocc_cmd_bits_status_mpp,
    input [0:0] rocc_cmd_bits_status_spp,
    input rocc_cmd_bits_status_mpie,
    input rocc_cmd_bits_status_hpie,
    input rocc_cmd_bits_status_spie,
    input rocc_cmd_bits_status_upie,
    input rocc_cmd_bits_status_mie,
    input rocc_cmd_bits_status_hie,
    input rocc_cmd_bits_status_sie,
    input rocc_cmd_bits_status_uie,
    input rocc_resp_ready,
    output rocc_resp_valid,
    output [4:0] rocc_resp_bits_rd,
    output [xLen-1:0] rocc_resp_bits_data,
    input rocc_mem_req_ready,
    output rocc_mem_req_valid,
    output [coreMaxAddrBits-1:0] rocc_mem_req_bits_addr,
    output [dcacheReqTagBits-1:0] rocc_mem_req_bits_tag,
    output [M_SZ-1:0] rocc_mem_req_bits_cmd,
    output [mem_req_bits_size_width-1:0] rocc_mem_req_bits_size,
    output rocc_mem_req_bits_signed,
    output rocc_mem_req_bits_phys,
    output rocc_mem_req_bits_no_alloc,
    output rocc_mem_req_bits_no_xcpt,
    output [coreDataBits-1:0] rocc_mem_req_bits_data,
    output [coreDataBytes-1:0] rocc_mem_req_bits_mask,
    output rocc_mem_s1_kill,
    output [coreDataBits-1:0] rocc_mem_s1_data_data,
    output [coreDataBytes-1:0] rocc_mem_s1_data_mask,
    input rocc_mem_s2_nack,
    input rocc_mem_s2_nack_cause_raw,
    output rocc_mem_s2_kill,
    input rocc_mem_s2_uncached,
    input [paddrBits-1:0] rocc_mem_s2_paddr,
    input rocc_mem_resp_valid,
    input [coreMaxAddrBits-1:0] rocc_mem_resp_bits_addr,
    input [dcacheReqTagBits-1:0] rocc_mem_resp_bits_tag,
    input [M_SZ-1:0] rocc_mem_resp_bits_cmd,
    input [mem_req_bits_size_width-1:0] rocc_mem_resp_bits_size,
    input rocc_mem_resp_bits_signed,
    input [coreDataBits-1:0] rocc_mem_resp_bits_data,
    input [coreDataBytes-1:0] rocc_mem_resp_bits_mask,
    input rocc_mem_resp_bits_replay,
    input rocc_mem_resp_bits_has_data,
    input [coreDataBits-1:0] rocc_mem_resp_bits_data_word_bypass,
    input [coreDataBits-1:0] rocc_mem_resp_bits_data_raw,
    input [coreDataBits-1:0] rocc_mem_resp_bits_store_data,
    input rocc_mem_replay_next,
    input rocc_mem_s2_xcpt_ma_ld,
    input rocc_mem_s2_xcpt_ma_st,
    input rocc_mem_s2_xcpt_pf_ld,
    input rocc_mem_s2_xcpt_pf_st,
    input rocc_mem_s2_xcpt_ae_ld,
    input rocc_mem_s2_xcpt_ae_st,
    input rocc_mem_ordered,
    input rocc_mem_perf_acquire,
    input rocc_mem_perf_release,
    input rocc_mem_perf_grant,
    input rocc_mem_perf_tlbMiss,
    input rocc_mem_perf_blocked,
    input rocc_mem_perf_canAcceptStoreThenLoad,
    input rocc_mem_perf_canAcceptStoreThenRMW,
    input rocc_mem_perf_canAcceptLoadThenLoad,
    input rocc_mem_perf_storeBufferEmptyAfterLoad,
    input rocc_mem_perf_storeBufferEmptyAfterStore,
    output rocc_mem_keep_clock_enabled,
    input rocc_mem_clock_enabled,
    output rocc_busy,
    output rocc_interrupt,
    input rocc_exception,
    input rocc_fpu_req_ready,
    output rocc_fpu_req_valid,
    output rocc_fpu_req_bits_ldst,
    output rocc_fpu_req_bits_wen,
    output rocc_fpu_req_bits_ren1,
    output rocc_fpu_req_bits_ren2,
    output rocc_fpu_req_bits_ren3,
    output rocc_fpu_req_bits_swap12,
    output rocc_fpu_req_bits_swap23,
    output rocc_fpu_req_bits_singleIn,
    output rocc_fpu_req_bits_singleOut,
    output rocc_fpu_req_bits_fromint,
    output rocc_fpu_req_bits_toint,
    output rocc_fpu_req_bits_fastpipe,
    output rocc_fpu_req_bits_fma,
    output rocc_fpu_req_bits_div,
    output rocc_fpu_req_bits_sqrt,
    output rocc_fpu_req_bits_wflags,
    output [FPConstants_RM_SZ-1:0] rocc_fpu_req_bits_rm,
    output [1:0] rocc_fpu_req_bits_fmaCmd,
    output [1:0] rocc_fpu_req_bits_typ,
    output [fLen:0] rocc_fpu_req_bits_in1,
    output [fLen:0] rocc_fpu_req_bits_in2,
    output [fLen:0] rocc_fpu_req_bits_in3,
    output rocc_fpu_resp_ready,
    input rocc_fpu_resp_valid,
    input [fLen:0] rocc_fpu_resp_bits_data,
    input [FPConstants_FLAGS_SZ-1:0] rocc_fpu_resp_bits_exc );


	reg	mem_req_valid_reg;
	reg mem_req_valid_delay_reg;
	reg [31:0] mem_req_bits_addr_reg;
	reg [31:0] mem_req_bits_addr2_reg;
	reg imdct_process;
	reg imdct_start;
	reg [8:0] mem_req_bits_tag_reg;
	reg [4:0] mem_req_bits_cmd_reg;
	reg [1:0] mem_req_bits_size;
	reg [31:0] mem_req_bits_data_reg;
	reg [9:0] mem_cnt;
	reg [9:0] mem_resp_cnt;
	reg mem_read;
	//reg mem_1024;
	reg interrupt_reg;
	
//	reg [31:0] int_mem [0:1023];
	
	reg rocc_resp_valid_reg;
	
  assign rocc_cmd_ready = 1'b1;
//  assign rocc_resp_valid = 1'b0;

//  assign rocc_mem_req_valid = 1'b0;
	assign rocc_mem_req_valid = mem_req_valid_reg;  
	assign rocc_mem_req_bits_addr = mem_req_bits_addr_reg; 
  	assign rocc_mem_req_bits_tag = mem_req_bits_tag_reg; 
  	assign rocc_mem_req_bits_cmd = mem_req_bits_cmd_reg;
	assign rocc_mem_req_bits_size = mem_req_bits_size;
	
    assign rocc_mem_req_bits_signed=0;
    assign rocc_mem_req_bits_phys=1;
//    assign rocc_mem_req_bits_phys=0;
    assign rocc_mem_req_bits_no_alloc=1;
    assign rocc_mem_req_bits_no_xcpt=1;
    assign rocc_mem_req_bits_data=mem_req_bits_data_reg;
    assign rocc_mem_req_bits_mask=4'b0000;
	
	wire imdct_done;
  
  assign rocc_mem_s1_kill = 1'b0;
  assign rocc_mem_s2_kill = 1'b0;

  assign rocc_busy = 1'b0;
  //assign rocc_busy = mem_req_valid_reg|imdct_process;
  //assign rocc_interrupt = 1'b0;
  assign rocc_interrupt = interrupt_reg;

  assign rocc_fpu_req_valid = 1'b0;
  assign rocc_fpu_resp_ready = 1'b1;

  /* Accumulate rs1 and rs2 into an accumulator */
  reg [xLen-1:0] acc;
  reg doResp;
  reg doResp_d;
  reg doResp_dd;

  reg [4:0] rocc_cmd_bits_inst_rd_d;
  reg [6:0] rocc_cmd_bits_inst_funct_d;
  
  reg [9:0] int_mem_addr;
  reg [9:0] mem_write_cnt;
  reg [31:0] int_mem_do;
  reg int_mem_read_enable;
  
  //reg [9:0] mem_tranfer_num;
  reg [7:0] imdct_setting;
  
  wire mem_1024 = imdct_setting[0];
  wire [4:0] imdct_es = imdct_setting[5:1];
  wire FFT_ONLY=imdct_setting[6];

  
	//debug signal
	wire cmd_0b_00 = ( rocc_cmd_bits_inst_opcode==7'h0b && rocc_cmd_bits_inst_funct==7'h00 &&  rocc_cmd_valid && rocc_cmd_ready );
	wire cmd_0b_01 = ( rocc_cmd_bits_inst_opcode==7'h0b && rocc_cmd_bits_inst_funct==7'h01 &&  rocc_cmd_valid && rocc_cmd_ready );
	wire cmd_0b_02 = ( rocc_cmd_bits_inst_opcode==7'h0b && rocc_cmd_bits_inst_funct==7'h02 &&  rocc_cmd_valid && rocc_cmd_ready );
	wire cmd_0b_03 = ( rocc_cmd_bits_inst_opcode==7'h0b && rocc_cmd_bits_inst_funct==7'h03 &&  rocc_cmd_valid && rocc_cmd_ready );
	wire cmd_0b_04 = ( rocc_cmd_bits_inst_opcode==7'h0b && rocc_cmd_bits_inst_funct==7'h04 &&  rocc_cmd_valid && rocc_cmd_ready );
	wire cmd_0b_05 = ( rocc_cmd_bits_inst_opcode==7'h0b && rocc_cmd_bits_inst_funct==7'h05 &&  rocc_cmd_valid && rocc_cmd_ready );
	wire cmd_0b_06 = ( rocc_cmd_bits_inst_opcode==7'h0b && rocc_cmd_bits_inst_funct==7'h06 &&  rocc_cmd_valid && rocc_cmd_ready );
	wire cmd_0b_07 = ( rocc_cmd_bits_inst_opcode==7'h0b && rocc_cmd_bits_inst_funct==7'h07 &&  rocc_cmd_valid && rocc_cmd_ready );
	
	wire cmd_2b_01 = ( rocc_cmd_bits_inst_opcode==7'h2b && rocc_cmd_bits_inst_funct==7'h01 &&  rocc_cmd_valid && rocc_cmd_ready );
	wire cmd_2b_02 = ( rocc_cmd_bits_inst_opcode==7'h2b && rocc_cmd_bits_inst_funct==7'h02 &&  rocc_cmd_valid && rocc_cmd_ready );
	//debug signal
  

/*
    input rocc_mem_req_ready,
    output rocc_mem_req_valid,
    output [coreMaxAddrBits-1:0] rocc_mem_req_bits_addr,
    output [dcacheReqTagBits-1:0] rocc_mem_req_bits_tag,
    output [M_SZ-1:0] rocc_mem_req_bits_cmd,
    output [mem_req_bits_size_width-1:0] rocc_mem_req_bits_size,
    output rocc_mem_req_bits_signed,
    output rocc_mem_req_bits_phys,
    output rocc_mem_req_bits_no_alloc,
    output rocc_mem_req_bits_no_xcpt,
    output [coreDataBits-1:0] rocc_mem_req_bits_data,
    output [coreDataBytes-1:0] rocc_mem_req_bits_mask,

    input rocc_mem_resp_valid,
    input [coreMaxAddrBits-1:0] rocc_mem_resp_bits_addr,
    input [dcacheReqTagBits-1:0] rocc_mem_resp_bits_tag,
    input [M_SZ-1:0] rocc_mem_resp_bits_cmd,
    input [mem_req_bits_size_width-1:0] rocc_mem_resp_bits_size,
    input rocc_mem_resp_bits_signed,
    input [coreDataBits-1:0] rocc_mem_resp_bits_data,
    input [coreDataBytes-1:0] rocc_mem_resp_bits_mask,
    input rocc_mem_resp_bits_replay,
    input rocc_mem_resp_bits_has_data,
    input [coreDataBits-1:0] rocc_mem_resp_bits_data_word_bypass,
    input [coreDataBits-1:0] rocc_mem_resp_bits_data_raw,
    input [coreDataBits-1:0] rocc_mem_resp_bits_store_data,
*/  

wire [31:0]  imdct_dout;  

imdct_fft_with_ram256 imdct(
.rst_n(~reset),
.clk(clock),
.din(rocc_mem_resp_bits_data),
.we(rocc_mem_resp_valid&mem_read),
.ram_en( (rocc_mem_resp_valid&mem_read) | int_mem_read_enable ),
.addr(int_mem_addr),
.start(imdct_start),
.tabidx(mem_1024),
.mode(1'b0),
.es(imdct_es),
//.func(1'b0),
//.auto(1'b1),
.func(FFT_ONLY),
.auto(~FFT_ONLY),
.bit_rev(1'b0),
.dout(imdct_dout), 
.done(imdct_done),
.progress(progress)
);  
  
  always @ (posedge clock) 
  begin
    if (reset) 
	begin
		
	end
	else
	begin
	
		
	end
  end
		
	  
  always @ (posedge clock) 
  begin
    if (reset) 
    begin
      acc <= 0;
      doResp<= 0;
      doResp_d<= 0;
      doResp_dd<= 0;      
      rocc_cmd_bits_inst_rd_d<=0;
    end
    if (rocc_cmd_valid && rocc_cmd_ready) 
	begin
      //doResp                  <= ( rocc_cmd_bits_inst_opcode==7'h0b && rocc_cmd_bits_inst_funct==7'h01)  ? 0 :rocc_cmd_bits_inst_xd;
	  doResp                  <= rocc_cmd_bits_inst_xd;
      rocc_cmd_bits_inst_rd_d <= rocc_cmd_bits_inst_rd;
      acc                     <= acc + rocc_cmd_bits_rs1 + rocc_cmd_bits_rs2;
	  rocc_cmd_bits_inst_funct_d<=rocc_cmd_bits_inst_funct;
	  
	  if(rocc_cmd_bits_inst_funct==1)
	  begin
	  	
	  end
	  else
	  begin
	  	
	  end
	  
	  
    end
    else 
    begin
		if(doResp & rocc_resp_ready)
		begin
      		doResp <= 0;
		end
	  //doResp <= (mem_read & mem_cnt==7 &mem_req_valid_reg & rocc_mem_req_ready);
    end
      

      doResp_d<= doResp;
      doResp_dd<= doResp_d;      
  end

	always @ *
	begin
		//mem_req_bits_data_reg<=int_mem_do^32'h80000000;
		mem_req_bits_data_reg<=imdct_dout;
		
	end


//mem_req
  always @ (posedge clock or posedge reset) 
  begin
    if (reset) 
    begin
      	mem_req_valid_reg<=0;
		mem_req_valid_delay_reg<=0;
		mem_req_bits_addr_reg<=0;
		mem_req_bits_tag_reg<=0;
		mem_req_bits_cmd_reg<=0;
		mem_req_bits_size<=2'b10;
		//mem_req_bits_data_reg<=0;
		mem_cnt<=0;
		mem_resp_cnt<=0;
		mem_read<=0;
		//mem_1024<=0;
		mem_write_cnt<=0;
		//mem_tranfer_num<=0;
		interrupt_reg<=0;
		imdct_setting<=0;
		imdct_process<=0;
		imdct_start<=0;
    end
	else
	begin
		if (1'b1) 
		begin
			if ( rocc_cmd_bits_inst_opcode==7'h0b && (rocc_cmd_bits_inst_funct==7'h00 )&&  rocc_cmd_valid && rocc_cmd_ready ) //imdct setting
			begin
				imdct_setting <=rocc_cmd_bits_rs1[7:0];			
			end
			//read mem
		    if ( rocc_cmd_bits_inst_opcode==7'h0b && (rocc_cmd_bits_inst_funct==7'h01 | rocc_cmd_bits_inst_funct==7'h05 | rocc_cmd_bits_inst_funct==7'h04 )&&  rocc_cmd_valid && rocc_cmd_ready )
			begin
				mem_req_valid_reg<=1;	
				//mem_req_bits_addr_reg<=32'h80000FF0;	
				mem_req_bits_addr_reg<=rocc_cmd_bits_rs1;
				
				if( rocc_cmd_bits_inst_funct==7'h04)
				begin
					imdct_process<=1;
					mem_req_bits_addr2_reg<=rocc_cmd_bits_rs2;
				end

				if(mem_req_bits_tag_reg!=9'h3f)
				begin
					mem_req_bits_tag_reg<=mem_req_bits_tag_reg+1;
				end
				else
				begin
					mem_req_bits_tag_reg<=0;
				end
				
				mem_req_bits_cmd_reg<=5'b00000;
				mem_req_bits_size<=2'b10;
				mem_cnt<=0;
				mem_read<=1;
				mem_resp_cnt<=0;
				if(rocc_cmd_bits_inst_funct==7'h05)
				begin
					//mem_1024<=1;
				end
				else
				begin
					//mem_1024<=0;
					//mem_tranfer_num<=rocc_cmd_bits_rs2[9:0];
				end
		
	    		end	 
			
			if(imdct_done)
			begin
			end
			   		 
			//else if(mem_req_valid_reg & rocc_mem_req_ready)
			if(mem_req_valid_reg & rocc_mem_req_ready)
			begin
				mem_cnt<=mem_cnt+1;
				mem_req_bits_addr_reg<=mem_req_bits_addr_reg+4;
				if(mem_cnt== (mem_1024 ? 1023 :127) )
				begin
					if(~mem_read)
					begin
						mem_req_valid_reg<=0;
					end
					//mem_read<=0;
					
					
					//if(~imdct_process )
					if(~imdct_process & ~mem_read)					
					begin
						interrupt_reg<=1;
					end
					
					if(imdct_process & ~mem_read)
					begin
						imdct_process<=0;
						interrupt_reg<=1;
					end
					
				end
			end
			else
	    	begin
	    	end
			
			
			if(imdct_start)
			begin
				imdct_start<=0;
			end
			if(interrupt_reg)
			begin
				interrupt_reg<=0;
			end
			
			//write mem after imdct
			if ( imdct_process &  imdct_done)
			begin
				mem_req_valid_delay_reg<=1;	
				mem_req_bits_addr_reg<=mem_req_bits_addr2_reg;

				if(mem_req_bits_tag_reg!=9'h3f)
				begin
					mem_req_bits_tag_reg<=mem_req_bits_tag_reg+1;
				end
				else
				begin
					mem_req_bits_tag_reg<=0;
				end
				mem_req_bits_cmd_reg<=5'b00001;
				mem_req_bits_size<=2'b10;
				mem_cnt<=0;
				mem_read<=0;
				mem_resp_cnt<=0;
				mem_write_cnt<=0;
	    		end	    
			
			
			
			//write mem
			if ( rocc_cmd_bits_inst_opcode==7'h0b && (rocc_cmd_bits_inst_funct==7'h03 | rocc_cmd_bits_inst_funct==7'h07 ) &&  rocc_cmd_valid && rocc_cmd_ready )
			begin
				mem_req_valid_delay_reg<=1;	
				//mem_req_bits_addr_reg<=32'h80000FF0;	
				mem_req_bits_addr_reg<=rocc_cmd_bits_rs1;

				if(mem_req_bits_tag_reg!=9'h3f)
				begin
					mem_req_bits_tag_reg<=mem_req_bits_tag_reg+1;
				end
				else
				begin
					mem_req_bits_tag_reg<=0;
				end
				mem_req_bits_cmd_reg<=5'b00001;
				mem_req_bits_size<=2'b10;
				mem_cnt<=0;
				mem_read<=0;
				mem_resp_cnt<=0;
				mem_write_cnt<=0;
				
				if(rocc_cmd_bits_inst_funct==7'h07)
				begin
					//mem_1024<=1;
				end
				else
				begin
					//mem_1024<=0;
					//mem_tranfer_num<=rocc_cmd_bits_rs2[9:0];
				end
	    	end	    
			
			if((mem_req_valid_reg & rocc_mem_req_ready & ~mem_read)|mem_req_valid_delay_reg)
			begin
				mem_write_cnt<=mem_write_cnt+1;
			end
			
			if(mem_req_valid_delay_reg)
			begin
				mem_req_valid_reg<=1;
				mem_req_valid_delay_reg<=0;
			end
			
			
			if(rocc_mem_resp_valid&mem_read)
			begin
				mem_resp_cnt<=mem_resp_cnt+1;
				//int_mem[mem_resp_cnt]<=rocc_mem_resp_bits_data;
				if(mem_resp_cnt==(mem_1024 ? 1023 :127))
				begin					
					mem_read<=0;					
					mem_req_valid_reg<=0;	//added 20210708
					
					if(imdct_process)
					begin
						imdct_start<=1;
					end
					else
					begin
						interrupt_reg<=1;
					end

				end
				
			end
		end
	end
  end
  

  always @ *
  begin
  	if(mem_read)
	begin
		int_mem_addr<=mem_resp_cnt;
	end
	else
	begin
		int_mem_addr<=mem_write_cnt;
	end

	int_mem_read_enable<=(mem_req_valid_reg & rocc_mem_req_ready )|mem_req_valid_delay_reg;
	
  end
  
/*  
  always @ (posedge clock) 
  begin
  	if(rocc_mem_resp_valid&mem_read)
	begin
  		int_mem[int_mem_addr]<=rocc_mem_resp_bits_data;
	end
	if(int_mem_read_enable)
	begin
		int_mem_do<=int_mem[int_mem_addr];
	end
  	
  end
*/
  
  reg [31:0] rocc_resp_bits_data_reg;

//  assign rocc_resp_valid = doResp;
//  assign rocc_resp_valid = doResp_d;
  assign rocc_resp_valid = rocc_resp_valid_reg;

//  assign rocc_resp_bits_rd = rocc_cmd_bits_inst_rd;
  assign rocc_resp_bits_rd = rocc_cmd_bits_inst_rd_d;
  
//  assign rocc_resp_bits_data = acc;
//  assign rocc_resp_bits_data = 32'h76543210+rocc_resp_bits_rd;

//  assign rocc_resp_bits_data = {31'h0000, mem_req_valid_reg};
  assign rocc_resp_bits_data = rocc_resp_bits_data_reg;
  
  reg tram_sel_0_r;
  reg tram_sel_fall;
  //wire tram_sel_0_w = TestDriver.design_1_i.RISCV_R32_CPC_0.inst.U_ExampleRocketSystem.tram_sel_0;
  wire tram_sel_0_w = rocc_tram_sel;

  always @ *
  begin
  case (rocc_cmd_bits_inst_funct_d)
  0: rocc_resp_valid_reg <=doResp;
  1: rocc_resp_valid_reg <=doResp;
  2: rocc_resp_valid_reg <=doResp;
  3: rocc_resp_valid_reg <=doResp;  
  4: rocc_resp_valid_reg <=doResp;  
  6: rocc_resp_valid_reg <=tram_sel_fall;    
  default : rocc_resp_valid_reg <=doResp;
  endcase
  end
  
  
   
  always @ *
  begin
  case (rocc_cmd_bits_inst_funct_d)
  0: rocc_resp_bits_data_reg <={27'h0, rocc_cmd_bits_inst_rd_d};
  1: rocc_resp_bits_data_reg <={31'h0000, mem_req_valid_reg};
  2: rocc_resp_bits_data_reg <={30'h0000, imdct_process, mem_req_valid_reg};
  3: rocc_resp_bits_data_reg <={31'h0000, mem_req_valid_reg};  
  4: rocc_resp_bits_data_reg <=32'h0004;  
  default : rocc_resp_bits_data_reg <=0;
  
  
  endcase
  
  end
  
  

always @ (posedge clock or posedge reset) 
begin
	if (reset) 
	begin
	  	tram_sel_0_r<=0;
		tram_sel_fall<=0;
	end
	else
	begin
	  	tram_sel_0_r<=tram_sel_0_w;
		tram_sel_fall<=tram_sel_0_r & ~tram_sel_0_w;
	end
end




  

endmodule
