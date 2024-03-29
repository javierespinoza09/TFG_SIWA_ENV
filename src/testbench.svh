`timescale 1ns/10ps
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "Reg_CSR.svh"
`include "wrapper_if.svh"
`include "RTL_MEM_Wrapper.svh"
`include "Sequence_Item.svh"
`include "Driver.svh"
`include "Monitor.svh"
`include "Scoreboard.svh"
`include "Sequence.svh"
`include "Agent.svh"
`include "Enviroment.svh"
`include "test_base.svh"



module tb_top;
  //import uvm_pkg::*;
  //import test::*;
  
  bit clk_tb;
  always #5 clk_tb <= ~clk_tb;
  
  wrapper_if dut_if(clk_tb);
  RTL_MEM_Wrapper dut_wr (._if (dut_if));
  csr_reg_block ral_csr;
  

  initial begin
    uvm_config_db#(virtual wrapper_if)::set(null, "*","v_if", dut_if);
    ral_csr = new();
    ral_csr.build();
    uvm_config_db#(csr_reg_block)::set(null, "*","ral_csr", ral_csr);

    run_test("test_base");
  end
  
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0,tb_top);
  end
  
endmodule
