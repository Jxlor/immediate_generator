class imm_full_test extends imm_base_test;
    `uvm_component_utils(imm_full_test)
 
    function new(string name = "imm_full_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction
 
    task run_phase(uvm_phase phase);
      imm_walking_seq      wseq = imm_walking_seq::type_id::create("wseq");
      imm_opcode_sweep_seq sseq = imm_opcode_sweep_seq::type_id::create("sseq");
      imm_random_seq       rseq = imm_random_seq::type_id::create("rseq");
      phase.raise_objection(this);
      wseq.start(env.agt.sqr);
      sseq.start(env.agt.sqr);
      rseq.start(env.agt.sqr);
      repeat (5) @(env.agt.drv.vif.cb);
      phase.drop_objection(this);
    endtask
  endclass
