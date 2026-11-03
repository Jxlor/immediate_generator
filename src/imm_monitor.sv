  class imm_monitor extends uvm_monitor;
    `uvm_component_utils(imm_monitor)
    virtual imm_if vif;
    uvm_analysis_port #(imm_item) ap;
 
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
 
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      ap = new("ap", this);
      if (!uvm_config_db#(virtual imm_if)::get(this, "", "vif", vif))
        `uvm_fatal("MON", "Khong lay duoc virtual interface 'vif'")
    endfunction
 
    task run_phase(uvm_phase phase);
      imm_item tr;
      forever begin
        @(vif.mon_cb);
        if (vif.mon_cb.vld === 1'b1) begin
          tr = imm_item::type_id::create("tr");
          tr.instr = vif.mon_cb.instr;
          tr.imm   = vif.mon_cb.imm;
          ap.write(tr);
        end
      end
    endtask
  endclass
 
