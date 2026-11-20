typedef class ALU_model;

class Imm_Gen_model;
  protected logic [31:0] instr;
  protected logic [6:0]  opcode;
  protected logic [31:0] imm_expected;

  ALU_model next_alu_model;

  function new();
    instr        = 32'h0;
    imm_expected = 32'h0;
  endfunction

  function void set_instr(logic [31:0] a);
    this.instr  = a;
    this.opcode = a[6:0];
    predict_imm();
  endfunction

  protected function void predict_imm();
    case (opcode)
      // 1 & 2. LUI & AUIPC (U-Type)
      7'b0110111, 7'b0010111: imm_expected = {instr[31:12], 12'b0};
      // 3. JAL (J-Type: mở rộng dấu 21-bit)
      7'b1101111: imm_expected = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
      // 4, 6, 8. JALR, LOAD, ITYPE (I-Type)
      7'b1100111, 7'b0000011, 7'b0010011: imm_expected = {{20{instr[31]}}, instr[31:20]};
      // 5. BRANCH (B-Type: mở rộng dấu 13-bit)
      7'b1100011: imm_expected = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
      // 7. STORE (S-Type)
      7'b0100011: imm_expected = {{20{instr[31]}}, instr[31:25], instr[11:7]};
      // 9 & 10. RTYPE & FENCE -> ép về 0
      7'b0110011, 7'b0001111: imm_expected = 32'h0000_0000;
      // 11. ENVIRONMENT / CSR -> Zero-extend 5-bit instr[19:15]
      7'b1110011: imm_expected = {27'b0, instr[19:15]};
      default:    imm_expected = 32'h0000_0000;
    endcase
  endfunction

  function logic [31:0] get_imm_expected();
    return imm_expected;
  endfunction
endclass
