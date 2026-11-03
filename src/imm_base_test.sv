class imm_base_test extends uvm_test;
    `uvm_component_utils(imm_base_test)
    imm_env env;
 
    function new(string name = "imm_base_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction
 
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = imm_env::type_id::create("env", this);
    endfunction
  endclass
