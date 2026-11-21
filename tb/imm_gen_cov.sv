class imm_gen_cov extends uvm_subscriber #(imm_gen_item);
  `uvm_component_utils(imm_gen_cov)
  imm_gen_item tr;

  covergroup cg_imm_gen;
    cp_opcode: coverpoint tr.instr[6:0] {
      bins lui    = {7'b0110111};
      bins auipc  = {7'b0010111};
      bins jal    = {7'b1101111};
      bins jalr   = {7'b1100111};
      bins branch = {7'b1100011};
      bins load   = {7'b0000011};
      bins store  = {7'b0100011};
      bins itype  = {7'b0010011};
      bins rtype  = {7'b0110011};
      bins fence  = {7'b0001111};
      bins env    = {7'b1110011};
    }
    cp_sign_bit: coverpoint tr.instr[31] {
      bins pos = {1'b0};
      bins neg = {1'b1};
    }
    cx_opc_sign: cross cp_opcode, cp_sign_bit;
  endgroup

  function new(string name = "imm_gen_cov", uvm_component parent = null);
    super.new(name, parent);
    cg_imm_gen = new();
  endfunction

  function void write(imm_gen_item t);
    tr = t;
    cg_imm_gen.sample();
  endfunction
endclass
