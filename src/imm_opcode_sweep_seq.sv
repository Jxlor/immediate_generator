// Directed: moi opcode 0..127 voi vai mau bit co dinh (bat ca opcode la)
  class imm_opcode_sweep_seq extends uvm_sequence #(imm_item);
    `uvm_object_utils(imm_opcode_sweep_seq)
 
    function new(string name = "imm_opcode_sweep_seq");
      super.new(name);
    endfunction
 
    task body();
      bit [24:0] pat [4] = '{25'h0, 25'h1FFFFFF, 25'h0AAAAAA, 25'h1555555};
      imm_item it;
      for (int op = 0; op < 128; op++)
        foreach (pat[p]) begin
          it = imm_item::type_id::create("it");
          start_item(it);
          it.instr = {pat[p], op[6:0]};
          finish_item(it);
        end
    endtask
  endclass
