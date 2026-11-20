class imm_gen_item extends uvm_sequence_item;
  rand logic [31:0] instr;
       logic [31:0] imm_out;

  `uvm_object_utils_begin(imm_gen_item)
    `uvm_field_int(instr,   UVM_ALL_ON | UVM_HEX)
    `uvm_field_int(imm_out, UVM_ALL_ON | UVM_HEX)
  `uvm_object_utils_end

  constraint c_valid_opcode {
    instr[6:0] inside {
      7'b0110111, 7'b0010111, 7'b1101111, 7'b1100111,
      7'b1100011, 7'b0000011, 7'b0100011, 7'b0010011,
      7'b0110011, 7'b0001111, 7'b1110011
    };
  }

  function new(string name = "imm_gen_item");
    super.new(name);
  endfunction
endclass
