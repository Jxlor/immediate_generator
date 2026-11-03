class imm_walking_seq extends uvm_sequence #(imm_item);
    `uvm_object_utils(imm_walking_seq)
 
    function new(string name = "imm_walking_seq");
      super.new(name);
    endfunction
 
    task send(bit [31:0] i);
      imm_item it = imm_item::type_id::create("it");
      start_item(it);
      it.instr = i;
      finish_item(it);
    endtask
 
    task body();
      bit [31:0] v;
      foreach (VALID_OPCODES[k]) begin
        // toan 0 va toan 1
        send({25'h0,       VALID_OPCODES[k]});
        send({25'h1FFFFFF, VALID_OPCODES[k]});
        for (int b = 7; b < 32; b++) begin
          v = 32'd1 << b;                 // chi bit b bang 1
          v[6:0] = VALID_OPCODES[k];
          send(v);
          v = ~(32'd1 << b);              // chi bit b bang 0
          v[6:0] = VALID_OPCODES[k];
          send(v);
        end
      end
    endtask
  endclass
