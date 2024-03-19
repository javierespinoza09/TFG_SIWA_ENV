class mon_sb extends uvm_object;

  int reset;
  int event_time;

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

  uvm_status_e  status;
  int  read_data;
  bit[7:0] bit_data;
  csr_reg_block ral_csr;
  
	function new (string name = "Monitor", uvm_component parent=null);
	    super.new(name,parent);
	endfunction
  
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual wrapper_if)::get(this,"","v_if",v_if))begin
      `uvm_fatal("MON","uvm_config_db::get failed wrapper_if")
    end
    mon_analysis_port=new("mon_analysis_port",this);
    /*ral_csr = csr_reg_block::type_id::create("ral_csr",this);
    ral_csr = new;
    */
    

    
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    if(!uvm_config_db#(csr_reg_block)::get(null, "","ral_csr", ral_csr))begin
      `uvm_fatal("MON","uvm_config_db::get failed ral_csr")
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
            
            mon_sb mon_sb = new;
            rst_high = 1;
            //mon_sb = mon_sb::type_id::create("mon_sb");
            mon_sb.reset = 1;
            mon_sb.event_time = $time();
            //Acciones a tomar por el monitor
            `uvm_info("MON", $sformatf("t=%0t reset=%0b", mon_sb.event_time, mon_sb.reset), UVM_LOW)  
            mon_analysis_port.write (mon_sb);
            //mon_sb.print();
        end
        if(v_if.reset==0) rst_high = 0;

    end
  endtask : RST_check

  virtual task Backdoor_access();
    forever begin
      @(posedge v_if.clk);
      //bit_data = ral_csr.control_sm.get_mirrored_value();
      //$display("Backdoor_access: %0h", bit_data);
      ral_csr.control_sm.peek(status, bit_data);
      if (bit_data == 8'h6d) $display("%0d MOnitor RAL = %0h",$time,bit_data);
      //`uvm_info("Reg", $sformatf("CONTROL = 0x%0h", ral_csr.control_sm.get_mirrored_value()), UVM_LOW);
    end
  endtask : Backdoor_access
    
endclass : Monitor

