module r4r8_1st_pass_core(
input rst_n,
input clk,
input mode,
input start,

input [31:0] dout_0,
input [31:0] dout_1,
input bit_rev_output,

output wire ram_we_0,
output wire ram_we_1,
output wire [8:0] ram_raddr_0,
output wire [8:0] ram_waddr_0,

output wire [8:0] ram_raddr_1,
output wire [8:0] ram_waddr_1,

output wire signed [31:0] din_0,
output wire signed [31:0] din_1,

output reg done,
output wire progress
);

localparam LAST_CSTATE = 13;

//wire bit_rev_output=1;

reg first_progress;
reg core_progress;
reg first_pass_done;
reg core_done;
reg rev_progress;
reg rev_done;
reg rev_write;


assign progress=first_progress|first_pass_done|core_progress|rev_progress;


//wire [8:0] ram_raddr_rev0;
//wire [8:0] ram_waddr_rev0;

//wire [8:0] ram_raddr_rev1;
//wire [8:0] ram_waddr_rev1;

wire [31:0] rom0_out;
wire [31:0] rom1_out;
wire [8:0] rom_rev512out;
wire [8:0] rom_rev64out;


reg [31:0] x0;  //ar
reg [31:0] x1;	//ai
reg [31:0] x2;	//br
reg [31:0] x3;	//bi
reg [31:0] x4;	//cr
reg [31:0] x5;	//ci
reg [31:0] x6;	//dr
reg [31:0] x7;	//di
reg [31:0] x8;	
reg [31:0] x9;
reg [31:0] x10;
reg [31:0] x11;
reg [31:0] x12;
reg [31:0] x13;
reg [31:0] x14;
reg [31:0] x15;

reg signed[31:0] sr;
reg signed[31:0] si;
reg signed[31:0] tr;
reg signed[31:0] ti;
reg signed[31:0] ur;
reg signed[31:0] ui;
reg signed[31:0] vr;
reg signed[31:0] vi;

reg [4:0] bg;
reg [7:0] gp;

reg [1:0] bg_loop;

reg [4:0] cstate;



wire [31:0] sr_sr1 = {sr[31],sr[31:1]};
wire [31:0] si_sr1 = {si[31],si[31:1]};

wire [31:0] tr_sr1 = {tr[31],tr[31:1]};
wire [31:0] ti_sr1 = {ti[31],ti[31:1]};

wire [31:0] ur_sr1 = {ur[31],ur[31:1]};
wire [31:0] ui_sr1 = {ui[31],ui[31:1]};

wire [31:0] vr_sr1 = {vr[31],vr[31:1]};
wire [31:0] vi_sr1 = {vi[31],vi[31:1]};


reg [31:0] wr;
reg [31:0] wi;
reg [31:0] yr;
reg [31:0] yi;

				//wr <= ( (x8 + x10 + x12 + dout_0) >> 1 );
				//yr <= ( (x8 + x10 - (x12 + dout_0) ) >> 1 );
				//wi <= ( (x9 + x11 + x13 + dout_1) >> 1 );
				//yi <= ( (x9 + x11 - (x13 + dout_1) ) >> 1 );

wire [31:0] wr_x2_wire = (x8 + x10 + x12 + dout_0) ;
wire [31:0] yr_x2_wire = (x8 + x10 - (x12 + dout_0) ) ;
wire [31:0] wi_x2_wire = (x9 + x11 + x13 + dout_1) ;
wire [31:0] yi_x2_wire = (x9 + x11 - (x13 + dout_1) ) ;

wire [31:0] wr_wire = {wr_x2_wire[31],wr_x2_wire[31:1]};
wire [31:0] wi_wire = {wi_x2_wire[31],wi_x2_wire[31:1]};
wire [31:0] yr_wire = {yr_x2_wire[31],yr_x2_wire[31:1]};
wire [31:0] yi_wire = {yi_x2_wire[31],yi_x2_wire[31:1]};


wire [31:0] ws_a_2wi = wr + { wi[30:0], 1'b0};

reg [31:0] xr;
reg [31:0] xi;
reg [31:0] zr;
reg [31:0] zi;



wire [31:0] mulo0;
wire [31:0] mulo1;
wire [31:0] mulo2;
wire [31:0] mulo3;

//#define SQRT1_2 0x5a82799a	/* sqrt(1/2) in Q31 */

wire [31:0] SQRT1_2 = 32'h5a82799a;

wire [31:0] ar_m_ai = (x8 - x10 - (x13 - dout_1)) - (x9 - x11 + x12 - dout_0);
wire [31:0] ar_a_ai = (x8 - x10 - (x13 - dout_1)) + (x9 - x11 + x12 - dout_0);
wire [31:0] cr_m_ci = (x8 - x10 + x13 - dout_1) - (x9 - x11 - (x12 - dout_0));
wire [31:0] cr_a_ci = (x8 - x10 + x13 - dout_1) + (x9 - x11 - (x12 - dout_0));

reg [8:0] xptr;
reg [9:0] wptr;
reg [8:0] xa_reg;
reg [9:0] wa_reg;
reg [8:0] step;

reg [8:0] raddr_reg;
reg [8:0] waddr_reg;
reg readend;
reg writestart;

reg addr_sel;


reg signed[31:0] din_0_reg;
reg signed[31:0] din_1_reg;
reg core_wr;

reg [31:0] core_m0_in0;
reg [31:0] core_m0_in1;
reg [31:0] core_m1_in0;
reg [31:0] core_m1_in1;
reg [31:0] core_m2_in0;
reg [31:0] core_m2_in1;

wire [31:0] m0_in0 = core_progress ? core_m0_in0 : SQRT1_2;
wire [31:0] m0_in1 = core_progress ? core_m0_in1 : ar_m_ai;
wire [31:0] m1_in0 = core_progress ? core_m1_in0 : SQRT1_2;
wire [31:0] m1_in1 = core_progress ? core_m1_in1 : ar_a_ai;
wire [31:0] m2_in0 = core_progress ? core_m2_in0 : SQRT1_2;
wire [31:0] m2_in1 = core_progress ? core_m2_in1 : cr_m_ci;



//wire [8:0] step = mode ? 9'h1ff : 9'h03f;

always @ *
begin
	case (bg_loop)
		2'b00:
		begin
			step <= mode ? 8 : 4;
		end
		2'b01:
		begin
			step <= mode ? 32 : 16;
		end
		2'b10:
		begin
			step <= 128;
		end
		default:			
		begin
			step <= 128;
		end
	endcase
end

wire [8:0] end_addr = mode ? 9'h1ff : 9'h03f;

wire [8:0] rom_revout = mode ? rom_rev512out : rom_rev64out;

wire [8:0] rev_raddr512 = {rom_rev512out[0],rom_rev512out[1],rom_rev512out[2],rom_rev512out[3],rom_rev512out[4],rom_rev512out[5],rom_rev512out[6],rom_rev512out[7],rom_rev512out[8] };
wire [8:0] rev_raddr64 = {3'b000, rom_rev64out[0],rom_rev64out[1],rom_rev64out[2],rom_rev64out[3],rom_rev64out[4],rom_rev64out[5] };
wire [8:0] rev_raddr = mode ? rev_raddr512 : rev_raddr64;

wire [8:0] rev_process_raddr= addr_sel ? rom_revout : rev_raddr;

wire [8:0] rev_waddr512 = {waddr_reg[0],waddr_reg[1],waddr_reg[2],waddr_reg[3],waddr_reg[4],waddr_reg[5],waddr_reg[6],waddr_reg[7],waddr_reg[8] };
wire [8:0] rev_waddr64 = {3'b000,waddr_reg[0],waddr_reg[1],waddr_reg[2],waddr_reg[3],waddr_reg[4],waddr_reg[5] };
wire [8:0] rev_waddr = mode ? rev_waddr512 : rev_waddr64;

wire [8:0] rev_process_waddr= addr_sel ? waddr_reg : rev_waddr;

assign  ram_we_0= core_progress ? core_wr : (rev_progress ? rev_write : writestart);
assign  ram_we_1= core_progress ? core_wr : (rev_progress ? rev_write : writestart);

//assign  ram_we_0= writestart;
//assign  ram_we_1= writestart;

wire [8:0] rama = core_progress ? xa_reg : (rev_progress ? rev_process_raddr : raddr_reg);
wire [8:0] rama_w = core_progress ? xa_reg : (rev_progress ? rev_process_waddr : waddr_reg);


//assign  ram_raddr_0=mode ? {raddr_reg[0],raddr_reg[1],raddr_reg[2],raddr_reg[3],raddr_reg[4],raddr_reg[5],raddr_reg[6],raddr_reg[7],raddr_reg[8] } : 
//{3'h0, raddr_reg[0],raddr_reg[1],raddr_reg[2],raddr_reg[3],raddr_reg[4],raddr_reg[5] };
assign  ram_raddr_0=mode ? {rama[0],rama[1],rama[2],rama[3],rama[4],rama[5],rama[6],rama[7],rama[8] } : 
{3'h0, rama[0],rama[1],rama[2],rama[3],rama[4],rama[5] };


//assign  ram_waddr_0=mode ? {waddr_reg[0],waddr_reg[1],waddr_reg[2],waddr_reg[3],waddr_reg[4],waddr_reg[5],waddr_reg[6],waddr_reg[7],waddr_reg[8] } :
//{3'h0, waddr_reg[0],waddr_reg[1],waddr_reg[2],waddr_reg[3],waddr_reg[4],waddr_reg[5] };
assign  ram_waddr_0=mode ? {rama_w[0],rama_w[1],rama_w[2],rama_w[3],rama_w[4],rama_w[5],rama_w[6],rama_w[7],rama_w[8] } :
{3'h0, rama_w[0],rama_w[1],rama_w[2],rama_w[3],rama_w[4],rama_w[5] };


//assign  ram_raddr_1=mode ? {raddr_reg[0],raddr_reg[1],raddr_reg[2],raddr_reg[3],raddr_reg[4],raddr_reg[5],raddr_reg[6],raddr_reg[7],raddr_reg[8] } : 
//{3'h0, raddr_reg[0],raddr_reg[1],raddr_reg[2],raddr_reg[3],raddr_reg[4],raddr_reg[5] };
assign  ram_raddr_1=mode ? {rama[0],rama[1],rama[2],rama[3],rama[4],rama[5],rama[6],rama[7],rama[8] } : 
{3'h0, rama[0],rama[1],rama[2],rama[3],rama[4],rama[5] };


//assign  ram_waddr_1=mode ? {waddr_reg[0],waddr_reg[1],waddr_reg[2],waddr_reg[3],waddr_reg[4],waddr_reg[5],waddr_reg[6],waddr_reg[7],waddr_reg[8] } :
//{3'h0, waddr_reg[0],waddr_reg[1],waddr_reg[2],waddr_reg[3],waddr_reg[4],waddr_reg[5] };
assign  ram_waddr_1=mode ? {rama_w[0],rama_w[1],rama_w[2],rama_w[3],rama_w[4],rama_w[5],rama_w[6],rama_w[7],rama_w[8] } :
{3'h0, rama_w[0],rama_w[1],rama_w[2],rama_w[3],rama_w[4],rama_w[5] };



assign  din_0=din_0_reg;
assign  din_1=din_1_reg;

always @ *
begin
	case (cstate)
		5'h00:
			begin
				xa_reg<=xptr;
				wa_reg<=wptr;
			end
		5'h01:
			begin
				xa_reg<=xptr+step;
				wa_reg<=wptr+1;
			end
		5'h02:
			begin
				xa_reg<=xptr+step;
				wa_reg<=wptr+2;
			end
		5'h03:
			begin
				xa_reg<=xptr+step+step;
				wa_reg<=wptr+3;
			end
		5'h04:
			begin
				xa_reg<=xptr+step+step;
				wa_reg<=wptr+4;
			end
		5'h05:
			begin
				xa_reg<=xptr+step+step+step;
				wa_reg<=wptr+5;
			end
		5'h06:
			begin
				xa_reg<=xptr+step+step+step;
				wa_reg<=wptr+5;
			end
		5'h07:
			begin
				xa_reg<=xptr+step+step+step;
				wa_reg<=wptr+5;
			end
		5'h0B:
			begin
				xa_reg<=xptr+step+step;
				wa_reg<=wptr+5;
			end
		5'h0C:
			begin
				xa_reg<=xptr+step;
				wa_reg<=wptr+5;
			end
		5'h0D:
			begin
				xa_reg<=xptr;
				wa_reg<=wptr+5;
			end
			
		
		default:
			begin
				xa_reg<=xptr+step+step+step;
				wa_reg<=wptr+5;
			end
	endcase
	
end

always @ *
begin
	case(cstate)
			5'h03:
				begin
					core_m0_in0 <= wi;
					core_m0_in1 <= x2+x3;
					core_m1_in0 <= ws_a_2wi;
					core_m1_in1 <= x2;
					//core_m2_in0 <= mode ? rom1_out : rom0_out;
					core_m2_in0 <= wr;
					core_m2_in1 <= x3;
				end
			5'h05:
				begin
					core_m0_in0 <= wi;
					core_m0_in1 <= x4+x5;
					core_m1_in0 <= ws_a_2wi;
					core_m1_in1 <= x4;
					//core_m2_in0 <= mode ? rom1_out : rom0_out;
					core_m2_in0 <= wr;
					core_m2_in1 <= x5;
				end
			5'h07:
				begin
					core_m0_in0 <= wi;
					core_m0_in1 <= x6+x7;
					core_m1_in0 <= ws_a_2wi;
					core_m1_in1 <= x6;
					//core_m2_in0 <= mode ? rom1_out : rom0_out;
					core_m2_in0 <= wr;
					core_m2_in1 <= x7;
				end
			default:
				begin
					core_m0_in0 <=0;
					core_m0_in1 <=0;
					core_m1_in0 <=0;
					core_m1_in1 <=0;
					core_m2_in0 <=0;
					core_m2_in1 <=0;
				end
	endcase
end

always @ *
begin
	if (core_progress)
	begin //Core
			case (cstate)
			5'h0A:
				begin
					din_0_reg<= x0 + x5;
					din_1_reg<= x1 + x6;
					core_wr<=1;
				end
			5'h0B:
				begin
					din_0_reg<= x2 - x4;
					din_1_reg<= x3 - x7;
					core_wr<=1;
				end
			5'h0C:
				begin
					din_0_reg<= x0 - x5;
					din_1_reg<= x1 - x6;
					core_wr<=1;
				end
			5'h0D:
				begin
					din_0_reg<= x2 + x4;
					din_1_reg<= x3 + x7;
					core_wr<=1;
				end
			default:
				begin
					din_0_reg<=0;
					din_1_reg<=0;
					core_wr<=0;
				end
			endcase
	end
	else if(rev_progress)
	begin
		din_0_reg<=dout_0;
		din_1_reg<=dout_1;
	end
	else
	begin //first pass
		core_wr<=0;
		
		if(~mode)
		begin
			case (waddr_reg[1:0])
			2'b00:
				begin
					din_0_reg<=x0 + x2 + x4 + dout_0;
					din_1_reg<=x1 + x3 + x5 + dout_1;
				end
			2'b01:
				begin
					din_0_reg<=x2;
					din_1_reg<=x3;
				end
			2'b10:
				begin
					din_0_reg<=x4;
					din_1_reg<=x5;
				end
			2'b11:
				begin
					din_0_reg<=x6;
					din_1_reg<=x7;
				end
			endcase
		end
		else
		begin
		
	/*
			x[ 0] = ( (sr >> 1) + wr );
			x[ 1] = ( (si >> 1) + wi );
			x[ 2] = ( (vr >> 1) + zi );
			x[ 3] = ( (vi >> 1) - zr );
			x[ 4] = ( (ur >> 1) + yi );
			x[ 5] = ( (ui >> 1) - yr );
			x[ 6] = ( (tr >> 1) - xr );
			x[ 7] = ( (ti >> 1) - xi );
			x[ 8] = ( (sr >> 1) - wr );
			x[ 9] = ( (si >> 1) - wi );
			x[10] = ( (vr >> 1) - zi );
			x[11] = ( (vi >> 1) + zr );		
			x[12] = ( (ur >> 1) - yi );
			x[13] = ( (ui >> 1) + yr );
			x[14] = ( (tr >> 1) + xr );
			x[15] = ( (ti >> 1) + xi );
	
	*/
		
			case (waddr_reg[2:0])
			3'b000:
				begin
					//din_0_reg<= ( (sr >> 1) + wr );
					//din_1_reg<= ( (si >> 1) + wi );
					din_0_reg<= ( sr_sr1 + wr );
					din_1_reg<= ( si_sr1 + wi );
					
				end
			3'b001:
				begin
					//din_0_reg<= ( (vr >>> 1) + zi );
					//din_1_reg<= ( (vi >> 1) - zr );
					din_0_reg<= ( vr_sr1 + zi );
					din_1_reg<= ( vi_sr1 - zr );
				end
			3'b010:
				begin
					//din_0_reg<= ( (ur >> 1) + yi );
					//din_1_reg<= ( (ui >> 1) - yr );
					din_0_reg<= ( ur_sr1 + yi );
					din_1_reg<= ( ui_sr1 - yr );
				end
			3'b011:
				begin
					//din_0_reg<= ( (tr >> 1) - xr );
					//din_1_reg<= ( (ti >> 1) - xi );
					din_0_reg<= ( tr_sr1 - xr );
					din_1_reg<= ( ti_sr1 - xi );
				end
			3'b100:
				begin
					//din_0_reg<= ( (sr >> 1) - wr );
					//din_1_reg<= ( (si >> 1) - wi );
					din_0_reg<= ( sr_sr1 - wr );
					din_1_reg<= ( si_sr1 - wi );
				end
			3'b101:
				begin
					//din_0_reg<= ( (vr >> 1) - zi );
					//din_1_reg<= ( (vi >> 1) + zr );		
					din_0_reg<= ( vr_sr1 - zi );
					din_1_reg<= ( vi_sr1 + zr );		
				end
			3'b110:
				begin
					//din_0_reg<= ( (ur >> 1) - yi );		
					//din_1_reg<= ( (ui >> 1) + yr );
					din_0_reg<= ( ur_sr1 - yi );		
					din_1_reg<= ( ui_sr1 + yr );
					
				end
			3'b111:
				begin
					//din_0_reg<= ( (tr >> 1) + xr );
					//din_1_reg<= ( (ti >> 1) + xi );
					din_0_reg<= ( tr_sr1 + xr );
					din_1_reg<= ( ti_sr1 + xi );
				end
			endcase
		end
	end
end


always @ *
begin
	done <= bit_rev_output ? rev_done : core_done;
end

always @(negedge rst_n or posedge clk)
if (~rst_n)
begin
   	core_done <= 0;
	first_pass_done<=0;
	first_progress<=0;
	core_progress<=0;
	rev_progress<=0;
	rev_done<=0;
	rev_write<=0;
end  
else
begin
	first_progress<= ( (start&~first_progress)|first_progress )& (waddr_reg!=end_addr);
	first_pass_done<=first_progress&~done&(waddr_reg==end_addr);
	//core_progress<=( (first_progress&~done&(waddr_reg==end_addr)) | core_progress ) & ~done;
	core_progress<=( first_pass_done | core_progress ) & ~core_done;
	//done<=core_progress;
	core_done<= mode ? ((bg_loop==2) & (bg==1) & (gp==1) & (cstate==LAST_CSTATE)) : ((bg_loop==1) & (bg==1) & (gp==1) & (cstate==LAST_CSTATE));
	rev_progress<= ( (core_done & bit_rev_output) |rev_progress)& ~rev_done;  
	rev_done<= rev_progress & (raddr_reg==(mode ? 240 : 35)) & ~addr_sel;
	rev_write<= ( (rev_progress & (raddr_reg==0) & addr_sel) |rev_write)& ~rev_done; 
end




always @(negedge rst_n or posedge clk)
if (~rst_n)
begin
   	raddr_reg <= 0;
	waddr_reg<=0;
	readend<=0;
	writestart<=0;
	addr_sel<=0;
	x0<=0;
	x1<=0;
	x2<=0;
	x3<=0;
	x4<=0;
	x5<=0;
	x6<=0;
	x7<=0;
	x8<=0;
	x9<=0;
	x10<=0;
	x11<=0;
	x12<=0;
	x13<=0;
	x14<=0;
	x15<=0;
	xr<=0;
	xi<=0;
	yr<=0;
	yi<=0;	
	zr<=0;
	zi<=0;
	bg<=0;
	gp<=0;
	
	sr<=0;
	si<=0;
	tr<=0;
	ti<=0;
	ur<=0;
	ui<=0;
	vr<=0;
	vi<=0;
	wr<=0;
	wi<=0;
	
	bg_loop<=0;
	cstate<=0;
	xptr<=0;
	wptr<=0;
end  
else
begin
	if(start | ~progress)
	begin
		raddr_reg <= 0;
		waddr_reg<=0;
		readend<=0;
		writestart<=0;
	end
	
	if(first_pass_done)
	begin
		bg<= mode ? 16: 4;
		gp<= mode ? 8: 4;
		cstate<=0;
		bg_loop<=0;
		xptr<=0;
		wptr<=0;
	end
	
	if(core_progress)
	begin
		if(mode)
		begin
			if(cstate == LAST_CSTATE)
			begin
				cstate <= 0;
				
				if(gp==1)
				begin
				
					if(bg==1)
					begin
						bg <= (bg_loop ==0) ? 4 : ( (bg_loop==1) ? 1 : 0);
						bg_loop<=bg_loop+1;
						gp <= (bg_loop ==0) ? 32 : ( (bg_loop==1) ? 128 : 128); 
						xptr<=0;
						wptr<=wptr+6;
					end
					else
					begin
						bg <= bg - 1;
						
						gp <= (bg_loop ==0) ? 8 : ( (bg_loop==1) ? 32 : 128); 
						xptr<=xptr+1+step+step+step;			
						//wptr<=0;
						wptr<=(bg_loop ==0) ? 0 :  ((bg_loop ==1) ? 48 : 240) ;
					end
	
				end
				else
				begin
					gp<=gp-1;	
					xptr<=xptr+1;			
					wptr<=wptr+6;
				end
				
			end
			else
			begin
				cstate<=cstate+1;
			end		
		end
		else
		begin
			if(cstate == LAST_CSTATE)
			begin
				cstate <= 0;
				
				if(gp==1)
				begin
					if(bg==1)
					begin
						bg_loop<=bg_loop+1;
						bg <= (bg_loop ==0) ? 1 : 0 ;						
						gp <= (bg_loop ==0) ? 16 : 0; 
						xptr<=0;
						wptr<=wptr+6;
					end
					else
					begin
						bg <= bg - 1;
						gp <= (bg_loop ==0) ? 4 : 16; 
						xptr<=xptr+1+step+step+step;			
						wptr<=(bg_loop ==0) ? 0 :  ((bg_loop ==1) ? 24 : 120) ;
						
					end
				end
				else
				begin
					gp<=gp-1;
					xptr<=xptr+1;	
					wptr<=wptr+6;		
				end
				
			end
			else
			begin
				cstate<=cstate+1;
			end
		end
		
	end
	
	//if(first_progress & ~readend)
	if(first_progress )
	begin
		raddr_reg<=raddr_reg+1;
	end
	if(first_progress & ~readend & raddr_reg==end_addr)
	begin
		readend<=1;
	end
	
	if(first_progress  & raddr_reg== (mode ? 9'h008 : 9'h003 ) )
	begin
		writestart<=1;
	end
	if(first_progress  & waddr_reg==end_addr)
	begin
		writestart<=0;
		readend<=0;
	end
	
	if(first_progress  & writestart )
	begin
		waddr_reg<=waddr_reg+1;
	end
	
	if(core_progress & core_done)
	begin
		raddr_reg<=0;
		addr_sel<=0;
	end
	
	if(core_progress)
	begin
		if(~mode) //FFT64
		begin
			case(cstate)
			5'h00:
				begin
					
				end
			5'h01:
				begin
					x0<=dout_0;	
					x1<=dout_1;
					wr <= rom0_out;		//wr=ws
					
				end
			5'h02:
				begin
					x2<=dout_0;	
					x3<=dout_1;
					wi <= rom0_out;
				end
			5'h03:
				begin
					wr <= rom0_out;		//wr=ws
					ur <= ws_a_2wi;
				end
			5'h04:
				begin
					tr<=mulo0;
					x2<=mulo1 - mulo0;
					x3<=mulo2 + mulo0;
					
					x4<=dout_0;	
					x5<=dout_1;
					wi <= rom0_out;
				end
			5'h05:
				begin
					ur <= ws_a_2wi;
					wr <= rom0_out;		//wr=ws
					
				end
			5'h06:
				begin
					tr<=mulo0;
					x4<=mulo1 - mulo0;
					x5<=mulo2 + mulo0;
					
					x6<=dout_0;	
					x7<=dout_1;	
					wi <= rom0_out;				
				end
			5'h07:
				begin
					ur <= ws_a_2wi;
					
				end
			5'h08:
				begin
					tr<=mulo0;
					x6<=mulo1 - mulo0;
					x7<=mulo2 + mulo0;
					
				end
			5'h09:
				begin
					x0 <= {x0[31],x0[31],x0[31:2]} - x2;
					x1 <= {x1[31],x1[31],x1[31:2]} - x3;
					x2 <= {x0[31],x0[31],x0[31:2]} + x2;
					x3 <= {x1[31],x1[31],x1[31:2]} + x3;
				
					x4 <= x4 + x6;
					x5 <= x7 - x5;
					x6 <= x4 - x6;
					x7 <= x7 + x5;
				end
			default:
				begin
				end
			endcase

		end
		else	//FFT512
		begin
			case(cstate)
			5'h00:
				begin
					
				end
			5'h01:
				begin
					x0<=dout_0;	
					x1<=dout_1;
					wr <= rom1_out;		//wr=ws
					
				end
			5'h02:
				begin
					x2<=dout_0;	
					x3<=dout_1;
					wi <= rom1_out;
				end
			5'h03:
				begin
					wr <= rom1_out;		//wr=ws
					ur <= ws_a_2wi;
				end
			5'h04:
				begin
					tr<=mulo0;
					x2<=mulo1 - mulo0;
					x3<=mulo2 + mulo0;
					
					x4<=dout_0;	
					x5<=dout_1;
					wi <= rom1_out;
				end
			5'h05:
				begin
					ur <= ws_a_2wi;
					wr <= rom1_out;		//wr=ws
					
				end
			5'h06:
				begin
					tr<=mulo0;
					x4<=mulo1 - mulo0;
					x5<=mulo2 + mulo0;
					
					x6<=dout_0;	
					x7<=dout_1;	
					wi <= rom1_out;				
				end
			5'h07:
				begin
					ur <= ws_a_2wi;
					
				end
			5'h08:
				begin
					tr<=mulo0;
					x6<=mulo1 - mulo0;
					x7<=mulo2 + mulo0;
					
				end
			5'h09:
				begin
					x0 <= {x0[31],x0[31],x0[31:2]} - x2;
					x1 <= {x1[31],x1[31],x1[31:2]} - x3;
					x2 <= {x0[31],x0[31],x0[31:2]} + x2;
					x3 <= {x1[31],x1[31],x1[31:2]} + x3;
				
					x4 <= x4 + x6;
					x5 <= x7 - x5;
					x6 <= x4 - x6;
					x7 <= x7 + x5;
				end
			5'h0A:
				begin
					
				end
			5'h0B:
				begin
					
				end
			5'h0C:
				begin
					
				end
			5'h0D:
				begin
					
				end
							
				
			default:
				begin
				end
			endcase
		end
	end
	else if( rev_progress)
	begin
		addr_sel<=~addr_sel;
		if(addr_sel)
		begin
			raddr_reg<=raddr_reg+1;
		end		
		waddr_reg<=rom_revout;
	end
	else
	//else	//First pass
	begin
		if(~mode)
		begin	//FFT64
			case(raddr_reg[1:0])
			2'b00:
				begin
					//x6<=dout_0;
					//x7<=dout_1;
					
					x0 <= x0 + x2 + x4 + dout_0;
					x1 <= x1 + x3 + x5 + dout_0;
					x2 <= x0 - x2 + x5 - dout_1;
					x3 <= x1 - x3 - (x4 - dout_0);
		
					x4 <= x0 + x2 - (x4 + dout_0);
					x5 <= x1 + x3 - (x5 + dout_1);
					x6 <= x0 - x2 - (x5 - dout_1);
					x7 <= x1 - x3 + x4 - dout_0;
					
					
				end
			2'b01:
				begin
					x0<=dout_0;
					x1<=dout_1;
				end
			2'b10:
				begin
					x2<=dout_0;
					x3<=dout_1;
				end
			2'b11:
				begin
					x4<=dout_0;
					x5<=dout_1;
				end
			endcase
		end
		else
		begin	//FFT512
			case(raddr_reg[2:0])
			3'b000:
				begin
					x14 <=dout_0;
					x15 <=dout_1;
					
					//wr <= ( (x8 + x10 + x12 + dout_0) >> 1 );
					//yr <= ( (x8 + x10 - (x12 + dout_0) ) >> 1 );
					//wi <= ( (x9 + x11 + x13 + dout_1) >> 1 );
					//yi <= ( (x9 + x11 - (x13 + dout_1) ) >> 1 );
					
					wr <= wr_wire; 
					yr <= yr_wire; 
					wi <= wi_wire;
					yi <= yi_wire; 
					
					sr <= x0 + x2 + x4 + x6;
					ur <= x0 + x2 - (x4 + x6);
					si <= x1 + x3 + x5 + x7;
					ui <= x1 + x3 - (x5 + x7);
					tr <= x0 - x2 - (x5 - x7);
					vr <= x0 - x2 + x5 - x7;
					ti <= x1 - x3 + x4 - x6;
					vi <= x1 - x3 - (x4 - x6);
					
				end
			3'b001:
				begin
					x0<=dout_0;
					x1<=dout_1;
				end
			3'b010:
				begin
					x2<=dout_0;
					x3<=dout_1;
				end
			3'b011:
				begin
					x4<=dout_0;
					x5<=dout_1;
				end
			3'b100:
				begin
					x6 <=dout_0;
					x7 <=dout_1;
					
	//				sr <= x0 + x2 + x4 + dout_0;
	//				ur <= x0 + x2 - (x4 + dout_0);
	//				si <= x1 + x3 + x5 + dout_1;
	//				ui <= x1 + x3 - (x5 + dout_1);
	//				tr <= x0 - x2 - (x5 - dout_1);
	//				vr <= x0 - x2 + x5 - dout_1;
	//				ti <= x1 - x3 + x4 - dout_0;
	//				vi <= x1 - x3 - (x4 - dout_0);			
				end
			3'b101:
				begin
					x8<=dout_0;
					x9<=dout_1;
				end
			3'b110:
				begin
					x10<=dout_0;
					x11<=dout_1;
				end
			3'b111:
				begin
					x12<=dout_0;
					x13<=dout_1;
				end
				
			endcase
			
			if (waddr_reg[2:0]==3'b000)
			begin
				xr<=mulo0;
				xi<=mulo1;
				zr<=mulo2;
				zi<=mulo3;
			end
		end
	end

end


mul_shift32 mul0 (
.rst_n(rst_n),
.clk(clk),
.in1(m0_in0),
.in2(m0_in1),
.out(mulo0)
);

mul_shift32 mul1 (
.rst_n(rst_n),
.clk(clk),
.in1(m1_in0),
.in2(m1_in1),
.out(mulo1)
);

mul_shift32 mul2 (
.rst_n(rst_n),
.clk(clk),
.in1(m2_in0),
.in2(m2_in1),
.out(mulo2)
);

mul_shift32 mul3 (
.rst_n(rst_n),
.clk(clk),
.in1(SQRT1_2),
.in2(cr_a_ci),
.out(mulo3)
);

rom_twidTabEven rom0(
.clk(clk),
.en(1'b1),
.addr(wa_reg),
.dout(rom0_out)
);

rom_twidTabOdd rom1(
.clk(clk),
.en(1'b1),
.addr(wa_reg),
.dout(rom1_out)
);

rom_rev240 rom2(
.clk(clk),
.en(1'b1),
.addr(raddr_reg[7:0]),
.dout(rom_rev512out)
);

rom_rev35 rom3(
.clk(clk),
.en(1'b1),
.addr(raddr_reg[5:0]),
.dout(rom_rev64out)
);


endmodule


