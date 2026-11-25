class imm_gen_item extends uvm_sequence_item;
  rand logic [19:0] raw_imm;
  rand logic [6:0]  opcode;
       logic [31:0] imm;

  `uvm_object_utils_begin(imm_gen_item)
    `uvm_field_int(raw_imm, UVM_ALL_ON | UVM_HEX)
    `uvm_field_int(opcode,  UVM_ALL_ON | UVM_BIN)
    `uvm_field_int(imm,     UVM_ALL_ON | UVM_HEX)
  `uvm_object_utils_end

  constraint c_valid_opcode {
    opcode dist {
      `OPCODE_JALR        := 10,
      `OPCODE_LOAD        := 10,
      `OPCODE_ITYPE       := 10,
      `OPCODE_FENCE       := 10,
      `OPCODE_ENVIRONMENT := 10,
      `OPCODE_STORE       := 15,
      `OPCODE_LUI         := 10,
      `OPCODE_AUIPC       := 10,
      `OPCODE_BRANCH      := 15,
      `OPCODE_JAL         := 15,
      `OPCODE_RTYPE       := 10
    };
  }

  function new(string name = "imm_gen_item");
    super.new(name);
  endfunction
endclass
