module MIPS_MUX(input sel,input [31:0] a, input [31:0]b,output [31:0]y );
assign y=sel?b:a;
endmodule
