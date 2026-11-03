class imm_coverage extends uvm_subscriber #(imm_item);
    `uvm_component_utils(imm_coverage)
    imm_item smp;   // doi ten tu 't' de ham write() dung duoc ten tham so 't' (bat buoc voi UVM 1.1d)
 
    covergroup cg;
      cp_opcode : coverpoint smp.instr[6:0] {
        bins lui    = {OPCODE_LUI};
        bins auipc  = {OPCODE_AUIPC};
        bins jal    = {OPCODE_JAL};
        bins jalr   = {OPCODE_JALR};
        bins branch = {OPCODE_BRANCH};
        bins load   = {OPCODE_LOAD};
        bins store  = {OPCODE_STORE};
        bins itype  = {OPCODE_ITYPE};
        bins rtype  = {OPCODE_RTYPE};
        bins fence  = {OPCODE_FENCE};
        bins env    = {OPCODE_ENVIRONMENT};
        bins other  = default;
      }
      cp_sign : coverpoint smp.instr[31];        // bit dau cua lenh
      cp_imm_class : coverpoint smp.imm {
        bins zero     = {32'h0};
        bins neg      = {[32'h8000_0000 : 32'hFFFF_FFFF]};
        bins pos      = {[32'h1 : 32'h7FFF_FFFF]};
      }
      cx_opcode_sign  : cross cp_opcode, cp_sign;
      cx_opcode_class : cross cp_opcode, cp_imm_class;
    endgroup
 
    function new(string name, uvm_component parent);
      super.new(name, parent);
      cg = new();
    endfunction
 
    // UVM 1.1d: ten tham so cua write() phai la 't' giong lop cha uvm_subscriber
    function void write(imm_item t);
      smp = t;
      cg.sample();
    endfunction
 
    function void report_phase(uvm_phase phase);
      `uvm_info("COV", $sformatf("Functional coverage = %0.2f%%", cg.get_inst_coverage()), UVM_NONE)
    endfunction
  endclass
 
