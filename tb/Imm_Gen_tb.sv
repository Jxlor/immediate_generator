`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "modules/headers/opcode.vh"

module Immediate_Generator_tb;
  logic clk = 0;
  always #5 clk = ~clk;

  imm_gen_if vif(clk) ;
  // Khởi tạo DUT nguyên bản (không sửa RTL)
  Immediate_Generator immediate_generator (
    .raw_imm (vif.raw_imm),
    .opcode  (vif.opcode),
    .imm     (vif.imm)
  );

  // Tự động nối các biến trùng tên vào interface bằng bind

  initial begin
    $dumpfile("testbenches/results/waveforms/Immediate_Generator_tb_result.vcd");
    $dumpvars(0, immediate_generator);

    uvm_config_db#(virtual imm_gen_if)::set(null, "*", "vif", vif) ;
    run_test("imm_gen_test");
  end
endmodule
