module ext(
     input      [16- 1: 0]  imm16
    ,input                  sext
    ,output     [32- 1: 0]  imm32
);
  
  assign imm32 = sext ? {{16{imm16[15]}},imm16} //sext == 1 : SIGN
                        : {16'b0,imm16};        //sext == 0 : ZERO

endmodule

