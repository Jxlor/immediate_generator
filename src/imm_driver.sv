 class imm_driver extends uvm_driver #(imm_item);
    `uvm_component_utils(imm_driver)
    virtual imm_if vif;
 
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
 
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(virtual imm_if)::get(this, "", "vif", vif))
        `uvm_fatal("DRV", "Khong lay duoc virtual interface 'vif'")
    endfunction
 
    task run_phase(uvm_phase phase);
      vif.cb.vld <= 1'b0;
      forever begin
        seq_item_port.get_next_item(req);
        @(vif.cb);
        vif.cb.instr <= req.instr;
        vif.cb.vld   <= 1'b1;
        @(vif.cb);
        vif.cb.vld   <= 1'b0;
        seq_item_port.item_done();
      end
    endtask
  endclass
