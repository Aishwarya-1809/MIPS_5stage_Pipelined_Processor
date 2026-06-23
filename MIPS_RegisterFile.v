module MIPS_RegisterFile(
  input clk,
  input regWrite,
  input [4:0] rs, rt, rd,
  input [31:0] writeData,
  output [31:0] readData1, readData2
);
  reg [31:0] regfile[31:0];
 integer i;
  initial begin
     for (i = 0; i < 32; i = i + 1)
       regfile[i] = 0;
  end 


  assign readData1 = regfile[rs];
  assign readData2 = regfile[rt];

  always @(posedge clk)
    if (regWrite && rd != 0)
      regfile[rd] <= writeData;

endmodule
