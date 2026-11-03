 class imm_item extends uvm_sequence_item;
    rand bit [31:0] instr;
    bit      [31:0] imm;        // quan sat tu DUT
 
    // Opcode: phan lon hop le, mot phan ngau nhien (khong hop le)
    constraint c_opcode {
      instr[6:0] dist {
        OPCODE_LUI         := 8,
        OPCODE_AUIPC       := 8,
        OPCODE_JAL         := 10,
        OPCODE_JALR        := 8,
        OPCODE_BRANCH      := 10,
        OPCODE_LOAD        := 8,
        OPCODE_STORE       := 10,
        OPCODE_ITYPE       := 10,
        OPCODE_RTYPE       := 8,
        OPCODE_FENCE       := 4,
        OPCODE_ENVIRONMENT := 8,
        [7'd0 : 7'd127]    :/ 20
      };
    }
 
    // Cac bit con lai: thinh thoang toan 0 hoac toan 1 de thu gia tri bien
    constraint c_rest {
      instr[31:7] dist { 25'h0 := 3, 25'h1FFFFFF := 3,
                         [25'h1 : 25'h1FFFFFE] :/ 94 };
    }
 
    `uvm_object_utils_begin(imm_item)
      `uvm_field_int(instr, UVM_ALL_ON | UVM_HEX)
      `uvm_field_int(imm,   UVM_ALL_ON | UVM_HEX)
    `uvm_object_utils_end
 
    function new(string name = "imm_item");
      super.new(name);
    endfunction
  endclass
