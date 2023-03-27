module mips_datapath(
     input              clk
    ,input              rst_n
    ,input              jal
    ,input              sext
    ,input              regrt
    ,input              m2reg
    ,input              wreg
    ,input              wmem
    ,input              aluimm
    ,input              alushift
    ,input  [4 - 1: 0]  aluc
    ,input  [2 - 1: 0]  pcsrc
    ,output [32- 1: 0]  instruction
    );
    
  wire  [32- 1: 0]  alu_out;
  wire  [32- 1: 0]  busA;
  wire  [32- 1: 0]  busB;
  wire  [32- 1: 0]  alu_a;
  wire  [32- 1: 0]  alu_b;
  wire  [32- 1: 0]  imm32;
  wire  [32- 1: 0]  zero;
  wire  [32- 1: 0]  wreg_data;
  wire  [32- 1: 0]  mem2reg;
  wire  [32- 1: 0]  datamem_out;
  wire  [32- 1: 0]  jal_pc;
  wire  [5 - 1: 0]  regdst;
  wire  [5 - 1: 0]  reg_rtrd;

// instruction decode
  wire  [5 - 1: 0]  rs;
  wire  [5 - 1: 0]  rt;
  wire  [5 - 1: 0]  rd;
  wire  [5 - 1: 0]  sa;
  wire  [16- 1: 0]  imm16;

  assign rs      = instruction[26- 1:21];
  assign rt      = instruction[21- 1:16];
  assign rd      = instruction[16- 1:11];
  assign sa      = instruction[11- 1: 6];
  assign imm16   = instruction[16- 1: 0];

  ifu           U_IFU(
    .clk                (clk),
    .rst_n              (rst_n),
    .jal                (jal),
    .reg_data           (busA),
    .zero               (zero),
    .pcsrc              (pcsrc),
    .instruction        (instruction),
    .jal_pc             (jal_pc)
  );
    
  ext           U_EXT(
  .imm16                (imm16),
  .imm32                (imm32),
  .sext                 (sext)
  ); 
  
  alu           U_ALU(
  .a                    (alu_a),
  .b                    (alu_b),
  .aluc                 (aluc),
  .zero                 (zero),
  .alu_out              (alu_out)
  );
  
 // regrt == 0 : use rd
 // regrt == 1 : use rt
  mux_RegDst    U_MUX_RTRD(
  .rt                   (rt),
  .rd                   (rd),
  .regrt                (regrt),
  .regdst               (reg_rtrd)
  );

 // regrt == 0 : use regrt
 // regrt == 1 : use jal_$ra
  mux_RegDst    U_MUX_REGDST(
  .rd                   (reg_rtrd),
  .rt                   (5'b1_1111),
  .regrt                (jal),
  .regdst               (regdst)
  );

 // alushift == 0 : use busA
 // alushift == 1 : use sa
  mux       U_MUX_ALU_A_SRC(
  .a0                   (busA),
  .a1                   ({{27{1'b0}},sa}),
  .op                   (alushift),
  .out                  (alu_a)
  );
 
 // aluimm == 0: use busB 
 // aluimm == 1: use imm32
  mux       U_MUX_ALU_B_SRC(
  .a0                   (busB),
  .a1                   (imm32),
  .op                   (aluimm),
  .out                  (alu_b)
  );

  mux       U_MUX_MEM2REG(
  .a0                   (alu_out),
  .a1                   (datamem_out),
  .op                   (m2reg),
  .out                  (mem2reg)
  );

  mux       U_MUX_DATA2REG(
  .a0                   (mem2reg),
  .a1                   (jal_pc),
  .op                   (jal),
  .out                  (wreg_data)
  );

  regfile   U_REGFILE(
  .clk                  (clk),
  .rst_n                (rst_n),
  .we                   (wreg),
  .wn                   (regdst),
  .rna                  (rs),
  .rnb                  (rt),
  .d                    (wreg_data),
  .qa                   (busA),
  .qb                   (busB)
  );
  
  dm        U_DM(
  .clk                  (clk),
  .rst_n                (rst_n),
  .Data_in              (busB),
  .MemWr                (wmem),
  .Addr                 (alu_out),
  .Data_out             (datamem_out)
  );
 
endmodule
