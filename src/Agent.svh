class Agent extends  uvm_agent;
	`uvm_component_utils(Agent);
	string name = "Agent"
	function new(string name, uvm_component parent = null);
	    super.new(name,parent);
	 endfunction

	
endclass : Agent

