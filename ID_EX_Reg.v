module ID_EX_Reg(
  input clk, input rst,input clr,
  input [31:0] readData1D, readData2D, 
 
  input RegDstD, ALUSrcD, MemtoRegD, RegWriteD, MemReadD, MemWriteD, BranchD,
  input [4:0] rtD, rdD, rsD ,
  input [3:0] ALUControlD,
  input [31:0] signImmD, 

  output reg [31:0] readData1E, readData2E, signImmE,
         // NEW: pipelined shifted immediate to EX stage
  output reg RegDstE, ALUSrcE, MemtoRegE, RegWriteE, MemReadE, MemWriteE, BranchE,
  output reg [4:0] rtE, rdE, rsE,
  output reg [3:0] ALUControlE
  
);


always @(posedge clk or posedge rst) begin
  if(rst) begin
    RegDstE <= 0; 
    ALUSrcE <= 0;
    MemtoRegE <= 0;
    RegWriteE <= 0;
    MemReadE <= 0;
    MemWriteE <= 0; 
    BranchE <= 0; 
    ALUControlE <= 0;
    rtE <= 0;
    rdE <= 0;
    rsE <= 0;
    signImmE <= 0; 
    readData1E <= 0; 
    readData2E <= 0;
   
    
  end 
  else if(clr) begin
     
    // Flush control signals only
     RegDstE <= 0; 
      ALUSrcE <= 0;
      MemtoRegE <= 0;
      RegWriteE <= 0;
      MemReadE <= 0;
      MemWriteE <= 0; 
      BranchE <= 0; 
      ALUControlE <= 0;
    // Data path can remain (don’t care)
  

    end 
  else  begin
    RegDstE <= RegDstD;
    ALUSrcE <= ALUSrcD; 
    MemtoRegE <= MemtoRegD; 
    RegWriteE <= RegWriteD;
    MemReadE <= MemReadD;
    MemWriteE <= MemWriteD;
    BranchE <= BranchD; 
    ALUControlE <= ALUControlD;
    rtE <= rtD;
    rdE <= rdD;
    rsE <= rsD;
    signImmE <= signImmD;
    readData1E <= readData1D;
    readData2E <= readData2D;
    
  end
end
endmodule

