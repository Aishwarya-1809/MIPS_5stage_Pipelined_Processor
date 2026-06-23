module MIPS_ALU(
  input [31:0] A, B,
  input [3:0] ALUControl,
  output reg [31:0] result,
  output zero
);
  always @(*) begin
    case(ALUControl)
      4'b0010: result = A + B;
      4'b0110: result = A - B;
      4'b0000: result = A & B;
      4'b0001: result = A | B;
      4'b0111: result = (A < B) ? 1 : 0;
      default: result = 0;
    endcase
  end

  assign zero = (result == 0);
endmodule
