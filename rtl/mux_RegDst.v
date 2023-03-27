module mux_RegDst
(   
     input  [5 - 1: 0]  rt
    ,input  [5 - 1: 0]  rd
    ,input              regrt
    ,output [5 - 1: 0]  regdst
);

assign regdst = regrt ? rt : rd ;

endmodule

