//============================================================================
// Immediate_Generator (RISC-V RV32I)
// Nhan nguyen lenh 32 bit, tach va mo rong dau truong immediate thanh 32 bit.
//
//  U-type (LUI, AUIPC)          : imm = {instr[31:12], 12'b0}
//  J-type (JAL)                 : imm = sext({instr[31], instr[19:12], instr[20], instr[30:21], 0})
//  I-type (JALR, LOAD, OP-IMM)  : imm = sext(instr[31:20])
//  S-type (STORE)               : imm = sext({instr[31:25], instr[11:7]})
//  B-type (BRANCH)              : imm = sext({instr[31], instr[7], instr[30:25], instr[11:8], 0})
//  SYSTEM (CSR)                 : imm = zero-extend(instr[19:15])   (zimm cua csrrwi/csrrsi/csrrci)
//  Con lai                      : imm = 0
//
// LUU Y: day la gia dinh theo chuan RV32I. Neu spec cua ban co cong khac
// (vi du nhan them opcode rieng) hoac xu ly CSR khac, sua lai cho khop.
//============================================================================
package imm_defs_pkg;
  localparam logic [6:0] OPCODE_LUI         = 7'b0110111;
  localparam logic [6:0] OPCODE_AUIPC       = 7'b0010111;
  localparam logic [6:0] OPCODE_JAL         = 7'b1101111;
  localparam logic [6:0] OPCODE_JALR        = 7'b1100111;
  localparam logic [6:0] OPCODE_BRANCH      = 7'b1100011;
  localparam logic [6:0] OPCODE_LOAD        = 7'b0000011;
  localparam logic [6:0] OPCODE_STORE       = 7'b0100011;
  localparam logic [6:0] OPCODE_ITYPE       = 7'b0010011;
  localparam logic [6:0] OPCODE_RTYPE       = 7'b0110011;  // khong co immediate -> imm = 0
  localparam logic [6:0] OPCODE_FENCE       = 7'b0001111;  // khong dung immediate -> imm = 0
  localparam logic [6:0] OPCODE_ENVIRONMENT = 7'b1110011;
endpackage

module Immediate_Generator
  import imm_defs_pkg::*;
(
  input  logic [31:0] instr,
  output logic [31:0] imm
);

  always_comb begin
    case (instr[6:0])
      OPCODE_LUI,
      OPCODE_AUIPC: imm = {instr[31:12], 12'b0};

      OPCODE_JAL:   imm = {{11{instr[31]}}, instr[31], instr[19:12],
                           instr[20], instr[30:21], 1'b0};

      OPCODE_JALR,
      OPCODE_LOAD,
      OPCODE_ITYPE: imm = {{20{instr[31]}}, instr[31:20]};

      OPCODE_STORE: imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};

      OPCODE_BRANCH: imm = {{19{instr[31]}}, instr[31], instr[7],
                            instr[30:25], instr[11:8], 1'b0};

      OPCODE_ENVIRONMENT: imm = {27'b0, instr[19:15]};

      default:      imm = 32'd0;
    endcase
  end

endmodule
