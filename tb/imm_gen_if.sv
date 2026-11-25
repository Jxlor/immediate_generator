interface imm_gen_if(input logic clk);
  logic [19:0] raw_imm;
  logic [6:0]  opcode;
  logic [31:0] imm;

  clocking drv_cb @(posedge clk);
    output raw_imm, opcode;
  endclocking

  clocking mon_cb @(negedge clk);
    input raw_imm, opcode, imm;
  endclocking
endinterface
