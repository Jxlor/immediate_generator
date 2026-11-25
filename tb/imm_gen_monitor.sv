class imm_gen_monitor extends uvm_monitor;
  `uvm_component_utils(imm_gen_monitor)
  virtual imm_gen_if vif;
  uvm_analysis_port #(imm_gen_item) ap;

  function new(string name = "imm_gen_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
    if (!uvm_config_db#(virtual imm_gen_if)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", "Khong tim thay imm_gen_if cho Monitor")
  endfunction

  task run_phase(uvm_phase phase);
    imm_gen_item item;
    @(vif.drv_cb);
    forever begin
      @(vif.mon_cb);
      item = imm_gen_item::type_id::create("item");
      item.raw_imm = vif.mon_cb.raw_imm;
      item.opcode  = vif.mon_cb.opcode;
      item.imm     = vif.mon_cb.imm;
      ap.write(item);
    end
  endtask
endclass
