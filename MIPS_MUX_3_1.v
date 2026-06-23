module MIPS_MUX_3_1( input [1:0]sel , input[31:0] a , input[31:0] b, input[31:0] c , output reg [31:0] out);
always@(*)
begin
case(sel)
2'b00:out <=a;
2'b01:out <=b;
2'b10:out <=c;
default:out<=32'hxxxxxxxx;
endcase
end
endmodule
