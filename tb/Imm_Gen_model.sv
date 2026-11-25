class Imm_Gen_model;
  protected logic [19:0] raw_imm;
  protected logic [6:0]  opcode;
  protected logic [31:0] imm_expected;

  //ALU_model next_alu_model;

  function new();
    raw_imm      = 20'h0;
    opcode       = 7'h0;
    imm_expected = 32'h0;
  endfunction

  function void set_inputs(logic [19:0] raw, logic [6:0] opc);
    this.raw_imm = raw;
    this.opcode  = opc;
    predict_imm();
  endfunction

  protected function void predict_imm();
    case (opcode)
      `OPCODE_JALR, `OPCODE_LOAD, `OPCODE_ITYPE, `OPCODE_FENCE, `OPCODE_ENVIRONMENT:
        imm_expected = {{20{raw_imm[11]}}, raw_imm[11:0]};
      `OPCODE_STORE:
        imm_expected = {{20{raw_imm[11]}}, raw_imm[11:0]};
      `OPCODE_LUI, `OPCODE_AUIPC:
        imm_expected = {raw_imm, 12'b0};
      `OPCODE_BRANCH:
        imm_expected = {{19{raw_imm[11]}}, raw_imm[11:0], 1'b0};
      `OPCODE_JAL:
        imm_expected = {{11{raw_imm[19]}}, raw_imm[19:0], 1'b0};
      default:
        imm_expected = 32'b0;
    endcase
  endfunction

  function logic [31:0] get_imm_expected();
    return imm_expected;
  endfunction
endclass
