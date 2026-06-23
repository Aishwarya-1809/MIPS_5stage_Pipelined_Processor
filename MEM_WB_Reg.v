module MEM_WB_Reg(
  input clk, rst,
  input [31:0] ALUResultM,  ReadDataM,
  input [4:0] WriteRegM,
  input RegWriteM, MemtoRegM,
  output reg [31:0] ReadDataW, ALUResultW,
  output reg [4:0] WriteRegW,
  output reg RegWriteW, MemtoRegW
);

always @(posedge clk or posedge rst) begin
  if(rst) begin
    ReadDataW <= 0; ALUResultW <= 0;  WriteRegW <= 0;
    RegWriteW <= 0; MemtoRegW <= 0;
  end else begin
    ReadDataW <= ReadDataM; ALUResultW <= ALUResultM;
    WriteRegW <= WriteRegM; RegWriteW <= RegWriteM; MemtoRegW <= MemtoRegM;
  end
end
endmodule
