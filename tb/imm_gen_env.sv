class imm_gen_env extends uvm_env;
  `uvm_component_utils(imm_gen_env)
  imm_gen_agent      agent;
  imm_gen_scoreboard scb;

  function new(string name = "imm_gen_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = imm_gen_agent::type_id::create("agent", this);
    scb   = imm_gen_scoreboard::type_id::create("scb", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.mon.ap.connect(scb.item_export);
  endfunction
endclass
