module rom_rev240(
clk,
en,
addr,

dout
);

input clk;
input en;
input [7:0] addr;
output reg [8:0] dout;

reg [8:0] mem[0:239]={ 

9'h001,
9'h002,
9'h003,
9'h004,
9'h005,
9'h006,
9'h007,
9'h008,
9'h009,
9'h00a,
9'h00b,
9'h00c,
9'h00d,
9'h00e,
9'h00f,
9'h011,
9'h012,
9'h013,
9'h014,
9'h015,
9'h016,
9'h017,
9'h018,
9'h019,
9'h01a,
9'h01b,
9'h01c,
9'h01d,
9'h01e,
9'h01f,
9'h021,
9'h022,
9'h023,
9'h024,
9'h025,
9'h026,
9'h027,
9'h029,
9'h02a,
9'h02b,
9'h02c,
9'h02d,
9'h02e,
9'h02f,
9'h031,
9'h032,
9'h033,
9'h034,
9'h035,
9'h036,
9'h037,
9'h039,
9'h03a,
9'h03b,
9'h03c,
9'h03d,
9'h03e,
9'h03f,
9'h041,
9'h042,
9'h043,
9'h045,
9'h046,
9'h047,
9'h049,
9'h04a,
9'h04b,
9'h04c,
9'h04d,
9'h04e,
9'h04f,
9'h051,
9'h052,
9'h053,
9'h055,
9'h056,
9'h057,
9'h059,
9'h05a,
9'h05b,
9'h05c,
9'h05d,
9'h05e,
9'h05f,
9'h061,
9'h062,
9'h063,
9'h065,
9'h066,
9'h067,
9'h069,
9'h06a,
9'h06b,
9'h06d,
9'h06e,
9'h06f,
9'h071,
9'h072,
9'h073,
9'h075,
9'h076,
9'h077,
9'h079,
9'h07a,
9'h07b,
9'h07d,
9'h07e,
9'h07f,
9'h081,
9'h083,
9'h085,
9'h086,
9'h087,
9'h089,
9'h08a,
9'h08b,
9'h08d,
9'h08e,
9'h08f,
9'h091,
9'h093,
9'h095,
9'h096,
9'h097,
9'h099,
9'h09a,
9'h09b,
9'h09d,
9'h09e,
9'h09f,
9'h0a1,
9'h0a3,
9'h0a5,
9'h0a6,
9'h0a7,
9'h0a9,
9'h0ab,
9'h0ad,
9'h0ae,
9'h0af,
9'h0b1,
9'h0b3,
9'h0b5,
9'h0b6,
9'h0b7,
9'h0b9,
9'h0bb,
9'h0bd,
9'h0be,
9'h0bf,
9'h0c1,
9'h0c3,
9'h0c5,
9'h0c7,
9'h0c9,
9'h0cb,
9'h0cd,
9'h0ce,
9'h0cf,
9'h0d1,
9'h0d3,
9'h0d5,
9'h0d7,
9'h0d9,
9'h0db,
9'h0dd,
9'h0de,
9'h0df,
9'h0e1,
9'h0e3,
9'h0e5,
9'h0e7,
9'h0e9,
9'h0eb,
9'h0ed,
9'h0ef,
9'h0f1,
9'h0f3,
9'h0f5,
9'h0f7,
9'h0f9,
9'h0fb,
9'h0fd,
9'h0ff,
9'h103,
9'h105,
9'h107,
9'h109,
9'h10b,
9'h10d,
9'h10f,
9'h113,
9'h115,
9'h117,
9'h119,
9'h11b,
9'h11d,
9'h11f,
9'h123,
9'h125,
9'h127,
9'h12b,
9'h12d,
9'h12f,
9'h133,
9'h135,
9'h137,
9'h13b,
9'h13d,
9'h13f,
9'h143,
9'h147,
9'h14b,
9'h14d,
9'h14f,
9'h153,
9'h157,
9'h15b,
9'h15d,
9'h15f,
9'h163,
9'h167,
9'h16b,
9'h16f,
9'h173,
9'h177,
9'h17b,
9'h17f,
9'h187,
9'h18b,
9'h18f,
9'h197,
9'h19b,
9'h19f,
9'h1a7,
9'h1af,
9'h1b7,
9'h1bf,
9'h1cf,
9'h1df
};
always @(posedge clk) 
  if (en)
    dout <= mem[addr];

endmodule