module imdct_state(
input rst_n,
input clk,
input start,
input tabidx,
input mode,

output wire [8:0] ram_raddr_a,
output wire [8:0] ram_raddr_b,
output wire [8:0] ram_waddr_a,
output wire [8:0] ram_waddr_b,
output wire ram_we_a,
output wire ram_we_b,
output wire [9:0] pre_rom_addr,
output reg  [8:0] post_rom_addr,
output wire done,
output wire progress
);

reg [9:0] state_in;
reg [9:0] state;

always @(*)
  case(state)
    10'h000: state_in = start ? 10'h1 : 10'h0;
    10'h045: state_in = tabidx ? 10'h46 : 10'h0;
    10'h205: state_in = 10'h0;
    default: state_in = state + 10'h1;
  endcase

always @(negedge rst_n or posedge clk)
  if (~rst_n)
    state <= 10'h0;
  else
    state <= state_in;

assign ram_raddr_a = state - 1'h1;
assign ram_raddr_b = mode ? (tabidx ? (10'h201 - state) : (10'h41 - state)) : (tabidx ? (10'h200 - state) : (10'h40 - state));

assign ram_waddr_a = mode ? (state - 3'h6) : (state - 3'h5);
assign ram_waddr_b = tabidx ? (10'h205 - state) : (10'h45 - state);

assign ram_we_a = mode ? ram_we_b : ((state >= 10'h5) && (tabidx ? (state <= 10'h204) : (state <= 10'h44)) );
assign ram_we_b = (state >= 10'h6) && (tabidx ? (state <= 10'h205) : (state <= 10'h45) );

assign pre_rom_addr = tabidx ? (ram_raddr_a + 10'h40) : ram_raddr_a;

assign done = tabidx ? (state == 10'h205) : (state == 10'h45);

assign progress = (state > 0);

always @(negedge rst_n or posedge clk)
  if (~rst_n)
    post_rom_addr <= 8'h0;
  else if (start)
    post_rom_addr <= 8'h0;
  else if ((state[0] == 1'b0) && (state != 0) && (mode == 1))
    post_rom_addr <= post_rom_addr + (tabidx ? 8'h1 : 8'h8);
    

endmodule
