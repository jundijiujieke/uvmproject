module imdct_fft_with_ram256(
input rst_n,
input clk,
input [31:0] din,
input we,
input ram_en,
input [9:0] addr,
input start,
input tabidx,
input mode,
input [4:0] es,
input func,   //0: IMDCT, 1: FFT
input auto,   //0:manual 1: auto
input bit_rev,   //0 : ext_addr no rev, 1 : ext_addr bit rev, 


output wire [31:0] dout, 
output wire done,
output wire progress
);

wire [31:0] din_a;
wire [31:0] din_b;

wire [31:0] dout_a;
wire [31:0] dout_b;

wire ram_we_a;
wire ram_we_b;
wire [8:0] ram_raddr_a;
wire [8:0] ram_waddr_a;

wire [8:0] ram_raddr_b;
wire [8:0] ram_waddr_b;

wire [31:0] din0;
wire we0;
wire [7:0] waddr0;
wire [7:0] raddr0;
wire [31:0] dout0;

wire [31:0] din1;
wire we1; 
wire [7:0] waddr1;
wire [7:0] raddr1;
wire [31:0] dout1;

wire [31:0] din2;
wire we2;
wire [7:0] waddr2;
wire [7:0] raddr2;
wire [31:0] dout2;

wire [31:0] din3;
wire we3; 
wire [7:0] waddr3;
wire [7:0] raddr3;
wire [31:0] dout3;

reg ext_addr9_d;
reg ext_addr0_d;
reg ram_raddr0_a_d;
reg ram_raddr0_b_d;

reg raddr0_f8_d;
reg raddr1_f8_d;

reg auto_imdct_start1;
reg auto_imdct_start2;
reg auto_fft_start;
reg auto_progress;
reg auto_mode;
reg auto_tabidx;
reg auto_func_sel;

//wire func_sel = func;
wire func_sel = auto ? auto_func_sel: func ;


wire ext_we = we;
wire [31:0] ext_din = din;
wire [9:0] rev_addr64;
wire [9:0] rev_addr512;

assign rev_addr64={ 3'b000, addr[1],addr[2],addr[3],addr[4],addr[5],addr[6],addr[0]};
assign rev_addr512={ addr[1],addr[2],addr[3],addr[4],addr[5],addr[6],addr[7],addr[8],addr[9],addr[0]};

wire [9:0] ext_addr = ~bit_rev ? addr : (tabidx ? rev_addr512:rev_addr64);

//reg rev_ia;
//wire [8:0] rev_ram_waddr_a={ ram_waddr_a[1],ram_waddr_a[2],ram_waddr_a[3],ram_waddr_a[4],ram_waddr_a[5],ram_waddr_a[6],ram_waddr_a[7],ram_waddr_a[8],ram_waddr_a[9],ram_waddr_a[0]};
//wire [8:0] rev_ram_raddr_a={ ram_raddr_a[1],ram_raddr_a[2],ram_raddr_a[3],ram_raddr_a[4],ram_raddr_a[5],ram_raddr_a[6],ram_raddr_a[7],ram_raddr_a[8],ram_raddr_a[9],ram_raddr_a[0]};
//
//wire [8:0] rev_ram_waddr_b={ ram_waddr_b[1],ram_waddr_b[2],ram_waddr_b[3],ram_waddr_b[4],ram_waddr_b[5],ram_waddr_b[6],ram_waddr_b[7],ram_waddr_b[8],ram_waddr_b[9],ram_waddr_b[0]};
//wire [8:0] rev_ram_raddr_b={ ram_raddr_b[1],ram_raddr_b[2],ram_raddr_b[3],ram_raddr_b[4],ram_raddr_b[5],ram_raddr_b[6],ram_raddr_b[7],ram_raddr_b[8],ram_raddr_b[9],ram_raddr_b[0]};
//
//wire [8:0] imdct_waddr_a = ~rev_ia ? ram_waddr_a : rev_ram_waddr_a;
//wire [8:0] imdct_raddr_a = ~rev_ia ? ram_raddr_a : rev_ram_raddr_a;
//wire [8:0] imdct_waddr_b = ~rev_ia ? ram_waddr_b : rev_ram_waddr_b;
//wire [8:0] imdct_raddr_b = ~rev_ia ? ram_raddr_b : rev_ram_raddr_b;


assign din0   = ~progress ? ext_din  : din_a;
assign we0    = ~progress ? ext_we & (tabidx ? ~ext_addr[9] : ~ext_addr[6]) & ~ext_addr[0] : ram_we_a & ~ram_waddr_a[0];
assign waddr0 = ~progress ? (tabidx ? ext_addr[8:1] : {3'h0, ext_addr[5:1]}) : ram_waddr_a[8:1];
assign raddr0 = ~progress ? (tabidx ? ext_addr[8:1] : {3'h0, ext_addr[5:1]}) : ram_raddr_a[8:1];

assign din1 = ~progress ? ext_din : din_a;
assign we1  = ~progress ? ext_we & (tabidx ? ~ext_addr[9] : ~ext_addr[6]) & ext_addr[0]  : ram_we_a & ram_waddr_a[0];
assign waddr1 = ~progress ? (tabidx ? ext_addr[8:1] : {3'h0, ext_addr[5:1]}) : ram_waddr_a[8:1];
assign raddr1 = ~progress ? (tabidx ? ext_addr[8:1] : {3'h0, ext_addr[5:1]}) : ram_raddr_a[8:1];

assign din2 = ~progress ? ext_din : din_b;
assign we2  = ~progress ? ext_we & (tabidx ? ext_addr[9] : ext_addr[6]) & ~ext_addr[0] : ram_we_b & ~ram_waddr_b[0];
assign waddr2 = ~progress ? (tabidx ? ext_addr[8:1] : {3'h0, ext_addr[5:1]}) : ram_waddr_b[8:1];
assign raddr2 = ~progress ? (tabidx ? ext_addr[8:1] : {3'h0, ext_addr[5:1]}) : ram_raddr_b[8:1];

assign din3 = ~progress ? ext_din : din_b;
assign we3  = ~progress ? ext_we & (tabidx ? ext_addr[9] : ext_addr[6]) & ext_addr[0] : ram_we_b & ram_waddr_b[0];
assign waddr3 = ~progress ? (tabidx ? ext_addr[8:1] : {3'h0, ext_addr[5:1]}) : ram_waddr_b[8:1];
assign raddr3 = ~progress ? (tabidx ? ext_addr[8:1] : {3'h0, ext_addr[5:1]}) : ram_raddr_b[8:1];

assign dout = (ext_addr9_d) ? (ext_addr0_d ? dout3 : dout2)  : (ext_addr0_d ? dout1 : dout0);  
  
assign dout_a = ram_raddr0_a_d ? dout1 : dout0;
assign dout_b = ram_raddr0_b_d ? dout3 : dout2;
  
/* FFT RAM signal begin */  

wire [31:0] ram_din0;
wire [31:0] ram_din1;
wire [31:0] ram_din2;
wire [31:0] ram_din3;
wire [31:0] din0_f;
wire [31:0] din1_f;
wire [31:0] din0_fft;
wire [31:0] din1_fft;
wire progress_fft;


assign din0_fft = progress_fft ? din0_f : ext_din;
assign din1_fft = progress_fft ? din1_f : ext_din;


assign ram_din0=func_sel ? din0_fft : din0;  //
assign ram_din1=func_sel ? din1_fft : din1;
assign ram_din2=func_sel ? din0_fft : din2;
assign ram_din3=func_sel ? din1_fft : din3;

wire ram_we0;
wire ram_we1;
wire ram_we2;
wire ram_we3;
wire ram_we0_f;
wire ram_we1_f;
wire ram_we2_f;
wire ram_we3_f;

assign ram_we0=func_sel ? ram_we0_f : we0;  //
assign ram_we1=func_sel ? ram_we1_f : we1;  
assign ram_we2=func_sel ? ram_we2_f : we2;
assign ram_we3=func_sel ? ram_we3_f : we3;

wire [7:0] ram_waddr0;
wire [7:0] ram_waddr1;
wire [7:0] ram_waddr2;
wire [7:0] ram_waddr3;

wire [7:0] ram_raddr0;
wire [7:0] ram_raddr1;
wire [7:0] ram_raddr2;
wire [7:0] ram_raddr3;

wire [31:0] ram_dout0;
wire [31:0] ram_dout1;
wire [31:0] ram_dout2;
wire [31:0] ram_dout3;

wire [8:0] waddr0_f;
wire [8:0] waddr1_f;
wire [8:0] raddr0_f;
wire [8:0] raddr1_f;

wire [7:0] waddr0_fft;
wire [7:0] waddr1_fft;
wire [7:0] waddr2_fft;
wire [7:0] waddr3_fft;

wire [7:0] raddr0_fft;
wire [7:0] raddr1_fft;
wire [7:0] raddr2_fft;
wire [7:0] raddr3_fft;


wire we0_f;
wire we1_f;
wire [31:0] dout0_f;
wire [31:0] dout1_f;

wire debug_w05b= ~waddr0_f[5];
wire debug_w15b= ~waddr1_f[5];
wire debug_wf05b= (tabidx ? ~waddr0_f[8] : ~waddr0_f[5]);
wire debug_wf15b= (tabidx ? ~waddr1_f[8] : ~waddr1_f[5]);



assign ram_we0_f= progress_fft ? ( (tabidx ? ~waddr0_f[8] : ~waddr0_f[5]) & we0_f) : (ext_we & ~ext_addr[0] & (tabidx ? ~ext_addr[9] : ~ext_addr[6]) );
assign ram_we1_f= progress_fft ? ( (tabidx ? ~waddr1_f[8] : ~waddr1_f[5]) & we1_f) : (ext_we & ext_addr[0] & (tabidx ? ~ext_addr[9] : ~ext_addr[6]) );
assign ram_we2_f= progress_fft ? ( (tabidx ? waddr0_f[8] : waddr0_f[5]) & we0_f) : (ext_we & ~ext_addr[0] & (tabidx ? ext_addr[9] : ext_addr[6]) ) ;
assign ram_we3_f= progress_fft ? ( (tabidx ? waddr1_f[8] : waddr1_f[5]) & we1_f) : (ext_we & ext_addr[0] & (tabidx ? ext_addr[9] : ext_addr[6]) ) ;

assign waddr0_fft=progress_fft ? (tabidx ? waddr0_f[7:0] : {3'h0,waddr0_f[4:0]}) : (tabidx ? ext_addr[8:1] : {3'h0,ext_addr[5:1]}) ;
assign waddr1_fft=progress_fft ? (tabidx ? waddr1_f[7:0] : {3'h0,waddr1_f[4:0]}) : (tabidx ? ext_addr[8:1] : {3'h0,ext_addr[5:1]}) ;
assign waddr2_fft=progress_fft ? (tabidx ? waddr0_f[7:0] : {3'h0,waddr0_f[4:0]}) : (tabidx ? ext_addr[8:1] : {3'h0,ext_addr[5:1]}) ;
assign waddr3_fft=progress_fft ? (tabidx ? waddr1_f[7:0] : {3'h0,waddr1_f[4:0]}) : (tabidx ? ext_addr[8:1] : {3'h0,ext_addr[5:1]}) ;

assign raddr0_fft=progress_fft ? (tabidx ? raddr0_f[7:0] : {3'h0,raddr0_f[4:0]}) : (tabidx ? ext_addr[8:1] : {3'h0,ext_addr[5:1]}) ;
assign raddr1_fft=progress_fft ? (tabidx ? raddr1_f[7:0] : {3'h0,raddr1_f[4:0]}) : (tabidx ? ext_addr[8:1] : {3'h0,ext_addr[5:1]}) ;
assign raddr2_fft=progress_fft ? (tabidx ? raddr0_f[7:0] : {3'h0,raddr0_f[4:0]}) : (tabidx ? ext_addr[8:1] : {3'h0,ext_addr[5:1]}) ;
assign raddr3_fft=progress_fft ? (tabidx ? raddr1_f[7:0] : {3'h0,raddr1_f[4:0]}) : (tabidx ? ext_addr[8:1] : {3'h0,ext_addr[5:1]}) ;



assign ram_waddr0=func_sel ? waddr0_fft[7:0] : waddr0;
assign ram_waddr1=func_sel ? waddr1_fft[7:0] : waddr1;
assign ram_waddr2=func_sel ? waddr2_fft[7:0] : waddr2;
assign ram_waddr3=func_sel ? waddr3_fft[7:0] : waddr3;

assign ram_raddr0=func_sel ? raddr0_fft[7:0] : raddr0;
assign ram_raddr1=func_sel ? raddr1_fft[7:0] : raddr1;
assign ram_raddr2=func_sel ? raddr2_fft[7:0] : raddr2;
assign ram_raddr3=func_sel ? raddr3_fft[7:0] : raddr3;

assign dout0_f= ~raddr0_f8_d ? dout0 : dout2;
assign dout1_f= ~raddr1_f8_d ? dout1 : dout3;

/* FFT RAM signal end */  
  
always @(negedge rst_n or posedge clk)
  if (~rst_n)
  begin
    ext_addr9_d <= 1'b0;
    ext_addr0_d <= 1'b0;
    ram_raddr0_a_d <= 1'b0;
    ram_raddr0_b_d <= 1'b0;  
    raddr0_f8_d<=1'b0;  
    raddr1_f8_d<=1'b0;  
  end
  else
  begin
    if(ram_en|progress)
    begin
    //ext_addr9_d <= tabidx ? ext_addr[9] : ext_addr[6];
    //ext_addr9_d <= (func_sel ? 1'b1 : tabidx ) ? ext_addr[9] : ext_addr[6];
    ext_addr9_d <= (func_sel ? tabidx : tabidx ) ? ext_addr[9] : ext_addr[6];
    ext_addr0_d <= ext_addr[0];
    ram_raddr0_a_d <= ram_raddr_a[0];
    ram_raddr0_b_d <= ram_raddr_b[0];    
    raddr0_f8_d<=(tabidx ? raddr0_f[8] : raddr0_f[5]);  
    raddr1_f8_d<=(tabidx ? raddr1_f[8] : raddr1_f[5]);  
    end
    
  end
      	
  
  
ram256x32 ram_0(
.clk(clk),
.din(ram_din0),
.we(ram_we0),
.waddr(ram_waddr0),
.raddr(ram_raddr0),
.en(ram_en|progress),

.dout(dout0)
);  

ram256x32 ram_1(
.clk(clk),
.din(ram_din1),
.we(ram_we1),
.waddr(ram_waddr1),
.raddr(ram_raddr1),
.en(ram_en|progress),

.dout(dout1)
);  
  
ram256x32 ram_2(
.clk(clk),
.din(ram_din2),
.we(ram_we2),
.waddr(ram_waddr2),
.raddr(ram_raddr2),
.en(ram_en|progress),

.dout(dout2)
);  

ram256x32 ram_3(
.clk(clk),
.din(ram_din3),
.we(ram_we3),
.waddr(ram_waddr3),
.raddr(ram_raddr3),
.en(ram_en|progress),

.dout(dout3)
);  
  
wire imdct_tabidx  = auto ? auto_tabidx : tabidx;
wire imdct_mode  = auto ? auto_mode : mode;
wire imdct_start = auto ? (auto_imdct_start1|auto_imdct_start2) : (~func_sel & start) ;
wire fft_start = auto ? (auto_fft_start) : (func_sel & start) ;

  
imdct imdct(
.rst_n(rst_n),
.clk(clk),
.tabidx(imdct_tabidx),
.mode(imdct_mode),
.start(imdct_start),
.es(es),
.dout_a(dout_a),
.dout_b(dout_b),

.ram_we_a(ram_we_a),
.ram_we_b(ram_we_b),
.ram_raddr_a(ram_raddr_a),
.ram_waddr_a(ram_waddr_a),

.ram_raddr_b(ram_raddr_b),
.ram_waddr_b(ram_waddr_b),

.din_a(din_a),
.din_b(din_b),

.done(done_imdct),
.progress(progress_imdct)
);

//wire bit_rev_output=1'b0;
wire bit_rev_output=1'b1;

r4r8_1st_pass_core fft (
.rst_n(rst_n),
.clk(clk),
.mode(imdct_tabidx),
.start(fft_start),
.dout_0(dout0_f),
.dout_1(dout1_f),
.bit_rev_output(auto ? 1'b1 : bit_rev_output ),
.ram_we_0(we0_f),
.ram_we_1(we1_f),
.ram_raddr_0(raddr0_f),
.ram_waddr_0(waddr0_f),
.ram_raddr_1(raddr1_f),
.ram_waddr_1(waddr1_f),
.din_0(din0_f),
.din_1(din1_f),
.done(done_fft),
.progress(progress_fft)
);

assign done = auto_progress ? (auto_progress & auto_mode & done_imdct) : (func_sel ? done_fft : done_imdct);
assign progress = auto_progress | (func_sel ? progress_fft : progress_imdct) ;





always @(negedge rst_n or posedge clk)
  if (~rst_n)
  begin
	auto_imdct_start1<=0;
	auto_imdct_start2<=0;
	auto_fft_start<=0;
	auto_progress<=0;
	auto_mode<=0;
	auto_tabidx<=0;
	auto_func_sel<=0;
  end
  else
  begin
	auto_imdct_start1 <= (start & auto & ~auto_progress & ~progress_fft & ~progress_imdct);
	auto_fft_start<=(auto_progress & ~auto_mode & done_imdct);
	auto_imdct_start2<=(auto_progress & done_fft);
	
	
	if(start & auto & ~auto_progress & ~progress_fft & ~progress_imdct)
	begin
		auto_progress<=1;
		auto_tabidx<=tabidx;
		auto_mode<=0;
		auto_func_sel<=0;
	end

	if(auto_progress & ~auto_mode & done_imdct)
	begin
		auto_func_sel<=1;
	end
	
	if(auto_progress & done_fft)
	begin
		auto_mode<=1;
		auto_func_sel<=0;
	end
  	
	if(auto_progress & auto_mode & done_imdct)
	begin
		auto_progress<=0;
	end
  end


endmodule
