class imm_agent extends uvm_agent;
    `uvm_component_utils(imm_agent)
    imm_sequencer sqr;
    imm_driver    drv;
    imm_monitor   mon;
 
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
 
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mon = imm_monitor::type_id::create("mon", this);
      if (get_is_active() == UVM_ACTIVE) begin
        sqr = imm_sequencer::type_id::create("sqr", this);
        drv = imm_driver::type_id::create("drv", this);
      end
    endfunction
 
    function void connect_phase(uvm_phase phase);
      if (get_is_active() == UVM_ACTIVE)
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
  endclass
