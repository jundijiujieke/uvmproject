module imdct(
input rst_n,
input clk,
input tabidx,
input mode,   // pre = 0, post = 1
input start,
input [4:0] es,
input [31:0] dout_a,
input [31:0] dout_b,

output wire ram_we_a,
output wire ram_we_b,
output wire [8:0] ram_raddr_a,
output wire [8:0] ram_waddr_a,

output wire [8:0] ram_raddr_b,
output wire [8:0] ram_waddr_b,

output wire [31:0] din_a,
output wire [31:0] din_b,

output wire done,
output wire progress
);

wire [63:0] pre_romd;
wire [63:0] post_romd;
wire [9:0] pre_rom_addr;
wire [8:0] post_rom_addr;
wire [31:0] z1;
wire [31:0] z2;
wire [31:0] z1_d;
wire [31:0] z2_d;

wire [31:0] ar;
wire [31:0] ai;

reg [31:0] dout_a_d;
reg [31:0] dout_b_d;

always @(negedge rst_n or posedge clk)
  if (~rst_n)
    dout_a_d <= 32'h0;
  else
    dout_a_d <= dout_a;
    
always @(negedge rst_n or posedge clk)
  if (~rst_n)
    dout_b_d <= 32'h0;
  else
    dout_b_d <= dout_b;
    
assign din_a = mode ? z1 : (ram_waddr_a[0] ? z2_d : z1);
assign din_b = mode ? z2 : (ram_waddr_b[0] ? z2 : z1_d);

assign ar = mode ? (~ram_raddr_a[0] ? dout_a_d : dout_b) : (ram_raddr_a[0] ? dout_a : dout_b);
assign ai = mode ? (~ram_raddr_a[0] ? dout_a : dout_b_d ) : (ram_raddr_a[0] ? dout_b : dout_a);

imdct_alu imdct_alu(
.rst_n(rst_n),
.clk(clk),
.mode(mode),
.ar(ar),
.ai(ai),
.pre_romd(pre_romd),
.post_romd(post_romd),
.es(es),
.ram_raddr_a0(ram_raddr_a[0]),

.z1(z1),
.z2(z2),
.z1_d(z1_d),
.z2_d(z2_d)
);

imdct_state imdct_state(
.rst_n(rst_n),
.clk(clk),
.start(start),
.tabidx(tabidx),
.mode(mode),

.ram_raddr_a(ram_raddr_a),
.ram_raddr_b(ram_raddr_b),
.ram_waddr_a(ram_waddr_a),
.ram_waddr_b(ram_waddr_b),
.ram_we_a(ram_we_a),
.ram_we_b(ram_we_b),
.pre_rom_addr(pre_rom_addr),
.post_rom_addr(post_rom_addr),
.done(done),
.progress(progress)
);

imdct_rom576x64 imdct_rom576x64(
.clk(clk),
.addr(pre_rom_addr),
.en(1'b1),

.dout(pre_romd)
);

imdct_rom257x64 imdct_rom257x64(
.clk(clk),
.addr(post_rom_addr),
.en(1'b1),

.dout(post_romd)
);

endmodule
