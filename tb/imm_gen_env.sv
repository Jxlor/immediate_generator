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

class imm_gen_test extends uvm_test;
  `uvm_component_utils(imm_gen_test)
  imm_gen_env env;

  function new(string name = "imm_gen_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "env.agent", "is_active", UVM_ACTIVE);
    env = imm_gen_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    imm_gen_vplan_seq seq = imm_gen_vplan_seq::type_id::create("seq");
    phase.raise_objection(this);
    seq.start(env.agent.sqr);
    #20;
    phase.drop_objection(this);
  endtask
endclass
