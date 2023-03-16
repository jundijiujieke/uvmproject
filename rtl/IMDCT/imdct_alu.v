module imdct_alu(
input rst_n,
input clk,
input mode,
input [31:0] ar,
input [31:0] ai,
input [63:0] pre_romd,
input [63:0] post_romd,
input [4:0] es,
input ram_raddr_a0,

output reg [31:0] z1,
output reg [31:0] z2,
output reg [31:0] z1_d,
output reg [31:0] z2_d
);

reg [31:0] ai_d;
reg [31:0] cps2_d;
reg [31:0] sum;
reg [31:0] sin2a_d;
reg [31:0] ar_d;
reg [31:0] cms2;

wire [31:0] mul_1;
wire [31:0] mul_2;
wire [31:0] mul_t;

wire [31:0] cps2 = mode ? post_romd[63:32] : pre_romd[63:32];
wire [31:0] sin2a = mode ? post_romd[31:0] : pre_romd[31:0];

wire [31:0] ai_shift;
wire [31:0] post_ai_shift;
wire [31:0] ar_shift;

reg [31:0] pre_z1;
wire [31:0] z1_shift;

reg [31:0] pre_z2;
wire [31:0] z2_shift;
wire sign_z1_ok;
wire sign_z2_ok;

wire [4:0] pre_es;
wire [4:0] post_es;

wire [31:0] chk_z1_a;
wire [31:0] chk_z1_b;
wire [31:0] chk_z2_a;
wire [31:0] chk_z2_b;

// level 0
assign pre_es = mode ? 5'h0 : es;

barrel_shifter32_right barrel_shifter32_right0(
.din(ai),
.ctrl(pre_es),
.dout(ai_shift)
);

barrel_shifter32_right barrel_shifter32_right1(
.din(ar),
.ctrl(pre_es),
.dout(ar_shift)
);

// pre level 1 for postMultiplication
assign post_ai_shift = (mode & ram_raddr_a0) ? (~ai_shift + 1'b1) : ai_shift;

// level 1 
always @(negedge rst_n or posedge clk)
  if (~rst_n)
    ai_d <= 32'h0;
  else
    ai_d <= post_ai_shift;

always @(negedge rst_n or posedge clk)
  if (~rst_n)
    cps2_d <= 32'h0;
  else
    cps2_d <= cps2;

always @(negedge rst_n or posedge clk)
  if (~rst_n)
    sum <= 32'h0;
  else
    sum <= post_ai_shift + ar_shift;

always @(negedge rst_n or posedge clk)
  if (~rst_n)
    sin2a_d <= 32'h0;
  else
    sin2a_d <= sin2a;
    
always @(negedge rst_n or posedge clk)
  if (~rst_n)
    ar_d <= 32'h0;
  else
    ar_d <= ar_shift;

always @(negedge rst_n or posedge clk)
  if (~rst_n)
    cms2 <= 32'h0;
  else
    cms2 <= cps2 - {sin2a[30:0], 1'b0};

// level 2
mul_shift32 mul1(
.rst_n(rst_n),
.clk(clk),
.in1(ar_d), 
.in2(cms2),
.out(mul_1)
);

mul_shift32 mul2(
.rst_n(rst_n),
.clk(clk),
.in1(ai_d), 
.in2(cps2_d),
.out(mul_2)
);

mul_shift32 mult(
.rst_n(rst_n),
.clk(clk),
.in1(sum), 
.in2(sin2a_d),
.out(mul_t)
);

// level 3

always @(negedge rst_n or posedge clk)
  if (~rst_n)
    pre_z2 <= 32'h0;
  else
    pre_z2 <= mode ? (mul_t - mul_2) : (mul_2 - mul_t);

always @(negedge rst_n or posedge clk)
  if (~rst_n)
    pre_z1 <= 32'h0;
  else
    pre_z1 <= mul_1 + mul_t;

// level 4
assign post_es = mode ? es : 5'h0;

barrel_shifter32_left barrel_shifter32_left0(
.din(pre_z1),
.ctrl(post_es),
.dout(z1_shift)
);

barrel_shifter32_left barrel_shifter32_left1(
.din(pre_z2),
.ctrl(post_es),
.dout(z2_shift)
);

assign chk_z1_a = {32{pre_z1[31]}};


barrel_shifter32_right barrel_shift32_right3(
.din(pre_z1),
.ctrl((5'h1e - post_es)),
.dout(chk_z1_b)
);

assign  sign_z1_ok = (((chk_z1_a == chk_z1_b) ? 1'b1 : 1'b0)) | ~mode; 

//assign sign_z1_ok = ~(pre_z1[31] ^ z1_shift[31]) & ~(pre_z1[30] ^ z1_shift[30]);

always @(*)
  casex ({sign_z1_ok, pre_z1[31]})
    2'b1x:   z1 = z1_shift;
    2'b00:   z1 = 32'h3fffffff;
    default: z1 = 32'hc0000000;
  endcase

assign chk_z2_a = {32{pre_z2[31]}};


barrel_shifter32_right barrel_shift32_right4(
.din(pre_z2),
.ctrl((5'h1e - post_es)),
.dout(chk_z2_b)
);

assign  sign_z2_ok = ((chk_z2_a == chk_z2_b) ? 1'b1 : 1'b0) | ~mode; 
   
//assign sign_z2_ok = ~(pre_z2[31] ^ z2_shift[31]) & ~(pre_z2[30] ^ z2_shift[30]);

always @(*)
  casex ({sign_z2_ok, pre_z2[31]})
    2'b1x:   z2 = z2_shift;
    2'b00:   z2 = 32'h3fffffff;
    default: z2 = 32'hc0000000;
  endcase

always @(negedge rst_n or posedge clk)
  if (~rst_n)
    z2_d <= 32'h0;
  else
    z2_d <= z2;

always @(negedge rst_n or posedge clk)
  if (~rst_n)
    z1_d <= 32'h0;
  else
    z1_d <= z1;

endmodule
