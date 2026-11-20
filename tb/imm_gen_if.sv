interface imm_gen_if(input logic clk);
  logic [6:0]  opcode;
  logic [24:0] raw_imm; // instr[31:7]
  logic [31:0] imm;

  clocking drv_cb @(posedge clk);
    output opcode, raw_imm;
  endclocking

  clocking mon_cb @(negedge clk);
    input opcode, raw_imm, imm;
  endclocking
endinterface
