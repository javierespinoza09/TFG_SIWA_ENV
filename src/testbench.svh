`include "uvm_macros.svh"
import uvm_pkg::*;

`include "wrapper_if.svh"
`include "RTL_MEM_Wrapper.svh"
`include "Sequence_Item.svh"
`include "Driver.svh"
`include "Sequence.svh"
`include "Agent.svh"

`include "Enviroment.svh"
`include "test_base.svh"



module tb_top;
  //import uvm_pkg::*;
  import test::*;
  
  bit clk_tb;
  always #5 clk_tb <= ~clk_tb;
  
  wrapper_if dut_if(clk_tb);
  RTL_MEM_Wrapper dut_wr (._if (dut_if));
  

  initial begin
    uvm_config_db#(virtual router_if)::set(null, "*","v_if", dut_if);
    run_test("test_base");
  end
  
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0,tb_top);
  end
  
endmodule