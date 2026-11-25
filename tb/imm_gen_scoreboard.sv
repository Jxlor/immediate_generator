class imm_gen_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(imm_gen_scoreboard)
  uvm_analysis_imp #(imm_gen_item, imm_gen_scoreboard) item_export;

  Imm_Gen_model model;
  int pass_cnt = 0, fail_cnt = 0;

  function new(string name = "imm_gen_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_export = new("item_export", this);
    model       = new();
  endfunction

  function void write(imm_gen_item item);
    logic [31:0] exp_imm;
    model.set_inputs(item.raw_imm, item.opcode);
    exp_imm = model.get_imm_expected();

    if (item.imm === exp_imm) begin
      pass_cnt++;
    end else begin
      fail_cnt++;
      `uvm_error("IMM_GEN_ERR", $sformatf("Op=%b Raw=%h | Exp=%h | Act=%h",
                 item.opcode, item.raw_imm, exp_imm, item.imm))
    end
  endfunction

  function void report_phase(uvm_phase phase);
    `uvm_info("SCB_REPORT", $sformatf("IMM_GEN SUMMARY: PASS=%0d, FAIL=%0d",
              pass_cnt, fail_cnt), UVM_LOW)
  endfunction
endclass
