module alu
(    input      [32- 1: 0]  a
    ,input      [32- 1: 0]  b
    ,input      [4 - 1: 0]  aluc
    ,output     [32- 1: 0]  zero
    ,output reg [32- 1: 0]  alu_out
);

//a : sa or regfile
//b : imm or regfile

  //set param 
  parameter ADD=4'b0000;
  parameter SUB=4'b0100;
  parameter AND=4'b0001;
  parameter OR =4'b0101;
  parameter XOR=4'b0010;
  parameter LUI=4'b0110;
  parameter SLL=4'b0011;
  parameter SRL=4'b0111;
  parameter EQU=4'b1000;
  parameter NEQ=4'b1001;
  parameter SRA=4'b1111;

  always@(*)
  begin
    case (aluc)
      ADD:begin
        alu_out = a + b;
      end
      SUB:begin
        alu_out = a - b;
      end
      AND:begin 
        alu_out = a & b;
      end
      OR :begin
        alu_out = a | b;
      end
      XOR:begin
        alu_out = a ^ b;
      end
      LUI:begin
        alu_out = {{b[16- 1: 0]},{16{1'b0}}};
      end
      SLL:begin
        alu_out = b << a;
      end
      SRL:begin
        alu_out = b >> a;
      end
      SRA:begin
        alu_out = b >>> a;
      end
      EQU:begin
        alu_out = (b == a) ? 1'b1 : 1'b0;
      end
      NEQ:begin
        alu_out = (b == a) ? 1'b0 : 1'b1;
      end
      default : alu_out = 0;
    endcase
  end

  assign zero = ((aluc == EQU) || (aluc == NEQ)) ? alu_out : 32'hffff_ffff;

endmodule

