class imm_gen_agent extends uvm_agent;
  `uvm_component_utils(imm_gen_agent)
  uvm_sequencer #(imm_gen_item) sqr;
  imm_gen_driver                drv;
  imm_gen_monitor               mon;
  imm_gen_cov                   cov;

  function new(string name = "imm_gen_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon = imm_gen_monitor::type_id::create("mon", this);
    cov = imm_gen_cov::type_id::create("cov", this);
    if (get_is_active() == UVM_ACTIVE) begin
      sqr = uvm_sequencer#(imm_gen_item)::type_id::create("sqr", this);
      drv = imm_gen_driver::type_id::create("drv", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    mon.ap.connect(cov.analysis_export);
    if (get_is_active() == UVM_ACTIVE)
      drv.seq_item_port.connect(sqr.seq_item_export);
  endfunction
endclass
