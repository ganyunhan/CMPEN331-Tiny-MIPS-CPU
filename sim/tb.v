`timescale 1ns/1ps
`define INS_NUM  9

module tb;


  reg clk = 0;
  reg rst_n = 0;
  reg [32- 1: 0] inst_mem [64- 1: 0];
  wire [32- 1: 0]   instruction;
  wire [32- 1: 0]   pc;
  wire [32- 1: 0]   regs  [32- 1: 1];
  wire [8 - 1: 0]   data_mem [128- 1 :0];

  integer imf;
  integer i;
  genvar gen_i;

  initial begin
        rst_n = 1;
    #10 rst_n = 0;
    #10 rst_n = 1;
    #2000 $finish;
  end

  generate
    for (gen_i = 1 ; gen_i < 32 ; gen_i = gen_i + 1) begin
        assign regs[gen_i] = U_MIPS.U_MIPS_DATAPATH.U_REGFILE.register[gen_i]; 
    end
  endgenerate

 //  generate
 //    for (gen_i = 0 ; gen_i < 128 ; gen_i = gen_i + 1) begin
 //        assign data_mem[gen_i] = {U_MIPS.U_MIPS_DATAPATH.U_DM.DataMem[gen_i],
 //    end
 //  endgenerate

 assign data_mem[12] = {U_MIPS.U_MIPS_DATAPATH.U_DM.DataMem[12],
                        U_MIPS.U_MIPS_DATAPATH.U_DM.DataMem[13],
                        U_MIPS.U_MIPS_DATAPATH.U_DM.DataMem[14],
                        U_MIPS.U_MIPS_DATAPATH.U_DM.DataMem[15]};

  /************************************************************************************************************************************************
  **BIG-ENDIAN**                                         opcode   rs      rt      rd(imm)   sa     func       comment
  0x200d_0080  001000_00000_01101_0000_0000_1000_0000  //addi     $0      $13     #128                        set reg[13] = 128
  0x200a_0040  001000_00000_01010_0000_0000_0100_0000  //addi     $0      $10     #64                         set reg[10] = 64
  0xac0a_000c  101011_00000_01010_0000_0000_0000_1100  //sw       $0      $10     #12                         set Datamem[12] = reg[10] = 64
  0x01aa_6822  000000_01101_01010_01101_00000_100010   //sub      $13     $10     $13       00000  100010     set reg[13] = reg[13] - reg[10] = 64
  0x8c0f_000c  100011_00000_01111_0000_0000_0000_1100  //lw       $0      $15     #12                         set reg[15] = Datamem[12] = 64
  0x000f_8080  000000_00000_01111_10000_00010_000000   //sll      00000   $15     $16       00010  000000     set reg[16] = reg[15] << 2 = 256
  0x15aa_0002  000101_01101_01010_0000_0000_0000_0010  //bne      $13     $10     #2                          if reg[13] != 64 ,jump add 2 ,else continue
  0x3c0d_0001  001111_00000_01101_0000_0000_0000_0001  //lui      00000   $13     #1                          set reg[13] = 1 << 16 = 65536
  0x0c00_0002  000011_00000_00000_0000_0000_0000_0010  //jal      #2                                          jump add 2
  ***********************************************************************************************************************************************/
  initial begin
    inst_mem[0] = 32'h200d_0080;
    inst_mem[1] = 32'h200a_0040;
    inst_mem[2] = 32'hac0a_000c;
    inst_mem[3] = 32'h01aa_6822;
    inst_mem[4] = 32'h8c0f_000c;
    inst_mem[5] = 32'h000f_8080;
    inst_mem[6] = 32'h15aa_0002;
    inst_mem[7] = 32'h3c0d_0001;
    inst_mem[8] = 32'h0c00_0002;
  end

  assign instruction = U_MIPS.U_MIPS_DATAPATH.U_IFU.instruction;
  assign pc = (U_MIPS.U_MIPS_DATAPATH.U_IFU.pc) >> 2;

  always@(posedge clk) begin
    if (instruction == inst_mem[pc]) begin
        $display("[INFO]    : instruction expected: %x actual: %x MATCH!",instruction,inst_mem[pc]);
        case (pc)
            32'd1 : begin
                if (regs[13] != 'd128) begin
                    $display("[ERROR]: PC = %d --  REG[13]: expected : 128  actual: %d",pc,regs[13]);
                end
            end
            32'd2 : begin
                if (regs[10] != 'd64) begin
                    $display("[ERROR]: PC = %d --  REG[10]: expected :  64  actual: %d",pc,regs[10]);
                end
            end
            32'd3 : begin
                if (data_mem[12] != 'd64) begin
                    $display("[ERROR]: PC = %d -- DMEM[12]: expected :  64  actual: %d",pc,data_mem[12]);
                end
            end
            32'd4 : begin
                if (regs[13] != 'd64) begin
                    $display("[ERROR]: PC = %d --  REG[13]: expected :  64  actual: %d",pc,regs[13]);
                end
            end
            32'd5 : begin
                if (regs[15] != 'd64) begin
                    $display("[ERROR]: PC = %d --  REG[15]: expected :  64  actual: %d",pc,regs[15]);
                end
            end
            32'd6 : begin
                if (regs[16] != 'd256) begin
                    $display("[ERROR]: PC = %d --  REG[16]: expected : 256  actual: %d",pc,regs[16]);
                end
            end
            32'd8 : begin
                if (regs[13] != 'd65536) begin
                    $display("[ERROR]: PC = %d --  REG[13]: expected :65536  actual: %d",pc,regs[13]);
                end else begin
                    $display("[COMPLETE] : Simulation done!! ALL PASS!!");
                    $finish;
                end
            end
            default : begin
            end
        endcase
 //    end else begin
 //        $display("[INS-ERROR]: INS expect: %x  actual: %x",inst_mem[pc],instruction);
    end
  end

  /* BIG-ENDIAN */
  initial begin
    imf = $fopen("../soft/code.txt","w+");
    for(i = 0; i < `INS_NUM; i = i + 1) begin
        $fdisplay(imf,"%x",inst_mem[i][31:24]);
        $fdisplay(imf,"%x",inst_mem[i][23:16]);
        $fdisplay(imf,"%x",inst_mem[i][15:8]);
        $fdisplay(imf,"%x",inst_mem[i][7:0]);
    end
    $fclose(imf);
    $readmemh("../soft/code.txt",U_MIPS.U_MIPS_DATAPATH.U_IFU.im);
  end

  always
  #10 clk=~clk;

  initial begin
        $fsdbDumpfile("tb.fsdb");       
        $fsdbDumpvars(0,"tb","+all");
  end

  mips U_MIPS(
     .clk           (clk    )
    ,.rst_n         (rst_n  )
  );

endmodule
