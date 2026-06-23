module MIPS_SignExtend (input [15:0] imm, output [31:0] signExtImm);
  assign signExtImm = {{16{imm[15]}}, imm};
endmodule
