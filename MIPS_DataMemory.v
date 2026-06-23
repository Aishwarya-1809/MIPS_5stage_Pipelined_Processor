module MIPS_DataMemory (
  input clk,
  input memRead, memWrite,
  input [31:0] addr, writeData,
  output [31:0] readData
);
  reg [31:0] memory [0:255];

  assign readData = (memRead) ? memory[addr[9:2]] : 32'b0;


  always @(posedge clk)
    if (memWrite)
      memory[addr[9:2]] <= writeData;
endmodule

