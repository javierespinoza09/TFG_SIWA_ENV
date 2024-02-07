`include "Agent.svh"

class Enviroment extends uvm_env;
	`uvm_component_utils(Enviroment);
  
  	Agent agent_inst;
  	gen_sequence_item sequence_inst;
  	virtual wrapper_if v_if;
  	

    function new(string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent_inst = Agent::type_id::create("agent_inst",this);
    endfunction

endclass : Enviroment