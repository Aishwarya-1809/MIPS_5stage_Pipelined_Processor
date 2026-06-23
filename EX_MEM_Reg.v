module EX_MEM_Reg(
  input clk, input rst,
  input RegWriteE, MemtoRegE, MemWriteE, MemReadE,
  input [31:0] ALUResultE , input [31:0] WriteDataE,
  input [4:0] WriteRegE,
  output reg [31:0] ALUResultM, WriteDataM,
  output reg [4:0] WriteRegM,
  output reg RegWriteM, MemtoRegM, MemWriteM, MemReadM 
);
always @(posedge clk or posedge rst) begin
  if(rst) begin
    ALUResultM <= 0; WriteDataM <= 0; WriteRegM <= 0;
    RegWriteM <= 0; MemtoRegM <= 0; MemWriteM <= 0; MemReadM <= 0;
  end else begin
    ALUResultM <= ALUResultE; WriteDataM <= WriteDataE; WriteRegM <= WriteRegE;
    RegWriteM <= RegWriteE; MemtoRegM <= MemtoRegE; MemWriteM <= MemWriteE; MemReadM <= MemReadE;
    end
end

endmodule
