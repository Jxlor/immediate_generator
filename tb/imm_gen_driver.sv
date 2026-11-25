class imm_gen_driver extends uvm_driver #(imm_gen_item);
  `uvm_component_utils(imm_gen_driver)
  virtual imm_gen_if vif;

  function new(string name = "imm_gen_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual imm_gen_if)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF", "Khong tim thay imm_gen_if cho Driver")
  endfunction

  task run_phase(uvm_phase phase);
    vif.drv_cb.raw_imm <= 20'b0;
    vif.drv_cb.opcode  <= 7'b0;

    forever begin
      seq_item_port.get_next_item(req);
      @(vif.drv_cb);
      vif.drv_cb.raw_imm <= req.raw_imm;
      vif.drv_cb.opcode  <= req.opcode;
      seq_item_port.item_done();
    end
  endtask
endclass
