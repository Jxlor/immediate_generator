module Imm_Gen_tb;
  logic clk = 0;
  always #5 clk = ~clk;

  logic [6:0]  opcode;
  logic [24:0] raw_imm;
  logic [31:0] imm;

  // Khởi tạo DUT khớp 100% cổng trên sơ đồ KHWL_RV32I46F
  imm_gen dut (
    .opcode  (opcode),
    .raw_imm (raw_imm),
    .imm     (imm)
  );

  // Tự động nối các biến trùng tên vào interface bằng bind
  bind imm_gen imm_gen_if vif_inst(.clk(Imm_Gen_tb.clk));

  initial begin
    uvm_config_db#(virtual imm_gen_if)::set(null, "*", "vif", dut.vif_inst);
    run_test("imm_gen_test");
  end
endmodule
