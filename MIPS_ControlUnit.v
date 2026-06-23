module MIPS_ControlUnit (
    input [5:0] opcode,
    input [5:0] funct,
    output RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch,
    output [3:0] ALUControl
);

    wire [1:0] ALUOp;

    MainDecoder ins1 (
        .opcode(opcode),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    ALUDecoder ins2 (
        .ALUOp(ALUOp),
        .funct(funct),
        .ALUControl(ALUControl)
    );

endmodule


//  Main Decoder 
module MainDecoder(
    input [5:0] opcode,
    output reg RegDst,
    output reg ALUSrc,
    output reg MemtoReg,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    output reg [1:0] ALUOp
);
    always @(*) begin
        case(opcode)
            6'b000000: begin // R-type
                RegDst   = 1;
                ALUSrc   = 0;
                MemtoReg = 0;
                RegWrite = 1;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b10;
            end

            6'b100011: begin // lw
                RegDst   = 0;
                ALUSrc   = 1;
                MemtoReg = 1;
                RegWrite = 1;
                MemRead  = 1;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b00;
            end

            6'b101011: begin // sw
                RegDst   = 0; // don’t care
                ALUSrc   = 1;
                MemtoReg = 0; // don’t care
                RegWrite = 0;
                MemRead  = 0;
                MemWrite = 1;
                Branch   = 0;
                ALUOp    = 2'b00;
            end

            6'b000100: begin // beq
                RegDst   = 0; 
                ALUSrc   = 0;
                MemtoReg = 0; 
                RegWrite = 0;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 1;
                ALUOp    = 2'b01;
            end

            6'b001000: begin // addi
                RegDst   = 0;
                ALUSrc   = 1;
                MemtoReg = 0;
                RegWrite = 1;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b00; // add
            end

            default: begin // Safe defaults (NOP)
                RegDst   = 0;
                ALUSrc   = 0;
                MemtoReg = 0;
                RegWrite = 0;
                MemRead  = 0;
                MemWrite = 0;
                Branch   = 0;
                ALUOp    = 2'b00; // avoid x
            end
        endcase
    end
endmodule


// ALU Decoder 
module ALUDecoder(
    input [1:0] ALUOp,
    input [5:0] funct,
    output reg [3:0] ALUControl
);
    always @(*) begin
        case(ALUOp)
            2'b00: ALUControl = 4'b0010; // add (lw/sw/addi)
            2'b01: ALUControl = 4'b0110; // sub (beq)
            2'b10: begin
                case(funct)
                    6'b100000: ALUControl = 4'b0010; // add
                    6'b100010: ALUControl = 4'b0110; // sub
                    6'b100100: ALUControl = 4'b0000; // and
                    6'b100101: ALUControl = 4'b0001; // or
                    6'b101010: ALUControl = 4'b0111; // slt
                    default:   ALUControl = 4'b0010; // safe default = add
                endcase
            end
            default: ALUControl = 4'b0010; // safe default = add
        endcase
    end
endmodule



