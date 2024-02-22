//////////////////////////////////////////
//	Driver								//
//	Modulo UVM encargado de manejar 	//
//	las señales que van al DUT			//
//	Programador: Javier Espinoza Rivera	//
// 	Supervisor: Roberto Molina 			//
//////////////////////////////////////////

class Driver extends uvm_driver #(drv_item);
	//import uvm_pkg::*; 	
	`uvm_component_utils(Driver);
	virtual wrapper_if v_if;
	int start_delay = 0;
   	int sim_time_execution = 0;
   	bit dropped;

	function new(string name = "Driver",uvm_component parent = null);
    	super.new(name,parent);
  	endfunction


  	function void build_phase(uvm_phase phase);
    	if(!uvm_config_db#(virtual wrapper_if)::get(this, "", "v_if", v_if)) begin
      		`uvm_error("","uvm_config_db::get failed")
    	end
  	endfunction


   	virtual task run_phase(uvm_phase phase);
   		super.run_phase(phase);
   		phase.raise_objection(this);
   		if_known_initial_state();
   		this.v_if.reset = 1'b1;
   		forever begin

   			

   			drv_item drv_item_i;
	   		sim_time_execution = 0;
	   		seq_item_port.get_next_item(drv_item_i);
	   		if(drv_item_i.stop==1) begin 
	   			`uvm_info("DRV",$sformatf("Se recibe Item para Detener %0d", $time()),UVM_LOW)
	   			phase.drop_objection(this);
	   		end
	   		
	   		if(drv_item_i.start == 1) begin
	   			apply_reset(drv_item_i.delay);
	   			`uvm_info("DRV",$sformatf("Se recibe Item para reiniciar %0d", $time()),UVM_LOW)
	   		end
	   		else begin
	   			`uvm_warning("DRV",$sformatf("Se recibe Item sin reiniciar %0d", $time(),UVM_LOW))
	   		end
	   		while (sim_time_execution < drv_item_i.sim_time) begin
	   			sim_time_execution++;
	   			#1;
	   		end
	   		seq_item_port.item_done();
	   		
   		end
   		
   		//
	endtask : run_phase

	task apply_reset(int delay);
		int start_delay = 0;
		while (start_delay < delay) begin
			this.v_if.reset = 1'b1;
	   		start_delay+= 1;
	   		#1;
   		end
   		`uvm_warning("MON",$sformatf("Simulation Delay Finished at %0d", $time(),UVM_LOW))
   		this.v_if.reset = 1'b0;
	endtask : apply_reset

	task if_known_initial_state();
		this.v_if.gpio = 0;
		this.v_if.full_range_level_shifter = 0;
		this.v_if.IS_Val = 0;
		this.v_if.IS_Config = 0;
		this.v_if.IS_Trigger = 0;
		this.v_if.maip = 0;
		this.v_if.Reg_GPIO_en = 0;
		this.v_if.Reg_GPIO_int = 0;
		this.v_if.Reg_GPIO_out = 0;
		this.v_if.TX_UART = 1;
		this.v_if.RX_UART = 1;
	endtask : if_known_initial_state

endclass