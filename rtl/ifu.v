module ifu(
     input                  clk
    ,input                  rst_n
    ,input                  jal
    ,input  [32- 1: 0]      reg_data
    ,input  [32- 1: 0]      zero
    ,input  [2 - 1: 0]      pcsrc
    ,output [32- 1: 0]      instruction
    ,output [32- 1: 0]      jal_pc
);

  reg   [32- 1: 0]  pc;
  reg   [8 - 1: 0]  im  [64:0];
  reg   [32- 1: 0]  pcnew;
  wire  [32- 1: 0]  temp;
  wire  [32- 1: 0]  t0;
  wire  [32- 1: 0]  t1;
  wire  [16- 1: 0]  imm16;
  wire  [32- 1: 0]  extout;
  
  //give instruction a value
  assign instruction = { im[pc[10- 1: 0]]
                        ,im[pc[10- 1: 0] + 1]
                        ,im[pc[10- 1: 0] + 2]
                        ,im[pc[10- 1: 0] + 3]};
  
//  assign instruction = im[pc];

  assign imm16 = instruction[16- 1: 0];
  
  //set extout value
  assign temp = {{16{imm16[15]}},imm16};
  
  
  //j condition
  assign extout = jal ? {pc[32- 1:28],instruction[26- 1: 0],2'b0} //for j & jal
                      : temp[32- 1: 0] << 2;                 //for beq & bne
    
  //set pcnew
  assign t0 = pc + 4;
  assign t1 = t0 + extout;
  assign jal_pc = t0;

  always@(*) begin
    case (pcsrc)
        2'b00 : begin
            pcnew = t0;
        end
        2'b01 : begin   //for beq & bne
            if(zero)begin
                pcnew = t1;
            end else begin
                pcnew = t0;
            end
        end
        2'b10 : begin   //for jr
            pcnew = reg_data;
        end
        2'b11 : begin   //for j& jal
            pcnew = extout;
        end
        default : pcnew = t0;
    endcase
  end

  //update pc
  always@(posedge clk or negedge rst_n)
  begin
    if(!rst_n) begin
        pc <= 32'h0000_0000;
    end else begin
        pc <= pcnew;
    end
  end
  
endmodule
    
