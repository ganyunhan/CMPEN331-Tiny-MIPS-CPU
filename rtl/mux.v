module mux(
     input  [32- 1: 0]  a0
    ,input  [32- 1: 0]  a1
    ,input              op
    ,output [32- 1: 0]  out
);

assign out = op ? a1 : a0;

endmodule

