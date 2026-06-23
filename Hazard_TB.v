module Hazard_TB;


    reg clk, reset;

  wire [4:0] rs, rt, rd;
  wire [5:0] opcode, funct;
  wire [3:0] ALUControl;
  wire RegWrite, ALUSrc, Branch, MemWrite, MemtoReg;
  wire [31:0] reg_val_rs, reg_val_rt, reg_val_rd;


  // Instantiate  top module 
  MIPS_Pipeline_Hazard uut (
     .clk(clk),
     .reset(reset),
     .rs(rs), .rt(rt), .rd(rd),
     .opcode(opcode), .funct(funct),
     .ALUControl(ALUControl),
     .RegWrite(RegWrite), .ALUSrc(ALUSrc), .Branch(Branch),
     .MemWrite(MemWrite), .MemtoReg(MemtoReg),
     .reg_val_rs(reg_val_rs),
     .reg_val_rt(reg_val_rt),
     .reg_val_rd(reg_val_rd)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns period
  end

  // Stimulus
  initial begin
    

    reset = 1;
    #12;
    reset = 0;

    // Run simulation for some cycles
    #2000;

    $finish;
  end
initial begin
$monitor("Time=%0t | R1=%d |, R2=%d | , R3=%d |, R4=%d | , R5=%d |R6=%d| PC=%h | Branch=%d| rsE=%d | rtE=%d | FwdA=%b | FwdB=%b | aluSrcA=%d | outB=%d | ALUSrcE=%b | ALUinB=%d | ALUResultM=%d | writeData=%d | ",
  $time,
  uut.regfile.regfile[1], 
            uut.regfile.regfile[2],
            uut.regfile.regfile[3], 
            uut.regfile.regfile[4], 
            uut.regfile.regfile[5], uut.regfile.regfile[6],uut.pc,uut.control.Branch,
  uut.id_ex.rsE, uut.id_ex.rtE,
  uut.hazard.ForwardAE, uut.hazard.ForwardBE,
  uut.alu.A, uut.muxB.out,
  uut.id_ex.ALUSrcE,
  uut.alu.B, //  this is after 2:1 mux into ALU B
  uut.ex_mem.ALUResultM, uut.regfile.writeData);


  end
endmodule
