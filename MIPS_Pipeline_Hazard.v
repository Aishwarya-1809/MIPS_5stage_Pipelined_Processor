module MIPS_Pipeline_Hazard (
    input clk,
    input reset,
    output [4:0] rs, rt, rd,
    output [5:0] opcode, funct,
    output [3:0] ALUControl,
    output RegWrite, ALUSrc, Branch, MemWrite, MemtoReg,
    output [31:0] reg_val_rs, reg_val_rt, reg_val_rd
);

    wire [31:0] pc, next_pc, pc_plus4, instr;
    wire [31:0] readData1, readData2, writeData;
    wire [31:0] aluSrcB,aluSrcA, aluResult , memReadData ,shiftedImm, PCBranchD;
    wire  pcSrc, RegDst, MemRead,BranchD;
    wire [4:0] writeReg;
    wire [31:0] pc_plus4D ;
    wire [31:0] instr_out;
    wire [31:0] readData1E, readData2E, signImmE ,signImmD, outB;
    wire RegDstE, ALUSrcE, MemtoRegE, RegWriteE, MemReadE, MemWriteE;
    wire [4:0] rtE, rdE ,rsE;
    wire [3:0] ALUControlE;
    wire [31:0] ALUResultM, WriteDataM;
    wire [4:0] WriteRegM, WriteRegE;
    wire RegWriteM, MemtoRegM, MemWriteM, MemReadM; 
    wire [31:0] ReadDataW, ALUResultW;
    wire [4:0] WriteRegW;
    wire RegWriteW, MemtoRegW ;
    wire [1:0] ForwardAE,ForwardBE,ForwardAD,ForwardBD;
    wire StallF, StallD, FlushE;
    wire PCWrite;
    wire en;
    wire clr;
    wire [31:0] RD1 , RD2;  
   wire branch_flush;
    assign reg_val_rs = readData1;
    assign reg_val_rt = readData2;
    assign reg_val_rd = writeData;
    
    assign en= ~StallD;
    assign clr = FlushE ;
       
       MIPS_MUX pc_mux (  
           .sel(pcSrc),
           .a(pc_plus4),
           .b(PCBranchD),
           .y(next_pc)
       );

 MIPS_PC pc_reg (.clk(clk), .reset(reset), .next_pc(next_pc), .pc(pc) ,.en(PCWrite));
 assign PCWrite = ~StallF;
 
 MIPS_PCadder adderIF (.pc(pc), .next_pc(pc_plus4));
 
 MIPS_InstrMemory imem (.addr(pc), .instr(instr));
 
  MIPS_ControlUnit control (
        .opcode(instr_out[31:26]),
        .funct(instr_out[5:0]),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ALUControl(ALUControl)
    );
assign BranchD = Branch;
 IF_ID_Reg if_id (
       .clk(clk), .rst(reset),
       .pc_plus4F(pc_plus4),.clr(pcSrc),
       .instr_in(instr),
       .pc_plus4D(pc_plus4D),
       .instr_out(instr_out),.en(en)
   );
   
    MIPS_RegisterFile regfile (
          .clk(clk),
          .regWrite(RegWriteW),  // WE // WB stage writes back!
          .rs(instr_out[25:21]), // A1
          .rt(instr_out[20:16]), //A2
          .rd(WriteRegW), //A3
          .writeData(writeData), //WD
          .readData1(readData1), // RD1
          .readData2(readData2) //RD2
      );
     assign rs = instr_out[25:21];
         assign rt = instr_out[20:16];
         assign rd  = instr_out[15:11];
         assign opcode = instr_out[31:26];
         assign funct  = instr_out[5:0];
         
    MIPS_SignExtend signext (.imm(instr_out[15:0]), .signExtImm(signImmD));
     
      assign shiftedImm = signImmD << 2;
    
      assign PCBranchD = pc_plus4D + shiftedImm;
      
      MIPS_MUX RD1_mux (.sel(ForwardAD),
              .a(readData1),
              .b(ALUResultM),
              .y(RD1));
       
      MIPS_MUX RD2_mux (.sel(ForwardBD),
                      .a(readData2),
                      .b(ALUResultM),
                      .y(RD2));

      assign pcSrc = BranchD & (RD1==RD2);
  
  
 ID_EX_Reg id_ex (
                .clk(clk), .rst(reset),
                .readData1D(readData1), .readData2D(readData2),
                
        
                .RegDstD(RegDst), .ALUSrcD(ALUSrc), .MemtoRegD(MemtoReg),
                .RegWriteD(RegWrite), .MemReadD(MemRead), .MemWriteD(MemWrite), //.BranchD(Branch),
        
                .rtD(instr_out[20:16]), .rdD(instr_out[15:11]),
                .signImmE(signImmE), .ALUControlD(ALUControl),
        
                .readData1E(readData1E), .readData2E(readData2E),
               
        
                .RegDstE(RegDstE), .ALUSrcE(ALUSrcE), .MemtoRegE(MemtoRegE),
                .RegWriteE(RegWriteE), .MemReadE(MemReadE), .MemWriteE(MemWriteE),
                 .rtE(rtE), .rdE(rdE), .ALUControlE(ALUControlE),
                .rsE(rsE) ,.rsD(instr_out[25:21]), .signImmD(signImmD) ,.clr(clr)
            );
     
     // ID/EX WriteReg MUX
                MIPS_MUX ID_EX_mux2 (
                    .sel(RegDstE),
                    .a(rtE),
                    .b(rdE),
                    .y(WriteRegE)
                ); 
   
    //Forwarding 3:1 mux for srcA and srcB
    MIPS_MUX_3_1 muxA (.sel(ForwardAE), .a(readData1E),.b(writeData),.c(ALUResultM),.out(aluSrcA));
               
    MIPS_MUX_3_1 muxB (.sel(ForwardBE) , .a(readData2E),.b(writeData),.c(ALUResultM),.out(outB));
                
   // ID/EX ALU SrcB MUX //assign aluSrcB = (ALUSrcE) ?  outB :signImmE ;
     MIPS_MUX ID_EX_mux1 (
           .sel(ALUSrcE),
           .a(outB),
           .b(signImmE),
           .y(aluSrcB)
       );

   
    MIPS_ALU alu (
        .A(aluSrcA),
        .B(aluSrcB),
        .ALUControl(ALUControlE),
        .result (aluResult)
    );
    
      EX_MEM_Reg ex_mem (
         .clk(clk), .rst(reset),
         .RegWriteE(RegWriteE), .MemtoRegE(MemtoRegE),
         .MemWriteE(MemWriteE), .MemReadE(MemReadE),
         .ALUResultE(aluResult), .WriteDataE(outB),
         .WriteRegE(WriteRegE),
         .ALUResultM(ALUResultM), .WriteDataM(WriteDataM),
         .WriteRegM(WriteRegM), .RegWriteM(RegWriteM),
         .MemtoRegM(MemtoRegM), .MemWriteM(MemWriteM), .MemReadM(MemReadM) );

    
   
    MIPS_DataMemory dmem (
        .clk(clk),
        .memRead(MemReadM),
        .memWrite(MemWriteM),//WE
        .addr(ALUResultM), //A
        .writeData(WriteDataM),//WD
        .readData(memReadData) //RD
    );

      MEM_WB_Reg mem_wb (
        .clk(clk), .rst(reset),
        .ALUResultM(ALUResultM), .ReadDataM(memReadData),
        .WriteRegM(WriteRegM),
        .RegWriteM(RegWriteM), .MemtoRegM(MemtoRegM),
        .ReadDataW(ReadDataW), .ALUResultW(ALUResultW),
        .WriteRegW(WriteRegW), .RegWriteW(RegWriteW), .MemtoRegW(MemtoRegW)
    );
    
     
      // MEM/WB MUX  //assign writeData = MemtoRegW ? ReadDataW : ALUOutW;
      MIPS_MUX mem_wb_mux (
          .sel(MemtoRegW),
          .b(ReadDataW),      // Data Memory output
          .a(ALUResultW),     // ALU output
          .y(writeData)
      );


Hazard_Unit hazard (
    .rsE(rsE), .rtE(rtE),
    .WriteRegM(WriteRegM), .WriteRegW(WriteRegW),
    .RegWriteM(RegWriteM), .RegWriteW(RegWriteW),
    .ForwardAE(ForwardAE), .ForwardBE(ForwardBE),.ForwardAD(ForwardAD),.ForwardBD(ForwardBD),
    .MemtoRegE(MemtoRegE),.rsD(rs),.rtD(rt) ,.StallF(StallF), 
    .StallD(StallD), .FlushE(FlushE),.BranchD(Branch)
);


endmodule
