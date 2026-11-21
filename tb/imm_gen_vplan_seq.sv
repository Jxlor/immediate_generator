class imm_gen_vplan_seq extends uvm_sequence #(imm_gen_item);
  `uvm_object_utils(imm_gen_vplan_seq)

  logic [31:0] vplan_hex[11] = '{
    32'h1234_5037, 32'hABCDE017,  32'h8000_00EF, 32'h7FF0_0067,
    32'h0020_8463, 32'h0100_2003, 32'h0052_2223, 32'h00A0_0093,
    32'h0020_8133, 32'h0000_000F, 32'h0000_0073
  };

  logic [31:0] corner_hex[8] = '{
    32'h0000_0037, 32'hFFFF_F037, 32'hFFFF_F067, 32'h8000_0093,
    32'hFE00_0FA3, 32'hFFFF_FF33, 32'hFFFF_FF0F, 32'h000F_8073
  };

  function new(string name = "imm_gen_vplan_seq");
    super.new(name);
  endfunction

  task body();
    foreach (vplan_hex[i]) begin
      req = imm_gen_item::type_id::create("req");
      start_item(req); req.instr = vplan_hex[i]; finish_item(req);
    end
    foreach (corner_hex[i]) begin
      req = imm_gen_item::type_id::create("req");
      start_item(req); req.instr = corner_hex[i]; finish_item(req);
    end
    for (int b = 12; b <= 31; b++) begin
      req = imm_gen_item::type_id::create("req");
      start_item(req); req.instr = (32'h1 << b) | 32'h0000_006F; finish_item(req);
    end
    repeat (500) begin
      req = imm_gen_item::type_id::create("req");
      start_item(req); assert(req.randomize()); finish_item(req);
    end
  endtask
endclass
