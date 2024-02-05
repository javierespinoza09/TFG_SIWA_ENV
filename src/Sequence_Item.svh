//////////////////////////////////////////////
//	Sequence Item							//
//	UVM Sequence Item, hereda de UVM   		//
//	object, establece valores para el Driver//
//	Programador: Javier Espinoza Rivera		//
// 	Supervisor: Roberto Molina 				//
//////////////////////////////////////////////

class drv_item extends uvm_sequence_item;
	`uvm_object_utils(drv_item)
	int delay;
	int sim_time;
	bit start;

	function new(string name = "drv_item");
		super.new(name);
	endfunction

	function void build_phase(uvm_phase phase);

	endfunction

	virtual function string item_str_content ();
        return $sformatf("Delay=%0d, SimulationTime=%0d", delay, sim_time);
    endfunction

endclass : drv_item