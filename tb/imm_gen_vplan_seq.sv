class imm_gen_vplan_seq extends uvm_sequence #(imm_gen_item);
  `uvm_object_utils(imm_gen_vplan_seq)

  typedef struct {
    logic [6:0]  opc;
    logic [19:0] raw;
  } vec_t;

  // 17 vector ke thua tu Immediate_Generator_tb.v + Corner cases VPlan
  // CÃ¡c trÆ°á»ng há»£p khá»i Äá»ng 
  vec_t vplan_vecs[15] = '{
    '{`OPCODE_JALR,        20'h007FF}, // I-Type Max dÆ°Æ¡ng 12-bit (+2047)
    '{`OPCODE_LOAD,        20'h00800}, // I-Type Min Ã¢m 12-bit (-2048)
    '{`OPCODE_ITYPE,       20'h00000}, // I-Type sá» 0
    '{`OPCODE_FENCE,       20'h007FF}, // FENCE dÆ°Æ¡ng
    '{`OPCODE_ENVIRONMENT, 20'h00800}, // ENV Ã¢m
    '{`OPCODE_STORE,       20'h007FF}, // S-Type Max dÆ°Æ¡ng 12-bit
    '{`OPCODE_STORE,       20'h00800}, // S-Type Min Ã¢m 12-bit
    '{`OPCODE_LUI,         20'h7FFFF}, // U-Type Max 20-bit
    '{`OPCODE_AUIPC,       20'h80000}, // U-Type bit[19]=1
    '{`OPCODE_BRANCH,      20'h007FF}, // B-Type Max dÆ°Æ¡ng
    '{`OPCODE_BRANCH,      20'h00800}, // B-Type Min Ã¢m
    '{`OPCODE_JAL,         20'h7FFFF}, // J-Type Max dÆ°Æ¡ng 20-bit
    '{`OPCODE_JAL,         20'h80000}, // J-Type Min Ã¢m 20-bit
    '{7'b0000000,          20'd0},     // Illegal opcode dÆ°Æ¡ng
    '{7'b0000000,         -20'd1121}   // Illegal opcode Ã¢m
  };

  function new(string name = "imm_gen_vplan_seq");
    super.new(name);
  endfunction

  task body();
    foreach (vplan_vecs[i]) begin
      req = imm_gen_item::type_id::create("req");
      start_item(req);
      req.opcode  = vplan_vecs[i].opc;
      req.raw_imm = vplan_vecs[i].raw;
      finish_item(req);
    end
// VÃ²ng láº·p cÃ¡c trÆ°á»ng há»£p ngáº«u nhiÃªn
    repeat (700) begin
      req = imm_gen_item::type_id::create("req");
      start_item(req);
      assert(req.randomize());
      finish_item(req);
    end
  endtask
endclass
