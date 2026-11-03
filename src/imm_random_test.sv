 class imm_random_test extends imm_base_test;
    `uvm_component_utils(imm_random_test)
 
    function new(string name = "imm_random_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction
 
    task run_phase(uvm_phase phase);
      imm_random_seq rseq = imm_random_seq::type_id::create("rseq");
      phase.raise_objection(this);
      rseq.start(env.agt.sqr);
      repeat (5) @(env.agt.drv.vif.cb);
      phase.drop_objection(this);
    endtask
  endclass
 
