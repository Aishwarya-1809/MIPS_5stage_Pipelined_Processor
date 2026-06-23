module IF_ID_Reg(
  input clk, input rst,input en,clr,
  input [31:0] pc_plus4F, input [31:0] instr_in,
  output reg [31:0] pc_plus4D, output reg [31:0] instr_out
);
always @(posedge clk or posedge rst) begin
  if(rst) begin
    pc_plus4D <= 0;
    instr_out <= 0;
  end
   else if(clr) begin
     pc_plus4D <= 0;
     instr_out <= 0;
   end 
   
       else if(en) begin
    pc_plus4D <= pc_plus4F;
    instr_out <= instr_in;
  end
   
end
endmodule
