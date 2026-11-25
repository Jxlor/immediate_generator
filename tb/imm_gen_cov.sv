class imm_gen_cov extends uvm_subscriber #(imm_gen_item);
  `uvm_component_utils(imm_gen_cov)
  imm_gen_item tr;

  covergroup cg_imm_gen;
    cp_opcode: coverpoint tr.opcode {
      bins u_lui    = {`OPCODE_LUI};
      bins u_auipc  = {`OPCODE_AUIPC};
      bins j_jal    = {`OPCODE_JAL};
      bins i_jalr   = {`OPCODE_JALR};
      bins b_branch = {`OPCODE_BRANCH};
      bins i_load   = {`OPCODE_LOAD};
      bins s_store  = {`OPCODE_STORE};
      bins i_itype  = {`OPCODE_ITYPE};
      bins r_def    = {`OPCODE_RTYPE};
      bins i_fence  = {`OPCODE_FENCE};
      bins i_env    = {`OPCODE_ENVIRONMENT};
      bins illegal_def = {7'b0000000};
    }
    cp_sign_12b: coverpoint tr.raw_imm[11] {
      bins pos_12 = {1'b0};
      bins neg_12 = {1'b1};
    }
    cp_sign_20b: coverpoint tr.raw_imm[19] {
      bins pos_20 = {1'b0};
      bins neg_20 = {1'b1};
    }
    cross_op_x_sign12: cross cp_opcode, cp_sign_12b {
      ignore_bins non_12b = binsof(cp_opcode) intersect {
        `OPCODE_LUI, `OPCODE_AUIPC, `OPCODE_JAL, `OPCODE_RTYPE
      };
    }
    cross_op_x_sign20: cross cp_opcode, cp_sign_20b {
      ignore_bins non_20b = binsof(cp_opcode) intersect {
        `OPCODE_JALR, `OPCODE_BRANCH, `OPCODE_LOAD, `OPCODE_STORE,
        `OPCODE_ITYPE, `OPCODE_RTYPE, `OPCODE_FENCE, `OPCODE_ENVIRONMENT
      };
    }
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
