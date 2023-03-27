module mips(
     input      clk
    ,input      rst_n
);
 
  wire    [32- 1: 0]  instruction; 
  wire                jal; 
  wire                sext; 
  wire                regrt; 
  wire                m2reg; 
  wire                wreg; 
  wire                wmem; 
  wire                aluimm; 
  wire                alushift; 
  wire    [4 - 1: 0]  aluc; 
  wire    [2 - 1: 0]  pcsrc; 

  mips_ctrl       U_MIPS_CONTROL(
     .rst_n           (rst_n        ) //input                 
    ,.instruction     (instruction  ) //input      [32- 1: 0] 
    ,.jal             (jal          ) //output reg            
    ,.sext            (sext         ) //output reg            
    ,.regrt           (regrt        ) //output reg            
    ,.m2reg           (m2reg        ) //output reg            
    ,.wreg            (wreg         ) //output reg            
    ,.wmem            (wmem         ) //output reg            
    ,.aluimm          (aluimm       ) //output reg            
    ,.alushift        (alushift     ) //output reg            
    ,.aluc            (aluc         ) //output reg [4 - 1: 0] 
    ,.pcsrc           (pcsrc        ) //output reg [2 - 1: 0] 

  );
  
  mips_datapath   U_MIPS_DATAPATH(
     .clk             (clk          ) //input             
    ,.rst_n           (rst_n        ) //input             
    ,.jal             (jal          ) //input             
    ,.sext            (sext         ) //input             
    ,.regrt           (regrt        ) //input             
    ,.m2reg           (m2reg        ) //input             
    ,.wreg            (wreg         ) //input             
    ,.wmem            (wmem         ) //input             
    ,.aluimm          (aluimm       ) //input             
    ,.alushift        (alushift     ) //input             
    ,.aluc            (aluc         ) //input  [4 - 1: 0] 
    ,.pcsrc           (pcsrc        ) //input  [2 - 1: 0] 
    ,.instruction     (instruction  ) //output [32- 1: 0] 
  );
endmodule
  
