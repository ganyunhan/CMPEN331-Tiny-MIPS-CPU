module dm(
     input                      clk
    ,input                      rst_n
    ,input      [32- 1: 0]      Data_in
    ,input                      MemWr
    ,input      [32- 1: 0]      Addr
    ,output reg [32- 1: 0]      Data_out
);

  reg   [8 - 1: 0]DataMem[128- 1: 0];
  wire  [10- 1: 0]pointer;

  assign pointer = Addr[10- 1: 0];

  //reset
  integer i;
  always@(negedge rst_n or posedge clk)begin
    if (!rst_n) begin
      for(i = 0;i < 1024;i = i + 1) begin
          DataMem[i] <= 0;
      end
    end
  end
  
  always@(posedge clk)begin
    //sw
    if(MemWr == 1)begin
      DataMem[pointer]      <= Data_in[32- 1:24];
      DataMem[pointer + 1]  <= Data_in[24- 1:16];
      DataMem[pointer + 2]  <= Data_in[16- 1: 8];
      DataMem[pointer + 3]  <= Data_in[8 - 1: 0];
    end
  end
  
  always@(negedge clk)begin
    //lw
    if(MemWr == 0) begin
      Data_out <= {DataMem[pointer]
                  ,DataMem[pointer + 1]
                  ,DataMem[pointer + 2]
                  ,DataMem[pointer + 3]};
    end
  end
endmodule
    
    
  
