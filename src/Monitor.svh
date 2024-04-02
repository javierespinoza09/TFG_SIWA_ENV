class mon_sb extends uvm_object;

  int reset;
  int event_time;
  bit [32]reg_values[31];
  `uvm_object_utils_begin(mon_sb)
    `uvm_field_int (reset, UVM_DEFAULT)
    `uvm_field_int (event_time, UVM_DEFAULT)
  `uvm_object_utils_end
  function new(string name= "mon_sb");
      super.new(name);
    endfunction
endclass : mon_sb

//////////////////////////////////////////////
//  UVM Monitor                             //
//  Monitor, hereda de UVM Monitor          //
//  Realizar lectura de señales provenientes//
//  de la interfaz y el DUT                 //
//  Programador: Javier Espinoza Rivera     //
//  Supervisor: Roberto Molina              //
//////////////////////////////////////////////

class Monitor extends uvm_monitor;
  
  `uvm_component_utils(Monitor);
  
  uvm_analysis_port #(mon_sb) mon_analysis_port;


  //mon_sb mon_sb;
  bit mnt_num;
  
  virtual wrapper_if v_if;


  ///////////// RAL Variables /////////////
  uvm_status_e  status;
  int  read_data;
  bit[7:0] bit_data;
  bit [31] reg_mirror_array;

  

  ////////////////  RAL Instances  /////////////////
  csr_reg_block ral_csr;
  reg_file_block ral_general;


  ////////////////  Constructor   //////////////////
	function new (string name = "Monitor", uvm_component parent=null);
	    super.new(name,parent);
	endfunction
  
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual wrapper_if)::get(this,"","v_if",v_if))begin
      `uvm_fatal("MON","uvm_config_db::get failed wrapper_if")
    end
    mon_analysis_port=new("mon_analysis_port",this);
    

    
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    if(!uvm_config_db#(csr_reg_block)::get(null, "","ral_csr", ral_csr))begin
      `uvm_fatal("MON","uvm_config_db::get failed ral_csr")
    end



    if(!uvm_config_db#(reg_file_block)::get(null, "","ral_general", ral_general))begin
      `uvm_fatal("MON","uvm_config_db::get failed ral_general")
    end

    fork
      RST_check();
      Backdoor_access();
      //concurrent_task_1...
      //concurrent_task_2...
    join
    
    
  endtask


  virtual task RST_check();
    int rst_high;
    forever begin
      @(posedge v_if.clk);
        if (v_if.reset==1 && rst_high == 0) begin

            //// Acciones a tomar por el monitor ////
            mon_sb mon_sb = new;
            rst_high = 1;
            mon_sb.reset = 1;
            mon_sb.event_time = $time();
            `uvm_info("MON", $sformatf("t=%0t reset=%0b", mon_sb.event_time, mon_sb.reset), UVM_LOW)  
            mon_analysis_port.write (mon_sb);

        end
        if(v_if.reset==0) rst_high = 0;

    end
  endtask : RST_check

  virtual task Backdoor_access();

    bit  [32]reg_values[31];
    for (int r = 0; r < 31; r++) begin
      reg_values[r] = 0;
      $display("REG %h",reg_values [r]);
    end
    forever begin
      @(posedge v_if.clk);
      
      ral_csr.control_sm.peek(status, bit_data);
      if (bit_data == 8'h05) begin
        mon_sb mon_sb = new;
        mon_sb.reset = 0;
        mon_sb.event_time = $time();
        for(int i = 0; i < 31; i++) begin
          for (int h = 0; h < 32; h++) begin
            automatic int l = h;
            ral_general.Reg_General_array[i].Latch_General_array[l].peek(status, reg_values [i][l]);
          end
          mon_sb.reg_values[i] = reg_values [i];
          $display("%0d General [%0d] RAL = %h",$time,i,reg_values[i]);
        end
      mon_analysis_port.write (mon_sb);  
      end
      
    end
  endtask : Backdoor_access
    
endclass : Monitor

