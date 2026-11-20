module imm_gen (
  input  wire [6:0]  opcode,
  input  wire [24:0] raw_imm,
  output reg  [31:0] imm
);

  wire [31:0] instr = {raw_imm, opcode};

  always @(*) begin
    case (opcode)
      7'b0110111, 7'b0010111: imm = {instr[31:12], 12'b0};                                              // LUI, AUIPC
      7'b1101111:             imm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};    // JAL
      7'b1100111, 7'b0000011,
      7'b0010011:             imm = {{20{instr[31]}}, instr[31:20]};                                   // JALR, LOAD, ITYPE
      7'b1100011:             imm = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};      // BRANCH
      7'b0100011:             imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};                      // STORE
      7'b0110011, 7'b0001111: imm = 32'h0000_0000;                                                     // RTYPE, FENCE
      7'b1110011:             imm = {27'b0, instr[19:15]};                                             // ENVIRONMENT / CSR
      default:                imm = 32'h0000_0000;
    endcase
  end

endmodule
