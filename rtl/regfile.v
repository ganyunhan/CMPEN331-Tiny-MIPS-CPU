module regfile 
(
     input              clk
    ,input              rst_n
    ,input              we
    ,input  [5 - 1: 0]  wn
    ,input  [5 - 1: 0]  rna
    ,input  [5 - 1: 0]  rnb
    ,input  [32- 1: 0]  d 
    ,output [32- 1: 0]  qa
    ,output [32- 1: 0]  qb
);
  reg       [32- 1: 0]  register [1:31];
  
  integer i;
  always@(posedge clk or negedge rst_n)
  begin
    if (!rst_n) begin
      for(i = 0; i < 32; i = i + 1) begin
        register[i] <= 0;
      end
    end else if (we && (wn != 0)) begin
      register[wn] <= d;
    end
  end
    
  assign qa = (rna == 0) ? 0 : register[rna];
  assign qb = (rnb == 0) ? 0 : register[rnb];
 
endmodule

