  class imm_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(imm_scoreboard)
    uvm_analysis_imp #(imm_item, imm_scoreboard) imp;
    int unsigned n_pass, n_fail;
 
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
 
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      imp = new("imp", this);
    endfunction
 
    function bit [31:0] model(bit [31:0] i);
      bit [11:0] t12;
      bit [12:0] t13;
      bit [20:0] t21;
      bit [6:0]  op = i[6:0];
 
      if (op == OPCODE_LUI || op == OPCODE_AUIPC) begin
        return {i[31:12], 12'b0};
      end
      else if (op == OPCODE_JAL) begin
        t21 = {i[31], i[19:12], i[20], i[30:21], 1'b0};   // imm[20|10:1|11|19:12]
        return 32'($signed(t21));
      end
      else if (op == OPCODE_JALR || op == OPCODE_LOAD || op == OPCODE_ITYPE) begin
        t12 = i[31:20];
        return 32'($signed(t12));
      end
      else if (op == OPCODE_STORE) begin
        t12 = {i[31:25], i[11:7]};
        return 32'($signed(t12));
      end
      else if (op == OPCODE_BRANCH) begin
        t13 = {i[31], i[7], i[30:25], i[11:8], 1'b0};     // imm[12|10:5|4:1|11]
        return 32'($signed(t13));
      end
      else if (op == OPCODE_ENVIRONMENT) begin
        return {27'b0, i[19:15]};
      end
      return 32'd0;
    endfunction
 
    function void write(imm_item t);
      bit [31:0] exp_imm = model(t.instr);
      if (t.imm === exp_imm) begin
        n_pass++;
        `uvm_info("SCB", $sformatf("PASS instr=%08h op=%07b -> imm=%08h",
                  t.instr, t.instr[6:0], t.imm), UVM_HIGH)
      end else begin
        n_fail++;
        `uvm_error("SCB", $sformatf("MISMATCH instr=%08h op=%07b | DUT imm=%08h EXP imm=%08h",
                   t.instr, t.instr[6:0], t.imm, exp_imm))
      end
    endfunction
 
    function void report_phase(uvm_phase phase);
      `uvm_info("SCB", $sformatf("KET QUA: PASS=%0d FAIL=%0d", n_pass, n_fail), UVM_NONE)
      if (n_fail == 0 && n_pass > 0) `uvm_info("SCB", "*** TEST PASSED ***", UVM_NONE)
      else                           `uvm_error("SCB", "*** TEST FAILED ***")
    endfunction
  endclass
 
