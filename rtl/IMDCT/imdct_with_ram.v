module imdct_with_ram(
input rst_n,
input clk,
input [31:0] ext_din,
input ext_we,
input [9:0] ext_addr,
input start,
input tabidx,
input mode,
input [4:0] es,

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
wire [8:0] waddr0;
wire [8:0] raddr0;
wire [31:0] dout0;

wire [31:0] din1;
wire we1; 
wire [8:0] waddr1;
wire [8:0] raddr1;
wire [31:0] dout1;


reg ext_addr9_d;

assign din0   = ~progress ? ext_din  : din_a;
assign we0    = ~progress ? ext_we & (tabidx ? ~ext_addr[9] : ~ext_addr[6]) : ram_we_a;
assign waddr0 = ~progress ? (tabidx ? ext_addr[8:0] : {3'h0, ext_addr[5:0]}) : ram_waddr_a;
assign raddr0 = ~progress ? (tabidx ? ext_addr[8:0] : {3'h0, ext_addr[5:0]}) : ram_raddr_a;

assign din1 = ~progress ? ext_din : din_b;
assign we1  = ~progress ? ext_we & (tabidx ? ext_addr[9] : ext_addr[6]) : ram_we_b;
assign waddr1 = ~progress ? (tabidx ? ext_addr[8:0] : {3'h0, ext_addr[5:0]}) : ram_waddr_b;
assign raddr1 = ~progress ? (tabidx ? ext_addr[8:0] : {3'h0, ext_addr[5:0]}) : ram_raddr_b;

always @(negedge rst_n or posedge clk)
  if (~rst_n)
    ext_addr9_d <= 1'b0;
  else
    ext_addr9_d <= tabidx ? ext_addr[9] : ext_addr[6];
      	
assign dout = (ext_addr9_d) ? dout1 : dout0;  
  
assign dout_a = dout0;
assign dout_b = dout1;
  
ram512x32 ram512x32_0(
.clk(clk),
.din(din0),
.we(we0),
.waddr(waddr0),
.raddr(raddr0),
.en(1'b1),

.dout(dout0)
);  

ram512x32 ram512x32_1(
.clk(clk),
.din(din1),
.we(we1),
.waddr(waddr1),
.raddr(raddr1),
.en(1'b1),

.dout(dout1)
);  
  
imdct imdct(
.rst_n(rst_n),
.clk(clk),
.tabidx(tabidx),
.mode(mode),
.start(start),
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

.done(done),
.progress(progress)
);

endmodule
