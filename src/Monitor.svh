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
    //fork
      //concurrent_task_1...
      //concurrent_task_2...
    //join
    RST_check();
    
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
            mon_sb.print();
        end
        if(v_if.reset==0) rst_high = 0;

    end
  endtask : RST_check
    
endclass : Monitor

