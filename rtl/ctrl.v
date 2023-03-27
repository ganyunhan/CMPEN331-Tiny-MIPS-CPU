module mips_ctrl(
     input                  rst_n 
    ,input      [32- 1: 0]  instruction
    ,output reg             jal
    ,output reg             sext
    ,output reg             regrt
    ,output reg             m2reg
    ,output reg             wreg
    ,output reg             wmem
    ,output reg             aluimm
    ,output reg             alushift
    ,output reg [4 - 1: 0]  aluc
    ,output reg [2 - 1: 0]  pcsrc
);

  wire [6 - 1: 0] opcode;
  wire [6 - 1: 0] func;
  
  assign opcode = instruction[32- 1:26];
  assign func   = instruction[6 - 1: 0];
  
  // reset
  always@(*) begin
    if (!rst_n) begin
      jal      = 1'b0;
      sext     = 1'b0;
      regrt    = 1'b0;
      m2reg    = 1'b0;
      wreg     = 1'b0;
      wmem     = 1'b0;
      aluimm   = 1'b0;
      alushift = 1'b0;
      aluc     = 4'b0000;
      pcsrc    = 2'b00;
    end 
  end
  
  //decode
  always@(*) begin
    case (opcode)
      6'b00_0000 : begin  //R-type
          case (func)
              6'b10_0000 : begin  //add
                jal      = 1'b0;      // no j-type
                sext     = 1'b0;      // no imm preprocess
                regrt    = 1'b0;      // use rd
                m2reg    = 1'b0;      // no lw
                wreg     = 1'b1;      // wreg en
                wmem     = 1'b0;      // wmem dis
                aluimm   = 1'b0;      // use busB
                alushift = 1'b0;      // use busA
                aluc     = 4'b0000;   // ADD
                pcsrc    = 2'b00;     // pc + 4
              end
              6'b10_0010 : begin  //sub
                jal      = 1'b0;      // no j-type
                sext     = 1'b0;      // no imm preprocess
                regrt    = 1'b0;      // use rd
                m2reg    = 1'b0;      // no lw
                wreg     = 1'b1;      // wreg en
                wmem     = 1'b0;      // wmem dis
                aluimm   = 1'b0;      // use busB
                alushift = 1'b0;      // use busA
                aluc     = 4'b0100;   // SUB
                pcsrc    = 2'b00;     // pc + 4
              end
              6'b10_0100 : begin  //and
                jal      = 1'b0;      // no j-type
                sext     = 1'b0;      // no imm preprocess
                regrt    = 1'b0;      // use rd
                m2reg    = 1'b0;      // no lw
                wreg     = 1'b1;      // wreg en
                wmem     = 1'b0;      // wmem dis
                aluimm   = 1'b0;      // use busB
                alushift = 1'b0;      // use busA
                aluc     = 4'b0001;   // AND
                pcsrc    = 2'b00;     // pc + 4
              end
              6'b10_0101 : begin  //or
                jal      = 1'b0;      // no j-type
                sext     = 1'b0;      // no imm preprocess
                regrt    = 1'b0;      // use rd
                m2reg    = 1'b0;      // no lw
                wreg     = 1'b1;      // wreg en
                wmem     = 1'b0;      // wmem dis
                aluimm   = 1'b0;      // use busB
                alushift = 1'b0;      // use busA
                aluc     = 4'b0101;   // OR
                pcsrc    = 2'b00;     // pc + 4
              end
              6'b10_0110 : begin  //xor
                jal      = 1'b0;      // no j-type
                sext     = 1'b0;      // no imm preprocess
                regrt    = 1'b0;      // use rd
                m2reg    = 1'b0;      // no lw
                wreg     = 1'b1;      // wreg en
                wmem     = 1'b0;      // wmem dis
                aluimm   = 1'b0;      // use busB
                alushift = 1'b0;      // use busA
                aluc     = 4'b0010;   // XOR
                pcsrc    = 2'b00;     // pc + 4
              end
              6'b00_0000 : begin  //sll
                jal      = 1'b0;      // no j-type
                sext     = 1'b0;      // no imm preprocess
                regrt    = 1'b0;      // use rd
                m2reg    = 1'b0;      // no lw
                wreg     = 1'b1;      // wreg en
                wmem     = 1'b0;      // wmem dis
                aluimm   = 1'b0;      // use busB
                alushift = 1'b1;      // use sa
                aluc     = 4'b0011;   // SLL
                pcsrc    = 2'b00;     // pc + 4
              end
              6'b00_0010 : begin  //srl
                jal      = 1'b0;      // no j-type
                sext     = 1'b0;      // no imm preprocess
                regrt    = 1'b0;      // use rd
                m2reg    = 1'b0;      // no lw
                wreg     = 1'b1;      // wreg en
                wmem     = 1'b0;      // wmem dis
                aluimm   = 1'b0;      // use busB
                alushift = 1'b1;      // use sa
                aluc     = 4'b0111;   // SLL
                pcsrc    = 2'b00;     // pc + 4
              end
              6'b00_0011 : begin  //sra
                jal      = 1'b0;      // no j-type
                sext     = 1'b0;      // no imm preprocess
                regrt    = 1'b0;      // use rd
                m2reg    = 1'b0;      // no lw
                wreg     = 1'b1;      // wreg en
                wmem     = 1'b0;      // wmem dis
                aluimm   = 1'b0;      // use busB
                alushift = 1'b1;      // use sa
                aluc     = 4'b1111;   // SRA
                pcsrc    = 2'b00;     // pc + 4
              end
              6'b00_1000 : begin  //jr
                jal      = 1'b1;      // j-type
                sext     = 1'b0;      // no imm preprocess
                regrt    = 1'b0;      // use rd
                m2reg    = 1'b0;      // no lw
                wreg     = 1'b0;      // wreg dis
                wmem     = 1'b0;      // wmem dis
                aluimm   = 1'b0;      // use busB
                alushift = 1'b0;      // use busA
                aluc     = 4'b0000;   // default
                pcsrc    = 2'b10;     // pc = reg_data
              end
          endcase
      end
      6'b00_1000 : begin  //addi
        jal      = 1'b0;       // no j-type
        sext     = 1'b1;       // imm preprocess
        regrt    = 1'b1;       // use rt
        m2reg    = 1'b0;       // no lw
        wreg     = 1'b1;       // wreg en
        wmem     = 1'b0;       // wmem dis
        aluimm   = 1'b1;       // use imm32
        alushift = 1'b0;       // use busA
        aluc     = 4'b0000;    // ADD
        pcsrc    = 2'b00;      // pc + 4 
      end
      6'b00_1100 : begin  //andi
        jal      = 1'b0;       // no j-type
        sext     = 1'b1;       // imm preprocess
        regrt    = 1'b1;       // use rt
        m2reg    = 1'b0;       // no lw
        wreg     = 1'b1;       // wreg en
        wmem     = 1'b0;       // wmem dis
        aluimm   = 1'b1;       // use imm32
        alushift = 1'b0;       // use busA
        aluc     = 4'b0001;    // AND
        pcsrc    = 2'b00;      // pc + 4 
      end
      6'b00_1101 : begin  //ori
        jal      = 1'b0;       // no j-type
        sext     = 1'b1;       // imm preprocess
        regrt    = 1'b1;       // use rt
        m2reg    = 1'b0;       // no lw
        wreg     = 1'b1;       // wreg en
        wmem     = 1'b0;       // wmem dis
        aluimm   = 1'b1;       // use imm32
        alushift = 1'b0;       // use busA
        aluc     = 4'b0101;    // OR
        pcsrc    = 2'b00;      // pc + 4 
      end
      6'b00_1110 : begin  //xori
        jal      = 1'b0;       // no j-type
        sext     = 1'b1;       // imm preprocess
        regrt    = 1'b1;       // use rt
        m2reg    = 1'b0;       // no lw
        wreg     = 1'b1;       // wreg en
        wmem     = 1'b0;       // wmem dis
        aluimm   = 1'b1;       // use imm32
        alushift = 1'b0;       // use busA
        aluc     = 4'b0010;    // XOR
        pcsrc    = 2'b00;      // pc + 4 
      end
      6'b10_0011 : begin  //lw
        jal      = 1'b0;       // no j-type
        sext     = 1'b1;       // imm preprocess
        regrt    = 1'b1;       // use rt
        m2reg    = 1'b1;       // use lw
        wreg     = 1'b1;       // wreg en
        wmem     = 1'b0;       // wmem dis
        aluimm   = 1'b1;       // use imm32
        alushift = 1'b0;       // use busA
        aluc     = 4'b0000;    // ADD
        pcsrc    = 2'b00;      // pc + 4 
      end
      6'b10_1011 : begin  //sw
        jal      = 1'b0;       // no j-type
        sext     = 1'b1;       // imm preprocess
        regrt    = 1'b1;       // use rt
        m2reg    = 1'b0;       // no lw
        wreg     = 1'b0;       // wreg dis
        wmem     = 1'b1;       // wmem en
        aluimm   = 1'b1;       // use imm32
        alushift = 1'b0;       // use busA
        aluc     = 4'b0000;    // ADD
        pcsrc    = 2'b00;      // pc + 4 
      end
      6'b00_0100 : begin  //beq
        jal      = 1'b0;       // no j-type
        sext     = 1'b1;       // imm preprocess
        regrt    = 1'b1;       // use rt
        m2reg    = 1'b0;       // no lw
        wreg     = 1'b0;       // wreg dis
        wmem     = 1'b0;       // wmem dis
        aluimm   = 1'b0;       // use busB
        alushift = 1'b0;       // use busA
        aluc     = 4'b1000;    // EQU
        pcsrc    = 2'b01;      // beq & bne
      end
      6'b00_0101 : begin  //bne
        jal      = 1'b0;       // no j-type
        sext     = 1'b1;       // imm preprocess
        regrt    = 1'b1;       // use rt
        m2reg    = 1'b0;       // no lw
        wreg     = 1'b0;       // wreg dis
        wmem     = 1'b0;       // wmem dis
        aluimm   = 1'b0;       // use busB
        alushift = 1'b0;       // use busA
        aluc     = 4'b1001;    // NEQ
        pcsrc    = 2'b01;      // beq & bne
      end
      6'b00_1111 : begin  //lui
        jal      = 1'b0;       // no j-type
        sext     = 1'b0;       // no imm preprocess
        regrt    = 1'b1;       // use rt
        m2reg    = 1'b0;       // no lw
        wreg     = 1'b1;       // wreg en
        wmem     = 1'b0;       // wmem dis
        aluimm   = 1'b1;       // use imm32
        alushift = 1'b0;       // use busA
        aluc     = 4'b0110;    // LUI
        pcsrc    = 2'b00;      // pc + 4
      end
      6'b00_0010 : begin  //j
        jal      = 1'b1;       // j-type
        sext     = 1'b0;       // no imm preprocess
        regrt    = 1'b1;       // use rt
        m2reg    = 1'b0;       // no lw
        wreg     = 1'b0;       // wreg dis
        wmem     = 1'b0;       // wmem dis
        aluimm   = 1'b1;       // use imm32
        alushift = 1'b0;       // use busA
        aluc     = 4'b0000;    // default
        pcsrc    = 2'b11;      // pc = exout
      end
      6'b00_0011 : begin  //jal
        jal      = 1'b1;       // j-type
        sext     = 1'b0;       // no imm preprocess
        regrt    = 1'b1;       // use rt
        m2reg    = 1'b0;       // no lw
        wreg     = 1'b1;       // wreg en
        wmem     = 1'b0;       // wmem dis
        aluimm   = 1'b1;       // use imm32
        alushift = 1'b0;       // use busA
        aluc     = 4'b0000;    // default
        pcsrc    = 2'b11;      // pc = exout
      end
      default : begin
        jal      = 1'b0;
        sext     = 1'b0;
        regrt    = 1'b0;
        m2reg    = 1'b0;
        wreg     = 1'b0;
        wmem     = 1'b0;
        aluimm   = 1'b0;
        alushift = 1'b0;
        aluc     = 4'b0000;
        pcsrc    = 2'b00;
      end
    endcase
  end

endmodule

